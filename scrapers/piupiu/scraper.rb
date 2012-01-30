# encoding: utf-8

require_relative '../scraper'
require_relative '../place'

require_relative '../simple_browser'
require_relative 'events_page'
require_relative 'event_detail_page'
require_relative 'event_builder'

class Scraper
  module Piupiu
    EVENTS_PATH = 'shows_semana.asp'
    URL = 'http://www.cafepiupiu.com.br/'

    class Scraper < ::Scraper
      attr_writer :browser, :event_builder

      def scrape
        events = browser.parse_with(URL + EVENTS_PATH, EventsPage)

        events.map do |event|
          event_detail = browser.parse_with(URL + event[:link], EventDetailPage)
          event_builder.build(event, event_detail)
        end
      end

      def place
        Place.new(:name => 'Café Piu Piu',
                  :address => 'Rua 13 Maio, 134, Bixiga',
                  :url => URL)
      end

      def browser
        @browser ||= Scraper::SimpleBrowser
      end

      def event_builder
        @event_builder ||= EventBuilder
      end
    end
  end
end
