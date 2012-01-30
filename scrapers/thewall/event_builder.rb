require_relative '../event'

class Scraper
  module Thewall
    class EventBuilder
      def self.build(attributes)
        attributes[:day], attributes[:month] = attributes[:date].split('/')
        attributes[:date] = nil

        Event.new(attributes)
      end
    end
  end
end
