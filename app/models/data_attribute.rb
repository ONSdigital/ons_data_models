class DataAttribute
  include Mongoid::Document
  field :slug, type: String
  field :name, type: String
  field :title, type: String
  
  validates :slug, presence: true, uniqueness: true
  validates :name, presence: true
end