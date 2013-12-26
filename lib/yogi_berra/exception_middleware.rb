module YogiBerra
  class ExceptionMiddleware
    def initialize(app)
      @app = app
    end

    def call(env)
      begin
        response = @app.call(env)
      rescue Exception => raised
        path_parameters = env['action_controller.request.path_parameters'] || {}
        query_hash      = env['rack.request.query_hash'] || {}
        environment = {
          :session => env['rack.session'],
          :params => path_parameters.merge(query_hash),
          :user_agent => env['HTTP_USER_AGENT'],
          :server_name => env['SERVER_NAME'],
          :server_port => env['SERVER_PORT'],
          :server_address => env['SERVER_ADDR'],
          :controller => env['action_controller.instance'],
          :remote_address => env['REMOTE_ADDR']
        }

        YogiBerra.exceptionize(raised, environment)
        raise raised
      end

      if env['rack.exception']
        YogiBerra.exceptionize(raised, environment)
      end
      response
    end

    def each(&block)
      @response.each(&block)
    end
  end
end
