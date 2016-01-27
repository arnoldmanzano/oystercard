require_relative 'station'
require_relative 'journey'

class Oystercard

  attr_reader :balance, :entry_station, :exit_station, :journey_list, :journey
  BALANCE_MAX = 90
  FARE_MIN = 1
  PENALTY_FARE = 6

  def initialize(journey = Journey.new)
    @balance = 0
    @journey = journey
  end

  def top_up(value)
    max_balance = BALANCE_MAX
    raise "Top-up exceeds maximum limit of #{max_balance}" if @balance + value > BALANCE_MAX
    @balance += value
  end

  def touch_in(entry_station)
    raise 'Please top up your card.' if @balance < FARE_MIN
    touch_out(nil) if @journey.in_journey?
    @journey.start(entry_station)
  end

  def touch_out(exit_station)
    touch_in(nil) if !@journey.in_journey?
    @journey.end(exit_station)
    deduct(fare)
    @journey.reset
  end

  def fare
    if @journey.complete?
      FARE_MIN
    else
      PENALTY_FARE
    end
  end

  def double_touch_in
    @journey.in_journey?
  end

  private

  def deduct(value)
    @balance -= value
  end
end
