
describe Homie::Commands::QueueEvent,  'Contains MQTT/Queue Messages' do
  include QueueMessages

  context "Initialization" do
    it '#new fails without param. ' do
      expect{ described_class.new }.to raise_error(ArgumentError)
    end
    it 'self#call fails without param. ' do
      expect{ described_class.call }.to raise_error(ArgumentError)
    end
    it '#new succeeds with valid param. ' do
      expect( described_class.new(homie_broadcast) ).to be
    end
    it 'self#call succeeds with valid param. ' do
      expect( described_class.(homie_broadcast) ).to be
    end
  end

  context "Determine type of message " do
    it '#id returns expected value' do
      expect( generate_queue_event(device_attribute).id.to_i ).to eq(device_attribute.id)
      expect( generate_queue_event(node_attribute).id.to_i ).to eq(node_attribute.id)
    end
    it '#homie_base returns expected value' do
      expect( generate_queue_event(device_attribute).homie_base ).to eq("sknSensors")
      expect( generate_queue_event(node_attribute).homie_base ).to eq("sknSensors")
    end
    it '#device_attribute returns expected value' do
      expect( generate_queue_event(node_attribute).device_attribute.success ).to be false
      expect( generate_queue_event(device_attribute).device_attribute.success ).to be true
    end
    it '#node_attribute returns expected value' do
      expect( generate_queue_event(node_attribute).node_attribute.success ).to be true
      expect( generate_queue_event(device_attribute).node_attribute.success ).to be false
    end
    it '#topic returns proper value ' do
      expect( generate_queue_event(device_attribute).topic.value ).to eq(device_attribute.topic)
      expect( generate_queue_event(homie_broadcast).topic.value ).to eq(homie_broadcast.topic)
    end
    it '#broadcast? returns proper value' do
      expect( generate_queue_event(homie_broadcast).broadcast? ).to be true
      expect( generate_queue_event(device_attribute).broadcast? ).to be false
    end
    it '#type_device? returns proper value' do
      expect( generate_queue_event(device_attribute).type_device? ).to be true
      expect( generate_queue_event(node_attribute).type_device? ).to be false
    end
    it '#type_node? returns proper value' do
      expect( generate_queue_event(device_attribute).type_node? ).to be false
      expect( generate_queue_event(node_attribute).type_node? ).to be true
    end
  end

  context "Device Stream Parsing" do
    it '#device_attribute returns expected value' do
      expect( generate_queue_event(device_attribute).device_attribute.success ).to be true
      expect( generate_queue_event(node_attribute).device_attribute.success ).to be false
    end
    it '#device_attribute_property returns expected value:stats' do
      expect( generate_queue_event(device_stats_property).device_attribute_property.success ).to be true
      expect( generate_queue_event(node_attribute).device_attribute_property.success ).to be false
    end
    it '#device_attribute_property returns expected valuefirmware' do
      expect( generate_queue_event(device_firmware_property).device_attribute_property.success ).to be true
      expect( generate_queue_event(device_attribute).device_attribute_property.success ).to be false
    end
    it '#device_attribute_property returns expected value:implementation' do
      expect( generate_queue_event(device_implementation_property2).device_attribute_property.success ).to be true
      expect( generate_queue_event(device_implementation_property).device_attribute_property.success ).to be false
    end
    it '#device_attribute_property_all returns expected value' do
      expect( generate_queue_event(device_implementation_property).device_attribute_property_all.success ).to be false
      expect( generate_queue_event(device_implementation_property2).device_attribute_property_all.success ).to be true
    end
  end

  context "Node Stream Parsing" do
    it '#node_attribute returns expected value' do
      expect( generate_queue_event(node_attribute).node_attribute.success ).to be true
      expect( generate_queue_event(node_property_attribute).node_attribute.success ).to be false
      expect( generate_queue_event(node_property_attribute).node_attribute.success ).to be false
    end
    it '#node_property returns expected value' do
      expect( generate_queue_event(node_property).node_property.success ).to be true
      expect( generate_queue_event(node_attribute).node_property.success ).to be false
    end
    it '#node_property_attribute returns expected value' do
      expect( generate_queue_event(node_property_attribute).node_property_attribute.success ).to be true
      expect( generate_queue_event(node_property_attribute).node_property.success ).to be true
      expect( generate_queue_event(node_property).node_property_attribute.success ).to be false
    end
    it '#node_set_property returns expected value' do
      expect( generate_queue_event(node_property_set).node_set_property.success ).to be true
      expect( generate_queue_event(node_property_settable_attribute).node_set_property.success ).to be false
    end
  end

end