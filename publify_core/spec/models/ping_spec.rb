# frozen_string_literal: true

require "rails_helper"

RSpec.describe Ping, type: :model do
  describe "validations" do
    let(:ping) { described_class.new }

    it "requires url to not be too long" do
      expect(ping).to validate_length_of(:url).is_at_most(255)
    end
  end
end
