
describe Homie::Components::Property, 'Node Properties and Device Stats Properies. ' do
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
    generate_queue_event(device_stats_property)
  }
  let(:queue_device_attribute) {
    generate_queue_event(device_attribute)
  }

  let(:prop_node_property)  { described_class.( queue_node_property ) }
  let(:prop_node_attribute) { described_class.(queue_node_attribute) }

  context "Initialization" do
    it '#new fails without param. ' do
      expect{ described_class.new }.to raise_error(ArgumentError)
    end
    it 'self#call fails without param. ' do
      expect{ described_class.call }.to raise_error(ArgumentError)
    end
    it 'self#call fails with  invalid param. ' do
      expect{ described_class.call( queue_device_attribute ) }.to raise_error(ArgumentError)
    end
    it '#new succeeds with valid param. ' do
      expect( described_class.new( queue_node_property ) ).to be
    end
    it 'self#call succeeds with valid param. ' do
      expect( described_class.( queue_node_property ) ).to be
    end
  end

  context "Determine type of message " do
    # "sknSensors/TheaterIR/irservice/command"
    it '#handle_queue_event? returns expected value' do
      expect( prop_node_property.handle_queue_event?(queue_node_property) ).to be true
      expect( prop_node_property.handle_queue_event?(queue_node_property_attribute) ).to be true
      expect( prop_node_property.handle_queue_event?(queue_node_attribute) ).to be false
      expect( prop_node_property.handle_queue_event?(queue_device_stats_property) ).to be false
      expect( prop_node_property.name ).to eq("command")
    end

    # "sknSensors/TheaterIR/irservice/command" < "sknSensors/TheaterIR/irservice/command/$type"
    it "Adds Attribute to existing Property. " do
      expect( prop_node_property.to_hash[:attributes].size ).to eq(0)
      expect( prop_node_property.handle_queue_event?(queue_node_property_attribute) ).to be true
      expect( prop_node_property.to_hash[:attributes].size ).to eq(1)
      expect( prop_node_property.handle_queue_event?(queue_node_property_attribute) ).to be true
      expect( prop_node_property.to_hash[:attributes].size ).to eq(1)
    end
    it "Update its value to last message. " do
      expect( prop_node_property.value ).to eq("on")
      expect( prop_node_property.handle_queue_event?(queue_node_property2) ).to be true
      expect( prop_node_property.value ).to eq("off")
    end
  end

  context "Property Parsing Operation" do
    it '#device returns expected value' do
      expect( generate_queue_event(device_attribute).device_name_abs.success ).to be true
      expect( generate_queue_event(node_attribute).device_name.success ).to be false
    end
    it '#device_attribute returns expected value' do
      expect( generate_queue_event(device_attribute).device_attribute.success ).to be true
      expect( generate_queue_event(node_attribute).device_attribute.success ).to be false
    end
    it '#device_stats_property returns expected value' do
      expect( generate_queue_event(device_stats_property).device_attribute_property.success ).to be true
      expect( generate_queue_event(device_attribute2).device_attribute_property.success ).to be false
    end
    it '#device_firmware_property returns expected value' do
      expect( generate_queue_event(device_firmware_property).device_attribute_property.success ).to be true
      expect( generate_queue_event(device_attribute).device_attribute_property.success ).to be false
    end
    # "sknSensors/TheaterIR/$implementation" || "sknSensors/TheaterIR/$implementation/version"{2}
    it '#device_attribute_property returns expected value' do
      expect( generate_queue_event(device_implementation_property2).device_attribute_property.success ).to be true
      expect( generate_queue_event(device_implementation_property).device_attribute_property.success ).to be false
    end
  end

end