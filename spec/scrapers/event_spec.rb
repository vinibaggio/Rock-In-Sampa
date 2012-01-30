require 'spec_helper'

describe Scraper::Event do
  describe "constructor" do
    describe "band construction" do
      before(:each) do
        @event = Scraper::Event.new(
          :band_name        => "Metallica",
          :band_description => 'Best metal band ever',
          :time             => "23:30",
          :day              => 15,
          :month            => 10,
          :description      => 'Best show ever'
        )
      end

      it "builds a band object" do
        @event.band[:name].must_equal "Metallica"
        @event.band[:description].must_equal "Best metal band ever"
      end
    end

    describe "with splitted attributes" do
      before(:each) do
        @event = Scraper::Event.new(
          :band_name   => "Metallica",
          :time        => "23:30",
          :day         => 15,
          :month       => 10,
          :description => 'Best show ever'
        )
      end

      it "builds event date accordingly" do
        time = Time.local(Time.now.year, 10, 15, 23, 30)

        @event.occurs_at.must_equal time
      end
    end

    describe "with bundled date" do
      before(:each) do
        @event = Scraper::Event.new(
          :band_name   => "Metallica",
          :time        => "23:30",
          :date        => Date.new(2011, 10, 15),
          :description => 'Best show ever'
        )
      end

      it "builds event date accordingly" do
        time = Time.local(Time.now.year, 10, 15, 23, 30)

        @event.occurs_at.must_equal time
      end
    end
  end
end
