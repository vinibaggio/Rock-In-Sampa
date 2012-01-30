class Event
  include DataMapper::Resource

  belongs_to :place
  belongs_to :band

  property :id            , Serial
  property :price_masc    , Decimal, :scale => 2, :precision => 5
  property :price_fem     , Decimal, :scale => 2, :precision => 5
  property :occurs_at     , DateTime
  property :description   , Text
  property :approval_hash , String
  property :public        , Boolean
  property :created_at    , DateTime

  def self.public
    all(:public => true)
  end

  def self.private
    all(:public => false)
  end

  def self.tomorrow
    tomorrow = DateGenerator.tomorrow

    beginning_of_day = DateGenerator.beginning_of_day(tomorrow)
    end_of_day = DateGenerator.end_of_day(tomorrow)

    all(:occurs_at => (beginning_of_day..end_of_day))
  end

  def self.today
    today = Time.now

    beginning_of_day = DateGenerator.beginning_of_day(today)
    end_of_day = DateGenerator.end_of_day(today)

    all(:occurs_at => (beginning_of_day..end_of_day))
  end

  def self.approve_with_hash!(hash)
    event = first(:approval_hash => hash)

    event.approve! if event
  end

  def self.reject_with_hash!(hash)
    event = first(:approval_hash => hash)

    if event
      event.approval_hash = ''
      event.public = false
      event.save
    end
  end

  def self.exist_event?(place, band, time)
    count(:place_id  => place.id,
          :band_id   => band.id,
          :occurs_at => time) > 0
  end

  def generate_approval_hash!
    self.approval_hash =  (1..30).inject('') { |sum, _| sum << rand(37).to_s(36) }
  end

  def approve!
    self.approval_hash = ''
    self.public = true
    save
  end

  def hour
    time = "#{occurs_at.hour}h"
    time << "#{occurs_at.minute}" if occurs_at.minute > 0

    time
  end

  def separate_prices?
    price_masc && price_fem
  end

  def same_prices?
    price_masc && !price_fem
  end

  def band_name
    band && band.name
  end
end
