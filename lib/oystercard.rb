require_relative 'station'
require_relative 'journey'
class Oystercard

  MAXIMUM_BALANCE = 90
  MINIMUM_BALANCE = 1

 attr_reader :balance, :entry_station, :history, :exit_station, :journey

  def initialize
    @balance = 0
    @history = []
  end

  def top_up amount
    fail "Balance has exceeded limit of #{MAXIMUM_BALANCE}" if amount + balance > MAXIMUM_BALANCE
    @balance += amount
  end

   def in_journey?
     !!entry_station
   end

  def touch_in(entry_station)
    fail "Insufficient funds" if balance < MINIMUM_BALANCE
    @journey = Journey.new
    @journey.start_journey entry_station
    @history << @journey.journey_details
  end

  def touch_out(exit_station)
    @journey = Journey.new if @journey == nil
    @journey.end_journey exit_station
    deduct(@journey.fare)
  end

  private

  def deduct(amount)
    @balance -= amount
  end

end
