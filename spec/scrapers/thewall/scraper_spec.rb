require 'spec_helper'

describe Scraper::Thewall::Scraper do
  class BrowserFake
    attr_accessor :visits, :returns

    def parse_with(url, parser_class)
      @visits ||= []
      @visits << {:url => url, :parser => parser_class}

      @returns[url]
    end

    def returns
      @returns ||= {}
    end
  end

  before(:each) do
    @browser = BrowserFake.new
    @builder = MiniTest::Mock.new
    @builder.expect(:build, nil, [Hash, String])

    @scraper = Scraper::Thewall::Scraper.new
    @scraper.browser = @browser
    @scraper.event_builder = @builder
  end

  describe "#scrape" do
    before(:each) do
      @browser.returns['http://www.thewallcafe.com.br/frame_programacao.htm'] = []
      @scraper.scrape
    end

    it "gets the events with EventsPage parser" do
      @browser.visits.must_include({
        :url => 'http://www.thewallcafe.com.br/frame_programacao.htm',
        :parser => Scraper::Thewall::EventsPage
      })
    end
  end
end

