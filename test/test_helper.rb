ENV["RACK_ENV"] = "test"

require "bundler/setup"

require "active_support/test_case"
require "shoulda/context"
require "minitest/autorun"

require "mongoid"
require "ons_data_models/require_all"
require "database_cleaner"
require "factory_girl"

FactoryGirl.reload

Mongoid.load! File.expand_path("../../config/mongoid.yml", __FILE__)

DatabaseCleaner.strategy = :truncation
# initial clean
DatabaseCleaner.clean

class ActiveSupport::TestCase
  def clean_db
    DatabaseCleaner.clean
  end
  set_callback :teardown, :before, :clean_db
end