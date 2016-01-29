
require 'journey'

describe Journey do

  subject(:journey) {described_class.new}
  let (:entry_station) {double(:entry_station)}
  let (:exit_station) {double(:exit_station)}
  let (:oystercard) {double(:oystercard, :balance => 10)}

  describe '#start_journey' do

    xit 'starts a journey' do
      subject.start_journey(entry_station)
      expect(subject.journey_details).to include(:entry_station => entry_station, :exit_station=> nil)
    end
  end

  describe '#end_journey' do

    xit 'ends a journey' do
      subject.start_journey(entry_station)
      subject.end_journey(exit_station)
      expect(subject.journey_details).to include(:entry_station => entry_station, :exit_station=> exit_station)
    end
  end

  describe '#fare' do

    it {should respond_to(:fare)}

    it 'should return the minimum fare' do
      minimum_fare = Journey::MINIMUM_FARE
      subject.start_journey(entry_station)
      subject.end_journey(exit_station)
      expect(subject.fare).to eq minimum_fare
    end

    it 'should return the PENALTY fare' do
      penalty_fare = Journey::PENALTY_FARE
      subject.end_journey(exit_station)
      expect(subject.fare).to eq penalty_fare
    end
  end
end
