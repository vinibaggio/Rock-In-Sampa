# encoding: utf-8

require_relative '../scraper'
require_relative '../place'

require_relative 'browser'
require_relative 'page'

class Scraper
  module Morrison
    class Scraper < ::Scraper
      def scrape
        page = Page.new(Browser.page)
        page.parse!

        page.events
      end

      def place
        Place.new(:name => 'Morrison Rock Bar',
                  :address => 'Rua Inácio Pereira da Rocha, 362, Vila Madalena',
                  :url => 'http://www.morrison.com.br/')
      end
    end
  end
end
