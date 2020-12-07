require 'spec_helper'

describe EcwidApi::PagedEnumerator do
  subject do
    EcwidApi::PagedEnumerator.new(response_one, &proc)
  end

  let(:proc) do
    Proc.new do |response, yielder|
      response[:stuff].each { |thing| yielder << thing }
      response[:next]
    end
  end

  let(:response_one) do
    {
      stuff: %w(1 2 3),
      next: response_two
    }
  end

  let(:response_two) do
    {
      stuff: %w(4 5 6),
    }
  end

  it "contains the whole result set" do
    expect(subject.to_a).to eq %w(1 2 3 4 5 6)
  end

  it "iterates over each response once" do
    expect(response_two[:stuff]).to receive(:each).once.and_call_original

    subject.each
    subject.each
  end
end