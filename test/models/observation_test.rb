require "test_helper"
require "models/observation"

class ObservationTest < ActiveSupport::TestCase
  context "with an observation" do
    should "have required fields" do
      observation = FactoryGirl.build(:observation, {slug: nil, dataset: nil})
      assert observation.valid? == false
      assert observation.errors[:slug]
      assert observation.errors[:dataset]
    end

    should "have fields for dataset structure" do
      observation = FactoryGirl.create(:observation)
      # place comes from the dataset structure
      observation.place = "MM1"
      observation.save
      # reload from mongo
      observation = Observation.find(observation.id)
      assert_equal "MM1", observation.place
    end

    should "not accept fields that aren't in dataset structure" do
      observation = FactoryGirl.create(:observation)
      assert_raise NoMethodError do
        observation.made_up_field = "WAT"
      end
    end
  end
end