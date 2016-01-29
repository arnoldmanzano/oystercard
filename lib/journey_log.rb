require_relative 'journey'
require_relative 'station'

class JourneyLog

  attr_reader :journey_klass, :journeys

  def initialize(journey_klass=Journey)
    @journey_klass = journey_klass
    @history = []
  end

  def start_journey(entry_station)
    create_record
    #outstanding_charges if @journey
    @journey = journey_klass.new
    @journey.start_journey(entry_station)
  end

  def create_record
    @history << @journey if @journey
  end

  def journey_status
    current_journey
  end

  def exit_journey(exit_station)
    @journey = current_journey
    @journey.end_journey(exit_station)
    create_record
    @journey = nil
  end

  def outstanding_charges
    @journey.fare
  end

  def journeys
    @history.dup
  end

  private
  def current_journey
    @journey ||= journey_klass.new
  end

end
