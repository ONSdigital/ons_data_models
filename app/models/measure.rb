class Measure
  include Mongoid::Document
  field :slug, type: String
  field :name, type: String
  field :title, type: String
  field :description, type: String

  validates :slug, presence: true, uniqueness: {scope: :dataset}
  validates :name, presence: true
  validates :title, presence: true
end