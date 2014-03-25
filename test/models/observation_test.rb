require "test_helper"
require "models/observation"

class ObservationTest < ActiveSupport::TestCase
  context "with an observation" do
    should "have required fields" do
      observation = FactoryGirl.build(:empty_observation)
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

    should "validate that an assigned data attribute value is from valid concept scheme" do
      observation = FactoryGirl.create(:observation)
      observation.provisional = true
      assert observation.valid? == true   
    end

    should "allow an assigned data attribute value to not have a concept scheme" do
      observation = FactoryGirl.create(:observation)
      data_attribute = FactoryGirl.create(:data_attribute, {name: "notes", title: "Notes"})
      dataset = observation.dataset
      dataset.data_attributes[data_attribute.id] = nil
      dataset.save

      observation.notes = "This observation is incredibly rare and pondered by many data scientists"
      observation.save

      assert observation.valid? == true
      assert observation.notes == "This observation is incredibly rare and pondered by many data scientists"
    end

    should "have measures assigned to it" do
      observation = FactoryGirl.create(:observation)
      observation.price_index = 111.5
      observation.save

      assert observation.valid? == true
      assert observation.price_index == 111.5
    end
  end

  context "with many observations for a dataset" do
    should "find all observations across a product dimension" do
      observation = FactoryGirl.create(:observation, {price_index: 60.5, product: "MC6A", date: "2014JAN"})
      observation_dec = FactoryGirl.create(:observation, {dataset: observation.dataset, price_index: 111.6, product: "MC6A", date: "2013DEC"})
      assert_equal observation.date, "2014JAN"
      assert_equal observation.product, "MC6A"
      results = observation.get_all_with(["product"])
      assert_equal results.count, 2
    end
    should "find only observations within this dataset" do
      observation = FactoryGirl.create(:observation, {price_index: 60.5, product: "MC6A", date: "2014JAN"})
      observation_dec = FactoryGirl.create(:observation, {price_index: 111.6, product: "MC6A", date: "2013DEC"})
      assert_equal observation.date, "2014JAN"
      assert_equal observation.product, "MC6A"
      results = observation.get_all_with(["product"])
      assert_equal results.count, 1
    end

  end
end