require 'journey_log'

describe JourneyLog do
  let(:journey_klass) { double('journey_klass', new: journey) }
  subject(:journey_log) { described_class.new(journey_klass: journey_klass) }
  let(:journey){ double(:journey, start_journey: :entry_station, end_journey: :exit_station) }
  let(:entry_station){ double(:station) }
  let(:exit_station){ double(:station) }

  before do
    allow(journey).to receive(:fare)
  end

  describe '#initialize' do
    it 'journey_log is empty when created' do
      expect(journey_log.journeys).to be_empty
    end
  end

  describe '#start_journey' do
    it 'calls the method start_journey' do
      expect(journey).to receive(:start_journey)
      journey_log.start_journey(entry_station)
    end
  end

  describe '#current_journey' do
    # xit 'returns incomplete journey' do
    #   journey_log.start_journey(entry_station)
    #   expect(journey_log.journey_status).to eq journey
    # end
    #
    # xit 'returns incomplete journey, and not starts a new' do
    #   journey_log.start_journey(entry_station)
    #   expect(journey_klass).not_to receive(:new)
    #   journey_log.journey_status
    # end

    it 'it creates a new journey' do
      expect(journey_klass).to receive(:new)
      journey_log.start_journey(entry_station)
    end
  end

  describe 'exit_journey' do
    it 'calls end_journey to the current journey' do
      expect(journey).to receive(:end_journey)
      journey_log.exit_journey(exit_station)
    end
  end

  describe '#journeys' do
    it 'stores a journey' do
     journey_log.start_journey(entry_station)
     journey_log.exit_journey(exit_station)
     expect(journey_log.journeys).to include(journey)
    end

    # xit 'stores an incomplete journey' do
    #   journey_log.start_journey(entry_station)
    #   journey_log.start_journey(entry_station)
    #   expect(journey_log.journeys).to include(journey)
    # end
    #
    # xit 'does not store an incomplete journey before it is ended' do
    #   journey_log.start_journey(entry_station)
    #   journey_log.exit_journey(exit_station)
    #   journey_log.start_journey(entry_station)
    #   expect(journey_log.journeys.length).not_to be 2
    # end
  end

  describe '#fare' do

    it 'calls fare on journey' do
      journey_log.start_journey(entry_station)
      expect(journey).to receive(:fare)
      journey_log.fare
    end
  end
end

#TODO in_progress test?
