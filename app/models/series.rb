class Series
  include Mongoid::Document
  field :slug, type: String
  field :title, type: String
  field :language, type: String
  field :frequency, type: String
  field :notes, type: String

  has_many :releases
  has_many :datasets

  embeds_one :contact

  index({slug: 1}, {unique: true, name: "slug_index"})

  validates :slug, presence: true, uniqueness: true
  validates :title, presence: true
  validates :frequency, inclusion: {in: ["annualy", "monthly", "weekly"]}
  validates :language, inclusion: {in: ["english"]}
end