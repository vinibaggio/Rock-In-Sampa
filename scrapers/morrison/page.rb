require 'nokogiri'

require_relative '../event'

class Scraper
  module Morrison
    class Page
      attr_reader :events

      def initialize(html_body)
        @document = Nokogiri::HTML(html_body, nil, 'ISO-8859-1')
      end

      def parse!
        events_tables = @document.css('table:nth-child(4) table')

        current_month = parse_current_month(events_tables)
        @events = parse_events(events_tables[0..-3], current_month)
      end

      private

      def parse_events(event_tables, current_month)
        event_tables.map do |event_table|
          attributes = {:month => current_month}

          attributes[:band_name] = parse_band_name(event_table)
          next if attributes[:band_name].nil?

          attributes[:day] = parse_event_day(event_table)
          attributes[:description] = parse_event_description(event_table)
          attributes[:time] = parse_event_time(attributes[:description])

          Event.new(attributes)
        end.compact
      end

      def parse_current_month(events_tables)
        first_table = events_tables.first
        month_image = first_table.css('tr:first img')[0]

        month_image['src'].gsub(/\s+/,'').match(/m(\d+)\.gif/)[1].to_i
      end

      def parse_event_day(event_table)
        day_image = event_table.css("tr:nth-child(2) img:first")[0]
        day_image['src'].match(/d(\d+)\.gif/)[1].to_i
      end

      def parse_band_name(event_table)
        band_link = event_table.css("tr:nth-child(6) a")[0]

        if band_link
          strip_concert(band_link.content).titlecase
        end
      end

      def parse_event_description(event_table)
        event_table.css("td.ProgTxtProg")[0].content.strip.encode("UTF-8")
      end

      def strip_concert(band_name)
        band_name.gsub('INCONCERT', '').gsub('IN CONCERT', '')
      end

      def parse_event_time(event_description)
        match1 = event_description.match(/(\d\d:\d\d) h/)
        match1 = match1 && match1[1]

        match2 = event_description.match(/(\d\d)h(\d\d)/)
        match2 = match2 && "#{match2[1]}:#{match2[2]}"

        match1 || match2 || "23:00"
      end
    end
  end
end
