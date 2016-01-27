require 'oystercard'

describe Oystercard do
  subject(:oystercard) {described_class.new(journey)}
  let(:entry_station) {double (:entry_station)}
  let(:exit_station) {double (:exit_station)}
  let(:journey) { double(:journey, :start => nil, :end => nil, :in_journey? => true, :complete? => true, :reset => nil) }

  describe "#balance" do
    it "is initialised with a balance of 0 by default" do
      expect(oystercard.balance).to eq 0
    end
  end

  describe '#top_up' do
    it 'adds the value specified to the balance' do
      value = rand(Oystercard::BALANCE_MAX)
      expect{oystercard.top_up(value)}.to change{ oystercard.balance }.from(0).to(value)
    end
  end

  describe '#top_up' do
    it 'raises an error if topping up more than the max limit' do
      max_balance = Oystercard::BALANCE_MAX
      oystercard.top_up(max_balance)
      expect{ oystercard.top_up(1) }.to raise_error "Top-up exceeds maximum limit of #{max_balance}"
    end
  end

  describe '#inferior_balance' do
    it 'raises an exception if the balance is inferior to £1' do
      expect{ oystercard.touch_in(entry_station) }.to raise_error 'Please top up your card.'
    end
  end

  describe '#touch_in(station)' do
    before(:each) do
      oystercard.top_up(10)
    end

    it 'starts journey when card is touched in (Manzano style)' do
      expect(journey).to receive(:start)
      oystercard.touch_in(entry_station)
    end

    it 'is in in_journey when the card is touched in' do
      oystercard.touch_in(entry_station)
      expect(journey).to be_in_journey
    end
  end

  describe '#touch_out' do

    before(:each) do
      oystercard.top_up(10)
      oystercard.touch_in(entry_station)
    end

    it 'reduces the balance by the minimum fare' do
      expect{oystercard.touch_out(exit_station)}.to change { oystercard.balance }.by -Oystercard::FARE_MIN
    end

    it 'ends journey when card is touched out (Manzano style)' do
      expect(journey).to receive(:end)
      oystercard.touch_out(exit_station)
    end

    it 'is in not in_journey when the card is touched out' do
      oystercard.touch_out(exit_station)
      expect(journey).to be_complete
    end
  end

  describe '#fare' do
    it 'returns the minimum fare when a journey is complete' do
      oystercard.top_up(10)
      oystercard.touch_in(entry_station)
      oystercard.touch_out(exit_station)
      expect(oystercard.fare).to eq Oystercard::FARE_MIN
    end

    it 'returns the penalty fare when a journey is incomplete' do
      allow(journey).to receive(:complete?).and_return false
      oystercard.top_up(10)
      oystercard.touch_in(entry_station)
      expect(oystercard.fare).to eq Oystercard::PENALTY_FARE
    end
  end

  describe '#double_touch_in' do
    it 'deducts Penalty charge on double touch in' do
      allow(journey).to receive(:complete?).and_return false
      oystercard.top_up(10)
      oystercard.touch_in(entry_station)
      expect{oystercard.touch_in(entry_station)}.to change{ oystercard.balance }.by -Oystercard::PENALTY_FARE
    end

    it 'deducts penalty charge on double touch out' do
      allow(journey).to receive(:complete?).and_return false
      oystercard.top_up(10)
      oystercard.touch_in(entry_station)
      oystercard.touch_out(exit_station)
      expect{oystercard.touch_out(exit_station)}.to change{ oystercard.balance }.by -Oystercard::PENALTY_FARE
    end
  end

end
