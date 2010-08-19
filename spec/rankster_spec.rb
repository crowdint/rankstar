require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Rankstar do
  describe :rank do
    it "raises an exception if you use an unsupported engine" do
      lambda {Rankstar.rank(:altavista, :keyword => 'somekeyword', :site => 'www.somesite.com')}.should raise_error
    end

    it "raises an error if the keyword option is missing" do
      lambda {Rankstar.rank(:google, :site => 'www.somesite.com')}.should raise_error
    end

    it "raises an error if the keyword site is missing" do
      lambda {Rankstar.rank(:google, :site => 'www.somesite.com')}.should raise_error
    end
  end
end
