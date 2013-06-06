require 'yogi_berra/catcher'
require 'yogi_berra/backtrace'
require 'yogi_berra/notice'
require 'yogi_berra/exception_middleware'
require 'yogi_berra/data'
require 'yogi_berra/logger'

if defined?(::Rails.version) && ::Rails.version.to_f >= 3.0
  require 'yogi_berra/engine'
else
  require 'yogi_berra/rails'
end

module YogiBerra
  class << self
    # Stores the notice exception
    # @see YogiBerra.exceptionize
    # @params exception
    # @params environment
    # @params database
    def exceptionize(exception, environment, database, opts = {})
      notice = build_notice_for(exception, opts)
      if database
        YogiBerra::Data.store!(notice, environment, database)
      else
        YogiBerra::Logger.log("No database connection!", :error)
      end
    end

    private

    def build_notice_for(exception, opts = {})
      exception = unwrap_exception(exception)
      if exception.respond_to?(:to_hash)
        opts = opts.merge(exception.to_hash)
      else
        opts = opts.merge(:exception => exception)
      end
      Notice.new(opts)
    end

    def unwrap_exception(exception)
      if exception.respond_to?(:original_exception)
        exception.original_exception
      elsif exception.respond_to?(:continued_exception)
        exception.continued_exception
      else
        exception
      end
    end
  end
end
