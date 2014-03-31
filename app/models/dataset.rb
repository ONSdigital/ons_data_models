class Dataset
  include Mongoid::Document
  field :title
  field :slug
  field :dimensions, type: Hash
  field :data_attributes, type: Hash
  field :measures, type: Array
  field :description, type: String

  belongs_to :release
  has_many :observations

  validates :slug, uniqueness: {scope: :release}
  validates :dimensions, presence: true
  validate :dimensions_maps_dimensions_to_concepts
  validate :data_attributes_maps_to_concepts
  validate :measures_declared

  def available_dimension_names
    Dimension.find(dimensions.keys).map { |d| d.name }
  end

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

  def measures_declared
    measures.each do |measure|
      if Measure.find(measure).nil?
        errors.add(:measures, "Unknown measure")
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
      found_an_measure = measures.map{|x| Measure.find(x)}.any?{|x| x.name == field_name}
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

  def get_all_observations_with(matching_dimensions)
    raise ArgumentError.new("Argument must be a hash of dimensions") unless matching_dimensions.is_a?Hash
    matching_dimensions["dataset"] = self
    Observation.where(matching_dimensions)
  end

  def get_a_slice_by_date(date_dimension_name, matching_dimensions)
    raise ArgumentError.new(
      'Date dimension must be included in matching dimensions'
    ) unless matching_dimensions.has_key?date_dimension_name.to_sym

    date_concept_scheme = concept_scheme_for_dimension(date_dimension_name)
    scheme = date_concept_scheme.values[matching_dimensions[date_dimension_name.to_sym]]
    date_range = date_concept_scheme.values.map do |value_key, structure|
      if structure["type"] == scheme["type"]
        value_key
      end
    end
    matching_dimensions.delete(date_dimension_name.to_sym)
    matching_dimensions["dataset"] = self
    Observation.where(matching_dimensions).in({date_dimension_name => date_range})
  end
end