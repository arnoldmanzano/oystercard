require 'station'

describe Station do
  subject{described_class.new("Highgate", 3)}

  it 'initialized name parameter' do
    expect(subject.name).to eq("Highgate")
  end

  it 'initialized zone parameter' do
    expect(subject.zone).to eq(3)
  end
end
