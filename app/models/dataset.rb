class Dataset
  include Mongoid::Document
  field :title
  field :slug

  # skipping the relationship to series atm
  # belongs_to :release

  belongs_to :series
  has_many :observations
end