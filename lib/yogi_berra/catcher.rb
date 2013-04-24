require 'mongo'

module YogiBerra
  class Catcher
    cattr_accessor :settings, :mongo_client, :connection

    class << self
      def load_db_settings
        begin
          File.open("#{Rails.root}/config/yogi.yml", 'r') do |f|
            yaml_file = YAML.load(f)
            @@settings = yaml_file["#{Rails.env}"] if yaml_file
          end
        rescue
          $stderr.puts "[YogiBerra Error] No such file: #{Rails.root}/config/yogi.yml"
        end
      end

      def db_client(host, port)
        # :w => 0 set the default write concern to 0, this allows writes to be non-blocking
        # by not waiting for a response from mongodb
        @@mongo_client = Mongo::MongoClient.new(host, port, :w => 0)
      rescue
        Rails.logger.error "[YogiBerra Error] Couldn't connect to the mongo database on host: #{host} port: #{port}."
        nil
      end

      def quick_connection
        settings = @@settings || load_db_settings
        if settings
          host = settings["host"]
          port = settings["port"]
          client = db_client(host, port)
          if client
            @@connection = client[settings["database"]]
          else
            Rails.logger.error "[YogiBerra Error] Couldn't connect to the mongo database on host: #{host} port: #{port}."
          end
        else
          Rails.logger.error "[YogiBerra Error] Couldn't load the yogi.yml file."
        end
      end
    end
  end
end