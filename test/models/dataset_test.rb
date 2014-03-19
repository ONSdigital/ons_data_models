require "test_helper"
require "models/dataset"

class DatasetTest < ActiveSupport::TestCase
  context "with a dataset" do

    should "have a unique slug" do
      dataset_1 = FactoryGirl.create(:dataset, {slug: "an-slug"})
      dataset_2 = FactoryGirl.build(:dataset, {slug: "an-slug"})
      assert dataset_1.valid?
      assert dataset_2.valid? == false
    end

    should "have a structure hash" do
      dataset_1 = FactoryGirl.create(:dataset)
      assert dataset_1.structure.is_a?Hash
    end
  end
end