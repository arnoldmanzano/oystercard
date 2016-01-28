
require 'Oystercard'

describe Oystercard do

  subject(:oystercard) {described_class.new}
  let(:entry_station) {double :entry_station}
  let(:exit_station) {double :exit_station}
  let(:journey) { {entry_station: nil, exit_station: nil}}

  describe '#initialize' do

    it 'initializes with 0 balance and an empty history' do
      expect(oystercard.balance).to eq 0
      expect(oystercard.history).to be_empty
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
      oystercard.top_up 50
      oystercard.touch_in(entry_station)
      expect{ oystercard.touch_out(exit_station) }.to change{ oystercard.balance }.by -1
    end

  end

  it 'in journey' do
    expect(oystercard.in_journey?).to eq false
  end

  describe '#touch in' do

    it 'deducts a maximum fare after double touch_in' do
      oystercard.top_up 10
      subject.touch_in(entry_station)
      expect{subject.touch_in(entry_station)}.to change{subject.balance}.by -(Journey::MAXIMUM_FARE)
    end




    it 'raises an error if balance is less than 1' do
      expect{oystercard.touch_in(entry_station)}.to raise_error "Insufficient funds"
    end

    it 'starts a journey' do
      oystercard.top_up 10
      subject.touch_in(entry_station)
      expect(subject.history).to include({:entry_station=> entry_station, :exit_station=> nil})
    end

  end

  describe '#touch_out' do

    before do
      oystercard.top_up 10
      oystercard.touch_in(entry_station)
    end


    it 'lets you touch out' do
      oystercard.touch_out(exit_station)
      expect(oystercard).not_to be_in_journey
    end

    # it 'deduct by minimum fare' do
    #   expect{oystercard.touch_out(exit_station)}.to change {oystercard.balance}.by(-Oystercard::MINIMUM_CHARGE)
    # end

    it 'forgets the entry station' do
      oystercard.touch_out(exit_station)
      expect(oystercard.entry_station).to eq nil
    end

    it 'stores a journey' do
      subject.touch_in(entry_station)
      oystercard.touch_out(exit_station)
      expect(oystercard.history).to include({:entry_station=> entry_station, :exit_station=> exit_station})
    end

  end

end
