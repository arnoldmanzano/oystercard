require 'oystercard'

describe Oystercard do
  subject(:card){described_class.new}

    it "new card balance == 0" do
		  expect(card.balance).to eq 0
    end

  describe "top_up" do
    it "topping up balance" do
      expect{card.top_up(10)}.to change{card.balance}.by 10
    end

    it "raises error if over limit" do
    	expect{card.top_up(Oystercard::TOP_UP_LIMIT + 1)}.to raise_error "Exceeds £#{Oystercard::TOP_UP_LIMIT} top up limit."
    end
  end

  describe "deduct" do
    it 'should deduct amount from balance' do
      card.top_up(50)
      expect{card.deduct(10)}.to change{card.balance}.by -10
    end
  end

  context "in_journey?" do

  	before do
  		card.top_up(Oystercard::TOP_UP_LIMIT)
  	end

  	 it 'start of journey in_journey? is false' do
  		expect(card).not_to be_in_journey
  	end

  	it 'touch in changes in_journey? to true' do
  		card.touch_in
  		expect(card).to be_in_journey
  	end

  	it 'touch out changes in_journey? to false' do
  		card.touch_in
  		card.touch_out
  		expect(card).not_to be_in_journey
  	end
  end
end