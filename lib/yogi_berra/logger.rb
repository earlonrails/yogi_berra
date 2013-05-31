module YogiBerra
  class Logger
    def self.log(log_string, level = :info)
      message = "[YogiBerra #{level.to_s.capitalize}] #{log_string}"
      if defined?(Rails)
        Rails.logger.send(level, message)
      else
        $stderr.puts(message)
      end
    end
  end
end