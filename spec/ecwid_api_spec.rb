require 'spec_helper'

describe EcwidApi do
  describe "::default_client" do
    it "builds an EcwidApi::Client with the block" do
      EcwidApi.default_client.should be_nil

      client = EcwidApi.default_client do |config|
        config.store_id = 123
      end

      client.is_a?(EcwidApi::Client).should be_true
    end
  end
end