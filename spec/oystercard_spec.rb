require 'oystercard'

describe Oystercard do
  subject(:card){described_class.new}
  subject(:card2){described_class.new}
  let(:start_station){double :start_station}
  let(:end_station){double :end_station}

	it "new card balance == 0" do
		expect(card.balance).to eq 0
	end

  context "changing balance" do
    it "topping up balance" do
      expect{card.top_up(10)}.to change{ card.balance}.by 10
    end
    it "raises error if over limit" do
    	message = "Exceeds £#{Oystercard::TOP_UP_LIMIT} top up limit."
      expect{card.top_up(Oystercard::TOP_UP_LIMIT + 1)}.to raise_error message
    end
  end

  context "#in_journey?" do
    before(:each) do
      card2.top_up(Oystercard::MIN_FARE)
    end

    it "raises error if balance is below minimum fare" do
      message = "Balance is below £#{Oystercard::MIN_FARE} minimum"
      expect { (card.touch_in(start_station)) }.to raise_error message
    end
  end

  context "end of journey" do
    before(:each) do
      card.top_up(10)
    end

    it "deducts balance after touch out" do
      expect{card.touch_out(end_station)}.to change{card.balance}.by -Oystercard::MIN_FARE
    end

  end

  context "start of journey" do
    before(:each) do
      card.top_up(10)
    end
  end
end

=begin
  context "journey history" do
    before(:each) do
      card.top_up(10)
    end
    it "starts with empty history" do
      expect(card.history).to be_empty
    end

    it "records journey in hash" do
      card.touch_in(start_station)
      card.touch_out(end_station)
      expect(card.journey).to include(start: start_station, end: end_station)
    end

    it "record history array upon touch out" do
      card.touch_in(start_station)
      card.touch_out(end_station)
      expect(card.history).to include card.journey
    end
  end
=end


=begin
    it "is in journey after touching in" do
      card2.touch_in(start_station)
      expect(card2).to be_in_journey
    end
    it "is no longer in journey after touching out" do
      card2.touch_in(start_station)
      card2.touch_out(end_station)
      expect(card2).to_not be_in_journey
    end

    it "remembers touch out station" do
      card.touch_in(start_station)
      card.touch_out(end_station)
      expect(card.exit_station).to eq end_station
    end
    it "remembers touch in station" do
      card.touch_in(start_station)
      expect(card.entry_station).to eq start_station
    end
    it "entry station cleared at touch out" do
      card.touch_in(start_station)
      card.touch_out(end_station)
      expect(card.entry_station).to eq nil
    end
=end
