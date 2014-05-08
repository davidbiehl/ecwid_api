require 'spec_helper'

describe EcwidApi::Entity do
  let(:data) { {"id" => 123, "parentId" => 456} }

  subject { EcwidApi::Entity.new(data) }

  describe "#[]" do
    it "gets data with a symbol key" do
      subject[:id].should == 123
    end

    it "gets data with a string key" do
      subject["parentId"].should == 456
    end
  end

  describe "#method_missing" do
    it "gets data with snake_cased messages" do
      subject.parent_id.should == 456
    end
  end
end