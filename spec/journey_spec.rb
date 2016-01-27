require 'journey'
describe Journey do
subject(:journey) {described_class.new}
  let (:entry_station) {double(:entry_station)}
  let (:exit_station) {double(:exit_station)}
describe '#start_journey' do


    it 'starts a journey' do
        subject.start_journey(entry_station)
        expect(subject.journey_details).to include(:entry_station => entry_station, :exit_station=> nil)
      end
    end

    describe '#end_journey' do


        it 'ends a journey' do
            subject.start_journey(entry_station)
            subject.end_journey(exit_station)
            expect(subject.journey_details).to include(:entry_station => entry_station, :exit_station=> exit_station)
          end
        end




end
