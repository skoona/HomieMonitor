# ##
#
# Device (core) Model
#
# Targets: (many)
# ~> [Device]
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

    class Device

      attr_reader :name, :value, :nodes, :attributes, :base

      def self.call(event)
        new(event)
      end

      def initialize(queue_event)
        @_notify_topic_parts = []
        @base        = queue_event.homie_base
        @value       = nil
        @nodes       = []
        @attributes  = []
        init_name(queue_event)
        true
      end

      def init_name(queue_event)
        @name = queue_event.device_name_abs.value if queue_event.device_name_abs.success

        raise ArgumentError, "Invalid Device Property: #{queue_event.topic_parts.last}" if @name.nil?

        SknApp.debug_logger.perf "#{self.class.name}##{__method__}(#{name}:#{queue_event.id}) With: #{queue_event.topic.value}"
        handle_queue_event?(queue_event)
      end

      def handle_queue_event?(queue_event)
        @_notify_topic_parts = queue_event.topic_parts
        rc = if queue_event and queue_event.device_name_abs.success and name.eql?(queue_event.device_name_abs.value)

               if queue_event.device_attribute_property.success
                 handle_attribute(queue_event)

               elsif queue_event.device_attribute.success
                 handle_attribute(queue_event)

               else
                 handle_node(queue_event)

               end
             else
               false
             end
        SknApp.debug_logger.perf "#{self.class.name}##{__method__}(#{name}:#{queue_event.id}) #{rc ? 'Processed' : 'Skipped'}: #{queue_event.topic.value} ~> #{queue_event.value}"
        rc
      end

      def handle_node(queue_event)
        if @nodes.detect {|prp| prp.handle_queue_event?(queue_event) }
          true
        else
          begin
            @nodes.push( Node.(queue_event) )
            true
          rescue
            SknApp.debug_logger.warn "#{self.class.name}##{__method__}(#{name}:#{queue_event.id}) Create Node Failure: #{queue_event.topic.value} ~> #{queue_event.value}"
            true   # no choice but answer true, cause it was our message to process no one else can
          end
        end
      end

      def handle_attribute(queue_event)
        if queue_event.device_attribute.success and '$name'.eql?(queue_event.device_attribute.value)
          @value = queue_event.value
        end
        if @attributes.detect {|prp| prp.handle_queue_event?(queue_event) }
          true
        else
          begin
            @attributes.push( Attribute.(queue_event) )
            true
          rescue => e
            SknApp.debug_logger.warn "#{self.class.name}##{__method__}(#{name}:#{queue_event.id}) Create Attribute Failure: #{queue_event.topic.value} ~> #{queue_event.value} [#{e.class.name}:#{e.message}]"
            true
          end
        end
      end

      def device_hash
        Psych.load( Psych.dump({
           klass: "Device",
           name: name,
           value: value,
           base: base,
           attributes: @attributes.map(&:to_hash)
        }))
      end

      def to_hash
        Psych.load( Psych.dump({
          klass: "Device",
          name: name,
          value: value,
          base: base,
          attributes: @attributes.map(&:to_hash),
          nodes: @nodes.map(&:to_hash)
        }))
      end

    end
  end
end
