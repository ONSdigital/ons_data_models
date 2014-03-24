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

    should "have a dimensions hash" do
      dataset_1 = FactoryGirl.create(:dataset)
      assert dataset_1.dimensions.is_a?Hash
    end

    should "return a concept scheme for a given dimension name" do
      dataset_1 = FactoryGirl.create(:dataset)
      found_concept_scheme = dataset_1.concept_scheme_for_dimension("place")
      assert_equal found_concept_scheme.title, "Galactic places"
    end

    should "have a data attributes hash" do
      dataset_1 = FactoryGirl.create(:dataset)
      assert dataset_1.data_attributes.is_a?Hash
    end

    should "return a concept scheme for a given data attribute name" do
      dataset_1 = FactoryGirl.create(:dataset)
      found_concept_scheme = dataset_1.concept_scheme_for_attribute("provisional")
      assert_equal found_concept_scheme.title, "Provisional"
    end

    should "allow data_attributes to not have a concept scheme" do
      # Notes, for example, does not have a concept scheme
      dataset_1 = FactoryGirl.create(:dataset)
      notes_attribute = FactoryGirl.create(:data_attribute, {name: "notes", title: "Notes"})
      dataset_1.data_attributes[notes_attribute.id] = nil
      dataset_1.save
      assert dataset_1.valid? == true
    end

    should "have fields for measures" do
      dataset = FactoryGirl.create(:dataset)
      assert dataset.has_field?("price_index")
    end
  end
end