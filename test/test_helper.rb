ENV["RACK_ENV"] = "test"

require "bundler/setup"

require "active_support/test_case"
require "shoulda/context"
require "minitest/autorun"

require "mongoid"
require "ons_data_models/require_all"

Mongoid.load! File.expand_path("../../config/mongoid.yml", __FILE__)