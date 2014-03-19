# -*- encoding: utf-8 -*-
require File.expand_path('../lib/ons_data_models/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Mazz Mosley"]
  gem.email         = ["mazz@houseofmnowster.com"]
  gem.description   = %q{ONS-dataset models}
  gem.summary       = %q{ONS-dataset models}
  gem.homepage      = "https://github.com/ONSDigital/ons_data_models"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "ons_data_models"
  gem.require_paths = ["lib", "app"]
  gem.version       = OnsDataModels::VERSION

  gem.add_dependency "mongoid", "~> 3.1"
  gem.add_dependency "mime-types", "~> 1.16"
  
  gem.add_development_dependency "database_cleaner", "1.2.0"
  gem.add_development_dependency "rake", "0.9.2.2"
  gem.add_development_dependency "shoulda-context", "1.0.0"
  gem.add_development_dependency "factory_girl", "4.4.0"
  
  # The following are added to help bundler resolve dependencies
  gem.add_development_dependency "rack", "~> 1.4.4"
end
