require 'spec_helper'

describe YogiBerra::Data do
  before(:each) do
    YogiBerra::Logger.stub(:log)
    YogiBerra::Catcher.load_db_settings("#{SPEC_FOLDER}/fixtures/test.yml")
  end

  it "should store an exception" do
    exception = build_exception
    mock_mongo_client(:client_should => true, :connection_should => true)
    YogiBerra::Catcher.quick_connection
    YogiBerra::Data.store!(exception)
  end

  it "should parse an exception" do
    exception = build_exception
    parsed_data = YogiBerra::Data.parse_exception(exception)
    parsed_data[:error_class].should == "Exception"
    parsed_data[:project].should == "test_yogi_project"
    parsed_data[:error_message].should == "Exception"
    parsed_data[:backtraces].size.should > 1
  end

  it "should parse a session" do
    session = build_session
    parsed_session = YogiBerra::Data.parse_session(session)
    parsed_session["password"].should == nil
    parsed_session["access"]["password"].should == nil
    parsed_session["access"]["user_id"].should == 30785
    parsed_session["access"]["id"].should == 605
    parsed_session["access"]["auth_key"].should == "Baseball is ninety percent mental and the other half is physical."
  end
end