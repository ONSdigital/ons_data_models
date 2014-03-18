class Observation
  include Mongoid::Document
  field :type, type: String
  field :value, type: Float
  
  field :base_period, type: String
  field :price, type: Float
  field :seasonal_adjustment, type: String
  field :index_period, type: Date
  field :provisional, type: Boolean
  
  # each observation can have 1 or more dimensions
  # eg. product:bread, geography:UK, date:Q12013
  field :dimension_ids, type: Array, default: []
end