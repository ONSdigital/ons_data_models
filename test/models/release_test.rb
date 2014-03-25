require "test_helper"
require "models/release"

class ReleaseTest < ActiveSupport::TestCase
  context "with a release" do
    
    should "have required fields" do
      release = FactoryGirl.build(:release, {slug: nil, title: nil, published: nil, state: nil})
      assert release.valid? == false
      assert release.errors[:slug]
      assert release.errors[:title]
      assert release.errors[:published]
      assert release.errors[:state]
    end
        
  end
end