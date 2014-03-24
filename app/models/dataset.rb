class Dataset
  include Mongoid::Document
  field :title
  field :slug
  field :dimensions, type: Hash
  field :data_attributes, type: Hash

  belongs_to :release
  has_many :observations
  has_many :measures

  validates :slug, uniqueness: {scope: :release}
  validates :dimensions, presence: true
  validate :dimensions_maps_dimensions_to_concepts
  validate :data_attributes_maps_to_concepts

  def dimensions_maps_dimensions_to_concepts
    dimensions.each_pair do |key, value|
      if Dimension.find(key).nil?
        errors.add(:dimensions, "Unknown dimension")
      end
      if ConceptScheme.find(value).nil?
        errors.add(:dimensions, "Unknown Concept Scheme")
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
    found_a_dimension = dimensions.map{|x| Dimension.find(x[0])}.any?{|x| x.name == field_name}
    return found_a_dimension unless found_a_dimension == false

    found_an_attribute = data_attributes.map{|x| DataAttribute.find(x[0])}.any?{|x| x.name == field_name}
    return found_an_attribute unless found_an_attribute == false

    found_an_measure = measures.where(name: field_name).first
    return found_an_measure
  end

  def concept_scheme_for_dimension(dimension_name)
    dimension = dimensions.map{|x| Dimension.find(x[0])}.find{|x| x.name == dimension_name}
    ConceptScheme.find(dimensions[dimension.id])
  end

  def concept_scheme_for_attribute(attribute_name)
    data_attribute = data_attributes.map{ |x| DataAttribute.find(x[0]) }.find{|x| x.name == attribute_name}
    ConceptScheme.find(data_attributes[data_attribute.id])
  end
end