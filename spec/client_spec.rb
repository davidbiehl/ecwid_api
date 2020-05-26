require "spec_helper"

describe EcwidApi::Client do
  subject { client }

  describe "#store_url" do
    its(:store_url) { "http://app.ecwid.com/api/v3/12345" }
  end

  describe "#get", faraday: true do
    it "delegates to the Faraday connection" do
      expect(subject.send(:connection)).to receive(:get).with("categories", parent: 1)
        .and_return(double(success?: true, status: 200))

      subject.get "categories", parent: 1
    end

    it "returns a Faraday::Response" do
      expect(subject.get("categories", parent: 1).is_a?(Faraday::Response)).to be true
    end
  end
end