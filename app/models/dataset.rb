class Dataset
  include Mongoid::Document
  field :title
  field :slug
  field :structure, type: Hash
  field :data_attributes, type: Hash

  belongs_to :release
  has_many :observations

  validates :slug, uniqueness: {scope: :release}
  validates :structure, presence: true
  validate :structure_maps_dimensions_to_concepts

  def structure_maps_dimensions_to_concepts
    structure.each_pair do |key, value|
      if Dimension.find(key).nil?
        errors.add(:structure, "Unknown dimension")
      end
      if ConceptScheme.find(value).nil?
        errors.add(:structure, "Unknown Concept Scheme")
      end
    end
  end

  def has_field?(field_name)
    structure.map{|x| Dimension.find(x[0])}.any?{|x| x.name == field_name}
  end

  def concept_scheme_for_dimension(dimension_name)
    dimension = structure.map{|x| Dimension.find(x[0])}.find{|x| x.name == dimension_name}
    ConceptScheme.find(structure[dimension.id])
  end
end