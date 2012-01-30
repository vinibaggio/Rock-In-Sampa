require_relative '../parser'

class Scraper
  module Piupiu
    class EventDetailPage < Parser
      def initialize(body)
        @body = Nokogiri::HTML(body, nil, 'ISO-8859-1')
      end

      def parse
        details = {}
        headline = utf8(@body.css('#Layer2 strong').inner_text).strip

        details[:date] = parse_date(headline)
        details[:price] = parse_price(headline)
        details[:time] = parse_time(headline)

        description_text = utf8(@body.css('#Layer1 font[size="2"]').first.inner_text)
        details[:band_description] = strip_description(description_text)

        details
      end

      private

      def parse_date(headline)
        match_data = headline.match(/(\d{1,2})\/(\d{1,2})\/(\d{4})/)
        day, month, year = match_data[1..3]

        Date.new(year.to_i, month.to_i, day.to_i)
      end

      def parse_price(headline)
        match_data = headline.match(/R\$(\d+),(\d+)/)
        money = (match_data[1] + match_data[2]).to_i / 100.0

        money
      end

      def parse_time(headline)
        match_data = headline.match(/(\d{2}:\d{2})/)
        match_data[1]
      end

      def strip_description(description)
        description.gsub(/[\n\r\t]/, '').strip
      end
    end
  end
end
