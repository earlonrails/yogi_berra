module YogiBerra
  class Engine < ::Rails::Engine
    YogiBerra::Catcher.connect(true)
    config.app_middleware.use "YogiBerra::ExceptionMiddleware"
  end
end