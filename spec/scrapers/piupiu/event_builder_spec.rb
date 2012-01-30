# encoding: utf-8

require 'spec_helper'

describe Scraper::Piupiu::EventBuilder do
  before(:each) do
    @event = {
      :day               => 11,
      :day_name          => 'Terça',
      :band_name         => 'Rockstock',
      :event_description => 'Clássicos do rock',
      :link              => 'programacao_detalhe.asp?ID=2574'
    }

    @event_detail = {
      :date             => Date.new(2011, 10, 11),
      :price            => 18.00,
      :time             => '23:30',
      :band_description => "Band description"
    }
  end

  describe ".build" do
    it "selects and build event object according to the supplied hashes" do
      event = Scraper::Piupiu::EventBuilder.build(@event, @event_detail)

      event.price_masc.must_equal 18.00
      event.price_fem.must_be_nil
      event.band[:name].must_equal 'Rockstock'
      event.description.must_equal 'Clássicos do rock'
      event.occurs_at.must_equal Time.local(2011, 10, 11, 23, 30)
    end
  end
end
