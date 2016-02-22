class HeadspaceJob < Job
  @period = '1h'

  def self.auth_hash
    { user_name: ENV["HEADSPACE_USER_NAME"],
      password: ENV["HEADSPACE_PASSWORD"] }
  end

  def self.perform_job
    super
    headspace = JobHelpers::HeadspaceJob.new(auth_hash, logger)
    headspace.sign_in
    headspace.save_progress
    progress_hash = headspace.progress_hash

    logger.info("Sending event to headspace_average_duration")
    send_event('headspace_average_duration', progress_hash["avg_session_length"])

    logger.info("Sending event to headspace_number_sessions")
    send_event('headspace_number_sessions', progress_hash["num_sessions"])

    logger.info("Sending event to headspace_total_time")
    send_event('headspace_total_time', progress_hash["number_of_minutes"])

    logger.info("Sending event to headspace_current_streak")
    send_event('headspace_current_streak', progress_hash["current_streak"])

    logger.info("Sending event to headspace_longest_streak")
    send_event('headspace_longest_streak', progress_hash["longest_streak"])

    logger.info("Sending event to headspace_courses")
    send_event('headspace_courses', items: headspace.course_hash)
  end
end

HeadspaceJob.run
