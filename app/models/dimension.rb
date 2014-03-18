class Dimension
  include Mongoid::Document

  # on import of data, we create a dimension for every possible dimension 
  # as described in the concept scheme for that dimension
  field :slug, type: String
  field :name, type: String
  field :title, type: String

  # a dimension's value is one of a set of defined values
  # from a dimension's concept scheme
  # eg. name: cdid, title: CDID, value: mca25
  # value: mca25 in the concept scheme, title is : "All the bread"
  field :value

  #has_one: concept_scheme

  has_and_belongs_to_many :observations
end