require "test_helper"
require "models/observation"

class ObservationTest < ActiveSupport::TestCase
  context "with an observation" do
    should "have required fields" do
      observation = FactoryGirl.build(:observation, {slug: nil, dataset: nil})
      assert observation.valid? == false
      assert observation.errors[:slug].empty? == false
      assert observation.errors[:dataset].empty? == false
    end

    should "have fields for dataset dimensions" do
      observation = FactoryGirl.create(:observation)
      # place comes from the dataset dimensions
      observation.place = "MM1"
      observation.save
      # reload from mongo
      observation = Observation.find(observation.id)
      assert_equal "MM1", observation.place
    end

    should "not accept fields that aren't in dataset dimensions" do
      observation = FactoryGirl.create(:observation)
      assert_raise NoMethodError do
        observation.made_up_field = "WAT"
      end
    end

    should "validate that an assigned dimension value is from our concept scheme" do
      observation = FactoryGirl.create(:observation)
      observation.place = "MM1"
      assert observation.valid?
    end

    should "raise a validation error for an assigned dimension not in concept scheme" do
      observation = FactoryGirl.create(:observation)
      observation.place = "NOPE"
      assert observation.valid? == false
    end
  end
end