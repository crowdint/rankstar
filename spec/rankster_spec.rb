require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

# Mock response object
class HTTPResponse
  attr_accessor :body
  def initialize(body)
    self.body = body
  end
end

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

    it "returns crowdint with a rank of 1 on google for www.crowdint.com" do
      # Mock Google's response
      Net::HTTP.should_receive(:get_response).and_return(HTTPResponse.new(google_response))
      Rankstar.rank(:google, :keyword => 'crowdint', :url => 'www.crowdint.com', :limit => 300).should == 1  
    end

    it "returns crowdint with a rank of 2 on yahoo for www.crowdint.com" do
      # Mock Yahoo's response
      Net::HTTP.should_receive(:get_response).and_return(HTTPResponse.new(yahoo_response))
      Rankstar.rank(:yahoo, :keyword => 'crowdint', :url => 'www.crowdint.com', :limit => 300).should == 2
    end

    it "returns crowdint with a rank of 2 on bing for www.crowdint.com" do
      # Mock Bing's response
      Net::HTTP.should_receive(:get_response).and_return(HTTPResponse.new(bing_response))
      Rankstar.rank(:bing, :keyword => 'crowdint', :url => 'www.crowdint.com', :limit => 300).should == 2
    end
  end
end
