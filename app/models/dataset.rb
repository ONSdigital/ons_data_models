class Dataset
  include Mongoid::Document
  field :title
  field :slug
  field :dimensions, type: Hash
  field :data_attributes, type: Hash
  field :measures, type: Hash
  field :description, type: String

  belongs_to :release
  has_many :observations

  validates :slug, uniqueness: {scope: :release}
  validates :dimensions, presence: true
  validate :dimensions_maps_dimensions_to_concepts
  validate :data_attributes_maps_to_concepts
  validate :measures_maps_to_concepts

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
    return if data_attributes.nil?
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

  def measures_maps_to_concepts
    measures.each_pair do |key, value|
      if Measure.find(key).nil?
        errors.add(:measures, "Unknown measure")
      end
      if ConceptScheme.find(value).nil?
        errors.add(:measures, "Unknown Concept Scheme")
      end
    end
  end

  def has_field?(field_name)
    found_a_dimension = dimensions.map{|x| Dimension.find(x[0])}.any?{|x| x.name == field_name}
    return found_a_dimension unless found_a_dimension == false

    if !data_attributes.nil?
      found_an_attribute = data_attributes.map{|x| DataAttribute.find(x[0])}.any?{|x| x.name == field_name}
      return found_an_attribute unless found_an_attribute == false
    end

    if !measures.nil?
      found_an_measure = measures.map{|x| Measure.find(x[0])}.any?{|x| x.name == field_name}
      return found_an_measure
    end
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