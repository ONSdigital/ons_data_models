class Observation
  include Mongoid::Document
  field :slug, type: String
  field :measure

  belongs_to :dataset

  validates :slug, presence: true, uniqueness: {scope: :dataset}

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