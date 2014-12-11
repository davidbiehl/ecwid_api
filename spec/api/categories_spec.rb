require 'spec_helper'

describe EcwidApi::Api::Categories, faraday: true do
  subject { client.categories }

  describe "#all" do
    it "gets all of the categories from the client" do
      expect(client).to receive(:get).with("categories", hash_including({})).and_call_original
      subject.all
    end

    it "gets sub categories" do
      expect(client).to receive(:get).with("categories", hash_including(parent: 5)).and_call_original
      subject.all(parent: 5)
    end
  end

  describe "#root" do
    it "gets the root level categories" do
      expect(subject).to receive(:all).with(hash_including(parent: 0)).and_call_original
      subject.root
    end
  end

  describe "#find" do
    it "finds a single category" do
      expect(client).to receive(:get).with("categories/#{5}").and_call_original
      subject.find(5)
    end
  end
end