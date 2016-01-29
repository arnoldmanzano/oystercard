
require 'Oystercard'

describe Oystercard do
  let(:journey_log_klass) { double('journey_log_klass', new: journey_log) }
  subject(:oystercard) { described_class.new(journey_log_klass: journey_log_klass) }
  let(:journey_log){ double(:journey_log, start_journey: nil, exit_journey: nil, fare: Oystercard::MINIMUM_FARE) }
  let(:entry_station){ double(:station) }
  let(:exit_station){ double(:station) }

  describe '#initialize' do

    it 'initializes with 0 balance' do
      expect(oystercard.balance).to eq 0
    end
  end

  describe '#top up' do
    it 'can be topped up' do
      expect{ oystercard.top_up 1 }.to change{ oystercard.balance }.by 1
    end

    it 'top up cannot allow balance to exceed £90' do
      maximum_balance = Oystercard::MAXIMUM_BALANCE
      oystercard.top_up(maximum_balance)
      expect{oystercard.top_up(1)}.to raise_error "Balance has exceeded limit of #{maximum_balance}"
    end
  end

  describe '#deduct method' do

    it 'deduct' do
      allow(journey_log).to receive(:in_progress?){false}
      allow(journey_log).to receive(:fare){Oystercard::MINIMUM_FARE}
      oystercard.top_up 50
      oystercard.touch_in(entry_station)
      expect{ oystercard.touch_out(exit_station) }.to change{ oystercard.balance }.by -Oystercard::MINIMUM_FARE
    end
  end

  describe '#touch in' do

    it 'deducts a maximum fare after double touch_in' do
      allow(journey_log).to receive(:fare){Journey::PENALTY_FARE}
      allow(journey_log).to receive(:in_progress?){false}
      oystercard.top_up 10
      subject.touch_in(entry_station)
      allow(journey_log).to receive(:in_progress?){true}
      expect{subject.touch_in(entry_station)}.to change{subject.balance}.by -(Journey::PENALTY_FARE)
    end

    it 'raises an error if balance is less than 1' do
      expect{oystercard.touch_in(entry_station)}.to raise_error "Insufficient funds"
    end

    it 'calls the start_journey on journey_log' do
      oystercard.top_up 10
      allow(journey_log).to receive(:in_progress?){false}
      expect(journey_log).to receive(:start_journey)
      oystercard.touch_in(entry_station)
    end

    # it '' do
    # end
  end

  describe '#touch_out' do
    before do
      oystercard.top_up 10
      allow(journey_log).to receive(:in_progress?){false}
      oystercard.touch_in(entry_station)
    end

    it 'calls the exit_journey' do
      expect(journey_log).to receive(:exit_journey)
      oystercard.touch_out(exit_station)
    end

  end

end
