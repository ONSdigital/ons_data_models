require "test_helper"
require "models/observation"

class ObservationTest < ActiveSupport::TestCase
  context "with an observation" do
    should "be able to save" do
      obs = Observation.new({type: "observation", value: 106.5, base_period: "2010", provisional: true})
      obs.save
      assert_equal obs.provisional, true
    end
  end
end