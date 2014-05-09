require 'spec_helper'

describe EcwidApi::OrderItem do
  let(:client) { EcwidApi::Client.new { |config| config.store_id = '123455'} }
  subject { EcwidApi::OrderItem.new({"sku" => "12345", "categoryId" => 222}, client: client) }

  describe "#category" do
    it "gets the category from the client" do
      expect(client.categories).to receive(:find).with(222)
      subject.category
    end
  end
end