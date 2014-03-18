class ObservationAttribute
  include Mongoid::Document
  # may be able to define types of attributes
  field :name, type: String
  field :title, type: String
  field :value

  embedded_in :observation
end