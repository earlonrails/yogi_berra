require 'mongo'
require 'yaml'
require 'timeout'

module YogiBerra
  class Catcher
    class << self
      def load_db_settings(config_file = nil)
        if config_file
          YogiBerra.yogi_yml = config_file
        end

        begin
          File.open(YogiBerra.yogi_yml, 'r') do |f|
            yaml_file = YAML.load(f)
            YogiBerra.settings = yaml_file["#{environment}"] if yaml_file
          end
        rescue
          YogiBerra::Logger.log("No such file: #{YogiBerra.yogi_yml}", :error)
        end
        YogiBerra.settings
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
        host = YogiBerra.settings["host"]
        port = YogiBerra.settings["port"]
        database = YogiBerra.settings["database"]
        username = YogiBerra.settings["username"]
        password = YogiBerra.settings["password"]
        replica_set = YogiBerra.settings["replica_set"]

        # :w => 0 set the default write concern to 0, this allows writes to be non-blocking
        # by not waiting for a response from mongodb
        Thread.new do
          begin
            if replica_set
              YogiBerra.mongo_client = Mongo::MongoReplicaSetClient.new(replica_set, :w => 0, :connect_timeout => 10)
            else
              YogiBerra.mongo_client = Mongo::MongoClient.new(host, port, :w => 0, :connect_timeout => 10)
            end
          rescue Timeout::Error => timeout_error
            YogiBerra::Logger.log("Couldn't connect to the mongo database timeout on host: #{host} port: #{port}.\n #{timeout_error.inspect}", :error)
            retry
          rescue => error
            YogiBerra::Logger.log("Couldn't connect to the mongo database on host: #{host} port: #{port}.\n #{error.inspect}", :error)
            sleep 1
            retry
          end

          YogiBerra.connection = YogiBerra.mongo_client[database]
          if username && password
            begin
              YogiBerra.connection.authenticate(username, password)
            rescue
              YogiBerra::Logger.log("Couldn't authenticate with user #{username} to mongo database on host: #{host} port: #{port} database: #{database}.", :warn)
            end
          end
        end
      end

      def connect(load_settings = false)
        load_db_settings if load_db_settings

        if YogiBerra.settings
          fork_database
        else
          YogiBerra::Logger.log("Couldn't load the yogi.yml file.", :error) if load_settings
        end
        YogiBerra.connection
      end
    end
  end
end