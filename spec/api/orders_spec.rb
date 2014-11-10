require 'spec_helper'

describe EcwidApi::Api::Orders, faraday: true do
  subject { client.orders }

  describe "#all" do
    it "passes the parameters to the client" do
      expect(client).to receive(:get).with("orders", hash_including(from_date: '1982-05-17'))
      subject.all(from_date: '1982-05-17')
    end

    it "gets the proper response (see fixtures)" do
      subject.all.count.should == 2
    end

    it "gets EcwidApi::Order types" do
      subject.all.all? { |order| order.is_a?(EcwidApi::Order) }.should be_true
    end
  end

  describe "#find" do
    it "is an `EcwidApi::Order`" do
      subject.find(35).is_a?(EcwidApi::Order).should be_true
    end

    it "is nil when not found" do
      subject.find(404).should be_nil
    end
  end
end