class Oystercard
	attr_reader :balance, :entry_station

	TOP_UP_LIMIT = 90
	MIN_FARE = 1

	def initialize
		@balance = 0
	end

  def top_up(amount)
  	fail "Exceeds £#{TOP_UP_LIMIT} top up limit." if (@balance + amount) > TOP_UP_LIMIT
    @balance += amount
  end


  def in_journey?
    !!entry_station
  end

  def touch_in(station)
		fail "Balance is below £#{MIN_FARE} minimum" if @balance < MIN_FARE
    @entry_station = station
  end

  def touch_out
		deduct
    @entry_station = nil
  end

	private

  def deduct(amount=MIN_FARE)
    @balance -= amount
  end

end
