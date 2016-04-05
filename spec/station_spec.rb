require 'station'


describe Station do
	subject(:station) {described_class.new(:wimbledon, 1)}
  it 'has name' do
    expect(station.name).to eq :wimbledon
	end

	it 'has zone' do
    expect(station.zone).to eq 1
  end
end
