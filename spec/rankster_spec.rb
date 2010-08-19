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
      lambda {Rankstar.rank(:altavista, 'somekeyword', 'www.somesite.com')}.should raise_error
    end

    it "returns crowdint with a rank of 1 on google for www.crowdint.com" do
      # Mock Google's response
      Net::HTTP.stub!(:get_response).and_return(HTTPResponse.new(google_response))
      Rankstar.rank(:google, 'crowdint', 'www.crowdint.com', :limit => 300).should == 1  
    end

    it "returns crowdint with a rank of 2 on yahoo for www.crowdint.com" do
      # Mock Yahoo's response
      Net::HTTP.stub!(:get_response).and_return(HTTPResponse.new(yahoo_response))
      Rankstar.rank(:yahoo, 'crowdint', 'www.crowdint.com', :limit => 300).should == 2
    end

    it "returns crowdint with a rank of 2 on bing for www.crowdint.com" do
      # Mock Bing's response
      Net::HTTP.stub!(:get_response).and_return(HTTPResponse.new(bing_response))
      Rankstar.rank(:bing, 'crowdint', 'www.crowdint.com', :limit => 300).should == 2
    end

    it "returns crowdint with a rank of 1 on google for www.crowdint.com" do
      # Mock Google's incorrect response
      Net::HTTP.stub!(:get_response).and_return(HTTPResponse.new(google_not_found))
      Rankstar.rank(:google, 'something irrational', 'www.crowdint.com', :limit => 100).should be_nil
    end
  end
end
