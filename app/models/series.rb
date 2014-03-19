class Series
  include Mongoid::Document
  field :slug, type: String
  field :title, type: String
  field :description, type: String

  has_many :releases

  embeds_one :contact

  index({slug: 1}, {unique: true, name: "slug_index"})

end