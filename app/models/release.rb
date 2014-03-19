class Release
  include Mongoid::Document
  field :slug, type: String
  field :title, type: String
  field :published, type: DateTime
  field :notes

  belongs_to :series 
  has_many :datasets
  
  validates :slug, uniqueness: {scope: :series}
end