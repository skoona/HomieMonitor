
module Utils

  # The MQTT data is expected to be encoded as UTF-8 in the payload of the Packet.  It is binary on occasion
  # which raises an Encoding::InvalidByteSequenceError, or Encoding::UndefinedConversionError,
  # or ArgumentError::invalid byte sequence in UTF-8.
  # Homie requires all values transported via MQTT to be String Chars and it is assumed they're UTF-8.
  # We attempt to force encoding of the payload to UTF-8, to avoid raising those Exceptions and crashing the app.
  class Utilities

    # replace value with period when value is totally unknown and fallback is required.
    def [](c)
      '.'
    end

    def self.make_utf8(char_string)
      # char_string.encode("UTF-8", undef: :replace, invalid: :replace, fallback: self.new)
      # char_string.encode("UTF-8", "ASCII-8BIT", undef: :replace, invalid: :replace, fallback: self.new)
      # char_string.encode(undef: :replace, invalid: :replace, fallback: self.new)
      # char_string.encode("UTF-8", "ASCII-8BIT", undef: :replace, invalid: :replace, fallback: Encoding::Converter.new("utf-8", "ascii-8bit"))
      # char_string.encode(undef: :replace, invalid: :replace, fallback: Encoding::Converter.new("utf-8", "ascii-8bit"))
      # char_string.encode("UTF-8", undef: :replace, invalid: :replace, fallback: Encoding::Converter.new("utf-8", "ascii-8bit"))
      char_string.force_encoding("UTF-8")
    end
  end
end