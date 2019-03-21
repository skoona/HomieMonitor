# ##
#
# Node (core) Model
#
# Targets: (many)
# ~> [Node]
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
#
# ##
# Attributes = $ prefix
# Properties = Non-$ prefix
# ##
# ----------------------------------------------------------------------
# sknSensors/TheaterIR/$state ~> init
# sknSensors/TheaterIR/$homie ~> 3.0.1
# sknSensors/TheaterIR/$name ~> Theater IR Server
# sknSensors/TheaterIR/$mac ~> 5C:CF:7F:63:30:AF
# sknSensors/TheaterIR/$localip ~> 10.100.1.215
# sknSensors/TheaterIR/$nodes ~> irservice
# sknSensors/TheaterIR/$stats ~> uptime
# sknSensors/TheaterIR/$stats/interval ~> 0
# sknSensors/TheaterIR/$fw/name ~> sknSensors-IRService.d1_mini
# sknSensors/TheaterIR/$fw/version ~> 0.2.0
# sknSensors/TheaterIR/$fw/checksum ~> 934a0239a5b8513b09e16765dfdba9b5
# sknSensors/TheaterIR/$implementation ~> esp8266
# sknSensors/TheaterIR/$implementation/config ~> {"name":"Theater IR Server","device_id":"TheaterIR","device_stats_interval":180,"wifi":{"ssid":"SFNSS1-24G"},"mqtt":{"host":"openhabianpi.skoona.net","port":1883,"base_topic":"sknSensors/","auth":true},"ota":{"enabled":true},"settings":{"sensorsInterval":300,"onSequence":"3,2FD48B7,32 43,5006,16 3,4BB620DF,32 3,4BB6F00F,32","offSequence":"3,2FD48B7,32 43,5006,16 3,4B36E21D,32"}}
# sknSensors/TheaterIR/$implementation/version ~> 3.0.0
# sknSensors/TheaterIR/$implementation/ota/enabled ~> true
# sknSensors/TheaterIR/irservice/$name ~> IR Provider
# sknSensors/TheaterIR/irservice/$type ~> theater-remote
# sknSensors/TheaterIR/irservice/$properties ~> command,received
# sknSensors/TheaterIR/irservice/command/$name ~> IR Broadcaster
# sknSensors/TheaterIR/irservice/command/$settable ~> true
# sknSensors/TheaterIR/irservice/command/$datatype ~> string
# sknSensors/TheaterIR/irservice/command/$unit ~> %s
# sknSensors/TheaterIR/irservice/received/$name ~> IR Listener
# sknSensors/TheaterIR/irservice/received/$datatype ~> string
# sknSensors/TheaterIR/irservice/received/$unit ~> %s
# sknSensors/TheaterIR/$state ~> ready
# sknSensors/TheaterIR/$stats/signal ~> 64
# sknSensors/TheaterIR/$stats/uptime ~> 4
# ----------------------------------------------------------------------

module Homie
  module Components

    class Node
      attr_reader :name, :value, :attributes, :properties

      def self.call(event)
        new(event)
      end

      def initialize(queue_event)
        @value   = queue_event.value.to_s
        @properties  = []
        @attributes  = []
        init_name(queue_event)
        true
      end

      def init_name(queue_event)
        @name = queue_event.node_name_abs.value.to_s if queue_event.node_name_abs.success
        raise ArgumentError, "Invalid Node Property: #{queue_event.topic_parts.last}" if @name.nil?

        SknApp.debug_logger.info "#{self.class.name}##{__method__}(#{name}:#{queue_event.id}) With: #{queue_event.topic.value}"
        handle_queue_event?(queue_event)
      end

      def handle_queue_event?(queue_event)
        ref = queue_event.node_name_abs
        rc = if ref.success and name.eql?(ref.value.to_s)
               if queue_event.node_property_attribute.success
                 handle_property(queue_event)
               elsif queue_event.node_attribute.success
                 handle_attribute(queue_event)
               elsif queue_event.node_property.success
                 handle_property(queue_event)
               else
                 SknApp.debug_logger.warn "#{self.class.name}##{__method__}(#{name}) Unknown|Ignored: #{queue_event.topic.value}"
               end
               true # Required to respond true, cause it was our message - no matter the outcome
        else
          false
        end
        SknApp.debug_logger.info "#{self.class.name}##{__method__}(#{name}:#{queue_event.id}) #{rc ? 'Processed' : 'Skipped'}: #{queue_event.topic.value} ~> #{queue_event.value}"
        rc
      end

      def handle_attribute(queue_event)
        attr = queue_event.node_property_attribute
        attr = queue_event.node_attribute unless attr.success
        if attr.success
          if attr.value.eql?("$name")
            @value = queue_event.value
          end
        end
        if @attributes.detect {|prp| prp.handle_queue_event?(queue_event) }
          true
        else
          begin
            obj = Attribute.new(queue_event)
            @attributes.push( obj )
            true
          rescue => e
            SknApp.debug_logger.warn "#{self.class.name}##{__method__}(#{name}:#{queue_event.id}) Create Attribute Failue: #{queue_event.topic.value} ~> #{queue_event.value} [#{e.class.name}:#{e.message}]"
            true
          end
        end
      end

      def handle_property(queue_event)
        if @properties.detect {|prp| prp.handle_queue_event?(queue_event) }
          true
        else
          begin
            obj = Property.new(queue_event)
            @properties.push( obj )
            true
          rescue => e
            SknApp.debug_logger.warn "#{self.class.name}##{__method__}(#{name}:#{queue_event.id}) Create Property Failue: #{queue_event.topic.value} ~> #{queue_event.value} [#{e.class.name}:#{e.message}]"
            true
          end
        end
      end


      def to_hash
        Psych.load( Psych.dump({
            klass: "Node",
            name:  name,
            value: value,
            properties: @properties.map(&:to_hash),
            attributes: @attributes.map(&:to_hash)
        }))
      end

    end
  end
end