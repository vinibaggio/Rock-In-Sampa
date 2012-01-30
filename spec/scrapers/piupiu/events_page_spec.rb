# encoding: utf-8
require 'spec_helper'

describe Scraper::Piupiu::EventsPage do
  describe "#events" do
    before(:each) do
      page = load_fixture('piupiu_shows.html')
      @page = Scraper::Piupiu::EventsPage.new(page)
    end

    it "gets a hash of data" do
      event = @page.parse.first

      event[:day].must_equal 1
      event[:day_name].must_equal 'Terça'
      event[:band_name].must_equal 'Hot Rocks e Grungeria'
      event[:event_description].must_equal 'Clássicos do rock e Grunge'
      event[:link].must_equal 'programacao_detalhe.asp?ID=2562'
    end
  end
end
