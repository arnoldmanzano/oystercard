require_relative 'journey'

class JourneyLog

	attr_reader :zone_count

	def initialize(journey_class: Journey)
		@journey_class = journey_class
		@collection = []
		@journey = @journey_class.new
	end

	def starts(station)
		@collection << @journey if @journey.in_progress?
		@journey = @journey_class.new
		@journey.starts(station)
	end

	def ends(station)
		@journey = @journey_class.new unless @journey.in_progress?
		@journey.ends(station)
		@zone_count = @journey.counts_zones if @journey.complete? #<------test
		@collection << @journey
	end

	def collect
		@collection.dup
	end
end