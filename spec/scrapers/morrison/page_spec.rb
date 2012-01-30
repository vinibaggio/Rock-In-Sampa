require 'spec_helper'

describe Scraper::Morrison::Page do
  before(:each) do
    body = load_fixture('morrison.html')

    @page = Scraper::Morrison::Page.new(body)
  end

  describe "#parse!" do
    before(:each) do
      @page.parse!
    end

    it "retrieves events" do
      @page.events.each do |event|
        event.must_be_kind_of Scraper::Event
      end
    end
  end
end
