
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
      allow(journey_log).to receive(:fare){Oystercard::MINIMUM_FARE}
      oystercard.top_up 50
      oystercard.touch_in(entry_station)
      expect{ oystercard.touch_out(exit_station) }.to change{ oystercard.balance }.by -Oystercard::MINIMUM_FARE
    end
  end

  describe '#touch in' do

    it 'deducts a maximum fare after double touch_in' do
      allow(journey_log).to receive(:fare){Journey::PENALTY_FARE}
      oystercard.top_up 10
      subject.touch_in(entry_station)
      expect{subject.touch_in(entry_station)}.to change{subject.balance}.by -(Journey::PENALTY_FARE)
    end

    it 'raises an error if balance is less than 1' do
      expect{oystercard.touch_in(entry_station)}.to raise_error "Insufficient funds"
    end

    it 'calls the start_journey on journey_log' do
      oystercard.top_up 10
      expect(journey_log).to receive(:start_journey)
      oystercard.touch_in(entry_station)
    end

    # it 'starts a journey' do
    #   oystercard.top_up 10
    #   subject.touch_in(entry_station)
    #   expect(subject.history).to include({:entry_station=> entry_station, :exit_station=> nil})
    # end

  end

  describe '#touch_out' do
    before do
      oystercard.top_up 10
      oystercard.touch_in(entry_station)
    end

    it 'calls the exit_journey' do
      expect(journey_log).to receive(:exit_journey)
      oystercard.touch_out(exit_station)
    end

    # it 'forgets the entry station' do
    #   oystercard.touch_out(exit_station)
    #   expect(oystercard.entry_station).to eq nil
    # end

    # it 'stores a journey' do
    #   subject.touch_in(entry_station)
    #   oystercard.touch_out(exit_station)
    #   expect(oystercard.history).to include({:entry_station=> entry_station, :exit_station=> exit_station})
    # end
  end

end
