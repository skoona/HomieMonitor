
describe Homie::Component::Attribute, 'Node Property Attributes and Device Attributes. ' do
  include QueueMessages

  let(:queue_node_property) {
        generate_queue_event(node_property)
  }
  let(:queue_node_property2) {
    generate_queue_event(node_property2)
  }
  let(:queue_node_attribute) {
        generate_queue_event(node_attribute)
  }
  let(:queue_node_property_attribute) {
        generate_queue_event(node_property_attribute)
  }
  let(:queue_device_stats_property) {
    generate_queue_event(device_stats_property) # "sknSensors/TheaterIR/$stats/signal"
  }
  let(:queue_device_implementation_property) {
    generate_queue_event(device_implementation_property)
  }
  let(:queue_device_attribute) {
    generate_queue_event(device_attribute) # "sknSensors/TheaterIR/$stats"
  }
  let(:queue_device_attribute2) {
    generate_queue_event(device_attribute2)
  }
  let(:queue_homie_broadcast) {
    generate_queue_event(homie_broadcast)
  }

  let(:prop_node_property)  { described_class.( queue_node_property ) }
  let(:attr_device_attribute) { described_class.(queue_device_attribute) } # "sknSensors/TheaterIR/$stats"

  context "Initialization" do
    it '#new fails without param. ' do
      expect{ described_class.new }.to raise_error(ArgumentError)
    end
    it 'self#call fails without param. ' do
      expect{ described_class.call }.to raise_error(ArgumentError)
    end
    it 'self#call fails with  invalid param. ' do
      expect{ described_class.call( queue_node_property ) }.to raise_error(ArgumentError)
    end
    it '#new succeeds with valid param. ' do
      expect( described_class.new( queue_device_attribute ) ).to be
    end
    it 'self#call succeeds with valid param. ' do
      expect( described_class.( queue_device_attribute ) ).to be
    end
  end

  context "Determine type of message " do
    # "sknSensors/TheaterIR/$stats" ~> "sknSensors/TheaterIR/$stats/signal"
    it '#handle_queue_event? returns expected value' do
      expect( attr_device_attribute.handle_queue_event?(queue_device_stats_property) ).to be true
      expect( attr_device_attribute.handle_queue_event?(queue_device_stats_property) ).to be true
      expect( attr_device_attribute.handle_queue_event?(queue_device_attribute2) ).to be true
      expect( attr_device_attribute.handle_queue_event?(queue_device_implementation_property) ).to be false
      expect( attr_device_attribute.name ).to eq("$stats")
    end
    it "Adds Property to existing Attribute. " do
      expect( attr_device_attribute.to_hash[:properties].size ).to eq(0)
      expect( attr_device_attribute.handle_queue_event?(queue_device_stats_property) ).to be true
      expect( attr_device_attribute.to_hash[:properties].size ).to eq(1)
      expect( attr_device_attribute.handle_queue_event?(queue_device_stats_property) ).to be true
      expect( attr_device_attribute.to_hash[:properties].size ).to eq(1)
    end

    # "sknSensors/TheaterIR/$stats"
    # "sknSensors/TheaterIR/$stats/signal"
    # "sknSensors/TheaterIR/$fw/name",
    # "sknSensors/TheaterIR/$fw/version",
    # "sknSensors/TheaterIR/$implementation"
    # "sknSensors/TheaterIR/$implementation/version"
    #
    it "Handles $stats, $fw, and $implementation Properties as expected. " do
      expect( attr_device_attribute.to_hash[:properties].size ).to eq(0)
      expect( attr_device_attribute.handle_queue_event?(queue_device_stats_property) ).to be true
      expect( attr_device_attribute.to_hash[:properties].size ).to eq(1)
      expect( attr_device_attribute.handle_queue_event?(queue_device_stats_property) ).to be true
      expect( attr_device_attribute.to_hash[:properties].size ).to eq(1)
    end


    it "Update its value to last message. " do
      expect( attr_device_attribute.value ).to eq("uptime")
      expect( attr_device_attribute.handle_queue_event?(queue_device_attribute2) ).to be true
      expect( attr_device_attribute.value ).to eq("ready")
      expect( attr_device_attribute.handle_queue_event?(queue_device_attribute) ).to be true
      expect( attr_device_attribute.value ).to eq("uptime")
    end
  end

end