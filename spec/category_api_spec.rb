require 'spec_helper'

describe EcwidApi::CategoryApi, faraday: true do
  let(:client) { EcwidApi::Client.new { |config| config.store_id = '12345' } }
  subject { EcwidApi::CategoryApi.new(client) }

  before(:each) do
    faraday_client(client)
  end

  describe "#all" do
    it "gets all of the categories from the client" do
      expect(client).to receive(:get).with("categories", {}).and_call_original
      subject.all
    end

    it "gets sub categories" do
      expect(client).to receive(:get).with("categories", parent: 5).and_call_original
      subject.all(5)
    end
  end

  describe "#root" do
    it "gets the root level categories" do
      expect(subject).to receive(:all).with(0).and_call_original
      subject.root
    end
  end

  describe "#find" do
    it "finds a single category" do
      expect(client).to receive(:get).with("category", id: 5).and_call_original
      subject.find(5)
    end
  end
end