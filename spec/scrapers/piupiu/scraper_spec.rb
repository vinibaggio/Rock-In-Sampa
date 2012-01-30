require 'spec_helper'

describe Scraper::Piupiu::Scraper do
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

    @scraper = Scraper::Piupiu::Scraper.new
    @scraper.browser = @browser
    @scraper.event_builder = @builder
  end

  describe "#scrape" do
    before(:each) do
      @browser.returns['http://www.cafepiupiu.com.br/shows_semana.asp'] = [
        { :link => 'programacao_detalhe.asp?ID=2574' }
      ]
      @scraper.scrape
    end

    it "gets the events with EventsPage parser" do
      @browser.visits.must_include({
        :url => 'http://www.cafepiupiu.com.br/shows_semana.asp',
        :parser => Scraper::Piupiu::EventsPage
      })
    end

    it "gets the event detail with EventDetailPage parser" do
      @browser.visits.must_include({
        :url => 'http://www.cafepiupiu.com.br/programacao_detalhe.asp?ID=2574',
        :parser => Scraper::Piupiu::EventDetailPage
      })
    end
  end
end
