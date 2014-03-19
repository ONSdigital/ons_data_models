FactoryGirl.define do
  factory :dataset do
    sequence(:slug) { |s| "an-dataset-#{s}" }
    after(:build) do |dataset|
      dimension = FactoryGirl.create(:dimension)
      concept_scheme = FactoryGirl.create(:concept_scheme)
      dataset.structure = {dimension.id => concept_scheme.id}
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
    measure 60.5
    dataset
  end
end