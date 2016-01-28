require 'journey_log'

describe JourneyLog do
  let(:journey_klass) { double('journey_klass') }

  subject(:journey_log) { described_class.new(journey_klass) }
  let(:journey){ double(:journey) }
  let(:entry_station){ double(:station) }
  let(:exit_station){ double(:station) }

  before do
    allow(journey_klass).to receive(:new){journey}
    allow(journey).to receive(:start_journey){:entry_station}
    allow(journey).to receive(:end_journey){:exit_station}
    #journey_log (journey_klass)
  end

  describe '#initialize' do
    it 'journey_log is empty when created' do

      expect(subject.history).to be_empty
    end
  end

  describe '#start_journey' do
    it 'calls the method start_journey' do
      expect(journey).to receive(:start_journey)
      subject.start_journey(:entry_station)
    end
  end
  describe '#current_journey' do
    it 'returns incomplete journey' do
      subject.start_journey(entry_station)
      expect(subject.journey_status).to eq journey
    end

    it 'returns incomplete journey, and not starts a new' do
      subject.start_journey(entry_station)
      expect(journey_klass).not_to receive(:new)
      subject.journey_status
    end

    it 'it creates a new journey' do
      expect(journey_klass).to receive(:new)
      subject.journey_status
    end
  end

  describe 'exit_journey' do
    it 'adds an exit journey to the current journey' do
      expect(journey).to receive(:end_journey)
      subject.exit_journey(exit_station)
    end
  end
 describe '#journeys' do
    it 'stores a journey' do
     subject.start_journey(entry_station)
     subject.exit_journey(exit_station)
     expect(subject.history).to include(journey)
    end
    it 'stores an incomplete journey' do
      subject.start_journey(entry_station)
      subject.start_journey(entry_station)
      expect(subject.history).to include(journey)
    end

    it 'stores does not store an incomplete journey before it is ended' do
      subject.start_journey(entry_station)
      subject.exit_journey(exit_station)
      subject.start_journey(entry_station)
      expect(subject.history.length).not_to be 2
    end

  end
end
