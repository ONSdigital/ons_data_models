FactoryGirl.define do
  factory :dataset do
    slug "an-dataset"
    structure what: "up"
  end

  factory :dimension do
    slug "an-dimension"
    name "place"
    title "An Dimension Innit"
    dimension_type "stellar"
  end

  factory :concept_scheme do
    slug "an-uk-concept-scheme"
    title "Galactic places"
    values "MM1" => "Mazteroid"
  end
end