# Adapted from Airbrake code https://github.com/airbrake/airbrake/blob/master/lib/airbrake/rails/action_controller_catcher.rb
module YogiBerra
  module ActionControllerCatcher
    # Sets up an alias chain to catch exceptions for Rails 2
    def self.included(base)
      if base.method_defined?(:rescue_action_in_public)
        base.send(:alias_method, :rescue_action_in_public_without_yogi, :rescue_action_in_public)
        base.send(:alias_method, :rescue_action_in_public, :rescue_action_in_public_with_yogi)
        if YogiBerra.settings
          base.send(:alias_method, :rescue_action_locally_without_yogi, :rescue_action_locally)
          base.send(:alias_method, :rescue_action_locally, :rescue_action_locally_with_yogi)
        end
      end
    end

    private
    # Overrides the rescue_action method in ActionController::Base, but does not inhibit
    # any custom processing that is defined with Rails 2's exception helpers.
    def rescue_action_in_public_with_yogi(exception)
      rescue_action_yogi(exception)
      rescue_action_in_public_without_yogi(exception)
    end

    def rescue_action_locally_with_yogi(exception)
      rescue_action_yogi(exception)
      rescue_action_locally_without_yogi(exception)
    end

    def rescue_action_yogi(exception)
        environment = {
          :session => session,
          :params => params,
          :user_agent => request.headers['HTTP_USER_AGENT'],
          :server_name => request.headers['SERVER_NAME'],
          :server_port => request.headers['SERVER_PORT'],
          :server_address => request.headers['SERVER_ADDR'],
          :remote_address => request.remote_ip
        }
      error_id = YogiBerra.exceptionize(exception, environment)
      request.env['yogi_berra.error_id'] = error_id
    end
  end
end
