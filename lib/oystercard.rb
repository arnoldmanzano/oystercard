require_relative "journeylog"
require_relative "station"

class Oystercard
	attr_reader :balance, :station

	TOP_UP_LIMIT = 90
	MIN_FARE = 1
	PENALTY_FARE = 6

	def initialize(journey_log_class: JourneyLog)
		@balance = 0
		@journey_log = journey_log_class.new
		@station = station
    @touched_in = false
	end

	def top_up(amount)
  	fail "Exceeds £#{TOP_UP_LIMIT} top up limit." if exceeds_balance(amount)
    @balance += amount
  end

  def touch_in(station)
  	fail 'Insufficient funds' if @balance < MIN_FARE
    @journey_log.starts(station)
		return deduct(PENALTY_FARE) if @touched_in
		@touched_in = true
  end

  def touch_out(station)
    @journey_log.ends(station)
		return deduct(PENALTY_FARE) unless @touched_in
  	deduct(MIN_FARE + @journey_log.zone_count.to_i) # <-----test
    @touched_in = false
	end

  def logs
    @journey_log.collect
  end

  private

  def touched_in?
    @touched_in
  end

  def deduct(amount)
  	@balance -= amount
  end

  def exceeds_balance(amount)
    (@balance + amount) > TOP_UP_LIMIT
  end
end
