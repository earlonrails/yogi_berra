require 'yogi_berra/engine'

# Sidekiq error handling support
# require 'yogi_berra/sidekiq'

# Resque error handling support
# require 'resque/failure/multiple'
# require 'resque/failure/redis'
# require 'yogi_berra/resque'

# Resque::Failure::Multiple.classes = [Resque::Failure::Redis, YogiBerra::Resque]
# Resque::Failure.backend = Resque::Failure::Multiple

YogiBerra.configure do |config|
  # Ignore exception types.
  # ActiveRecord::RecordNotFound, AbstractController::ActionNotFound and ActionController::RoutingError are already added.
  # config.ignored_exceptions += %w{ActionView::TemplateError CustomError}

  # Mongodb setup
  # should point to the yogi.yml file which should contain the mongodb configuration settings ie
  #
  # defaults: &defaults
  #   username: yogi
  #   password: berra
  #   project: rails_yogi_project
  #
  # test:
  #   <<: *defaults
  #   database: yogi_berra
  #   host: localhost
  #   port: 27017
  #
  # Optionally a replica set may be used by replacing host with
  #
  # replica_set:
  #   - host1:27017
  #   - host2:27017
  #   - host3:27017
  #

  config.yogi_yml = "#{Rails.root}/config/yogi.yml"
end
