# encoding: utf-8

require_relative '../parser'

class Scraper
  module Thewall
    class EventsPage < Parser
      def initialize(body)
        @body = Nokogiri::HTML(body, nil, 'WINDOWS-1252')
      end

      def parse
        events = []

        @body.css('tr table')[0..-3].each do |row|
          event = {}

          event_text = utf8(row.css('td:nth-child(2)').inner_text.strip)
          event_text.gsub!(/\s{2,}/, ' ')

          event[:day_name], event[:date] = day(event_text)
          event[:band_name] = band_name(event_text)
          event[:price_fem], event[:price_masc] = prices(event_text)
          event[:description] = description(event_text)

          event[:time] = "23:00"

          events << event
        end

        events
      end

      private

      def day(event_text)
         day_name, date = event_text.split(/\s+/)

         [day_name, date.gsub(/[^\d\/]+/, '')]
      end

      def band_name(event_text)
        match = event_text.match(/\d{2}\/\d{2}[^-]*-(.*)R.*Mulher/)
        match[1].strip
      end

      def prices(event_text)
        match = event_text.match(/R\$ ([\d,]+)\s*Mulher\s*R\$ ([\d,]+)\s*Homem/)

        price_fem = match[1]
        price_masc = match[2]

        [convert_price(price_fem), convert_price(price_masc)]
      end

      def convert_price(price_string)
        price_string.gsub(',', '.').to_f
      end

      def description(event_text)
        description = event_text.match(/Homem - (.*)$/)[1]
        description.gsub!(' veja um vídeo da banda', '')

        description
      end
    end
  end
end
