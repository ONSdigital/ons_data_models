FactoryGirl.define do
  
  factory :dataset do
    sequence(:slug) { |s| "an-dataset-#{s}" }
    data_attributes "provisional" => false
    after(:build) do |dataset|
      measure = FactoryGirl.create(:measure)
      date_dimension = FactoryGirl.create(:date_dimension)
      date_concept_scheme = FactoryGirl.create(:date_concept_scheme)
      product_dimension = FactoryGirl.create(:product_dimension)
      product_concept_scheme = FactoryGirl.create(:product_concept_scheme)

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
      dataset.dimensions = {
        dimension.id.to_s => concept_scheme.id,
        date_dimension.id.to_s => date_concept_scheme.id,
        product_dimension.id.to_s => product_concept_scheme.id
      }
      dataset.data_attributes = {data_attribute.id.to_s => concept_scheme_2.id}
      dataset.measures = [ measure.id.to_s ]
    end
  end

  factory :product_dimension, class: Dimension do
    sequence(:slug) { |s| "product-dimension-#{s}" }
    name "product"
    title "Producer product"
    dimension_type "product"
  end

  factory :product_concept_scheme, class: ConceptScheme do
    sequence(:slug) { |s| "product-concept-scheme-#{s}"}
    title "PPI"
    values {{"MC6A" => {
      "notation" => "MC6A",
      "title" => "7229110080: Alcoholic Beverages - SPECIAL INDEX FOR USE IN NSO - Manu incl duty"
      },
      "JU5C" => {
        "notation" => "JU5C",
        "title" => "1107000000:Soft drinks; mineral waters and other bottled waters"
      }
    }}
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
      "2012" => {
        "title" => "2012",
        "type" => "year",
        "previous" => [
          {
            "period" => "year",
            "value" => "2011"
          }
        ]
      },
      "2013" => {
        "title" => "2013",
        "type" => "year",
        "previous" => [
          {
            "period" => "year",
            "value" => "2012"
          }
        ],
        "narrower" => [
          {
            "period" => "month",
            "value" => "2013DEC"
          },
          {
            "period" => "month",
            "value" => "2013NOV"
          }
        ]
      },   
      "2014" => {
        "title" => "2014",
        "type" => "year",
        "previous" => [
          {
            "period" => "year",
            "value" => "2013"
          }],
          "narrower" => [
            {
              "period" => "quarter",
              "value" => "2014Q1"
            }
          ]
      },             
      "2014Q1" => {
        "title" => "Q1 2014",
        "type" => "quarter",
        "narrower" => [
          {
            "period" => "month",
            "value" => "2014JAN"
          }
        ],
        "broader" => [
          {
            "period" => "year",
            "value" => "2014"
          }
        ]
      },
      "2014JAN" => {
        "title" => "January 2014",
        "type" => "month",
        "previous" => [
          {
            "period" => "month",
            "value" => "2013DEC"
          },
          {
            "period" => "year",
            "value" => "2013JAN"
          }
        ],
        "broader" => [
          {
            "period" => "year",
            "value" => "2014"
          },
          {
            "period" => "quarter",
            "value" => "2014Q1"
          }
        ] 
      },
      "2013DEC" => {
        "title" => "December 2013",
        "type" => "month",
        "broader" => [
          {
            "period" => "year",
            "value" => "2013"
          }
        ]
      },
      "2013NOV" => {
        "title" => "November 2013",
        "type" => "month",
        "broader" => [
          {
            "period" => "year",
            "value" => "2013"
          }
        ]
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