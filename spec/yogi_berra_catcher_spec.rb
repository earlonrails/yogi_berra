require 'spec_helper'

describe YogiBerra::Catcher do
  before(:all) do
    @test_yaml = "#{SPEC_FOLDER}/fixtures/test.yml"
  end

  before(:each) do
    YogiBerra::Logger.stub(:log)
  end

  it "should load a yaml file without rails" do
    lambda { YogiBerra::Catcher.load_db_settings(@test_yaml) }.should_not raise_error
    YogiBerra::Catcher.settings.should_not == nil
    YogiBerra::Catcher.settings["project"].should == "test_yogi_project"
  end

  it "should load a yaml file with rails" do
    ENV["YOGI_ENV"] = nil
    load "#{SPEC_FOLDER}/fixtures/rails.rb"
    lambda { YogiBerra::Catcher.load_db_settings }.should_not raise_error
    YogiBerra::Catcher.settings.should_not == nil
    YogiBerra::Catcher.settings["project"].should == "rails_yogi_project"
    Object.send(:remove_const, :Rails)
  end

  it "should grab a connection using the settings file" do
    mock_mongo_client(client_should: true)
    connection = nil
    YogiBerra::Catcher.load_db_settings(@test_yaml)
    connection = YogiBerra::Catcher.quick_connection
    connection.should_not == nil
  end

  it "should grab a connection to mongodb" do
    mock_mongo_client(auth: false)
    YogiBerra::Catcher.load_db_settings(@test_yaml)
    db_client = YogiBerra::Catcher.db_client(YogiBerra::Catcher.settings["host"], YogiBerra::Catcher.settings["port"])
    db_client.should_not == nil
  end

  it "should grab a connection and fail to connect after 5 seconds" do
    mock_mongo_client(timeout: true)
    YogiBerra::Catcher.load_db_settings(@test_yaml)
    client = YogiBerra::Catcher.db_client(YogiBerra::Catcher.settings["host"], YogiBerra::Catcher.settings["port"])
    client.should == nil
  end

  it "should grab a connection and authenticate" do
    mock_mongo_client(client_should: true)
    YogiBerra::Catcher.load_db_settings(@test_yaml)
    connection = YogiBerra::Catcher.quick_connection
    connection.should_not == nil
  end

  it "should grab a connection and fail to authenticate" do
    mock_mongo_client(client_should: true, auth: :error)
    YogiBerra::Catcher.load_db_settings(@test_yaml)
    connection = YogiBerra::Catcher.quick_connection
    connection.should_not == nil
  end
end