require 'oystercard'

describe Oystercard do
  subject(:card){described_class.new}
  subject(:card2){described_class.new}

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

    it "is in journey after touching in" do
      card2.touch_in
      expect(card2).to be_in_journey
    end
    it "is no longer in journey after touching out" do
      card2.touch_in
      card2.touch_out
      expect(card2).to_not be_in_journey
    end
    it "raises error if balance is below minimum fare" do
      message = "Balance is below £#{Oystercard::MIN_FARE} minimum"
      expect { (card.touch_in) }.to raise_error message
    end
  end

  context "end of journey" do
    before(:each) do
      card.top_up(10)
    end

    it "deducts balance after touch out" do
      expect{card.touch_out}.to change{card.balance}.by -Oystercard::MIN_FARE
    end
  end
end
