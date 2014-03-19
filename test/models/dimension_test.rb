require "test_helper"
require "models/dimension"

class DimensionTest < ActiveSupport::TestCase
  context "with a dimension" do
    should "have required fields" do
      dimension = FactoryGirl.build(:dimension, {slug: nil, title: nil, dimension_type: nil})
      assert dimension.valid? == false
      assert dimension.errors[:slug]
      assert dimension.errors[:title]
      assert dimension.errors[:dimension_type]    
    end
  end
end