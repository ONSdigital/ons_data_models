class Contact
  include Mongoid::Document
  embedded_in :series
  
  field :department, type: String
  field :email, type: String
  field :name, type: String
  field :telephone, type: String
  field :uri, type: String
end