class Scraper
  class << self
    attr_accessor :scrapers

    def inherited(subclass)
      @scrapers ||= []
      @scrapers << subclass
    end
  end

  def scrape
    raise NotImplementedError
  end

  def place
    raise NotImplementedError
  end
end
