require 'spec_helper'

describe YogiBerra do

  it "should call the upstream app with the environment" #do
    # environment = { 'key' => 'value' }
    # app = lambda { |env| ['response', {}, env] }
    # stack = YogiBerra::ExceptionMiddleware.new(app)

    # response = stack.call(environment)

    # assert_equal ['response', {}, environment], response
  #end

  it "deliver an exception raised while calling an upstream app" #do

    # exception = build_exception
    # environment = { 'key' => 'value' }
    # app = lambda do |env|
    #   raise exception
    # end

    # begin
    #   stack = YogiBerra::ExceptionMiddleware.new(app)
    #   stack.call(environment)
    # rescue Exception => raised
    #   assert_equal exception, raised
    # else
    #   flunk "Didn't raise an exception"
    # end

  #end

  it "should deliver an exception in rack.exception" #do

    # exception = build_exception
    # environment = { 'key' => 'value' }

    # response = [200, {}, ['okay']]
    # app = lambda do |env|
    #   env['rack.exception'] = exception
    #   response
    # end
    # stack = YogiBerra::ExceptionMiddleware.new(app)

    # actual_response = stack.call(environment)

    # assert_equal response, actual_response

  #end

end