require 'spec_helper'

describe EcwidApi::Api::ProductTypes, faraday: true do
  subject { client.product_types }

  describe "#all" do
    it "returns an array" do
      expect(client).to receive(:get).with("classes", {}).and_call_original
      subject.all
    end

    it "gets the proper response count (see fixture)" do
      expect(subject.all.count).to eq 2
    end

    it "gets the proper product_type (see fixture)" do
      expect(subject.all.first.name).to eq "Foo"
    end
  end
end
