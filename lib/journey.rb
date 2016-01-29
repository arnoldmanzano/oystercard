class Journey


  MINIMUM_FARE = 1
  PENALTY_FARE = 6

  attr_reader :entry_station, :exit_station

  def initialize
    @entry_station = nil
    @exit_station = nil
    @cost = nil
  end

  def start_journey(entry_station)
    @entry_station = entry_station
  end

  def end_journey(exit_station)
    @exit_station = exit_station
  end

  def fare
    @cost = (complete? ? fare_calc : PENALTY_FARE)
  end

  def complete?
    @entry_station && @exit_station
  end

  def in_progress?
    @entry_station && !@exit_station
  end

  private
  def fare_calc
    MINIMUM_FARE + (@entry_station.zone - @exit_station.zone).abs
  end
end
