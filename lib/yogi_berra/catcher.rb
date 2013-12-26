require 'mongo'
require 'facets'
require 'yaml'
require 'timeout'

module YogiBerra
  class Catcher
    extend Facets
    cattr_accessor :settings, :mongo_client, :connection

    class << self
      def load_db_settings(config_file = nil)
        if config_file
          database_config = config_file
        elsif defined?(::Rails)
          database_config = Rails.root ? "#{Rails.root}/config/yogi.yml" : "config/yogi.yml"
        else
          YogiBerra::Logger.log("No config file specified!", :error)
        end

        if database_config
          begin
            File.open(database_config, 'r') do |f|
              yaml_file = YAML.load(f)
              @@settings = yaml_file["#{environment}"] if yaml_file
            end
          rescue
            YogiBerra::Logger.log("No such file: #{database_config}", :error)
          end
          @@settings
        end
      end

      def environment
        if ENV["YOGI_ENV"]
          ENV["YOGI_ENV"]
        elsif defined?(Rails)
          Rails.env
        elsif ENV["RAILS_ENV"]
          ENV["RAILS_ENV"]
        else
          "test"
        end
      end

      def fork_database
        host = @@settings["host"]
        port = @@settings["port"]
        database = @@settings["database"]
        username = @@settings["username"]
        password = @@settings["password"]
        replica_set = @@settings["replica_set"]

        # :w => 0 set the default write concern to 0, this allows writes to be non-blocking
        # by not waiting for a response from mongodb
        Thread.new do
          begin
            if replica_set
              @@mongo_client = Mongo::MongoReplicaSetClient.new(replica_set, :w => 0, :connect_timeout => 10)
            else
              @@mongo_client = Mongo::MongoClient.new(host, port, :w => 0, :connect_timeout => 10)
            end
          rescue Timeout::Error => timeout_error
            YogiBerra::Logger.log("Couldn't connect to the mongo database timeout on host: #{host} port: #{port}.\n #{timeout_error.inspect}", :error)
            retry
          rescue => error
            YogiBerra::Logger.log("Couldn't connect to the mongo database on host: #{host} port: #{port}.\n #{error.inspect}", :error)
            sleep 1
            retry
          end

          @@connection = @@mongo_client[database]
          if username && password
            begin
              @@connection.authenticate(username, password)
            rescue
              YogiBerra::Logger.log("Couldn't authenticate with user #{username} to mongo database on host: #{host} port: #{port} database: #{database}.", :warn)
            end
          end
        end
      end

      def connect(load_settings = false)
        load_db_settings if load_settings

        if @@settings
          fork_database
        else
          YogiBerra::Logger.log("Couldn't load the yogi.yml file.", :error) if load_settings
        end
        @@connection
      end
    end
  end
end