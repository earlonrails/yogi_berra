SPEC_FOLDER = File.dirname(__FILE__)
require 'yaml'
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

