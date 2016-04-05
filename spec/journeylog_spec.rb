require "journeylog"

describe JourneyLog do
	#check incomplete journey history edge cases


	let(:station) {double(:station)}
	let(:journey_class) {double(:journey_class, new: journey)}
	let(:journey) {double(:journey, :starts => nil, :ends => nil, :in_progress? => false, :counts_zone => 0)}
 	subject(:journey_log) { described_class.new(journey_class: journey_class) }

	it "calls start on log" do
		expect(journey).to receive(:starts)
		journey_log.starts(station)
	end

	it "calls ends on log" do
		expect(journey).to receive(:ends)
		journey_log.ends(station)
	end

	it "starts with empty collection" do
		expect(journey_log.collect).to be_empty
	end

	it "stores a journey log" do
		journey_log.starts(station)
		journey_log.ends(station)
		expect(journey_log.collect).to include(journey)
	end

	# describe "edge cases" do
	# 	it "closes journey after touch out only" do
	# 		journey_log.ends(station)
	# 		expect(journey_log.collect).to include(journey)
	# 	end
	# end
end

describe JourneyLog do

	it "completes a legal journey log" do
		journey_log = JourneyLog.new
		journey_log.starts("Wimbledon", 4)
		journey_log.ends("Aldgate East", 3)
		expect(journey_log.collect.first.log).to eq({entry_station: "Wimbledon", exit_station: "Aldgate East"})
	end

	it "completes a single touch out journey log" do
		journey_log = JourneyLog.new
		journey_log.ends("Oxford Circus", 1)
		expect(journey_log.collect.first.log).to eq({exit_station: "Oxford Circus"})
	end

	it "completes a double touch in journey log" do
		journey_log = JourneyLog.new
		journey_log.starts("Balham", 3)
		journey_log.starts("Clapham", 2)
		expect(journey_log.collect.first.log).to eq({entry_station: "Balham"})
	end

	it "completes a touch out journey log after legal journey" do
		journey_log = JourneyLog.new
		journey_log.starts("Wimbledon", 4)
		journey_log.ends("Aldgate East", 3)
		journey_log.ends("Oxford Circus", 1)
		expect(journey_log.collect.last.log).to eq({exit_station: "Oxford Circus"})
	end
end