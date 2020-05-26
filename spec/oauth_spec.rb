require 'spec_helper'

describe EcwidApi::OAuth do
  subject do
    EcwidApi::OAuth.new do |config|
      config.client_id = "client_id"
      config.client_secret = "client_secret"
      config.scope = "scope"
      config.redirect_uri = "https://example.com/oauth"
    end
  end

  its(:oauth_url) { eq "https://my.ecwid.com/api/oauth/authorize?client_id=client_id&scope=scope&response_type=code&redirect_uri=https%3A%2F%2Fexample.com%2Foauth" }

  describe "#access_token(code)" do
    let(:response) do
      double("response").tap do |response|
        allow(response).to receive(:success?).and_return(true)
        allow(response).to receive(:body).and_return(access_token: "the_token", store_id: "12345")
      end
    end

    before(:each) do
      allow(subject.send(:connection)).to receive(:post).with("/api/oauth/token", hash_including(code: "code")).and_return(response)
    end

    it "sends a request to the API for an access_token" do
      expect(subject.send(:connection)).to receive(:post).with("/api/oauth/token", hash_including(code: "code")).and_return(response)
      subject.access_token("code")
    end

    it "returns an object that has the access_token" do
      expect(subject.access_token("code").access_token).to eq "the_token"
    end

    it "returns an object that has the store_id" do
      expect(subject.access_token("code").store_id).to eq "12345"
    end
  end
end