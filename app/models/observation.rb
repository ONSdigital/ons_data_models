class Observation
  include Mongoid::Document
  field :slug, type: String
  field :measure

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
      if dataset.has_field?(field_name)
        class_eval { field field_name.to_sym }
        send method, *args
      else
        super
      end
    else
      super
    end
  end

end