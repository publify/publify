# frozen_string_literal: true

require "rails_helper"

RSpec.describe PostType, type: :model do
  before do
    create(:blog)
  end

  describe "Given a new post type" do
    it "gives a valid post type" do
      expect(described_class.create(name: "foo")).to be_valid
    end

    it "has a sanitized permalink" do
      @pt = described_class.create(name: "Un joli PostType Accentué")
      expect(@pt.permalink).to eq("un-joli-posttype-accentue")
    end

    it "has a sanitized permalink with a" do
      @pt = described_class.create(name: "Un joli PostType à Accentuer")
      expect(@pt.permalink).to eq("un-joli-posttype-a-accentuer")
    end
  end

  it "post types are unique" do
    expect { described_class.create!(name: "test") }.not_to raise_error
    test_type = described_class.new(name: "test")
    expect(test_type).not_to be_valid
    expect(test_type.errors[:name]).to eq(["has already been taken"])
  end

  describe "validations" do
    let(:post_type) { described_class.new }

    it "requires name to not be too long" do
      expect(post_type).to validate_length_of(:name).is_at_most(255)
    end

    it "requires permalink to not be too long" do
      expect(post_type).to validate_length_of(:permalink).is_at_most(255)
    end

    it "requires description to not be too long" do
      expect(post_type).to validate_length_of(:description).is_at_most(255)
    end
  end
end
