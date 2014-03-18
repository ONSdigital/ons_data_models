class CDID
  include Mongoid::Document
  field :notation
  field :title, type: String

  has_and_belongs_to_many :series
  has_and_belongs_to_many :data_set
  has_and_belongs_to_many :observations

end