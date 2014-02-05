require 'yogi_berra/catcher'
require 'yogi_berra/backtrace'
require 'yogi_berra/notice'
require 'yogi_berra/exception_middleware'
require 'yogi_berra/data'
require 'yogi_berra/logger'
require 'facets'
include Facets

module YogiBerra
  mattr_accessor :ignored_exceptions, :yogi_yml, :settings, :mongo_client, :connection
  @@ignored_exceptions = %w{ActiveRecord::RecordNotFound AbstractController::ActionNotFound ActionController::RoutingError}
  @@yogi_yml = "config/yogi.yml"

  class << self
    # Stores the notice exception
    # @see YogiBerra.exceptionize
    # @params exception
    # @params environment
    # @params opts
    def exceptionize(exception, environment = nil, opts = {})
      return false if ignored_exception?(exception)
      notice = build_notice_for(exception, opts)
      if YogiBerra.connection
        YogiBerra::Data.store!(notice, environment)
      end
    end

    def configure
      yield self
    end

    private
    def ignored_exception?(exception)
      @@ignored_exceptions.collect(&:to_s).include?(exception.class.name)
    end

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
