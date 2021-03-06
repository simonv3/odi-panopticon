require 'test_helper'

class RummageableArtefactTest < ActiveSupport::TestCase

  setup do
    FactoryGirl.create(:tag, tag_type: "section", tag_id: "crime", title: "Crime")
    FactoryGirl.create(:tag, tag_type: "section", tag_id: "crime/batman", title: "Batman", parent_id: "crime")
    FactoryGirl.create :odi_role
    FactoryGirl.create :dapaas_role
  end

  test "should extract artefact attributes" do
    artefact = Artefact.new do |artefact|
      artefact.name = "My artefact"
      artefact.slug = "my-artefact"
      artefact.kind = "guide"
    end
    # Note: the link is not present if we are amending
    expected = {
      "title" => "My artefact",
      "format" => "guide",
      "section" => nil,
    }
    assert_equal expected, RummageableArtefact.new(artefact).artefact_hash
  end

  test "should include description" do
    artefact = Artefact.new do |artefact|
      artefact.name = "My artefact"
      artefact.slug = "my-artefact"
      artefact.kind = "guide"
      artefact.description = "Describe describey McDescribe"
    end
    # Note: the link is not present if we are amending
    expected = {
      "title" => "My artefact",
      "format" => "guide",
      "description" => "Describe describey McDescribe",
      "section" => nil,
    }
    assert_equal expected, RummageableArtefact.new(artefact).artefact_hash
  end

  test "should include indexable content if present" do
    artefact = Artefact.new do |artefact|
      artefact.name = "My artefact"
      artefact.slug = "my-artefact"
      artefact.kind = "guide"
      artefact.indexable_content = "Blah blah blah index this"
    end
    # Note: the link is present if we are not amending
    expected = {
      "link" => "/my-artefact",
      "title" => "My artefact",
      "format" => "guide",
      "section" => nil,
      "indexable_content" => "Blah blah blah index this"
    }
    assert_equal expected, RummageableArtefact.new(artefact).artefact_hash
  end

  test "should work with no primary section" do
    artefact = Artefact.new do |artefact|
      artefact.name = "My artefact"
      artefact.slug = "my-artefact"
      artefact.kind = "guide"
      artefact.indexable_content = "Blah blah blah index this"
      artefact.sections = []
    end
    expected = {
      "link" => "/my-artefact",
      "title" => "My artefact",
      "format" => "guide",
      "section" => nil,
      "indexable_content" => "Blah blah blah index this"
    }
  end

  test "should include section information" do
    artefact = Artefact.new do |artefact|
      artefact.name = "My artefact"
      artefact.slug = "my-artefact"
      artefact.kind = "guide"
      artefact.indexable_content = "Blah blah blah index this"
      artefact.sections = ["crime"]
    end
    expected = {
      "link" => "/my-artefact",
      "title" => "My artefact",
      "format" => "guide",
      "section" => "crime",
      "indexable_content" => "Blah blah blah index this"
    }
    assert_equal expected, RummageableArtefact.new(artefact).artefact_hash
  end

  test "should fake section information for travel advice format" do
    artefact = Artefact.new do |artefact|
      artefact.name = "My artefact"
      artefact.slug = "my-artefact"
      artefact.kind = "travel-advice"
      artefact.indexable_content = "Blah blah blah index this"
    end
    expected = {
      "link" => "/my-artefact",
      "title" => "My artefact",
      "format" => "travel-advice",
      "section" => "foreign-travel-advice",
      "indexable_content" => "Blah blah blah index this"
    }
    assert_equal expected, RummageableArtefact.new(artefact).artefact_hash
  end

  test "should consider live items should be indexed" do
    artefact = Artefact.new do |artefact|
      artefact.state = "live"
    end

    assert RummageableArtefact.new(artefact).should_be_indexed?
  end

  test "should not index business support content" do
    artefact = Artefact.new do |artefact|
      artefact.state = "live"
      artefact.kind = "business_support"
    end

    refute RummageableArtefact.new(artefact).should_be_indexed?
  end

  test "should index business support content with an acceptable slug" do
    artefact = Artefact.new do |artefact|
      artefact.slug = "new-enterprise-allowance"
      artefact.state = "live"
      artefact.kind = "business_support"
    end

    assert RummageableArtefact.new(artefact).should_be_indexed?
  end

  test "should not index content formats managed by Whitehall" do
    skip("We don't use Whitehall")
    artefact = Artefact.new do |artefact|
      artefact.state = "live"
      artefact.kind = Artefact::FORMATS_BY_DEFAULT_OWNING_APP["whitehall"].first
    end

    refute RummageableArtefact.new(artefact).should_be_indexed?
  end

  test "should not index content formats managed by Specialist publisher" do
    skip("We don't use specialist publisher")
    Artefact::FORMATS_BY_DEFAULT_OWNING_APP["specialist-publisher"].each do |kind|
      artefact = Artefact.new do |artefact|
        artefact.state = "live"
        artefact.kind = kind
      end

      refute RummageableArtefact.new(artefact).should_be_indexed?
    end
  end

  test "should not index content formats managed by Finder api" do
    skip("We don't use the finder API")
    Artefact::FORMATS_BY_DEFAULT_OWNING_APP["finder-api"].each do |kind|
      artefact = Artefact.new do |artefact|
        artefact.state = "live"
        artefact.kind = kind
      end

      refute RummageableArtefact.new(artefact).should_be_indexed?
    end
  end

  test "adds a rummageable artefact with indexable content to the search index" do
    artefact = build(:artefact, indexable_content: "blah", roles: ["odi"])
    rummageable_artefact = RummageableArtefact.new(artefact)

    stub_search_index = stub("Rummageable::Index")
    SearchIndex.expects(:instance).returns(stub_search_index)

    stub_search_index.expects(:add).with(rummageable_artefact.artefact_hash)
    rummageable_artefact.submit
  end

  test "adds a rummageable artefact with multiple roles and indexable content to the search index" do
    artefact = build(:artefact, indexable_content: "blah", roles: ["odi", "dapaas"])
    rummageable_artefact = RummageableArtefact.new(artefact)

    stub_search_index_1 = stub("Rummageable::Index")
    stub_search_index_2 = stub("Rummageable::Index")
    SearchIndex.expects(:instance).with('odi').returns(stub_search_index_1)
    SearchIndex.expects(:instance).with('dapaas').returns(stub_search_index_2)

    stub_search_index_1.expects(:add).with(rummageable_artefact.artefact_hash)
    stub_search_index_2.expects(:add).with(rummageable_artefact.artefact_hash)

    rummageable_artefact.submit
  end

  test "amends a rummageable artefact without indexable content" do
    artefact = build(:artefact, indexable_content: nil, roles: ["odi"])
    rummageable_artefact = RummageableArtefact.new(artefact)

    stub_search_index = stub("Rummageable::Index")
    SearchIndex.expects(:instance).returns(stub_search_index)

    stub_search_index.expects(:amend).with(rummageable_artefact.artefact_link,
                                           rummageable_artefact.artefact_hash)
    rummageable_artefact.submit
  end

  test "deletes a rummageable artefact" do
    artefact = build(:artefact, roles: ["odi"])
    rummageable_artefact = RummageableArtefact.new(artefact)

    stub_search_index = stub("Rummageable::Index")
    SearchIndex.expects(:instance).returns(stub_search_index)

    stub_search_index.expects(:delete).with(rummageable_artefact.artefact_link)
    stub_search_index.expects(:commit)

    rummageable_artefact.delete
  end
end
