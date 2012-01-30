# encoding: utf-8

require 'spec_helper'

describe Scraper::Thewall::EventBuilder do
  before(:each) do
    @event = {
      :description => 'Chopp grátis',
      :date => '08/10',
      :day_name => 'Sábado',
      :band_name => 'Columbia Rock',
      :price_masc => 15.00,
      :price_fem => 12.00,
      :time => '23:00'
    }
  end

  describe ".build" do
    it "selects and build event object according to the supplied hashes" do
      event = Scraper::Thewall::EventBuilder.build(@event)

      event.price_masc.must_equal 15.00
      event.price_fem.must_equal 12.00
      event.band[:name].must_equal 'Columbia Rock'
      event.description.must_equal 'Chopp grátis'
      event.occurs_at.must_equal Time.local(2011, 10, 8, 23, 00)
    end
  end
end
