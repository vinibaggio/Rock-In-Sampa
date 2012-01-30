class Place
  include DataMapper::Resource

  has n, :events

  property :id      , Serial
  property :name    , String
  property :address , String
  property :url     , String

  def self.find_or_create_place(place)
     first_or_create({:name => place.name}, {
       :address => place.address,
       :url => place.url
     })
  end
end
