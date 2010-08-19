require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Rankstar do
  describe :rank do
    it "raises an exception if you use an unsupported engine" do
      lambda {Rankstar.rank(:altavista, :keyword => 'somekeyword', :url => 'www.somesite.com')}.should raise_error
    end

    it "raises an error if the keyword option is missing" do
      lambda {Rankstar.rank(:google, :url => 'www.somesite.com')}.should raise_error
    end

    it "raises an error if the keyword site is missing" do
      lambda {Rankstar.rank(:google, :keyword => 'keyword')}.should raise_error
    end

    it "returns crowdint as the #1 site on google for www.crowdint.com" do
      Rankstar.rank(:google, :keyword => 'crowdint', :url => 'www.crowdint.com').should == 1  
    end
  end
end
