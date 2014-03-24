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
  validate :data_attributes_maps_to_concepts

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

  def data_attributes_maps_to_concepts
    data_attributes.each_pair do |key, value|
      if DataAttribute.find(key).nil?
        errors.add(:data_attributes, "Unknown data attribute")
      end
      unless value.nil?
        if ConceptScheme.find(value).nil?
          errors.add(:data_attributes, "Unknown Concept Scheme")
        end
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

  def concept_scheme_for_attribute(attribute_name)
    data_attribute = data_attributes.map{ |x| DataAttribute.find(x[0]) }.find{|x| x.name == attribute_name}
    ConceptScheme.find(data_attributes[data_attribute.id])
  end
end