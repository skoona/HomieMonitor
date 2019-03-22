# ##
# File: ./main/messaging_streams/stream.rb
#
#
# See:
#  ./main/homie/manager.rb
#  ./config/initializers/04-init_mqtt_modules.rb
# ##

# ##
# Homie MQTT Stream
# ##
# /homie/#
# /sknSensors/#
# end

# ##
# NQTT Spec: http://docs.oasis-open.org/mqtt/mqtt/v3.1.1/os/mqtt-v3.1.1-os.html
# QoS 0: At most once delivery
# QoS 1: At least once delivery
# QoS 2: Exactly once delivery


module Homie
  module Handlers

    # No client loops (write, read, misc) since we are in a thread or daemon mode; they're automatic
    class Stream
      attr_reader   :receive_queue, :send_queue, :debug_logger, :client

      def self.call()
        container = new()

        # Thread.abort_on_exception = false
        # Thread.report_on_exception = false
        # Thread.handle_interrupt(PahoMqtt::PacketFormatException => :never) {
        #   # PahoMqtt::PacketFormatException are ignored.
        # }

        tid = Thread.new do
          container.call()
        end

        at_exit do
          tid.terminate
        end

        SknSuccess.({tid: tid, container: container})
      end

      def initialize()
        @receive_queue   = SknApp.registry.resolve("stream_receive_queue")
        @send_queue      = SknApp.registry.resolve("stream_send_queue")
        @debug_logger    = SknApp.debug_logger
        @_config         = SknHash.new( {
                              host: Stream.host,
                              port: Stream.port,
                              persistent: true,
                              reconnect_limit: -1,
                              reconnect_delay: 10,
                              client_id: Stream.client_id,
                              username:  Stream.username,
                              password:  Stream.password,
                              ssl: Stream.ssl_enable
                           })
        if SknApp.debug or Stream.debug_log_file.present?
          PahoMqtt.logger  = Stream.debug_log_file
        end
        @debug_logger.debug "#{self.class.name}##{__method__}: Init to #{Stream.host}"
        true
      end

      def call

        sleep(10)

        @client = PahoMqtt::Client.new(@_config.to_hash)

        ### Set the encryption mode to True
        if Stream.ssl_enable and not Stream.ssl_certificate_path.blank?
          ### Configure the user SSL key and the certificate
          @client.config_ssl_context(Stream.ssl_certificate_path, Stream.ssl_key_path)
          debug_logger.debug "#{self.class.name}##{__method__}: SSL Certs Engaged: #{Stream.ssl_enable} "
        end

        client.on_message do |pck|
          # write to receive_q
          queue_message_push(pck)
          debug_logger.debug "Received(#{pck.id}): #{pck.topic} ~> #{pck.payload}" if Stream.debug_log_file.present?
        end

        @_wait_suback = true
        client.on_suback do
          @_wait_suback = false
          debug_logger.debug "#{self.class.name}##{__method__}: Subscribe Acknowledged"
        end

        @_wait_puback = true
        client.on_puback do
          @_wait_puback = false
          debug_logger.debug "#{self.class.name}##{__method__}: Publish Acknowledged"
        end

        client.on_connack do
          debug_logger.debug "#{self.class.name}##{__method__}: Successfully Connected"
        end

        client.connect(client.host, client.port, client.keep_alive, client.persistent, client.blocking)
        # client.connect

        client.subscribe( *Stream.base_topics )
        while @_wait_suback do
          sleep 0.001
        end

        handle_queue_receive

        debug_logger.debug "#{self.class.name}##{__method__}: Done!"
        true
      rescue => ex
        debug_logger.debug "#{self.class.name}##{__method__} Failure: klass=#{ex.class.name}, cause=#{ex.message}, Backtrace=#{ex.backtrace[0..8]}"
      ensure
        # @send_queue.clear
        # @send_queue.close
        # @receive_queue.clear
        # @receive_queue.close
        @client.disconnect if @client && @client.connection_state
        $stdout.puts "#{self.class.name} MQTT Listener Shutdown Complete!"
      end

      def handle_queue_receive
        loop do
          begin
            # read from send_q and publish
            if send_queue.length > 0
              queue_event = send_queue.pop
              queue_message_publish(queue_event) unless queue_event.nil?
            end
            sleep 0.1
          rescue => ex
            debug_logger.debug "#{self.class.name}##{__method__} Failure: klass=#{ex.class.name}, cause=#{ex.message}, Backtrace=#{ex.backtrace[0..8]}"
          end
        end
      end

      # ThreadError possible
      def queue_message_publish(queue_event)
        @_wait_puback = true
        client.publish(queue_event.topic.value, queue_event.value, queue_event.retain, queue_event.qos) # no-retain and atleast once
        while @_wait_puback do
          sleep 0.001
        end
        true
      rescue => ex
        debug_logger.debug "#{self.class.name}##{__method__} Failure: klass=#{ex.class.name}, cause=#{ex.message}, Backtrace=#{ex.backtrace[0..8]}"
        false
      end

      def queue_message_push(packet)
        if packet.topic.include?('$implementation/ota/firmware') # can't use firmware loads messages
          bytes = packet.payload.size
          packet.payload = "MessageBytes=#{bytes}"
        end
        receive_queue.push( Homie::Commands::QueueEvent.(packet) )
      end

    end # end class
  end
end

