require 'rubygems'
require 'yogi_berra'
YogiBerra::Catcher.load_db_settings("config/yogi.yml")
ENV["YOGI_ENV"] = "development"
YogiBerra::Catcher.load_db_settings("config/yogi.yml")
YogiBerra::Catcher.quick_connection
error = nil
begin
  [
    lambda { raise Exception }, lambda { raise StandardError }, lambda { raise NoMethodError },
    lambda { raise ArgumentError }, lambda { raise NameError }, lambda { raise NoMemoryError },
    lambda { raise ScriptError }, lambda { raise LoadError }, lambda { raise NotImplementedError },
    lambda { raise SyntaxError }, lambda { raise SignalException }, lambda { raise IOError },
    lambda { raise ActiveResource::ConnectionError }, lambda { raise ActiveResource::TimeoutError },
    lambda { raise ActiveRecord::RecordNotFound }, lambda { raise ActiveRecord::SubclassNotFound },
    lambda { raise ActiveRecord::RecordInvalid }, lambda { raise ActiveRecord::StatementInvalid }
  ].choice.call

rescue => e
  error = e
end

YogiBerra.exceptionize(error)