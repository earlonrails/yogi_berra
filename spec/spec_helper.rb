SPEC_FOLDER = File.dirname(__FILE__)
require 'yogi_berra'
require 'rspec/mocks'

def build_exception
  raise Exception
rescue Exception => caught_exception
  caught_exception
end

def build_session
  { "access" =>
    { "user_id" => 30785,
      "id" => 605,
      "password" => "[FILTERED]",
      "auth_key" => "Baseball is ninety percent mental and the other half is physical."
    }
  }
end

def mock_mongo(opts)
  mongo_client = double('mongo client')
  mongo_connection = double('mongo connection')

  if opts[:mongo_client_stub]
    Mongo::MongoClient.should_receive(:new) { mongo_client }
    mongo_client.should_receive(:[]) { mongo_connection }
  end

  if opts[:authenticate_stub] == :error
    mongo_connection.should_receive(:authenticate).and_raise
  else
    mongo_connection.should_receive(:authenticate)
  end

  if opts[:connection_stub]
    mongo_connection.should_receive(:[]) { mongo_connection }
    mongo_connection.should_receive(:insert)
  end
end

def mock_yogi_fork_database
  client = YogiBerra::Catcher.fork_database.join
  YogiBerra::Catcher.should_receive(:fork_database) { client }
end

def reset_if_rails
  if defined?(Rails)
    Object.send(:remove_const, :Rails)
  end
end