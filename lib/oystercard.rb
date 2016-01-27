require_relative 'station'

class Oystercard

  attr_reader :balance, :entry_station, :exit_station, :journey_list
  BALANCE_MAX = 90
  FARE_MIN = 1

  def initialize
    @balance = 0
    # @entry_station = nil
    # @exit_station = nil
    # @journey_list = {}
  end

  def top_up(value)
    max_balance = BALANCE_MAX
    raise 'Top-up exceeds maximum limit of #{max_balance}' if @balance + value > BALANCE_MAX
    @balance += value
  end

  # def touch_in(entry_station)
  #   raise 'Please top up your card.' if @balance < FARE_MIN
  #   @entry_station = entry_station
  # end

  # def touch_out(exit_station)
  #   deduct(FARE_MIN)
  #   @journey_list[@entry_station] = exit_station
  #   @exit_station = exit_station
  # end

  private

  def deduct(value)
    @balance -= value
  end

end
