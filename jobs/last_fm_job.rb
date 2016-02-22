class LastFMJob < Job
  @period = '7d'

  def self.auth_hash
    { user_name: ENV["LAST_FM_USER_NAME"],
      password: ENV["LAST_FM_PASSWORD"],
      api_key: ENV["LAST_FM_API_KEY"],
      api_secret: ENV["LAST_FM_API_SECRET"] }
  end

  def self.perform_job
    super
    last_fm = JobHelpers::LastFMJob.new(auth_hash, logger)
    last_fm.save_top_tracks

    logger.info("Sending event to last_fm_top_tracks")
    send_event('last_fm_top_tracks',   songs: last_fm.extract_top_tracks)
    
    logger.info("Sending event to last_fm_total_played")
    send_event('last_fm_total_played', text: last_fm.extract_total_played)
    
    logger.info("Sending event to last_fm_top_artists")
    send_event('last_fm_top_artists',  name: "Top Artists",
                                       children: last_fm.extract_top_artists)
    
    logger.info("Sending event to last_fm_top_tags")
    send_event('last_fm_top_tags',     name: "Top Tags",
                                       children: last_fm.extract_top_tags)
  end
end

# LastFMJob.run
