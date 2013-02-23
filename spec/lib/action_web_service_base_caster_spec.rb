require 'spec_helper'

include ActionWebService::Casting

describe ActionWebService::Casting::BaseCaster do

  describe "#cast" do

    it "returns value when signature_type is nil" do
      BaseCaster.cast("some", nil).should eq "some"
    end

    it "returns nil when value is nil" do
      BaseCaster.cast(nil, 0).should be_nil
    end

    it "returns nil when signature is structured? and value is false" do
      structured_signature = OpenStruct.new(structured?: true)
      BaseCaster.cast(false, structured_signature).should be_nil
    end

    context "when value is not false" do
      it "returns value when signature is not structued?" do
        matching_canonical_type = "matching_canonical_type"
        other = "Other"
        structured_signature = OpenStruct.new(structured?: false, type: matching_canonical_type)
        BaseCaster.should_receive(:canonical_type).with(other.class).and_return(matching_canonical_type)
        BaseCaster.cast(other, structured_signature).should eq other
      end

      it "returns value when signature is not array?" do
        matching_canonical_type = "matching_canonical_type"
        other = "Other"
        structured_signature = OpenStruct.new(array?: false, type: matching_canonical_type)
        BaseCaster.should_receive(:canonical_type).with(other.class).and_return(matching_canonical_type)
        BaseCaster.cast(other, structured_signature).should eq other
      end
    end


    context "when signature is array?" do
      it "raise CastingError where value not respond_to entries and value is a String" do
        other = "a string"
        structured_signature = OpenStruct.new(array?: true, type: "to_inspect")
        expect {
          BaseCaster.cast(other, structured_signature)
        }.to raise_error(ActionWebService::Casting::CastingError)
      end
    end

    context "when signature is structured?" do
      it "returns " do
        structured_signature = OpenStruct.new(array?: false, structured?: true)
      end
    end

    context "when signature is custom?" do
      it "returns " do
        structured_signature = OpenStruct.new(array?: false, structured?: false, custom?: true)
      end
    end
  end
end
