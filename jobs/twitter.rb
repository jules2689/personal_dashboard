require_relative 'helpers/twitter_job'

class TwitterJob < Job
  @period = '1d'

  def self.auth_hash
    { consumer_key: ENV["TWITTER_CONSUMER_KEY"],
      consumer_secret:  ENV["TWITTER_CONSUMER_SECRET"],
      access_token:  ENV["TWITTER_ACCESS_TOKEN"],
      access_token_secret:  ENV["TWITTER_ACCESS_TOKEN_SECRET"] }
  end

  def self.perform_job
    super
    begin
      twitter = Helpers::TwitterJob.new(auth_hash, logger)
      twitter.record_twitter_followers
      send_event('twitter_followers_count', twitter.twitter_follower_hash)
    rescue Twitter::Error => e
      log_error e
    end
  end
end

TwitterJob.run
