class Release
  include Mongoid::Document
  field :slug, type: String
  field :title, type: String
  field :published, type: DateTime
  field :notes

  belongs_to :series 
  has_many :datasets
  
#  validates :slug, presence: true, uniqueness: true, slug: true  
#  validates :title, presence: true

  def previous_release
    # find previous published release
  end
end