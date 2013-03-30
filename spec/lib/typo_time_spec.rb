require 'spec_helper'

describe TypoTime do
  describe "delta" do
    it "returns nil when nil year, nil month and nil day" do
      expect(TypoTime.delta).to be_nil
    end

    it "returns year when year given" do
      start_at = Time.utc(2009,1,1,0,0,0)
      end_at = Time.utc(2009,12,31,23,59,59)
      expect(TypoTime.delta(2009)).to eq(start_at..end_at)
    end

    it "returns year and month when year and month given" do
      start_at = Time.utc(2009,10,1,0,0,0)
      end_at = Time.utc(2009,10,31,23,59,59)
      expect(TypoTime.delta(2009, 10)).to eq(start_at..end_at)
    end

    it "returns year, month and day when year, month and day given" do
      start_at = Time.utc(2009,10,23,0,0,0)
      end_at = Time.utc(2009,10,23,23,59,59)
      expect(TypoTime.delta(2009, 10, 23)).to eq(start_at..end_at)
    end
  end
end
