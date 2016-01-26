class Journey
  attr_reader :history, :trip

  def initialize
    @trip = {start: nil, end: nil}
    @history = []
  end

  def start(station)
    @trip[:start] = station
  end

  def end(station)
    @trip[:end] = station
		@history << @trip
  end

  def started?
  !!@trip[:start]
  end

  def ended?
  !!@trip[:end]
  end
end
