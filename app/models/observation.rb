class Observation
  include Mongoid::Document
  field :slug, type: String

  belongs_to :dataset

  validates :slug, presence: true, uniqueness: {scope: :dataset}
  validates :dataset, presence: true
  validate :dimension_validator
  def dimension_validator
    return if dataset.nil?
    dataset.dimensions.each_pair do |dimension_id, concept_scheme_id|
      dimension_name = Dimension.find(dimension_id).name
      if respond_to? dimension_name
        concept_scheme = ConceptScheme.find(concept_scheme_id)
        unless concept_scheme.has_value? send(dimension_name)
          errors.add(dimension_name.to_sym, "Invalid value not found in concept scheme")
        end
      end
    end
  end

  def method_missing(method, *args)
    case method.to_s
    when /^([a-z0-9_]+)=?$/
      field_name = $1 
      if dataset && dataset.has_field?(field_name)
        class_eval { field field_name.to_sym }
        send method, *args
      else
        super
      end
    else
      super
    end
  end

  def get_all_with(matching_dimensions)
    where_clause = matching_dimensions.map { |x| [x.to_sym, send(x)]}
    where_clause<<["dataset", dataset]
    Observation.where(where_clause.to_h)
  end

  def get_date_slice(date_dimension_name, matching_dimensions)
    raise ArgumentError.new(
      'Date dimension must be included in matching dimensions'
    ) unless matching_dimensions.has_key?date_dimension_name.to_sym

    date_concept_scheme = dataset.concept_scheme_for_dimension(date_dimension_name)
    scheme = date_concept_scheme.values[matching_dimensions[date_dimension_name.to_sym]]
    date_range = date_concept_scheme.values.map do |value_key, structure|
      if structure["type"] == scheme["type"]
        value_key
      end
    end
    matching_dimensions.delete(date_dimension_name.to_sym)
    Observation.where(matching_dimensions).in({date_dimension_name => date_range})
  end

end