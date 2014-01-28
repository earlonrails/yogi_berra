require 'spec_helper'
require 'bson'

describe "Hash Keys" do
  it "should stringify hash parts to be used with BSON" do
    time = Time.now
    hash = {
      :foo => "bar",
      :bar => Class,
      "object" => {
        :a => 1,
        :b => "1",
        :c => {
          :d => 10.5,
          :e => nil,
          :f => ["one", "two", "three"]
        }
      },
      "time" => time,
      "warden.user.user.key" => "json/bson can't have periods in the keys"
    }
    hash.deep_stringify_keys_and_values!
    hash.should == {
      "foo" => "bar",
      "bar" => "Class",
      "object" => {
        "a" => 1,
        "b" => "1",
        "c" => {
          "d" => 10.5,
          "e" => "",
          "f" => ["one", "two", "three"]
        }
      },
      "time" => time,
      "warden-user-user-key" => "json/bson can't have periods in the keys"
    }
    lambda { BSON::BSON_CODER.serialize(hash) }.should_not raise_error
  end
end