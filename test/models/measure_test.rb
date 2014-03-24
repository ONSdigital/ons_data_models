require "test_helper"
require "models/measure"

class MeasureTest < ActiveSupport::TestCase
  context "with a measure" do
    should "have required fields" do
      measure = FactoryGirl.build(:measure, {slug: nil, title: nil})
      assert measure.valid? == false
      assert measure.errors[:slug]
      assert measure.errors[:name]
      assert measure.errors[:title]
    end
  end
end