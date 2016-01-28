require 'journey'
class JourneyLog

  attr_reader :journey_klass, :log

  def initialize(journey_klass=Journey)
    @journey_klass = journey_klass
    @log = []
  end

  def start_journey(entry_station)
    @journey = journey_klass.new
    @journey.start_journey(entry_station)
  end

  def journey_status
    current_journey
  end

  def exit_journey(exit_station)
    @journey = current_journey
    @journey.end_journey(exit_station)
  end

  private
  def current_journey
    @journey ||= journey_klass.new
  end

end
