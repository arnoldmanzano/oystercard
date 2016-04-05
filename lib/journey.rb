class Journey
	attr_reader :log

	def initialize
		@log = {}
	end

  def in_progress?
  	@log.has_key?(:entry_station) && !@log.has_key?(:exit_station)
  end

  def starts(station)
  	@log[:entry_station] = station
  end

  def ends(station)
  	@log[:exit_station] = station
  end

  def counts_zones #<-----test entire function
  ((@log[:entry_station]).zone - (@log[:exit_station]).zone).abs
  end

  def complete?
  	@log.has_key?(:entry_station) && @log.has_key?(:exit_station)
  end

end
