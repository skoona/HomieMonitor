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
#
# ##
# Attributes = $ prefix
# Properties = Non-$ prefix
# ##
# ---------------------------------------------------------------------- V3
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
# ---------------------------------------------------------------------- V2
# sknSensors/LabTarget/$homie 2.0.0
# sknSensors/LabTarget/$mac B4:E6:2D:53:A8:F0
# sknSensors/LabTarget/$name Blinking light
# sknSensors/LabTarget/$localip 10.100.1.233
# sknSensors/LabTarget/$stats/interval 0
# sknSensors/LabTarget/$fw/name Homie-light-onoff
# sknSensors/LabTarget/$fw/version 2.0.1
# sknSensors/LabTarget/$fw/checksum 751061e4e21be98289b931c5047ad7c9
# sknSensors/LabTarget/$implementation esp8266
# sknSensors/LabTarget/$implementation/config {"name":"Blinking light","device_id":"LabTarget","device_stats_interval":180,"wifi":{"ssid":"SFNSS1-24G"},"mqtt":{"host":"openhabianpi.skoona.net","port":1883,"base_topic":"sknSensors/","auth":true},"ota":{"enabled":true}}
# sknSensors/LabTarget/$implementation/version 2.0.0
# sknSensors/LabTarget/$implementation/ota/enabled true
# sknSensors/LabTarget/light/$type switch
# sknSensors/LabTarget/light/$properties on:settable
# sknSensors/LabTarget/$online true
# sknSensors/LabTarget/$stats/signal 78
# sknSensors/LabTarget/$stats/uptime 9
#


module Homie
  module Component

    class Device
      include Homie::Events::Notify

      attr_reader :name, :nodes, :attributes, :base, :debug_logger

      watch_attributes :value

      def self.call(event)
        new(event)
      end

      def initialize(queue_event)
        @_subscribers = []
        @_notify_topic_parts = []
        @base        = queue_event.homie_base
        @value       = queue_event.value
        @nodes       = []
        @attributes  = []
        @debug_logger = SknApp.debug_logger
        init_name(queue_event)
        true
      end

      def init_name(queue_event)
        @name = queue_event.device_name_abs.value if queue_event.device_name_abs.success

        raise ArgumentError, "Invalid Device Property: #{queue_event.topic_parts.last}" if @name.nil?

        debug_logger.info "#{self.class.name}##{__method__}(#{name}:#{queue_event.id}) With: #{queue_event.topic.value}"
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
        debug_logger.info "#{self.class.name}##{__method__}(#{name}:#{queue_event.id}) #{rc ? 'Processed' : 'Skipped'}: #{queue_event.topic.value} ~> #{queue_event.value}"
        rc
      end

      def handle_node(queue_event)
        if @nodes.detect {|prp| prp.handle_queue_event?(queue_event) }
          true
        else
          begin
            obj = Node.(queue_event)
            @nodes.push( obj )
            true
          rescue
            debug_logger.warn "#{self.class.name}##{__method__}(#{name}:#{queue_event.id}) Create Node Failue: #{queue_event.topic.value} ~> #{queue_event.value}"
            true   # no choice but answer true, cause it was our message to process no one else can
          end
        end
      end

      def handle_attribute(queue_event)
        if queue_event.device_name.success
          self.value = queue_event.value
        end
        if @attributes.detect {|prp| prp.handle_queue_event?(queue_event) }
          true
        else
          begin
            obj = Attribute.(queue_event)
            @attributes.push( obj )
            true
          rescue => e
            debug_logger.warn "#{self.class.name}##{__method__}(#{name}:#{queue_event.id}) Create Node Failue: #{queue_event.topic.value} ~> #{queue_event.value} [#{e.class.name}:#{e.message}]"
            true
          end
        end
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
