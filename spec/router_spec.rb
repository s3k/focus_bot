require "spec_helper"

RSpec.describe SnapList::Router do
  let(:pattern){ "edit/done/:id/parse/:bar" }
  let(:route){ "edit/done/210/parse/433" }

  it "match edit/done/:id/parse/:bar" do
    router = SnapList::Router.new(route, pattern)
    expect(router.match?).to eq true
    expect(router.params[:id]).to eq "210"
    expect(router.params[:bar]).to eq "433"
  end

  it "match simple command" do
    router = SnapList::Router.new("/list", "/list")
    expect(router.match?).to eq true
  end

  it "match simple route" do
    router = SnapList::Router.new("list/wow", "list/wow")
    expect(router.match?).to eq true
  end
end
