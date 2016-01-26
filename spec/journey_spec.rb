require "journey"

describe Journey do
  subject(:journey) {described_class.new("Aldgate", "Angel")}

  it "knows the start" do
    expect(journey.start).to eq "Aldgate"
  end
  it "knows the end" do
    expect(journey.end).to eq "Angel"
  end


end