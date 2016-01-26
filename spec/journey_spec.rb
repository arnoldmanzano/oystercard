require "journey"

describe Journey do
  subject(:journey) {described_class.new}
  let(:start_station){double :start_station}
  let(:end_station){double :end_station}

  context "#trip" do
    it "starts with empty history" do
      expect(journey.history).to be_empty
    end

    it "is in journey after start trip" do
      journey.start(start_station)
      expect(journey).to be_started
    end

    it "ends journey after end station" do
      journey.start(start_station)
      journey.end(end_station)
      expect(journey).to be_ended
    end

    it "records journey in hash" do
      journey.start(start_station)
      journey.end(end_station)
      expect(journey.history).to include(start: start_station, end: end_station)
    end

    it "record history array upon end trip" do
      journey.start(start_station)
      journey.end(end_station)
      expect(journey.history).to include journey.trip
    end
  end
end

#TODO fare method
