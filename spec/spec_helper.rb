SPEC_FOLDER = File.dirname(__FILE__)
require 'yogi_berra'
require 'rspec/mocks'

# Helper methods
# Creates RunTimeError
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

def mock_mongo_client(client_should = false, connection_should = false, auth = true)
  mongo_client = double('mongo client')
  mongo_connection = double('mongo connection')
  Mongo::MongoClient.should_receive(:new) { mongo_client }
  mongo_client.should_receive(:[]) { mongo_connection } if client_should
  mongo_connection.should_receive(:authenticate) if auth
  if connection_should
    mongo_connection.should_receive(:[]) { mongo_connection }
    mongo_connection.should_receive(:insert)
  end
  mongo_connection
end

def reset_if_rails
  if defined?(Rails)
    Object.send(:remove_const, :Rails)
  end
end