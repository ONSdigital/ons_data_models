class Dimension
  include Mongoid::Document
  field :slug, type: String
  field :name, type: String
  field :title, type: String
  field :dimension_type

  validates :slug, presence: true, uniqueness: true
  validates :name, presence: true
  validates :dimension_type, presence: true
end