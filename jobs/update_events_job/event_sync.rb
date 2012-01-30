require_relative '../job'

class UpdateEventsJob < Job
  class EventSync
    def initialize arguments = {}
      @scraped_event = arguments[:scraped_event]
      @band          = arguments[:band]
      @place         = arguments[:place]

      @event = event
    end

    def event
      @event ||= Event.new.tap do |new_event|
        new_event.price_masc  = @scraped_event.price_masc
        new_event.price_fem   = @scraped_event.price_fem
        new_event.occurs_at   = @scraped_event.occurs_at
        new_event.description = @scraped_event.description
        new_event.public      = false
        new_event.band        = @band
        new_event.place       = @place
      end
    end

    def new_event?
      !Event.exist_event?(@place, @band, @event.occurs_at)
    end

    def sync!
      if new_event?
        event.generate_approval_hash!
        event.save
      end
    end
  end
end
