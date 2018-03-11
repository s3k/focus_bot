require "spec_helper"

RSpec.describe SnapList::Handler::Base do
  let(:base) {
    data = Struct.new(:data).new("edit/done/210/parse/433")
    resp = Struct.new(:message).new(data)
    SnapList::Handler::Base.new(resp)
  }

  it "match edit/done/:id/parse/:bar" do
    result = []

    base.bind("edit/done/:id/parse/:bar") do |id, bar|
      result += [id, bar]
    end

    expect(result).to eq ["210", "433"]
  end
end
