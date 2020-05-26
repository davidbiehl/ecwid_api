require 'spec_helper'

describe EcwidApi::Api::Products, faraday: true do
  subject { client.products }

  describe "#all" do
    it "passes any other paramters through" do
      expect(client).to receive(:get).with("products", hash_including(from_date: '1982-05-17'))
        .and_return(empty_pagination_response)
      subject.all(from_date: '1982-05-17').each{}
    end

    it "gets the proper response count (see fixture)" do
      expect(subject.all.count).to eq 5
    end

    it "gets the proper product (see fixture)" do
      expect(subject.all.first.sku).to eq"NC53090"
    end
  end
end