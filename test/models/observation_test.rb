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
  end
end