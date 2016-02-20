require 'twitter'

module JobHelpers
  class TwitterJob
    def initialize(args, logger)
      @consumer_key = args[:consumer_key]
      @consumer_secret = args[:consumer_secret]
      @access_token = args[:access_token]
      @access_token_secret = args[:access_token_secret]
      @logger = logger
    end

    def twitter_follower_hash
      counts = TwitterCount.where("created_at >= ?", 6.months.ago)
      points = counts.collect do |count|
        { x: count.created_at.to_i, y: count.current_followers_count }
      end
      points = points.sort_by { |hsh| hsh[:x] }
      max_value = points.max_by { |hsh| hsh[:y] }[:y]
      min_value = points.min_by { |hsh| hsh[:y] }[:y]

      {
        points: points,
        displayedValue: user.followers_count,
        maxValue: max_value,
        minValue: min_value
      }
    end

    def record_twitter_followers
      @logger.info "Saving current Twitter follower count"
      TwitterCount.create(current_followers_count: user.followers_count)
    end

    def user
      twitter.user(@user_name)
    end

    def twitter
      @twitter ||= Twitter::REST::Client.new do |config|
        config.consumer_key = @consumer_key
        config.consumer_secret = @consumer_secret
        config.access_token = @access_token
        config.access_token_secret = @access_token_secret
      end
    end
  end
end
