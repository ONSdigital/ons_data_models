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

    should "return a list of dimension names available" do
      dataset = FactoryGirl.create(:dataset)
      allowed_dimensions = ["product", "date", "place"]
      dataset.available_dimension_names.map do |name|
        assert allowed_dimensions.include?(name) == true
      end
    end
  end

  context "a dataset with many observations" do
    should "find all observations across a product dimension" do
      observation = FactoryGirl.create(:observation, {
        price_index: 60.5,
        product: "MC6A",
        date: "2014JAN"}
      )
      dataset = observation.dataset
      observation_dec = FactoryGirl.create(:observation, {
        dataset: dataset,
        price_index: 111.6,
        product: "MC6A", date: "2013DEC"}
      )

      results = dataset.slice({product: "MC6A"})
      assert_equal results.count, 2
      results.each do |result|
        assert_equal result.product, "MC6A"
      end
    end

    should "only return observations from within this dataset" do
      observation = FactoryGirl.create(:observation, {
        price_index: 60.5,
        product: "MC6A",
        date: "2014JAN"}
      )
      dataset = observation.dataset
      observation_dec = FactoryGirl.create(:observation, {
        price_index: 111.6,
        product: "MC6A",
        date: "2013DEC"}
      )
      results = dataset.slice({product: "MC6A"})
      assert_equal results.count, 1
      assert_equal results[0].dataset, dataset
    end

    should "find all observations for top-level items in a time dimension slice" do
      price_index = 60.5
      years = ["2014", "2013", "2012"]
      dataset = nil
      observation = nil
      years.each do |year|
        if dataset.nil?
          observation = FactoryGirl.create(:observation, {
            price_index: price_index,
            product: "MC6A",
            date: "#{year}"})
          dataset = observation.dataset
        else
          FactoryGirl.create(:observation, {
            dataset: dataset,
            price_index: price_index,
            product: "MC6A",
            date: "#{year}"})
        end
        price_index + 10
      end

      # create an observation that shouldn't be returned in our time slice
      # the date value has a type of month
      FactoryGirl.create(:observation, {dataset: dataset, product: "MC6A", date: "2014JAN"})

      #wildcard means "all top level items"
      results = dataset.slice({product: "MC6A", date: "*"} )
      assert_equal results.count, 3
      results.each do |result|
        assert years.include?(result.date)
      end
    end
    
    should "find all observations with most granular time period when date is unspecified" do
      price_index = 60.5
      years = ["2014", "2013", "2012"]
      dataset = nil
      observation = nil
      years.each do |year|
        if dataset.nil?
          observation = FactoryGirl.create(:observation, {
            price_index: price_index,
            product: "MC6A",
            date: "#{year}"})
          dataset = observation.dataset
        else
          FactoryGirl.create(:observation, {
            dataset: dataset,
            price_index: price_index,
            product: "MC6A",
            date: "#{year}"})
        end
        price_index + 10
      end
    
      # create an observation that shouldbe returned in our time slice
      # the date value has a type of month
      FactoryGirl.create(:observation, {dataset: dataset, product: "MC6A", date: "2014JAN"})
    
      #date dimension is not specified so results should be single observation, ignoring the years
      results = dataset.slice({product: "MC6A"} )
      assert_equal results.count, 1
    end    
    
    should "perform simple slice query" do
      dataset = FactoryGirl.create(:dataset)
      observation_dec = FactoryGirl.create(:observation, {
        dataset: dataset,
        price_index: 111.6,
        product: "MC6A",
        date: "2013DEC"}
      )
      observation_dec = FactoryGirl.create(:observation, {
        dataset: dataset,
        price_index: 99,
        product: "MC6A",
        date: "2013"}
      )
      observations = dataset.slice( { product: "MC6A", date: "2013DEC"} )
      assert_equal observations.count, 1
      assert_equal observations.first.price_index, 111.6
    end
    
    should "slice by single dimension" do
      dataset = FactoryGirl.create(:dataset)
      observation_dec = FactoryGirl.create(:observation, {
        dataset: dataset,
        price_index: 111.6,
        product: "MC6A",
        date: "2013DEC"}
      )
      observation_dec = FactoryGirl.create(:observation, {
        dataset: dataset,
        price_index: 99,
        product: "MC6A",
        date: "2013"}
      )
      observation_dec = FactoryGirl.create(:observation, {
        dataset: dataset,
        price_index: 66,
        product: "JU5C",
        date: "2013DEC"}
      )
      observations = dataset.slice( { date: "2013DEC"} )
      assert_equal observations.count, 2
      assert_equal observations.first.price_index, 111.6
      assert_equal observations[1].price_index, 66
    end    
          
    should "allow wildcarding for schemes with nested values" do
      dataset = FactoryGirl.create(:dataset)
      observation_dec = FactoryGirl.create(:observation, {
        dataset: dataset,
        price_index: 111.6,
        product: "MC6A",
        date: "2013DEC"}
      )
      observation_dec = FactoryGirl.create(:observation, {
        dataset: dataset,
        price_index: 99,
        product: "MC6A",
        date: "2013"}
      )
      observation_dec = FactoryGirl.create(:observation, {
        dataset: dataset,
        price_index: 66,
        product: "JU5C",
        date: "2013DEC"}
      )
      #should match the two month based observations, as these are narrower than 2013
      observations = dataset.slice( { date: "2013/*"} )
      assert_equal observations.count, 2
      assert_equal observations.first.price_index, 111.6
      assert_equal observations[1].price_index, 66
    end  
      
    should "allow wildcarding for schemes with arbitrary nested values" do
      dataset = FactoryGirl.create(:dataset)
      observation_dec = FactoryGirl.create(:observation, {
        dataset: dataset,
        price_index: 111.6,
        product: "MC6A",
        date: "2014JAN"}
      )
      observation_dec = FactoryGirl.create(:observation, {
        dataset: dataset,
        price_index: 66,
        product: "JU5C",
        date: "2013DEC"}
      )
      observation_dec = FactoryGirl.create(:observation, {
        dataset: dataset,
        price_index: 66,
        product: "MC6A",
        date: "2014Q1"}
      )
      #should match the month which is in 2014, ignoring the quarter
      observations = dataset.slice( { date: "2014/*"}, "month" )
      assert_equal observations.count, 1
      assert_equal observations.first.price_index, 111.6
    end        
  end
end