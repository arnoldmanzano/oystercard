require_relative 'station'
require_relative 'oystercard'

class Journey

attr_reader :entry_station, :exit_station, :journey_list

def initialize
  @entry_station = nil
  @exit_station = nil
  @journey_list = {}
end

  def in_journey?
    !!@entry_station
  end

  def start(entry_station)
    @entry_station = entry_station
  end

  def end(exit_station)
    @journey_list[@entry_station] = exit_station
    @exit_station = exit_station
  end

  def complete?
    !!@entry_station && !!@exit_station
  end

  def reset
    @entry_station = nil
    @exit_station = nil
  end

end
