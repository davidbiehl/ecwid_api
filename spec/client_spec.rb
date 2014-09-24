require "spec_helper"

describe EcwidApi::Client do
  subject do
    EcwidApi::Client.new(store_id, token)
  end

  let(:store_id) { 12345 }
  let(:token)    { "some token thing" }

  describe "#store_url" do
    its(:store_url) { "http://app.ecwid.com/api/v3/12345" }
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