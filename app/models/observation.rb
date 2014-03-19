class Observation
  include Mongoid::Document
  field :slug, type: String
  field :measure

  belongs_to :dataset

  # James is going to do meta data programming for dimensions
  validates :slug, presence: true, uniqueness: {scope: :dataset}
end