require_relative '../parser'

class Scraper
  module Piupiu
    class EventsPage < Parser
      def initialize(body)
        @body = Nokogiri::HTML(body, nil, 'ISO-8859-1')
      end

      # I HATE THIS COOOOOOODE D:
      def parse
        events = []

        @body.css('tr').each do |row|
          event = {}

          event[:day] = row.css('td:nth-child(1)').inner_text.strip.to_i
          event[:day_name] = utf8(row.css('td:nth-child(3)').inner_text.strip)

          next if event[:day_name].blank?

          band_data = row.css('td:nth-child(5)')

          event[:band_name] = utf8(band_data.css('strong').inner_text.strip)
          event[:event_description] = strip_event_description(
            band_data.css('strong').first.next
          )

          link = band_data.css('strong a').first
          next if link.nil?

          event[:link] = utf8(link['href'])

          events << event
        end

        events.compact
      end

      private

      def strip_event_description(description)
        utf8(description).gsub(' - ', '').strip
      end
    end
  end
end
