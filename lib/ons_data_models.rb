require "ons_data_models/version"
require "mongoid"

begin
  module OnsDataModels
    class Engine < Rails::Engine
    end
  end
rescue NameError
  module OnsDataModels
  end
end