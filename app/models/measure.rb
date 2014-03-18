class Measure
  include Mongoid::Document
  # may be able to define some types of measures
  field :name, type: String
  field :title, type: String
  field :value

  embedded_in :observation
end