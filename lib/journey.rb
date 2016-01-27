class Journey
attr_reader :journey_details
def initialize
  @journey_details = {:entry_station => nil, :exit_station => nil}

end

def start_journey(entry_station)
  @journey_details[:entry_station] = entry_station

end

def end_journey(exit_station)
@journey_details[:exit_station] = exit_station
end
end
