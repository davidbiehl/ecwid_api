require "spec_helper"

describe EcwidApi::Client do
  subject do
    EcwidApi::Client.new do |config|
      config.store_id = store_id
    end
  end
  let(:store_id) { 12345 }

  context "without a store_id" do
    it "raises an error" do
      expect { EcwidApi::Client.new }.to raise_error(EcwidApi::Error, /store_id/)
    end
  end

  describe "#url" do
    its(:url) { "http://app.ecwid.com/api/v1" }

    it "can be overridden" do
      client = EcwidApi::Client.new do |config|
        config.store_id = store_id
        config.url = "http://ladida.com"
      end

      client.url.should == "http://ladida.com"
    end
  end

  describe "#store_url" do
    its(:store_url) { "http://app.ecwid.com/api/v1/12345" }
  end

  describe "#get", faraday: true do
    before(:each) do
      faraday_client(subject)
    end

    it "delegates to the Faraday connection" do
      expect(subject.send(:connection)).to receive(:get).with("categories", parent: 1)

      subject.get "categories", parent: 1
    end

    it "returns a Faraday::Response" do
      subject.get("categories", parent: 1).is_a?(Faraday::Response).should be_true
    end
  end
end