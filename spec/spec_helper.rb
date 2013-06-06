# Load support files
$:.unshift("../lib/yogi_berra/*")
require 'yogi_berra'
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

# Helper methods
# Creates RunTimeError
def build_exception
  raise
rescue => caught_exception
  caught_exception
end

