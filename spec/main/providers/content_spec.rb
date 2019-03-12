# ##
# content_spec.rb

class HomieBroadcasts

  attr_reader :collection, :device_name

  def initialize()
    @collection  = "broadcasts"
    @device_name = nil
  end

  def valid?
    false
  end

end

describe Services::Providers::Content, 'Resource Content Providers' do
  let(:cmd) { Services::Commands::HomieDevices.new }
  let(:cmd_wrong) { HomieBroadcasts.new() }

  it 'Returns Success object. ' do
    skn = double(:response, call: SknSuccess.call( rd_content_response() ))
    expect(described_class.call(cmd).success).to be true
  end

  it 'Returns Failure object caused by unknown/invalid command. ' do
    expect(described_class.call(cmd_wrong).success).to be false
  end
end