class Release
  include Mongoid::Document
  field :slug, type: String
  field :title, type: String
  field :published, type: DateTime
  field :notes, type: String
  field :comments, type: String
  field :state, type: String
  
  embeds_one :contact
    
  belongs_to :series 
  has_many :datasets
  
  validates :slug, uniqueness: {scope: :series}
end