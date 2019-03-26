# ##
#
# Property (properties) Model
#
# Targets: (many)
# ~> $device-$stats-properties
#    $device-$fw-properties
#    $device-$implementation-properties
#    $node-$properties
#
# ##
#  -> [Device]
#     -> device-$attribute                  +[$state, $homie, $name, $mac, $localip, $nodes, $stats, $fw, $implementation]
#     -> $device-$stats-properties          +[interval, uptime, signal, cputemp, cpuload, battery, freeheap, supply]
#     -> $device-$fw-properties              [name, version, checksum]
#     -> $device-$implementation-properties +[config, version, ota/enabled]
#
#  -> [Node] see $device-$attribute[$nodes]
#     -> $node-$attribute  [$name, $type, $properties, $array]
#     -> $node-$properties [command, received, +user+...] @see $node-$attribute[$properties]
#     -> node-$property-$attributes [$name, $settable, $retained, $unit, $datatype, $format]
##

module Homie
  module Components

    # Properties update themself if name matches, then if attr flag update/create attributes
    # Subscribe-able via :subscribe, :unsubscribe methods
    class Property
      include Homie::Components::Notifier

      attr_reader :name, :settable, :attributes

      watch_attributes :value

      def self.call(event)
        new(event)
      end

      def initialize(queue_event)
        @_subscribers = []
        @_notify_topic_parts = []
        @attributes   = []
        @settable     = false
        init_name(queue_event)
        true
      end

      def init_name(queue_event)
        rec = queue_event.device_attribute_property_all
        rec = queue_event.node_property unless rec.success

        raise ArgumentError, "Invalid Property: #{queue_event.topic_parts.last}" unless rec.success

        @name = rec.value
        @value = queue_event.value
        SknApp.debug_logger.perf "#{self.class.name}##{__method__}(#{name}:#{queue_event.id}) With: #{queue_event.topic.value}"
        handle_queue_event?(queue_event)
      end

      def handle_queue_event?(queue_event)
        @_notify_topic_parts = queue_event.topic_parts
        rec = queue_event.node_property
        rec = queue_event.device_attribute_property unless rec.success

        rc = if (queue_event.node_property_attribute.success && name.include?(queue_event.node_property.value))

               if queue_event.node_property_settable_attribute.success
                 @settable = queue_event.value.eql?("true") ? true : false
               end

               if @attributes.detect {|prp| prp.handle_queue_event?(queue_event) }
                  true
                else
                  begin
                    obj = Attribute.new(queue_event)
                    @attributes.push( obj )
                    true
                  rescue => e
                    SknApp.debug_logger.warn "#{self.class.name}##{__method__}(#{name}:#{queue_event.id}) Create Property-Attribute Failure: #{queue_event.topic.value} ~> #{queue_event.value} [#{e.class.name}:#{e.message}]"
                    true
                  end
                end

        elsif rec.success and name.include?(rec.value)  # tracking dupplicates
          self.value = queue_event.value
          true
        else
          false
        end
        SknApp.debug_logger.perf "#{self.class.name}##{__method__}(#{name}:#{queue_event.id}) #{rc ? 'Processed' : 'Skipped'}: #{queue_event.topic.value} ~> #{queue_event.value}"
        rc
      end

      def to_hash
        Psych.load( Psych.dump({
            klass: "Property",
            name: name,
            value: value,
            settable: settable,
            attributes: @attributes.map(&:to_hash)
        }))
      end

    end
  end
end