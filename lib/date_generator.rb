class DateGenerator
  def self.beginning_of_day(day)
    DateTime.parse(Time.local(day.year,
                              day.month,
                              day.day,
                              0,
                              0).to_s)
  end

  def self.end_of_day(day)
    DateTime.parse(Time.local(day.year,
                              day.month,
                              day.day,
                              23,
                              59).to_s)
  end

  def self.tomorrow
    Time.now + 24*3600
  end
end
