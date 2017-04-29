require 'spec_helper'

describe EcwidApi::Api::ProductTypes, faraday: true do
  subject { client.product_types }

  describe "#all" do
    it "passes any other parameters through" do
      expect(client).to receive(:get).with("classes", hash_including(from_date: '1982-05-17'))
      subject.all(from_date: '1982-05-17')
    end

    it "gets the proper response count (see fixture)" do
      expect(subject.all.count).to eq 2
    end

    it "gets the proper product_type (see fixture)" do
      expect(subject.all.first.name).to eq "Foo"
    end
  end
end
