require 'spec_helper'

describe YogiBerra::ExceptionMiddleware do
  before(:each) do
    @test_yaml = "#{SPEC_FOLDER}/fixtures/test.yml"
     YogiBerra::Catcher.load_db_settings(@test_yaml)
  end

  it "should call the upstream app with the environment" do
    # YogiBerra::Logger.stub(:log)
    mock_mongo(:mongo_client_stub => true)
    mock_yogi_fork_database
    environment = { 'key' => 'value' }
    app = lambda { |env| ['response', {}, env] }

    YogiBerra::Catcher.connect
    stack = YogiBerra::ExceptionMiddleware.new(app)

    response = stack.call(environment)
    response[0].should == 'response'
    response[1].should == {}
    response[2].should == { 'key' => 'value' }
  end

  it "deliver an exception raised while calling an upstream app" do
    YogiBerra::Logger.stub(:log)
    mock_mongo(:mongo_client_stub => true, :connection_stub => true)
    mock_yogi_fork_database
    exception = build_exception
    environment = { 'key' => 'value' }
    app = lambda do |env|
      raise exception
    end

    YogiBerra::Catcher.connect
    begin
      stack = YogiBerra::ExceptionMiddleware.new(app)
      stack.call(environment)
    rescue Exception => raised
      raised.should == exception
    end
  end

  it "should deliver an exception in rack.exception" do
    # YogiBerra::Logger.stub(:log)
    mock_mongo(:mongo_client_stub => true, :connection_stub => true)
    mock_yogi_fork_database
    exception = build_exception
    environment = { 'key' => 'value' }

    response = [200, {}, ['okay']]
    app = lambda do |env|
      env['rack.exception'] = exception
      response
    end
    YogiBerra::Catcher.connect
    stack = YogiBerra::ExceptionMiddleware.new(app)

    actual_response = stack.call(environment)
    actual_response[0].should == 200
    actual_response[1].should == {}
    actual_response[2].should == ["okay"]
  end

  it "log only once on app initialization and then be quiet" do
    YogiBerra::Logger.should_receive(:log).exactly(1).times
    mock_mongo(:mongo_client_stub => true, :connection_stub => true, :authenticate_stub => :error)
    mock_yogi_fork_database
    exception = build_exception
    environment = { 'key' => 'value' }

    response = [200, {}, ['okay']]
    app = lambda do |env|
      env['rack.exception'] = exception
      response
    end

    YogiBerra::Catcher.connect
    stack = YogiBerra::ExceptionMiddleware.new(app)

    actual_response = stack.call(environment)
    actual_response[0].should == 200
    actual_response[1].should == {}
    actual_response[2].should == ["okay"]

    actual_response = stack.call(environment)
    actual_response[0].should == 200
    actual_response[1].should == {}
    actual_response[2].should == ["okay"]
  end
end