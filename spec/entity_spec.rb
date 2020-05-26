require 'spec_helper'

class EntitySubject < EcwidApi::Entity
  self.url_root = "stuff"

  ecwid_reader :id, :parentId, :type, :modify, :override
  ecwid_writer :writeOnly
  ecwid_accessor :theStatus

  def override
    super.upcase
  end
end

class EntityUrlSubject < EcwidApi::Entity
  ecwid_reader :id, :parentId

  self.url_root = -> { "parent/#{parent_id}/and" }
end

describe EcwidApi::Entity do
  let(:data) do
    {
      "id" => 123,
      "parentId" => 456,
      "type" => "AWESOME",
      "theStatus" => "YOUNG",
      "hidden" => "tee hee",
      "writeOnly" => "write me!",
      "override" => "upcase me"
    }
  end

  subject { EntitySubject.new(data) }

  describe "::url_root" do
    its(:url) { eq "stuff/123" }

    context "with a proc" do
      subject { EntityUrlSubject.new(data) }
      its(:url) { eq "parent/456/and/123" }
    end
  end


  describe "#[]" do
    it "gets data with a symbol key" do
      expect(subject[:id]).to eq 123
    end

    it "gets data with a string key" do
      expect(subject["parentId"]).to eq 456
    end

    it "get nil for unknown data" do
      expect(subject["whatever"]).to be nil
    end

    it "gets attributes not revealed by ecwid_reader or ecwid_accessor" do
      expect(subject["hidden"]).to eq "tee hee"
    end
  end

  describe "overrides" do
    its(:override) { eq "UPCASE ME" }
  end

  describe "accessors" do

    describe "::ecwid_reader" do
      it "makes data accessible with a snake cased method" do
        expect(subject.parent_id).to eq 456
      end

      it "doesn't have a writer" do
        expect { subject.parent_id = 4 }.to raise_error(NoMethodError)
      end
    end

    describe "::ecwid_writer" do
      it "creates a writer method" do
        subject.write_only = "yee haw!"
        expect(subject["writeOnly"]).to eq "yee haw!"
      end

      it "doesn't have a reader" do
        expect { subject.write_only }.to raise_error(NoMethodError)
      end
    end

    describe "::ecwid_accessor" do
      it "creates a reader and a writer" do
        subject.the_status = "MATURE"
        expect(subject.the_status).to eq "MATURE"
      end
    end

    describe "without an accessor" do
      it "is accessible with []" do
        expect(subject[:hidden]).to eq "tee hee"
      end

      it "doesn't have an access method" do
        expect { subject.hidden }.to raise_error(NoMethodError)
      end
    end
  end
end