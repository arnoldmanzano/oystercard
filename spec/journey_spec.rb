
require 'journey'

describe Journey do

  subject(:journey) {described_class.new}
  let (:entry_station) {double(:entry_station)}
  let (:exit_station) {double(:exit_station)}
  let (:oystercard) {double(:oystercard, :balance => 10)}
  let (:station_zone1) {double(:station, name: 'A', zone:1)}
  let (:station_zone2) {double(:station, name: 'B', zone:2)}
  let (:station_zone3) {double(:station, name: 'C', zone:3)}
  let (:station_zone4) {double(:station, name: 'D', zone:4)}


  describe '#start_journey' do
    it 'defines entry_station' do
      journey.start_journey(entry_station)
      expect(journey.entry_station).to eq(entry_station)
    end
  end

  describe '#end_journey' do
    it 'defines exit_station' do
      journey.start_journey(entry_station)
      journey.end_journey(exit_station)
      expect(journey.exit_station).to eq(exit_station)
    end
  end

  describe '#fare' do

    it {should respond_to(:fare)}

    it 'should return the minimum fare for travel on same zone' do
      minimum_fare = Journey::MINIMUM_FARE
      journey.start_journey(station_zone1)
      journey.end_journey(station_zone1)
      expect(journey.fare).to eq minimum_fare
    end

    it 'should return the PENALTY fare' do
      penalty_fare = Journey::PENALTY_FARE
      journey.end_journey(exit_station)
      expect(journey.fare).to eq penalty_fare
    end
  end

  describe '#fare_calc' do
    it 'returns the correct fare for travel between 2 zones' do
      journey.start_journey(station_zone1)
      journey.end_journey(station_zone2)
      expect(journey.fare).to eq 2
    end

    it 'returns the correct fare for travel between 3 zones' do
      journey.start_journey(station_zone3)
      journey.end_journey(station_zone1)
      expect(journey.fare).to eq 3
    end
  end
end
