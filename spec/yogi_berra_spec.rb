require 'spec_helper'

describe YogiBerra do
  before(:all) do
    @test_yaml = "spec/fixtures/test.yml"
  end

  before(:each) do
    YogiBerra::Logger.stub(:log)
  end

  it "should call the upstream app with the environment" do
    environment = { 'key' => 'value' }
    app = lambda { |env| ['response', {}, env] }
    stack = YogiBerra::ExceptionMiddleware.new(app)

    response = stack.call(environment)

    response[0].should == 'response'
    response[1].should == {}
    response[2].instance_variable_get("@response").should == { 'key' => 'value' }
  end

  it "deliver an exception raised while calling an upstream app" do
    exception = build_exception
    environment = { 'key' => 'value' }
    app = lambda do |env|
      raise exception
    end

    begin
      stack = YogiBerra::ExceptionMiddleware.new(app)
      stack.call(environment)
    rescue Exception => raised
      raised.should == exception
    end
  end

  it "should deliver an exception in rack.exception" do
    exception = build_exception
    environment = { 'key' => 'value' }

    response = [200, {}, ['okay']]
    app = lambda do |env|
      env['rack.exception'] = exception
      response
    end
    stack = YogiBerra::ExceptionMiddleware.new(app)

    actual_response = stack.call(environment)

    actual_response[0].should == 200
    actual_response[1].should == {}
    actual_response[2].instance_variable_get("@response").should == ["okay"]
  end

  it "should load a yaml file without rails" do
    lambda { YogiBerra::Catcher.load_db_settings(@test_yaml) }.should_not raise_error
    YogiBerra::Catcher.settings.should_not == nil
    YogiBerra::Catcher.settings["project"].should == "test_yogi_project"
  end

  it "should load a yaml file with rails" do
    require 'fixtures/rails'
    lambda { YogiBerra::Catcher.load_db_settings }.should_not raise_error
    YogiBerra::Catcher.settings.should_not == nil
    YogiBerra::Catcher.settings["project"].should == "rails_yogi_project"
  end

  it "should grab a connection using the settings file" do
    connection = nil
    YogiBerra::Catcher.load_db_settings(@test_yaml)
    connection = YogiBerra::Catcher.quick_connection
    connection.should_not == nil
  end

  it "should grab a connection to mongodb" do
    yaml = nil
    yaml = YogiBerra::Catcher.load_db_settings(@test_yaml)
    db_client = YogiBerra::Catcher.db_client(YogiBerra::Catcher.settings["host"], YogiBerra::Catcher.settings["port"])
    db_client.should_not == nil
  end
end