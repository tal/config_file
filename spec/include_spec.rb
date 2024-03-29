require 'spec_helper'

module IncludeTest
  include ConfigFile
end

module Test2
  include ConfigFile
  self.config_file_name = 'include_test'
end

describe "ConfigFile" do
  it "should look for include_test.yml" do
    IncludeTest.config_file.should_not be_a(ConfigFile::File)
  end

  it "should define methods for each key" do
    IncludeTest.should respond_to(:key1)
    IncludeTest.should respond_to(:key2)
  end

  it "should return expected value" do
    IncludeTest.key1.should == 'key1'
    IncludeTest.key2.should == 'key2'
  end

  it "should define methods for each key" do
    Test2.should respond_to(:key1)
    Test2.should respond_to(:key2)
  end

  it "should return expected value" do
    Test2.key1.should == 'key1'
    Test2.key2.should == 'key2'
  end
end
