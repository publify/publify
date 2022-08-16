# frozen_string_literal: true

require "rails_helper"

RSpec.describe Redirect, type: :model do
  let(:blog) { create(:blog) }

  it "redirects are unique" do
    expect { blog.redirects.create!(from_path: "foo/bar", to_path: "/") }.not_to raise_error

    redirect = blog.redirects.build(from_path: "foo/bar", to_path: "/")

    expect(redirect).not_to be_valid
    expect(redirect.errors[:from_path]).to eq(["has already been taken"])
  end

  describe "#from_url" do
    it "is based on the blog's base_url" do
      redirect = blog.redirects.build(from_path: "right/here", to_path: "over_there")
      expect(redirect.from_url).to eq "#{blog.base_url}/right/here"
    end
  end

  describe "validations" do
    let(:redirect) { described_class.new }

    it "requires from_path to not be too long" do
      expect(redirect).to validate_length_of(:from_path).is_at_most(255)
    end

    it "requires to_path to not be too long" do
      expect(redirect).to validate_length_of(:to_path).is_at_most(255)
    end
  end
end
