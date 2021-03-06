# Require this file in a non-Rails app to load all the things
require "active_model"
require "mongoid"
# app/validators app/repositories app/traits
%w[ app/models lib ].each do |path|
  full_path = File.expand_path(
    "#{File.dirname(__FILE__)}/../../#{path}", __FILE__)
  $LOAD_PATH.unshift full_path unless $LOAD_PATH.include?(full_path)
end

# Require everything under app
Dir.glob("#{File.dirname(__FILE__)}/../../app/**/*.rb").sort.each do |file|
  require file
end
