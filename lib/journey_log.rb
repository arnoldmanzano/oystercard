require_relative 'journey'
require_relative 'station'
require 'forwardable'

class JourneyLog

  attr_reader :journey_klass, :journeys, :journey

  extend Forwardable
  delegate [:fare, :in_progress?] => :@journey

  def initialize(journey_klass: Journey)
    @journey_klass = journey_klass
    @history = []
    @journey = journey_klass.new
  end

  def start_journey(entry_station)
    # exit_journey(nil) if @journey.in_progress?
    @journey = journey_klass.new
    @journey.start_journey(entry_station)
  end

  def exit_journey(exit_station)
    # start_journey(nil) unless @journey.in_progress?
    @journey.end_journey(exit_station)
    @history << @journey
  end

  def journeys
    @history.dup
  end

end
