class ConceptScheme
  include Mongoid::Document
  field :title, type: String
  field :values

  # field values is a hash
  # you look up the value, based on what you've saved in dimension
  # that will then give you title
end