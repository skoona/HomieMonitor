# ##
#
# Attribute (attributes) Model
#
# Targets: (many)
# ~> device-$attribute
#    $node-$attribute
#    node-$property-$attributes
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

    # Attribues update themself if name matches, then if prop flag update/create properties
    class Attribute
      attr_reader :name, :value, :properties

      def self.call(event)
        new(event)
      end

      def initialize(queue_event)
        @properties       = []
        init_name(queue_event)
        true
      end

      def init_name(queue_event)
        rec = queue_event.node_property_attribute
        rec = queue_event.node_attribute unless rec.success
        rec = queue_event.device_attribute unless rec.success

        raise ArgumentError, "Invalid Attribute: #{queue_event.topic_parts.last}" unless rec.success

        @name = rec.value
        @value = queue_event.value

        SknApp.debug_logger.info "#{self.class.name}##{__method__}(#{name}:#{queue_event.id}) With: #{queue_event.topic.value} ~> #{queue_event.value}"
        handle_queue_event?(queue_event)
      end

      def handle_queue_event?(queue_event)

        rc = if queue_event.node_property_attribute.success
                store_value(queue_event.node_property_attribute.value, queue_event.value)

              elsif queue_event.node_attribute.success
                store_value(queue_event.node_attribute.value, queue_event.value)

              elsif queue_event.device_attribute_property.success && name.include?(queue_event.device_attribute.value)
                handle_property(queue_event)

              elsif queue_event.device_attribute.success
                store_value(queue_event.device_attribute.value, queue_event.value)

              else
                false
              end
        SknApp.debug_logger.info "#{self.class.name}##{__method__}(#{name}:#{queue_event.id}) #{rc ? 'Processed' : 'Skipped'}: #{queue_event.topic.value} ~> #{queue_event.value}"
        rc
      end

      def store_value(key, value)
        if name.include?(key)   # accept update
          @value = value
          true
        else
          false
        end
      end

      def handle_property(queue_event)
        if @properties.detect {|prp| prp.handle_queue_event?(queue_event) }
          true
        else
          begin
            @properties.push( Property.(queue_event) )
            true
          rescue => e
            SknApp.debug_logger.warn "#{self.class.name}##{__method__}(#{name}:#{queue_event.id}) Create Property Failue: #{queue_event.topic.value} ~> #{queue_event.value} [#{e.class.name}:#{e.message}]"
            true
          end
        end
      end


      def to_hash
        Psych.load( Psych.dump({
            klass: "Attribute",
            name: name,
            value: value,
            properties: @properties.map(&:to_hash)
        }))
      end

    end
  end
end
