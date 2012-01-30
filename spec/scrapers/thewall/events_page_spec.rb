# encoding: utf-8
require 'spec_helper'

describe Scraper::Thewall::EventsPage do
  describe "#events" do
    before(:each) do
      page = load_fixture('thewall.html')
      @page = Scraper::Thewall::EventsPage.new(page)
    end

    it "gets a hash of data" do
      events = @page.parse

      event = events[0]
      event[:date].must_equal '07/10'
      event[:day_name].must_equal 'Sexta-Feira'
      event[:band_name].must_equal 'Guns \'n Roses Cover + Columbia Trio'
      event[:price_masc].must_equal 12.00
      event[:price_fem].must_equal 10.00
      event[:time].must_equal '23:00'
      event[:description].must_equal 'Chopp Grátis até à 01h00'

      event = events[1]
      event[:date].must_equal '08/10'
      event[:day_name].must_equal 'Sábado'
      event[:band_name].must_equal 'Columbia Rock'
      event[:price_masc].must_equal 15.00
      event[:price_fem].must_equal 12.00
      event[:time].must_equal '23:00'
      event[:description].must_equal 'Chopp Grátis até à 00h30'
    end
  end
end
