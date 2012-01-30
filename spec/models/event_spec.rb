require 'spec_helper'

describe Event do
  describe ".exist_event?" do
    describe "with preexisting event" do
      it "returns true" do
        time = Time.now
        band_mock = mock(:id => 1)
        place_mock = mock(:id => 1)

        Event.expects(:count).with(:place_id => 1,
                                   :band_id => 1,
                                   :occurs_at => time).returns(5)

        Event.exist_event?(place_mock, band_mock, time).must_equal true
      end
    end

    describe "with no preexisting event" do
      it "returns false" do
        time = Time.now
        band_mock = mock(:id => 1)
        place_mock = mock(:id => 1)

        Event.expects(:count).with(:place_id => 1,
                                   :band_id => 1,
                                   :occurs_at => time).returns(0)

        Event.exist_event?(place_mock, band_mock, time).must_equal false
      end
    end
  end

  describe "#hour" do
    describe "with minutes" do
      it "builds time with minutes" do
        time = DateTime.civil(2011, 10, 15, 23, 30)
        event = Event.new(:occurs_at => time)

        event.hour.must_equal "23h30"
      end
    end

    describe "without minutes" do
      it "builds time with minutes" do
        time = DateTime.civil(2011, 10, 15, 23, 0)
        event = Event.new(:occurs_at => time)

        event.hour.must_equal "23h"
      end
    end
  end

  describe "#separate_prices" do
    it "is true when there are both prices specified" do
      event = Event.new(:price_masc => 15, :price_fem => 10)
      event.must_be :separate_prices?
    end

    it "is false when there are both prices specified" do
      event = Event.new(:price_masc => 15)
      event.wont_be :separate_prices?
    end

    it "is false when none prices specified" do
      event = Event.new
      event.wont_be :separate_prices?
    end
  end

  describe "#same_prices?" do
    it "is true when there is only one price specified" do
      event = Event.new(:price_masc => 15)
      event.must_be :same_prices?
    end

    it "is false when there are both prices specified" do
      event = Event.new(:price_masc => 15, :price_fem => 10)
      event.wont_be :same_prices?
    end

    it "is false when none prices specified" do
      event = Event.new
      event.wont_be :same_prices?
    end
  end
end
