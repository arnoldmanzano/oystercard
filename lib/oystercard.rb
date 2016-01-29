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
    @station_list = create_station_list
  end

  def top_up amount
    fail "Balance has exceeded limit of #{MAXIMUM_BALANCE}" if amount + balance > MAXIMUM_BALANCE
    @balance += amount
  end

  def touch_in(entry_station)
    fail "Insufficient funds" if balance < MINIMUM_FARE
    touch_out(nil) if @journey_log.in_progress?
    @journey_log.start_journey(retrieve(entry_station))
  end

  def touch_out(exit_station)
    touch_in(nil) unless @journey_log.in_progress?
    @journey_log.exit_journey(retrieve(exit_station))
    deduct(@journey_log.fare)
  end

  def journeys
    @journey_log.journeys
  end

  private
  def deduct(amount)
    @balance -= amount
  end

  def retrieve(station)
    @station_list.select{|s| s.name == station }[0]
  end

  def create_station_list
    lines = File.readlines("./doc/station_lib.txt")
    station_list = []

    lines.each do |line|
      line.chomp!
      line.gsub!(' ','')
      content = line.split(',')
      new_station = Station.new(content[0], content[1].to_i)
      station_list << new_station
    end
    station_list
  end
end
