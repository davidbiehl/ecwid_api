require 'spec_helper'

describe EcwidApi::Api::Customers, faraday: true do
  subject { client.customers }

  describe "#all" do
    it "passes any other parameters through" do
      expect(client).to receive(:get).with("customers", hash_including(from_date: '1982-05-17'))
      subject.all(from_date: '1982-05-17')
    end

    it "gets the proper response count (see fixture)" do
      expect(subject.all.count).to eq 5
    end

    it "gets the proper customer (see fixture)" do
      expect(subject.all.first.name).to eq "Abe Doe"
    end
  end
end
