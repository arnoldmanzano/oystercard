class Oystercard
	attr_reader :balance

	TOP_UP_LIMIT = 90
	MIN_BALANCE = 1

	def initialize
		@balance = 0
    @in_use = 0
	end

  def top_up(amount)
  	fail "Exceeds £#{TOP_UP_LIMIT} top up limit." if (@balance + amount) > TOP_UP_LIMIT
    @balance += amount
  end

  def deduct(amount)
    @balance -= amount
  end

  def in_journey?
    @in_use >= 1 ? true : false
  end

  def touch_in
		fail "Balance is below £#{MIN_BALANCE} minimum" if @balance < MIN_BALANCE
    @in_use += 1
  end

  def touch_out
    @in_use -= 1
  end

end
