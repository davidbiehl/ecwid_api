require 'spec_helper'

describe EcwidApi::Api::Orders, faraday: true do
  subject { client.orders }

  describe "#all" do
    it "limits the request to 100 no matter what" do
      expect(client).to receive(:get).with("orders", hash_including(limit: 100))
      subject.all(limit: 10)
    end

    it "passes any other paramters through" do
      expect(client).to receive(:get).with("orders", hash_including(from_date: '1982-05-17'))
      subject.all(from_date: '1982-05-17')
    end

    it "removes the offest" do
      expect(client).to receive(:get).with("orders", hash_not_including(offset: anything))
      subject.all(offset: 10)
    end

    it "returns a PagedEnumerator" do
      subject.all.is_a?(EcwidApi::PagedEnumerator).should be_true
    end
  end

  describe "#find" do
    it "finds a single order with the client" do
      expect(client).to receive(:get).with("orders", hash_including(order: 124)).and_call_original
      subject.find(124)
    end

    it "returns an `EcwidApi::Order` object" do
      subject.find(124).is_a?(EcwidApi::Order).should be_true
    end
  end
end