require 'nokogiri'

class Scraper
  class Parser
    def initialize(body)
      @body = Nokogiri::HTML(body)
    end

    def utf8(str)
      str.to_s.encode("UTF-8")
    end
  end
end
