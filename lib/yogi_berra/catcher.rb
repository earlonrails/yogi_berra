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
        elsif defined?(Rails)
          database_config = "#{Rails.root}/config/yogi.yml"
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

      def db_client(host, port, replica_set = nil)
        # :w => 0 set the default write concern to 0, this allows writes to be non-blocking
        # by not waiting for a response from mongodb
        # :connect_timeout set to 5 will only wait 5 seconds failing to connect
        if replica_set
          @@mongo_client = Mongo::MongoReplicaSetClient.new(replica_set, :w => 0, :connect_timeout => 5)
        else
          @@mongo_client = Mongo::MongoClient.new(host, port, :w => 0, :connect_timeout => 5)
        end
      rescue Timeout::Error => error
        YogiBerra::Logger.log("Couldn't connect to the mongo database timeout on host: #{host} port: #{port}.\n #{error}", :error)
        nil
      rescue => error
        YogiBerra::Logger.log("Couldn't connect to the mongo database on host: #{host} port: #{port}.", :error)
        nil
      end

      def quick_connection(load_settings = false)
        load_db_settings if load_settings

        if @@settings
          host = @@settings["host"]
          port = @@settings["port"]
          database = @@settings["database"]
          username = @@settings["username"]
          password = @@settings["password"]
          replica_set = @@settings["replica_set"]
          client = db_client(host, port, replica_set)
          if client
            @@connection = client[database]
            if @@connection && username && password
              begin
                @@connection.authenticate(username, password)
              rescue
                YogiBerra::Logger.log("Couldn't authenticate with user #{username} to mongo database on host: #{host} port: #{port} database: #{database}.", :warn)
              end
            end
          else
            YogiBerra::Logger.log("Couldn't connect to the mongo database on host: #{host} port: #{port}.", :error)
          end
        else
          YogiBerra::Logger.log("Couldn't load the yogi.yml file.", :error) if load_settings
        end
        @@connection
      end
    end
  end
end