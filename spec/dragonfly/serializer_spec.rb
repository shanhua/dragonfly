# encoding: utf-8
require 'spec_helper'

describe Dragonfly::Serializer do

  include Dragonfly::Serializer

  [
    'a',
    'sdhflasd',
    '/2010/03/01/hello.png',
    '//..',
    'whats/up.egg.frog',
    '£ñçùí;'
  ].each do |string|
    it "should encode #{string.inspect} properly with no padding/line break" do
      b64_encode(string).should_not =~ /\n|=/
    end
    it "should correctly encode and decode #{string.inspect} to the same string" do
      str = b64_decode(b64_encode(string))
      str.force_encoding('UTF-8') if str.respond_to?(:force_encoding)
      str.should == string
    end
  end

  [
    :hello,
    nil,
    true,
    4,
    2.3,
    'wassup man',
    [3,4,5],
    {:wo => 'there'},
    [{:this => 'should', :work => [3, 5.3, nil, {false => 'egg'}]}, [], true]
  ].each do |object|
    it "should correctly marshal encode #{object.inspect} properly with no padding/line break" do
      encoded = marshal_encode(object)
      encoded.should be_a(String)
      encoded.should_not =~ /\n|=/
    end
    it "should correctly marshal encode and decode #{object.inspect} to the same object" do
      marshal_decode(marshal_encode(object)).should == object
    end
  end

  describe "marshal_decode" do
    it "should raise an error if the string passed in is empty" do
      lambda{
        marshal_decode('')
      }.should raise_error(Dragonfly::Serializer::BadString)
    end
    it "should raise an error if the string passed in is gobbledeegook" do
      lambda{
        marshal_decode('ahasdkjfhasdkfjh')
      }.should raise_error(Dragonfly::Serializer::BadString)
    end
  end

  [
    [3,4,5],
    {'wo' => 'there'},
    [{'this' => 'should', 'work' => [3, 5.3, nil, {'egg' => false}]}, [], true]
  ].each do |object|
    it "should correctly json encode #{object.inspect} properly with no padding/line break" do
      encoded = json_encode(object)
      encoded.should be_a(String)
      encoded.should_not =~ /\n|=/
    end
    it "should correctly json encode and decode #{object.inspect} to the same object" do
      json_decode(json_encode(object)).should == object
    end
  end

  describe "json_decode" do
    it "optionally symbolizes keys" do
      json_decode(json_encode('a' => 1), :symbolize_keys => true).should == {:a => 1}
    end
    it "should raise an error if the string passed in is empty" do
      lambda{
        json_decode('')
      }.should raise_error(Dragonfly::Serializer::BadString)
    end
    it "should raise an error if the string passed in is gobbledeegook" do
      lambda{
        json_decode('ahasdkjfhasdkfjh')
      }.should raise_error(Dragonfly::Serializer::BadString)
    end
  end

end
