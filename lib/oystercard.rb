require 'journey'

class Oystercard
	attr_reader :balance, :journey, :history
	TOP_UP_LIMIT = 90
	MIN_FARE = 1

	def initialize
		@balance = 0
		@journey = Journey.new
#		@history = []
	end

  def top_up(amount)
  	fail "Exceeds £#{TOP_UP_LIMIT} top up limit." if (@balance + amount) > TOP_UP_LIMIT
    @balance += amount
  end

  def touch_in(station)
		fail "Balance is below £#{MIN_FARE} minimum" if @balance < MIN_FARE
		@journey.start(station)
  end

  def touch_out(station)
		deduct
		@journey.end(station)
  end

	private
  def deduct(amount=MIN_FARE)
    @balance -= amount
  end

end

# def in_journey?
#   !!entry_station
# end
# def touch_in(station)
# 	fail "Balance is below £#{MIN_FARE} minimum" if @balance < MIN_FARE
# 	@entry_station = station
# 	@journey[:start] = station
# end
#
# def touch_out(station)
# 	deduct
# 	@entry_station = nil
# 	@exit_station = station
# 	@journey[:end] = station
# 	@history << @journey
# end
