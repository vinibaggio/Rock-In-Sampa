class Scraper
  class Event
    attr_reader :occurs_at, :description, :price_masc,
      :price_fem, :band

    def initialize attributes={}
      @price_masc  = attributes[:price_masc]
      @price_fem   = attributes[:price_fem]
      @description = attributes[:description]
      @band        = create_band(attributes)
      @occurs_at   = select_date_attribute(attributes)
    end

    private

    def create_band(attributes)
      {
        :name => attributes[:band_name],
        :description => attributes[:band_description]
      }
    end

    def select_date_attribute(attributes)
      if !attributes[:date].nil?
        parse_time(attributes[:date].month, attributes[:date].day, attributes[:time])
      else
        parse_time(attributes[:month], attributes[:day], attributes[:time])
      end
    end

    def parse_time(month, day, time_as_clock)
      hour, minutes = time_as_clock.split(":")
      Time.local(Time.now.year, month, day, hour, minutes)
    end
  end
end
