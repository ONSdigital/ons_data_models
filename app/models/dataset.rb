class Dataset
  include Mongoid::Document
  field :title
  field :slug

  belongs_to :series
  has_many :observations
end