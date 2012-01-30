require 'spec_helper'

describe UpdateEventsJob::EventSync do
  before(:each) do
    @scraped_event_mock = MiniTest::Mock.new
    @scraped_event_mock.expect(:price_masc, 15.00)
    @scraped_event_mock.expect(:price_fem, 10.00)
    @scraped_event_mock.expect(:occurs_at, Time.now)
    @scraped_event_mock.expect(:description, 'A freakin awesome show')
    @scraped_event_mock.expect(:public, true)

    @place_mock = mock(:id => 1)
    @band_mock  = mock(:id => 1)

    @sync = UpdateEventsJob::EventSync.new(:scraped_event => @scraped_event_mock,
                                           :band => @band_mock,
                                           :place => @place_mock)
  end

  describe ".event" do
    it "copies several attributes from the object" do
      event = @sync.event

      event.price_masc.must_equal 15.00
      event.price_fem.must_equal 10.00
      event.occurs_at.to_time.to_i.must_be_close_to Time.now.to_i, 5
      event.description.must_equal 'A freakin awesome show'
      event.place.must_equal @place_mock
      event.band.must_equal @band_mock
    end

    it "sets the new event as private" do
      event = @sync.event

      event.public.wont_equal true
    end
  end

  describe ".new_event?" do
    describe "when there's an event in the database" do
      it "returns false" do
        Event.expects(:exist_event?).with(@place_mock,
                                           @band_mock,
                                           @sync.event.occurs_at).
                                           returns(true)

        @sync.wont_be :new_event?
      end
    end

    describe "when there's no event in the database" do
      it "returns true" do
        Event.expects(:exist_event?).with(@place_mock,
                                           @band_mock,
                                           @sync.event.occurs_at).
                                           returns(false)

        @sync.must_be :new_event?
      end
    end
  end

  describe ".sync!" do
    describe "when there's an event in the database" do
      it "does not save nor generates a new hash" do
        Event.expects(:exist_event?).with(@place_mock,
                                          @band_mock,
                                          @sync.event.occurs_at).
                                          returns(true)

        @sync.sync!.must_be_nil
      end
    end

    describe "when there are no events in the database" do
      before(:each) do
        Event.expects(:exist_event?).with(@place_mock,
                                          @band_mock,
                                          @sync.event.occurs_at).
                                          returns(false)
      end

      it "generates approval hash and saves de object" do
        @sync.event.expects(:save)
        @sync.sync!

        @sync.event.wont_be_nil
      end
    end
  end
end
