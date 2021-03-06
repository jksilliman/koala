require 'spec_helper'

describe "Koala" do

  it "should let an http service be set" do
    Koala.http_service = Koala::MockHTTPService
    Koala.http_service.should == Koala::MockHTTPService
    Koala.base_http_service.should == Koala::NetHTTPService
  end

  describe ".always_use_ssl" do
    it "should be added" do
      # in Ruby 1.8, .methods returns strings
      # in Ruby 1.9, .method returns symbols 
      Koala.methods.collect {|m| m.to_sym}.should include(:always_use_ssl)
      Koala.methods.collect {|m| m.to_sym}.should include(:always_use_ssl=)
    end
  end


  describe ".make_request" do

    before :each do
      Koala.http_service = Koala::MockHTTPService
    end

    it "should use SSL if Koala.always_use_ssl is set to true, even if there's no token" do
      Koala.http_service.should_receive(:make_request).with(anything, anything, anything, hash_including(:use_ssl => true))

      Koala.always_use_ssl = true
      Koala.make_request('anything', {}, 'anything')
    end

    it "should allow the caller to override the http_service" do
      http_service = stub
      http_service.should_receive(:make_request)
      
      Koala.make_request(anything, anything, anything, :http_service => http_service)
    end

  end
end