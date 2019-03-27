# ##
# File: ./main/homie/manager.rb
#
#
# See:
#  ./main/messaging_streams/messaging_streams.rb
#
# Startup during application init
#     - SknApp.registry.resolve("device_stream_handler").call()
#
# Collect data catalog for display via
#     - success_obj = SknApp.registry.resolve("device_stream_handler").catalog
#     - success_obj.payload.devices => big array of hashes
#     - success_obj.payload.broadcasts => big array of hashes
#

module Homie
  module Providers

    class Manager
      include Singleton
      attr_reader   :debug_logger

      def initialize(opts={})
        @_stream = establish_stream
        @_stream_tid           = @_stream.tid
        @_stream_receive_queue = SknApp.registry.resolve("stream_receive_queue")
        @_stream_send_queue    = SknApp.registry.resolve("stream_send_queue")
        @_subscriptions_provider = SknApp.registry.resolve("subscriptions_provider")
        @_data_source          = SknApp.registry.resolve("data_source")
        @_devices              = load_device_inventory
        @_broadcasts           = []
        @_subscriptions        = []
        @debug_logger          = SknApp.debug_logger
        @debug_logger.debug "#{self.class.name}##{__method__}: Init with Stream ThreadID: #{@_stream_tid}"
        true
      end

      def content_devices
        SknSuccess.( package: @_devices.map(&:to_hash) )
      end
      def content_broadcasts
        SknSuccess.( package: @_broadcasts.map {|bc| bc.success ? {name: bc.message, value: bc.value} : nil }.compact )
      end
      def content_subscriptions
        SknSuccess.( package: @_subscriptions.map(&:to_hash) )
      end

      def send_queue_event(queue_event)
        if @_stream_send_queue&.closed?
          false
        else
          @_stream_send_queue.push( queue_event )
          true
        end
      end

      def call
        tid = Thread.new do
          loop do
            msg = new_message
            if msg && actions_router(msg)
              create_device(msg) unless !!read_queue_dispatcher(msg)
              debug_logger.debug "StreamState:#{stream_active?}, SendQueue:#{@_stream_send_queue.length}, ReceiveQueue:#{@_stream_receive_queue.length}, Device Count: #{@_devices.size}, PacketID: #{msg.id}"
            end
            sleep 0.06
          end
        end
        at_exit do
          $stdout.puts "#{self.class.name} MQTT Manager Shutdown Complete!"
          tid.terminate
        end
        tid
      end

      def read_queue_dispatcher(queue_event)
        @_devices.detect do |device|
          device.handle_queue_event?(queue_event)
        end
      end

      def create_device(queue_event)
        if queue_event.device_create?   # Filter out of sequence messages
          @_devices.push( Homie::Components::Device.new(queue_event) )
        end
      end

      def stream_active?
        instance_variable_defined?(:@_stream_tid) ? @_stream_tid.alive? : false
      end

      def establish_stream
        unless stream_active?
          @_stream = SknApp.registry.resolve("device_stream_listener").call().payload;
        end
      end

      def new_message
        @_stream_receive_queue.size > 0 ? @_stream_receive_queue.pop : nil
      end

      def devices
        @_devices
      end

      def broadcasts
        @_broadcasts
      end

      def subscriptions
        @_subscriptions
      end

      # add more conditions of interest
      def actions_router(queue_event)
        if queue_event.broadcast?
          record_broadcasts(queue_event)
          false # skip broadcasts -- or cause a loop error
        elsif queue_event.ota_loading?
          false # skip ota inprogress counter
        elsif queue_event.schedule_related?
          handle_subscription_queue_event(queue_event)
          true   # Allow dispatch
        else
          save_device_inventory(@_devices) if (queue_event.id % 120 == 0)
          true   # Allow dispatch
        end
      end

      def broadcast_exist?(event)
        @_broadcasts.any? do |bc|
          bc.message.eql?(event.broadcast_key) && bc.value.eql?(event.value)
        end
      end

      # make SknSuccess.(value,message|topic)
      def record_broadcasts(event)  # reconnects cause dups
        @_broadcasts.push(event.homie_broadcast) unless !!broadcast_exist?(event)
      end

      def handle_subscription_queue_event(queue_event)
        @_subscriptions_provider.handle_queue_event?(queue_event)
      end

      def load_subscriptions
        @_subscriptions = @_subscriptions_provider.subscriptions_restore
      end

      def load_device_inventory
        return [] if SknApp.env.test?
        @_data_source.transaction { @_data_source.fetch(:devices, []) }
      end
      def save_device_inventory(ary)
        @_data_source.transaction { @_data_source[:devices] = ary }
      end
    end
  end
end