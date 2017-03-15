require 'spec_helper'

describe EcwidApi::Api::Orders, faraday: true do
  subject { client.orders }

  describe "#all" do
    it "passes the parameters to the client" do
      expect(client).to receive(:get).with("orders", hash_including(from_date: '1982-05-17'))
      subject.all(from_date: '1982-05-17')
    end

    it "gets the proper response (see fixtures)" do
      expect(subject.all.count).to be 2
    end

    it "gets EcwidApi::Order types" do
      expect(subject.all.all? { |order| order.is_a?(EcwidApi::Order) }).to be(true)
    end
  end

  describe "#find" do
    it "is an `EcwidApi::Order`" do
      expect(subject.find(35)).to be_a(EcwidApi::Order)
    end

    it "is nil when not found" do
      expect(subject.find(404)).to be_nil
    end
  end
end
