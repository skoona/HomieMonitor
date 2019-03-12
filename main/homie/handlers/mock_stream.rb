
# Used for Tests and local demo without MQTT
require("./spec/support/test_data_serializers.rb")

module Homie
  module Handlers

    class MockStream
      attr_reader   :receive_queue, :send_queue, :log, :client
      include TestDataSerializers

      def self.call()
        container = new()
        container.call
        SknSuccess.({tid: -1, container: container})
      end

      def initialize()
        @receive_queue   = SknApp.registry.resolve("stream_receive_queue")
        @send_queue      = SknApp.registry.resolve("stream_send_queue")
        @_discovery      = restore_test_data("homie.discovery.queue.records")
        @_events         = restore_test_data("homie.events.queue.records")
        # @_discovery      = device_stream_discovery
        # @_events         = device_stream_events
        # write_test_data @_discovery, "homie.discovery.queue.records"
        # write_test_data @_events, "homie.events.queue.records"
      end

      def call(with_events=true)
        receive_queue.clear
        @_discovery.each {|pkt| receive_queue.push(pkt); sleep 0.001 }
        @_events.each {|pkt| receive_queue.push(pkt); sleep 0.001 } if with_events
        true
      end

      def device_stream_discovery
        accum = []
        IO.read("./spec/factories/homie_device_streams.txt").each_line do |line|
          accum.push line.strip.split(" ",2)
        end
        gen_id = 0
        accum.map do |packet|
          gen_id += 1
          Homie::Commands::QueueEvent.new(
              SknHash.new({
                              id: gen_id,
                              topic: packet.first,
                              payload: packet.last
                          }) )
        end
      end

      def device_stream_events
        accum = []
        IO.read("./spec/factories/homie_stream_events.txt").each_line do |line|
          accum.push line.strip.split(" ",2)
        end
        gen_id = 199
        accum.map do |packet|
          gen_id += 1
          Homie::Commands::QueueEvent.new(
              SknHash.new({
                              id: gen_id,
                              topic: packet.first,
                              payload: packet.last
                          })
          )
        end
      end
    end

  end
end