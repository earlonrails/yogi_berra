require 'spec_helper'
require 'bson'

describe "Hash Keys" do
  it "should stringify hash parts to be used with BSON" do
    hash = {:foo => "bar", :bar => Class, "object" => {:a => 1, :b => "1", :c => {:d => 10.5, :e => nil}}}
    hash.deep_stringify_keys_and_values!
    lambda { BSON::BSON_CODER.serialize(hash) }.should_not raise_error
  end
end