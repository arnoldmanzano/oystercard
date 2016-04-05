require 'journey'

describe Journey do
	subject(:journey) {described_class.new}
	let(:station) {double (:station)}

 context "in_journey?" do

  	it 'start of journey in_progress? is false' do
  		expect(journey).not_to be_in_progress
  	end

  	it 'touch in changes in_progress? to true' do
  		journey.starts(station)
  		expect(journey).to be_in_progress
  	end

  	it 'touch out changes in_progress? to false' do
  		expect(journey).not_to be_in_progress
  	end
  end
end
