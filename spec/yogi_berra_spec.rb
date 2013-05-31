require 'spec_helper'

describe YogiBerra do

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

end