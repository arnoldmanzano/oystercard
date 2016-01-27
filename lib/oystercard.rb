#require_relative 'station'
class Oystercard

  MAXIMUM_BALANCE = 90
  MINIMUM_BALANCE = 1
  MINIMUM_CHARGE = 1

 attr_reader :balance, :entry_station, :history, :exit_station, :journey

  def initialize
    @balance = 0
    @history = []
    @journey = Hash.new
  end

  def top_up amount
    fail "Balance has exceeded limit of #{MAXIMUM_BALANCE}" if amount + balance > MAXIMUM_BALANCE
    @balance += amount
  end

   def in_journey?
     !!entry_station
   end

  def touch_in(station)
    fail "Insufficient funds" if balance < MINIMUM_BALANCE
    @entry_station = true
    @journey[:entry_station] = station
    
  end

  def touch_out(station)
    @entry_station = nil
    deduct MINIMUM_CHARGE
    @journey[:exit_station] = station
    @history << @journey
  end

  private
  def deduct amount
    @balance -= amount
  end

end
