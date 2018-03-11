require "spec_helper"

RSpec.describe SnapList do
  it "has a version number" do
    expect(SnapList::VERSION).not_to be nil
  end
end
