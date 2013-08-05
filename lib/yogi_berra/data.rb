require 'mongo'

module YogiBerra
  class Data
    def self.store!(exception, environment = nil)
      data = parse_exception(exception)
      if environment
        session = environment.delete(:session)
        data[:session] = parse_session(session) if session
        data.merge!(environment)
      end
      YogiBerra::Catcher.connection["caught_exceptions"].insert(data)
    end

    def self.parse_exception(notice)
      data_hash = {
        :error_class => "#{notice.class}",
        :project => YogiBerra::Catcher.settings["project"],
        :error_message => notice.respond_to?(:error_message) ? notice.error_message : notice.message
      }
      data_hash[:backtraces] = notice.backtrace
      if notice.backtrace.respond_to?(:lines) && notice.backtrace.lines.any?
        data_hash[:backtraces] = notice.backtrace.lines.collect(&:to_s)
      end
      data_hash[:created_at] = Time.now.utc
      data_hash
    end

    def self.parse_session(session)
      session.inject({}) do |result, element|
        key = element.first
        value = element.last
        if value.respond_to?(:as_json)
          result[key] = value.as_json(:except => ["password"])
        else
          value.delete("password")
          result[key] = value
        end
        result
      end
    end
  end
end
