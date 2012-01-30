require 'spec_helper'

describe Scraper::Morrison::Browser do
  before(:each) do
    headers = load_fixture('morrison_headers.txt')
    headers_hash = Hash[*headers.split(/[:\n]/)]

    stub_request(:get, "http://morrison.com.br/").
      with(:headers => {'User-Agent'=>'Typhoeus - http://github.com/dbalatero/typhoeus/tree/master'}).
      to_return(:status => 302, :body => "", :headers => headers_hash)

    stub_request(:get, "http://morrison.com.br/hotsite/default.asp").
      with(:headers => {
        'Cookie'=>' ASPSESSIONIDSSRBAQQS=DDGNPAPDEPCJEAEFDEHBENGC; path=/',
        'User-Agent'=>'Typhoeus - http://github.com/dbalatero/typhoeus/tree/master'}).
        to_return(:status => 200, :body => "success")
  end

  describe ".get" do
    it "reads the page accordingly" do
      response_body = Scraper::Morrison::Browser.page
      response_body.must_equal "success"
    end
  end
end
