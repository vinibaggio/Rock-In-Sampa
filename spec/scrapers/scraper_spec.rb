require 'spec_helper'

describe Scraper do
  before(:each) do
    @subclass = Class.new(Scraper)
  end

  after(:each) do
    Scraper.scrapers = []
  end

  describe "when inherited" do
    it "registers child class" do
      Scraper.scrapers.must_equal [@subclass]
    end
  end

  describe "#scrape" do
    it "raises errors on not implemented scrape method" do
      instance = @subclass.new
      proc { instance.scrape }.must_raise NotImplementedError
    end
  end

  describe "#place" do
    it "raises errors on not implemented place method" do
      instance = @subclass.new
      proc { instance.place }.must_raise NotImplementedError
    end
  end
end
