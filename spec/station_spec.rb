require 'station'

describe Station do

subject {described_class.new(name: "London Bridge", zone: 1)}

  describe '#new_station' do
    it 'tests that the name is initialised' do
      expect(subject.name).to eq("London Bridge")
    end

    it 'tests that the zone is initialised' do
      expect(subject.zone).to eq(1)
    end
  end

end
