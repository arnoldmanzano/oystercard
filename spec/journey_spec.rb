
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

    it 'should return the minimum fare for travel on same zone' do
      minimum_fare = Journey::MINIMUM_FARE
      subject.start_journey(station_zone1)
      subject.end_journey(station_zone1)
      expect(subject.fare).to eq minimum_fare
    end

    it 'should return the PENALTY fare' do
      penalty_fare = Journey::PENALTY_FARE
      subject.end_journey(exit_station)
      expect(subject.fare).to eq penalty_fare
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

    it 'returns the right fare between two real stations' do
      journey.start_journey(:brixton)
      journey.end_journey(wembley)
      expect(journey.fare).to eq 2
    end
  end
end
