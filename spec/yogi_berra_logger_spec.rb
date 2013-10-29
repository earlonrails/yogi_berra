require 'spec_helper'

describe YogiBerra::Logger do

  it "should call $stderr to log" do
    reset_if_rails
    $stderr.should_receive(:puts).with("[YogiBerra Info] The future ain't what it used to be.")
    YogiBerra::Logger.log("The future ain't what it used to be.")
  end

  it "should call Rails::Logger" do
    load "#{SPEC_FOLDER}/fixtures/rails.rb"
    logger = double('logger')
    Rails.stub(:logger) { logger }
    logger.should_receive(:info).with("[YogiBerra Info] Half the lies they tell about me aren't true.")
    YogiBerra::Logger.log("Half the lies they tell about me aren't true.")
  end
end