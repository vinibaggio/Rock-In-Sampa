class Scraper
  class Place
    attr_reader :name, :address, :url

    def initialize(attributes={})
      @name    = attributes[:name]
      @address = attributes[:address]
      @url     = attributes[:url]
    end
  end
end
