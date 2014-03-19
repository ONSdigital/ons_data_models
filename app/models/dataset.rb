class Dataset
  include Mongoid::Document
  field :title
  field :slug
  field :structure, type: Hash

  belongs_to :release
  has_many :observations

  validates :slug, uniqueness: {scope: :release}
  validates :structure, presence: true
end