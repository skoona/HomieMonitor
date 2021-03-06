# ##
#
#
# Encoding Issues : http://ruby-doc.org/core-2.2.0/String.html#method-i-encode
# - mostly caused by the degrees symbol in the unit string, but mqtt is also ascii-8
#
# cleaned = string.encode!("UTF-8", invalid: :replace, undef: :replace).force_encoding("utf-8") }
#  -- or --
# cleaned = string.map {|text| text.gsub!(/[^\001-\176]+/, "") }
#
# cleaned may have a `?` as the replaced char
#
# ##


module Homie
  module Commands

    class QueueEvent
      attr_reader   :id, :value, :elements

      @@_queue_counter = 0

      def self.call(packet)
        new(packet)
      end

      # The MQTT data is expected to be encoded as UTF-8 in the payload of the Packet.  It is binary on occasion
      # which raises an Encoding::InvalidByteSequenceError, or Encoding::UndefinedConversionError,
      # or ArgumentError::invalid byte sequence in UTF-8.
      # Homie requires all values transported via MQTT to be String Chars and it is assumed they're UTF-8.
      # We attempt to force encoding of the payload to UTF-8, to avoid raising those Exceptions and crashing the app.
      def initialize(packet)
        @_original = packet.topic
        @_package  = @_original.split('/')
        @elements  = @_package.size
        @value     = Utils::Utilities.make_utf8( packet.payload )
        # @value     = packet.payload
        @id        = packet.id.to_i > 0 ? packet.id.to_i : (@@_queue_counter += 1)
        @_qos      = packet.respond_to?(:qos) ? packet.qos : 1
        @_retain   = packet.respond_to?(:retain) ? packet.retain : false
      end

      def topic
        SknSuccess.(@_original)
      end

      def retain
        @_retain
      end

      def qos
        @_qos
      end

      def topic_parts
        @_package
      end

      def topic_size
        elements
      end

      def homie_base
        @_package.first
      end

      def broadcast?
        @_package[1].eql?("$broadcast")
      end
      def schedule_related?
        ['$state','$online', '$fw', '$implementation'].any? do |q|
          @_package[2]&.include?(q)
        end
      end
      def device_create?
        ['$homie','$state'].any? do |q|
          @_package[2]&.eql?(q) && elements == 3 && value.size > 0
        end
      end

      def ota_loading?
        @_original.include?('$implementation/ota/status') &&
          @value.start_with?("206 ")
      end

      def broadcast_key
        broadcast? && @_package[2..-1].join('.')
      end

      def type_device?
        !broadcast? && @_package[2].include?("$")
      end
      def type_node?
        !broadcast? && !@_package[2].include?("$")
      end

      def homie_broadcast
        if @_package[1].eql?("$broadcast")
          SknSuccess.(value, @_package[2..-1].join('.'))
        else
          SknFailure.("", @_package[2..-1].join('.'))
        end
      end

      def device_name_abs
        broadcast? ? SknFailure.("",@_package[1]) : SknSuccess.(@_package[1])
      end
      def device_name
        !broadcast? && @_package[2].eql?("$name")   ? SknSuccess.(@_package[1]) : SknFailure.("",@_package[1])
      end
      def device_attribute
        @elements > 2 && @_package[2].include?("$") ? SknSuccess.(@_package[2]) : SknFailure.("",@_package[2])
      end
      def device_attribute_property
        @elements > 3 && @_package[2].include?("$") ? SknSuccess.(@_package[3..-1].join('.')) : SknFailure.("",@_package[3..-1].join('.'))
      end
      def device_attribute_property_all
        @elements > 3 && @_package[2].include?("$") ? SknSuccess.(@_package[3..-1].join('.')) : SknFailure.("",@_package[3..-1].join('.'))
      end

      def node_name_abs
        broadcast? || @_package[2].include?("$")     ? SknFailure.("",@_package[2]) : SknSuccess.(@_package[2])
      end
      def node_name
        !broadcast? && @_package[3].eql?("$name")    ? SknSuccess.(@_package[2]) : SknFailure.("",@_package[2])
      end
      def node_attribute
        @elements > 3 && @_package[3].include?("$")  ? SknSuccess.(@_package[3]) : SknFailure.("",@_package[3])
      end
      def node_property
        @elements > 3 && !@_package[3].include?("$") ? SknSuccess.(@_package[3]) : SknFailure.("",@_package[3])
      end
      def node_set_property
        @elements == 5 && @_package[4].eql?("set")   ? SknSuccess.(@_package[3..-1].join(".")) : SknFailure.("",@_package[3..-1].join("."))
      end
      def node_property_attribute
        @elements == 5 && @_package[4].include?("$") ? SknSuccess.(@_package[4]) : SknFailure.("",@_package[4])
      end
      def node_property_settable_attribute
        @elements == 5 && @_package[4].eql?("$settable") ? SknSuccess.(@_package[4]) : SknFailure.("",@_package[4])
      end
    end
  end
end


# Nodes
# Nodes can be arrays. name_index
#   homie/super-car/lights_0/$name → "Back lights"
#   homie/super-car/lights_0/intensity → "0"
#   homie/super-car/lights_1/$name → "Front lights"
#   homie/super-car/lights_1/intensity → "100"
#

# homie / device ID / node ID
#    this is the base topic of a node. Each node must have
#    a unique node ID on a per-device basis

# homie / device ID / node ID / property ID:
#     this is the base topic of a property. Each property must
#     have a unique property ID on a per-node basis which adhere
#     to the ID format.

# Attributes: Devices, nodes and properties have specific attributes
# characterizing them. Attributes are represented by topic identifier
# starting with $.

