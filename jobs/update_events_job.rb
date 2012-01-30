require 'bundler'
Bundler.require

require_relative 'job'

require_relative '../scrapers/scraper'
require_relative '../scrapers/morrison/scraper'
require_relative '../scrapers/piupiu/scraper'
require_relative '../scrapers/thewall/scraper'

require_relative 'job_report'

require_relative 'update_events_job/event_sync'

class UpdateEventsJob < Job
  def execute
    @report = JobReport.new
    run_scrapers

    @report.deliver
  end

  private

  def run_scrapers
    Scraper.scrapers.each do |scraper_class|
      begin
        scraper = scraper_class.new

        place = Place.find_or_create_place(scraper.place)
        log.info "Updating events for: #{place.name}"

        process_place_events(scraper, place)
      rescue StandardError => e
        log.error "Error parsing: #{scraper_class} failed - #{e}"
        log.error "Backtrace:"
        e.backtrace.each { |b| log.error b }
      end
    end
  end

  def process_place_events(scraper, place)
    scraper.scrape.each do |scraped_event|
      log.info "Adding event #{scraped_event.band[:name]} @ #{scraped_event.occurs_at}"

      band = create_or_retrieve_band(scraped_event.band)
      create_event(place, band, scraped_event)
    end
  end

  def create_or_retrieve_band(scraped_band)
    Band.find_or_create_band(scraped_band)
  end

  def create_event(place, band, scraped_event)
    sync = EventSync.new(:place => place,
                         :band => band,
                         :scraped_event => scraped_event)

    event = sync.event

    if !sync.new_event?
      log.info "Skipping event: #{event.band.name}"
      @report.skipped << event
    elsif sync.sync!
      log.info "Event created successfully: #{event.band.name}"
      @report.successes << event
    else
      log.error "Unable to create entity: #{event.errors.inspect}"
      @report.failures << event
    end
  end
end

UpdateEventsJob.new.execute
