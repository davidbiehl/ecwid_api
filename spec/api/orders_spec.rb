require 'spec_helper'

describe EcwidApi::Api::Orders, faraday: true do
  subject { client.orders }

  describe "#all" do
    it "passes the parameters to the client" do
      expect(client).to receive(:get).with("orders", hash_including(from_date: '1982-05-17'))
        .and_return(empty_pagination_response)
      subject.all(from_date: '1982-05-17').each{}
    end

    it "gets the proper response (see fixtures)" do
      expect(subject.all.count).to be 2
    end

    it "gets EcwidApi::Order types" do
      expect(subject.all.all? { |order| order.is_a?(EcwidApi::Order) }).to be true
    end
  end

  describe "#find" do
    it "is an `EcwidApi::Order`" do
      expect(subject.find(35).is_a?(EcwidApi::Order)).to be true
    end

    it "is nil when not found" do
      expect{subject.find(404)}.to raise_exception(EcwidApi::NotFoundError)
    end
  end
end