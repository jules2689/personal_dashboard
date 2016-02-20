require 'logger'

class Job
  def self.auth_hash
    {}
  end

  def self.should_run?
    auth_hash.all? { |_k, v| !v.nil? && !v.empty? }
  end

  def self.run
    if !should_run?
      logger.warn "Could not run due to config"
    elsif @period.nil?
      logger.warn "No Period defined for #{name}"
    else
      schedule
    end
  end

  def self.schedule
    logger.info "Scheduling job for a period of #{@period}"
    SCHEDULER.every @period, first_in: 0 do |_job|
      perform_job
    end
  end

  def self.perform_job
    logger.info "Performing Job"
  end

  def self.logger
    @logger ||= Logger.new(STDOUT)
    @logger.level = Logger::DEBUG
    @logger.formatter = proc do |severity, datetime, _progname, msg|
      format_modifier = ""
      format_modifier = "\e[41m\e[97m" if severity == "ERROR"
      format_modifier = "\e[43m\e[97m" if severity == "WARN"
      "\e[94m[#{name}] => (#{datetime})\e[37m #{format_modifier}#{msg}\e[37m\e[49m\n"
    end
    @logger
  end
end
