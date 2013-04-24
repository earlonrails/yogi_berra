module YogiBerra
  class Engine < Rails::Engine
    config.app_middleware.use "YogiBerra::ExceptionMiddleware"
  end
end