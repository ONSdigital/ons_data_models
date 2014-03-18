require "test_helper"
require "models/observation"

class ObservationTest < ActiveSupport::TestCase
  context "with an observation" do

    should "be able to save some attributes" do
      series = Series.create({slug: "test-series", title: "A series of test data"})
      dataset = Dataset.create({slug: "dataset-1", title: "First lot of data", series: series})
      obs = Observation.create({title: "call me maybe"})
      attribute = ObservationAttribute.create({
        name: "provisional", 
        title: "Is a provisional value", 
        value: true,
        observation: obs
      })
      assert_equal obs.observation_attributes.count, 1
      assert_equal obs.observation_attributes[0].name, "provisional"
      assert obs.observation_attributes[0].value
    end
  end

  should "be able to save a dimension" do
    series = Series.create({slug: "test-series", title: "A series of test data"})
    dataset = Dataset.create({slug: "dataset-1", title: "First lot of data", series: series})
    obs = Observation.create({title: "call me maybe"})
    concept_scheme = ConceptScheme.create({
      "title" => "CDID",
      "values" => {
        "JU5C" => {"title" => "Soft drinks and juice"},
        "MCA25" => {"title" => "Imported products with BREAD"},
      }
    })
    assert_equal ConceptScheme.first['values']['MCA25']['title'], "Imported products with BREAD" 
    dimension = Dimension.create({title: "PPI Product", name: "product", value: "MCA25"})

    obs.dimensions << dimension
    obs.save

    assert_equal obs.dimensions.count, 1

  end
end