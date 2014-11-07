require 'spec_helper'

describe EcwidApi::Order, faraday: true do
  subject do
    EcwidApi::Order.new({
      "orderNumber" => 123,
      "billingPerson" => {
        "name" => "John Doe"
      },
      "shippingPerson" => shipping_person,
      "items" => [{
        "sku" => "112233"
      }],
      "fulfillmentStatus" => "AWAITING_PROCESSING"
    })
  end

  let(:shipping_person) { nil }

  its(:id) { should == 123 }

  describe "#billing_person" do
    its(:billing_person) { should be_a(EcwidApi::Person) }

    it "has the correct data" do
      subject.billing_person.name.should == "John Doe"
    end
  end

  describe "#shipping_person" do
    its(:shipping_person) { should be_a(EcwidApi::Person) }

    context "without a shipping person" do
      let(:shipping_person) { nil }
      its(:shipping_person) { should == subject.billing_person }
    end

    context "with a shipping person" do
      let(:shipping_person) { {"name" => "Jane Doe"} }
      it "has the correct data" do
        subject.shipping_person.name.should == "Jane Doe"
      end
    end
  end

  describe "#items" do
    it "has the correct number of items" do
      subject.items.size.should == 1
    end

    it "has the correct data" do
      subject.items.first.sku.should == "112233"
    end
  end

  describe "#fulfillment_status=" do
    it "raises an error with an invalid status" do
      expect { subject.fulfillment_status = :stuff }.to raise_error
    end

    it "doesn't raise an error with a valid status" do
      expect { subject.fulfillment_status = :processing }.to_not raise_error
    end
  end

  describe "#fulfillment_status" do
    it "is symbolized" do
      subject.fulfillment_status.should == :awaiting_processing
    end
  end
end