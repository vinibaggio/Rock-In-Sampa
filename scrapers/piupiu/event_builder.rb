require_relative '../event'

class Scraper
  module Piupiu
    class EventBuilder
      def self.build(event, event_detail)
        attributes = {
          :band_name   => event[:band_name],
          :description => event[:event_description],
          :date        => event_detail[:date],
          :price_masc  => event_detail[:price],
          :time        => event_detail[:time]
        }

        Event.new(attributes)
      end
    end
  end
end
