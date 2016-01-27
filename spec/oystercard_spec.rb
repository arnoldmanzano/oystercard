require 'oystercard'

describe Oystercard do
  subject(:oystercard) {described_class.new}
  let(:entry_station) {double (:entry_station)}
  let(:exit_station) {double (:exit_station)}

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
      expect{ oystercard.top_up(1) }.to raise_error 'Top-up exceeds maximum limit of #{max_balance}'
    end
  end

  describe '#touch_in(station)' do
    it 'raises an exception if the balance is inferior to £1' do
      expect{ oystercard.touch_in(entry_station) }.to raise_error 'Please top up your card.'
    end

    it 'starts journey when card is touched in (Manzano style)' do
      oystercard.top_up(10)
      expect(oystercard.journey).to receive(:start)
      oystercard.touch_in(entry_station)
    end

    it 'is in in_journey when the card is touched in' do
      oystercard.top_up(10)
      oystercard.touch_in(entry_station)
      expect(oystercard.journey).to be_in_journey
    end
  end

  describe '#touch_out' do
    it 'reduces the balance by the minimum fare' do
      expect{oystercard.touch_out(exit_station)}.to change { oystercard.balance }.by -Oystercard::FARE_MIN
    end

    it 'ends journey when card is touched out (Manzano style)' do
      oystercard.top_up(10)
      expect(oystercard.journey).to receive(:end)
      oystercard.touch_out(exit_station)
    end

    it 'is in not in_journey when the card is touched out' do
      oystercard.top_up(10)
      oystercard.touch_in(entry_station)
      oystercard.touch_out(exit_station)
      expect(oystercard.journey).to be_complete
    end
  end

  describe '#fare' do
    xit 'returns the minimum fare when a journey is complete' do
      oystercard.top_up(10)
      oystercard.touch_in(entry_station)
      oystercard.touch_out(exit_station)
      expect(oystercard.fare).to eq Oystercard::FARE_MIN
    end
  end

end
