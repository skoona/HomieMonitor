
describe Homie::Manager,  'Homie Discovery Provider. ' do
  include QueueMessages

  SknApp.registry
      .stub("device_stream_listener", ->() { Homie::Handlers::MockStream.call() })

  before :all do
    SknApp.registry.resolve("device_stream_manager").call
    sleep 15
    @manager = SknApp.registry.resolve("device_stream_manager")
  end

  context "Discovery Outcome " do
    it 'Two devices discovered. ' do
      expect( @manager.devices.size ).to eq 3
    end
    it 'Two broadcast discovered. ' do
      expect( @manager.broadcasts.size ).to eq 2
    end
    it '#to_hash renders the entire inventory. ' do
      out_hash = @manager.devices.map(&:to_hash)
      expect( out_hash.first ).to be_a(Hash)
      pp out_hash
    end
    it 'Discovers Proper Inventory. ' do
      devices = @manager.devices
      ncount = 0
      devices.each do |device|
        puts "Device: #{device.name}:#{device.value} \tNodes ~> #{device.nodes.size}"
        device.attributes.each do |datr|
          puts "\t(A) #{datr.name}:#{datr.value} \tProperties: #{datr.properties.size}"
          datr.properties.each do |property|
            puts "\t\t(P) #{property.name}:#{property.value} "
          end
        end
        device.nodes.each do |node|
          ncount += 1
          puts "\tNode: #{node.name}:#{node.value} \tProperties: #{node.properties.size}"
          node.attributes.each do |datr|
            puts "\t\t(A) #{datr.name}:#{datr.value} "
          end
          node.properties.each do |datr|
            puts "\t\t(P) #{datr.name}:#{datr.value} \tAttributes: #{datr.attributes.count}"
            datr.attributes.each do |patr|
              puts "\t\t\t(A) #{patr.name}:#{patr.value} "
            end
          end
        end
      end
      expect( devices.size ).to eq 3
      expect( ncount ).to eq 5
    end
  end

end
