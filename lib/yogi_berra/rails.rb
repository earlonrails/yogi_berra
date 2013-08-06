# Adapted from Airbrake code https://github.com/airbrake/airbrake/blob/master/lib/airbrake/rails.rb
require 'yogi_berra'
require 'yogi_berra/action_controller_catcher'

module YogiBerra
  def self.initialize
    if defined?(ActionController::Base)
      ActionController::Base.send(:include, YogiBerra::ActionControllerCatcher)
      # ActionController::Base.send(:include, YogiBerra::::ErrorLookup)
      # ActionController::Base.send(:include, YogiBerra::ControllerMethods)
      # ActionController::Base.send(:include, YogiBerra::JavascriptNotifier)
    end

    rails_logger = if defined?(::Rails.logger)
                     ::Rails.logger
                   elsif defined?(RAILS_DEFAULT_LOGGER)
                     RAILS_DEFAULT_LOGGER
                   end

    if defined?(::Rails.configuration) && ::Rails.configuration.respond_to?(:middleware)
      ::Rails.configuration.middleware.insert_after('ActionController::Failsafe', YogiBerra::ExceptionMiddleware)
      # ::Rails.configuration.middleware.insert_after 'Rack::Lock',
      #                                               YogiBerra::UserInformer
    end
  end
end

YogiBerra::Catcher.quick_connection(true)
YogiBerra.initialize
