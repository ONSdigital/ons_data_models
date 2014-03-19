require "test_helper"
require "models/concept_scheme"

class ConceptSchemeTest < ActiveSupport::TestCase
  context "with a concept scheme" do
    should "have required fields" do
      concept_scheme = FactoryGirl.build(:concept_scheme, {title: nil, slug: nil, values: nil})
      assert concept_scheme.valid? == false
      assert concept_scheme.errors[:slug]
      assert concept_scheme.errors[:title]
      assert concept_scheme.errors[:values]
    end
  end
end