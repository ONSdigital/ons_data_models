FactoryGirl.define do
  
  factory :date_dataset, class: Dataset do
    sequence(:slug) { |s| "has-dates-dataset-#{s}"}
    after(:build) do |dataset|
      FactoryGirl.create(:measure, {dataset: dataset})
      dimension = FactoryGirl.create(:date_dimension)
      concept_scheme = FactoryGirl.create(:date_concept_scheme)
      dataset.dimensions = {dimension.id => concept_scheme.id}
    end
  end

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

  factory :date_dimension, class: Dimension do
    sequence(:slug) { |s| "date-dimension-#{s}" }
    name "date"
    title "Date"
    dimension_type "date"
  end

  factory :date_concept_scheme, class: ConceptScheme do
    sequence(:slug) { |s| "date-concept-scheme-#{s}"}
    title "Reporting periods"
    values {{
      "2014JAN" => {
        "title" => "January 2014",
        "previous" => [
          {
            "period" => "month",
            "value" => "2013DEC"
          },
          {
            "period" => "year",
            "value" => "2013JAN"
          }
        ]
      },
      "2013DEC" => {
        "title" => "December 2013"
      },
      "2013NOV" => {
        "title" => "November 2013"
      }
      }}
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

  factory :date_observation, class: Observation do
    sequence(:slug) { |s| "a-observation-#{s}"}
    after(:build) do |obs|
      obs.price_index 60.5
      obs.date "2014JAN"
    end
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
  
  factory :release do
    sequence(:slug) { |s| "a-release-#{s}" }
    published "2014-04-01"
    title "April Horse Index"
    description "Horse price index"
  end
    
end