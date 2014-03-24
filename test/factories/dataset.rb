FactoryGirl.define do
  factory :dataset do
    sequence(:slug) { |s| "an-dataset-#{s}" }
    data_attributes "provisional" => false
    after(:build) do |dataset|
      FactoryGirl.create(:measure, {dataset: dataset})
      dimension = FactoryGirl.create(:dimension)
      concept_scheme = FactoryGirl.create(:concept_scheme)
      data_attribute = FactoryGirl.create(:data_attribute)
      concept_scheme_2 = FactoryGirl.create(:concept_scheme,
        {
          title: "Provisional",
          values: {
            true: "data is provisional",
            false: "data is for reals"
          }
        }
      )
      dataset.dimensions = {dimension.id => concept_scheme.id}
      dataset.data_attributes = {data_attribute.id => concept_scheme_2.id}
    end
  end

  factory :dimension do
    sequence(:slug) { |s| "an-dimension-#{s}" }
    name "place"
    title "An Dimension Innit"
    dimension_type "stellar"
  end

  factory :concept_scheme do
    sequence(:slug) { |s| "an-uk-concept-scheme-#{s}" }
    title "Galactic places"
    values "MM1" => "Mazteroid"
  end

  factory :observation do
    sequence(:slug) { |s| "a-observation-#{s}"}
    dataset
    price_index 111.5
  end

  factory :empty_observation, class: Observation do
  end


  factory :data_attribute do
    sequence(:slug) { |s| "an-attribute-#{s}" }
    name "provisional"
    title "Provisional"
  end

  factory :measure do
    sequence(:slug) { |s| "an-measure-#{s}" }
    name "price_index"
    title "Price Index"
    description "A value based on a series of economic indicators and toads."
  end
end