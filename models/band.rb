class Band
  include DataMapper::Resource

  has n, :events

  property :id          , Serial
  property :name        , String
  property :created_at  , DateTime
  property :description , Text

  def self.find_or_create_band(band)
     first_or_create({:name => band[:name]}, {
       :description => band[:description]
     })
  end
end
