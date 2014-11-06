require 'spec_helper'

describe EcwidApi::Api::Products, faraday: true do
  subject { client.products }

  describe "#all" do
    it "passes any other paramters through" do
      expect(client).to receive(:get).with("products", hash_including(from_date: '1982-05-17'))
      subject.all(from_date: '1982-05-17')
    end

    it "gets the proper response count (see fixture)" do
      subject.all.count.should == 5
    end

    it "gets the proper product (see fixture)" do
      subject.all.first.sku.should == "NC53090"
    end
  end
end