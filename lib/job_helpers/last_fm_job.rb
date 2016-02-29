require 'lastfm'

module JobHelpers
  class LastFMJob
    def initialize(args, logger)
      @user_name = args[:user_name]
      @password = args[:password]
      @api_key = args[:api_key]
      @api_secret = args[:api_secret]
      @logger = logger
    end

    def extract_top_artists
      top_artists = @top_tracks.group_by { |r| r["artist"]["name"] }.sort_by { |_k, v| -v.count }.first(5)
      top_artists.to_a.collect do |artist|
        { size: artist.last.count,
          name: artist.first.to_s,
          url: artist.last.first["url"] }
      end
    end

    def extract_top_tags
      tags = TopTag.includes(:top_tracks).all
      data = tags.collect do |tag|
        { size: tag.top_tracks.length,
          name: tag.name,
          url: tag.url }
      end
      data.sort_by { |h| -h[:size] }.first(20)
    end

    def extract_total_played
      total_played = @top_tracks.collect { |track| track["duration"].to_i }.inject(&:+)
      seconds_to_human_duration(total_played)
    end

    def extract_top_tracks
      tracks = @top_tracks.collect do |track|
        { name: track["name"],
          cover: track["image"].last["content"],
          artist: track["artist"]["name"],
          url: track["url"],
          playCount: track["playcount"] }
      end
      tracks.take(6)
    end

    # API Handlers

    def top_tracks
      return @top_tracks unless @top_tracks.nil?

      @top_tracks = []
      tracks_batch = "" # Default for first loop
      page = 1

      # Fetch all Top Tracks
      @logger.info "Fetching Top Tracks from Last FM"
      until tracks_batch.nil?
        tracks_batch = last_fm.user.get_top_tracks(user: @user_name,
                                                   period: "7day",
                                                   page: page,
                                                   limit: 100)
        unless tracks_batch.nil?
          @top_tracks << tracks_batch
          page += 1
        end
      end
      @top_tracks.flatten!

      # Fetch Tags for Top Tracks
      @logger.info "Fetching Tags for #{@top_tracks.count} tracks from Last FM"
      @top_tracks.each_with_index do |track, idx|
        @logger.info "Fetching Tags #{idx + 1} / #{@top_tracks.count}"
        track["tags"] = tags_for_track(track)
      end

      @top_tracks
    end

    def tags_for_track(track)
      info = last_fm.track.get_info(artist: track["artist"]["name"], track: track["name"])
      info["toptags"]["tag"]
    end

    def last_fm
      return @last_fm unless @last_fm.nil?

      @last_fm ||= Lastfm.new(@api_key, @api_secret)
      @last_fm.session = @last_fm.auth.get_mobile_session(username: @user_name, password: @password)['key']
      @last_fm
    end

    # Database Handlers

    def save_top_tracks
      @logger.info "Saving artists, tracks, images, tags, streamble to database"
      top_tracks.each do |top_track_hash|
        artist = save_artist(top_track_hash['artist'])
        top_track = save_top_track(top_track_hash, artist)
        save_streamable(top_track, top_track_hash['streamable'])
        save_images(top_track, top_track_hash["image"])
        save_tags(top_track, top_track_hash["tags"])
      end
    end

    def save_artist(artist_hash)
      artist = Artist.find_or_initialize_by(url: artist_hash["url"])
      artist.update(artist_hash)
      artist
    end

    def save_top_track(top_track_hash, artist)
      track_hash = sanitize_track_hash(top_track_hash, artist)
      top_track = TopTrack.find_or_initialize_by(url: track_hash["url"])
      top_track.update(track_hash)
      top_track
    end

    def save_streamable(top_track, streamable_hash)
      streamable = Streamable.find_or_initialize_by(top_track_id: top_track.id)
      streamable.update(streamable_hash)
    end

    def save_images(top_track, images_hash)
      unless images_hash.nil?
        ActiveRecord::Base.transaction do
          sizes = images_hash.collect { |i| i["size"] }
          images = Image.where(top_track_id: top_track.id, size: sizes)
          images_hash.each_with_index do |image_hash, idx|
            image = images[idx] || Image.new(top_track_id: top_track.id)
            image.update(image_hash)
          end
        end
      end
    end

    def save_tags(top_track, tags_hash)
      unless tags_hash.nil?
        ActiveRecord::Base.transaction do
          names = tags_hash.collect { |i| i["name"] }
          tags = TopTag.where(name: names)
          tags_hash.each_with_index do |tag_hash, idx|
            tag = tags[idx] || TopTag.new
            tag.update(tag_hash)
            top_track.top_tags << tag
          end
        end

        top_track.save
      end
    end

    # Helpers

    def sanitize_track_hash(top_track_hash, artist)
      hash = top_track_hash.dup
      hash.delete("streamable")
      hash.delete("artist")
      hash.delete("image")
      hash.delete("tags")
      hash["artist"] = artist
      hash
    end

    def seconds_to_human_duration(seconds)
      human_duration = []
      human_duration << "#{seconds / 86400} days" if seconds >= 86400
      human_duration << "#{seconds / 3600 % 24} hours" if seconds >= 3600
      human_duration << "#{seconds / 60 % 60} minutes" if seconds >= 60
      human_duration << "#{seconds} seconds" if seconds < 60
      human_duration.to_sentence
    end
  end
end
