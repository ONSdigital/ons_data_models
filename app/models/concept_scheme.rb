class ConceptScheme
  include Mongoid::Document
  field :title, type: String
  field :description, type: String
  field :slug, type: String
  field :values, type: Hash

  validates :title, presence: true
  validates :slug, presence: true, uniqueness: true
  validates :values, presence: true

  def has_value?(value)
    values.has_key?value
  end
end