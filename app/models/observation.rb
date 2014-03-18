class Observation
  include Mongoid::Document
  #field :type, type: String
  field :title, type: String
  belongs_to :dataset

  # each observation can have 1 or more dimensions
  # eg. product:bread, geography:UK, date:Q12013
  has_and_belongs_to_many :dimensions

  # each observation has 0 or many attributes
  # these are optional fields that differ from each dataset/series
  embeds_many :observation_attributes

  # each observation has 1 or more measures
  # these differe from each dataset
  # eg beach health data set, takes 5 measures of levels of toxicity
  # eg uk online survey, takes 1 measure of number of people online
  embeds_many :measures
end