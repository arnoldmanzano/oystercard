require 'Oystercard'

describe Oystercard do
  subject(:oystercard) {described_class.new}
  let(:entry_station) {double :entry_station}
  let(:exit_station) {double :exit_station}
  let(:journey) { {entry_station: nil, exit_station: nil}}


  it { is_expected. to respond_to{:balance}}

  describe '#initialize' do
    it 'initializes with 0 balance and an empty history' do
      expect(oystercard.balance).to eq 0
      expect(oystercard.history).to be_empty
    end
  end


  describe '#top up' do

    it {is_expected.to respond_to(:top_up).with(1).argument }

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
      expect{ oystercard.touch_out(exit_station) }.to change{ oystercard.balance }.by -1
    end
  end

  it 'in journey' do
    expect(oystercard.in_journey?).to eq false
  end

  describe '#touch in' do
    #
    # it 'Touch in' do
    #   oystercard.top_up 10
    #   oystercard.touch_in(entry_station)
    #   expect(oystercard.in_journey?).to eq true
    # end
    it { is_expected.to respond_to(:touch_in).with(1).argument }
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

    it 'deduct by minimum fare' do
      expect{oystercard.touch_out(exit_station)}.to change {oystercard.balance}.by(-Oystercard::MINIMUM_CHARGE)
    end

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

  it { is_expected.to respond_to(:touch_out).with(1).argument }

  it 'raises an error if balance is less than 1' do
    expect{oystercard.touch_in(entry_station)}.to raise_error "Insufficient funds"
  end




  end
