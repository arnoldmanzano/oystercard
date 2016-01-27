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
  end

  describe '#touch_out' do
    it 'reduces the balance by the minimum fare' do
      expect{oystercard.touch_out(exit_station)}.to change { oystercard.balance }.by -Oystercard::FARE_MIN
    end
  end

  # describe '#entry_station' do
  #   it 'remembers the entry station after touch in' do
  #     oystercard.top_up(Oystercard::FARE_MIN)
  #     oystercard.touch_in(entry_station)
  #     expect(oystercard.entry_station).to eq entry_station
  #   end
  # end
  #
  # # describe '#exit_station' do
  # #   it 'forgets the entry station after touch out' do
  # #     oystercard.top_up(Oystercard::FARE_MIN)
  # #     oystercard.touch_in(entry_station)
  # #     oystercard.touch_out(exit_station)
  # #     expect(oystercard.entry_station).to eq nil
  # #   end
  # # end
  #
  # describe '#journey_list' do
  #   it 'checks that the journey list is empty by default' do
  #     expect(oystercard.journey_list).to be {}
  #   end
  # end
  #
  # describe '#journey_list' do
  #   it 'checks that touching in and out creates a journey' do
  #     oystercard.top_up(Oystercard::FARE_MIN)
  #     oystercard.touch_in(entry_station)
  #     oystercard.touch_out(exit_station)
  #     expect(oystercard.journey_list).to include(entry_station => exit_station)
  #   end
  # end

end
