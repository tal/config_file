require 'spec_helper'

describe 'ConfigFile' do

  context "no namespaceing" do
    it "should get the value" do
      ConfigFile.base.base.should == 'foo'
    end
  end
end