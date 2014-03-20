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

    should "return if has a value key" do
      concept_scheme = FactoryGirl.build(:concept_scheme)
      assert concept_scheme.has_value?"MM1"
    end

    should "return false if it does not have a value key" do
      concept_scheme = FactoryGirl.build(:concept_scheme)
      assert concept_scheme.has_value?("WT1") == false
    end
  end
end