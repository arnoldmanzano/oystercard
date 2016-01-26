class Oystercard
	attr_reader :balance

	TOP_UP_LIMIT = 90

	def initialize
		@balance = 0
	end

  def top_up(amount)
  	fail "Exceeds £#{TOP_UP_LIMIT} top up limit." if (@balance + amount) > TOP_UP_LIMIT
    @balance += amount
  end

  def deduct(amount)
    @balance -= amount
  end

end