# ##
#
# Handle Delete Device
# Services::Handlers::DeleteDevice
# - Clear Retained Messages om MQTT
#
#

module Services
  module Handlers

    class DeleteDevice

      attr_reader :device

      def self.call(device_name)
        self.new.call(device_name)
      end

      def initialize()
        @_stream_manager = SknApp.registry.resolve("device_stream_manager")
        @device = nil
        SknApp.logger.debug "#{self.class.name}.#{__method__}"
        @_count = 0
      end

      def call(device_name)
        purge_topics( generate_topics_for(device_name) )
        resp = remove_device(device)

        msg = "#{self.class.name}##{__method__} Processed(#{device_name}:#{resp})"
        SknApp.logger.debug msg
        SknSuccess.call({success: resp,
                         status: 200,
                         message: "",
                         error: "",
                         payload: {count: @_count}
                        })
        
      rescue => ex
        msg = "#{self.class.name}##{__method__} Failure: klass=#{ex.class.name}, cause=#{ex.message}, Backtrace=#{ex.backtrace[0..8]}"
        SknApp.logger.error msg
        SknSuccess.call({success: false,
                         status: 404,
                         message: msg,
                         error: msg,
                         payload: {}
                        },
                        msg
        )
      end

      def generate_topics_for(device_name)
        topics = []
        @device = device_for(device_name)

        #device proper
        device.attributes.each do |attr|       # attribute -> property(.property)
          attr.properties.each do |prop|
            topic = "#{device.base}/#{device.name}/#{attr.name}/#{prop.name.split('.').join("/")}"
            topics.push( topic )
          end
          topic = "#{device.base}/#{device.name}/#{attr.name}"
          topics.push( topic )
        end

        # Nodes
        device.nodes.each do |node|
          node.attributes.each do |attr|      # nodes -> attributes
            topic = "#{device.base}/#{device.name}/#{node.name}/#{attr.name}"
            topics.push( topic )
            if attr.name.eql?('$properties') and attr.value.include?(':')
              attr.value.split(',').each do |part| # V2 trigger
                item = part.split(':')&.first
                topic = "#{device.base}/#{device.name}/#{node.name}/#{item}"
                topics.push( topic )
                if part.split(':')&.size > 1
                  topic = "#{device.base}/#{device.name}/#{node.name}/#{item}/set"
                  topics.push( topic )
                end
              end
            end
          end
          node.properties.each do |prop|      # nodes -> properties -> attributes
            prop.attributes.each do |attr|
              topic = "#{device.base}/#{device.name}/#{node.name}/#{prop.name}/#{attr.name}"
              topics.push( topic )
            end
            topic = "#{device.base}/#{device.name}/#{node.name}/#{prop.name}"
            topics.push( topic )
            if prop.settable
              topic = "#{device.base}/#{device.name}/#{node.name}/#{prop.name}/set"
              topics.push( topic )
            end
          end
          topic = "#{device.base}/#{device.name}/#{node.name}"
          topics.push( topic )
        end

        topics.uniq
      end

      def purge_topics(topic_stream)
        topic_stream.each do |item|
          @_count += 1
          @_stream_manager.send_queue_event( Homie::Commands::DeleteDevice.new(item) )
          SknApp.logger.debug "#{self.class.name}.#{__method__} Topic Deleted: #{item}"
        end
      end

      def remove_device(device_obj)
        sub = @_stream_manager.subscriptions.detect {|sub| device_obj.name.eql?(sub.device_name)}
        @_stream_manager.subscriptions.delete(sub) unless sub.nil?
        !!@_stream_manager.devices.delete(device_obj) unless device_obj.nil?
      end

      def device_for(device_name)
        device = @_stream_manager.devices.detect {|dev| device_name.eql?(dev.name)}
        raise "Device Not Found" if device.nil?
        device
      end

    end # end class
  end
end

