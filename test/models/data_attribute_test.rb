require "test_helper"
require "models/data_attribute"

class DataAttributeTest < ActiveSupport::TestCase
  context "with a data attribute" do
    should "have required fields" do
      data_attribute = FactoryGirl.build(:data_attribute, {slug: nil, title: nil})
      assert data_attribute.valid? == false
      assert data_attribute.errors[:slug]
      assert data_attribute.errors[:title]
    end
  end
end