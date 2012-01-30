# encoding: utf-8

require_relative '../scraper'
require_relative '../place'

require_relative '../simple_browser'
require_relative 'events_page'
require_relative 'event_builder'

class Scraper
  module Thewall
    EVENTS_PATH = 'frame_programacao.htm'
    URL = 'http://www.thewallcafe.com.br/'

    class Scraper < ::Scraper
      attr_writer :browser, :event_builder

      def scrape
        events = browser.parse_with(URL + EVENTS_PATH, EventsPage)

        events.map do |event|
          event_builder.build(event)
        end
      end

      def place
        Place.new(:name => 'The Wall Café',
                  :address => 'Rua 13 Maio, 152, Bela Vista',
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
