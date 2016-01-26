require 'oystercard'

describe Oystercard do
  subject(:card){described_class.new}
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

    it "deducting from balance" do
      expect{card.deduct(10)}.to change{card.balance}.by -10
    end
  end

  context "#in_journey?" do
    it "is in journey after touching in" do
      card.touch_in
      expect(card).to be_in_journey
    end
    it "is no longer in journey after touching out" do
      card.touch_in
      card.touch_out
      expect(card).to_not be_in_journey
    end

  end
end