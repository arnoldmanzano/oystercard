require 'journey'
require 'oystercard'

describe Journey do

  subject(:journey) {described_class.new}
  let(:entry_station) {double (:entry_station)}
  let(:exit_station) {double (:exit_station)}

  describe '#entry_station' do
    it 'remembers the entry station after journey started' do
      journey.start(entry_station)
      expect(journey.entry_station).to eq entry_station
    end
  end

  describe '#in_journey?' do
    it 'checks that when initialised the card is not in journey' do
      expect(subject).to_not be_in_journey
    end

    it 'checks that when the journey has started, the card is in journey' do
      journey.start(entry_station)
      expect(subject).to be_in_journey
    end
  end

    describe '#exit_station' do
      it 'remembers the exit station after journey ended' do
        journey.end(exit_station)
        expect(journey.exit_station).to eq exit_station
      end
    end

  describe '#journey_list' do
    it 'checks that the journey list is empty by default' do
      expect(journey.journey_list).to be {}
    end
  end

  describe '#journey_list' do
    it 'checks that touching in and out creates a journey' do
      journey.start(entry_station)
      journey.end(exit_station)
      expect(journey.journey_list).to include(entry_station => exit_station)
    end
  end

end
