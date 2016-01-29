require_relative 'station'
require_relative 'journey'
require_relative 'journey_log'

class Oystercard

  MAXIMUM_BALANCE = 90
  MINIMUM_FARE = 1

 attr_reader :balance

  def initialize(journey_log_klass: JourneyLog)
    @balance = 0
    @journey_log = journey_log_klass.new
  end

  def top_up amount
    fail "Balance has exceeded limit of #{MAXIMUM_BALANCE}" if amount + balance > MAXIMUM_BALANCE
    @balance += amount
  end

  # def touch_in(entry_station)
  #   fail "Insufficient funds" if balance < MINIMUM_FARE
  #   deduct(@journey_log.fare) if @journey_log.in_progress?
  #   @journey_log.start_journey(entry_station)
  # end
  #
  # def touch_out(exit_station)
  #   @journey_log.exit_journey(exit_station)
  #   deduct(@journey_log.fare)
  #   # @journey_log.reset
  # end

  def touch_in(entry_station)
    fail "Insufficient funds" if balance < MINIMUM_FARE
    touch_out(nil) if @journey_log.in_progress?
    @journey_log.start_journey(entry_station)
  end

  def touch_out(exit_station)
    touch_in(nil) unless @journey_log.in_progress?
    @journey_log.exit_journey(exit_station)
    deduct(@journey_log.fare)
  end

#TODO write a separate method to check minimum balance


  private
  def deduct(amount)
    @balance -= amount
  end
end
