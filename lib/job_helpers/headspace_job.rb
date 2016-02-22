require 'mechanize'

module JobHelpers
  class HeadspaceJob
    def initialize(args, logger)
      @user_name = args[:user_name]
      @password = args[:password]
      @logger = logger
    end

    def progress_hash
      stats = HeadspaceStat.where("created_at >= ?", 6.months.ago)
      {
        "num_sessions" => extract_hash(stats, "num_sessions"),
        "avg_session_length" => extract_hash(stats, "avg_session_length"),
        "number_of_minutes" => extract_hash(stats, "number_of_minutes"),
        "current_streak" => extract_hash(stats, "current_run_streak"),
        "longest_streak" => extract_hash(stats, "longest_run_streak"),
      }
    end

    def extract_hash(stats, val)
      stat_vals = stats.collect do |stat|
        { x: stat.created_at.to_i, y: stat.send(val) }
      end
      stat_vals = stat_vals.sort_by { |hsh| hsh[:x] }
      max_value = stat_vals.max_by { |hsh| hsh[:y] }[:y]
      min_value = stat_vals.min_by { |hsh| hsh[:y] }[:y]

      {
        points: stat_vals,
        displayedValue: stats.last.send(val),
        maxValue: max_value,
        minValue: min_value
      }
    end

    def course_hash
      groups = HeadspacePackGroup.all
      groups.collect do |group|
        {
          name: group.name,
          image: group.xxhdpi_icon_url,
          subtext: "#{group.no_of_packs} / #{group.total_packs}"
        }
      end
    end

    # Database

    def save_progress
      pack_groups = progress["pack_group"].dup
      progress.delete("pack_group")

      stat = save_stat(progress)
      save_pack_groups(stat, pack_groups)
    end

    def save_stat(progress)
      @logger.info("Saving Headspace Stat")
      stat = HeadspaceStat.find_or_initialize_by(remote_user_id: progress["remote_user_id"],
                                                 last_meditated: progress["last_meditated"])
      stat.update(progress)
      stat
    end

    def save_pack_groups(stat, pack_groups)
      @logger.info("Saving Headspace Pack Groups")
      ActiveRecord::Base.transaction do
        ids = pack_groups.collect { |i| i["pack_group_id"] }
        groups = HeadspacePackGroup.where(remote_pack_group_id: ids)
        pack_groups.each_with_index do |group_hash, idx|
          group = groups[idx] || HeadspacePackGroup.new
          group_hash["remote_pack_group_id"] = group_hash.delete("pack_group_id")
          group.update(group_hash)
          stat.headspace_pack_groups << group
          group.save
        end
      end

      stat.save
    end

    # Scraping

    def sign_in
      @logger.info("Signing into Headspace")
      mechanize.get('http://headspace.com') do |page|
        login_page = mechanize.click(page.link_with(text: /LOGIN/))
        login_page.form_with(action: '/login/check') do |f|
          f._username = @user_name
          f._password = @password
        end.submit
      end
    end

    def progress
      return @progress unless @progress.nil?

      @logger.info("Fetching new progress from Headspace")
      progress_url = 'https://www.headspace.com/ajax?resource=/journey/progress'
      json_response = JSON.parse(mechanize.get(progress_url).body)
      stats = json_response["data"]["response"]["stats"]["own"]
      stats["first_name"] = stats.delete("firstname")
      stats["last_name"] = stats.delete("lastname")
      stats["remote_user_id"] = stats.delete("userId")
      @progress = underscorize_hash(stats)
    end

    def mechanize
      @mechanize ||= Mechanize.new
    end

    def underscorize_hash(h)
      return h.collect { |s| underscorize_hash(s) } if h.is_a? Array
      return h unless h.is_a? Hash
      h.map { |k, v| [ActiveSupport::Inflector.underscore(k), underscorize_hash(v)] }.to_h
    end
  end
end
