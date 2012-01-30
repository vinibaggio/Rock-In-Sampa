require 'typhoeus'

class Scraper
  class SimpleBrowser
    class << self
      def get(url)
        response = Typhoeus::Request.get(url, :follow_location => true)
        response.body
      end

      def parse_with(url, parser)
        parser.new(get(url)).parse
      end
    end
  end
end
