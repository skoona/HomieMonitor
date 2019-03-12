# ##
# services_registry_spec.rb

describe Services::ServicesRegistry, 'Service Registry Module. ' do
  let(:package) {
    {
        roda_context: double(:roda,
                             request: double(:request, params: {"id" => "1.0.1", 'content_type' => 'Commission'})
        )
    }
  }
  before :each do
    allow(SknApp.registry).to receive(:resolve).with("content_provider").and_return( double(:response, call: SknSuccess.call( rd_content_response() )) )
  end

  it '#content returns expected object. ' do
    expect( described_class.new(package).content_devices ).to be_a SknSuccess
  end
end