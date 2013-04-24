require 'mongo'

module YogiBerra
  class Data
    def self.store!(exception, environment, client)
      data = parse_exception(exception)
      if environment
        session = environment.delete(:session)
        data[:session] = parse_session(session) if session
        data.merge!(environment)
      end
      client["caught_exceptions"].insert(data)
    end

    def self.parse_exception(notice)
      data_hash = {
        :error_class => notice.error_class,
        :error_message => notice.error_message
      }
      if notice.backtrace.lines.any?
        data_hash[:backtraces] = notice.backtrace.lines.collect(&:to_s)
      end
      data_hash[:created_at] = Time.now.utc
      data_hash
    end

    def self.parse_session(session)
      session.inject({}) do |result, element|
        result[element.first] = element.last.respond_to?(:as_json) ? element.last.as_json(:except => ["password"]) : element.last
        result
      end
    end
  end
end
