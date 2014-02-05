require 'sidekiq'

module YogiBerra
  class Sidekiq
    def call(worker, message, queue)
      begin
        yield
      rescue Exception => exception
        message["worker"] = message.delete("jid")
        YogiBerra.exceptionize(exception, :sidekiq => message)
        raise exception
      end
    end
  end
end

::Sidekiq.configure_server do |config|
  config.server_middleware do |chain|
    chain.add ::YogiBerra::Sidekiq
  end
end
