require "spec_helper"

describe EcwidApi::Client do
  subject { client }

  describe "#store_url" do
    it { is_expected.to have_attributes(store_url: "https://app.ecwid.com/api/v3/12345") }
  end

  describe "#get", faraday: true do
    it "delegates to the Faraday connection" do
      expect(subject.send(:connection)).to receive(:get).with("categories", parent: 1)

      subject.get "categories", parent: 1
    end

    it "returns a Faraday::Response" do
      expect(subject.get("categories", parent: 1)).to be_a(Faraday::Response)
    end
  end
end
