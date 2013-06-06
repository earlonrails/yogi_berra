# Load support files
SPEC_FOLDER = File.dirname(__FILE__)
require 'yaml'
require 'yogi_berra'
# Helper methods


# Creates RunTimeError
def build_exception
  raise
rescue => caught_exception
  caught_exception
end

