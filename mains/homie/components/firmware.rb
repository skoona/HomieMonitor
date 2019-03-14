

module Homie
  module Components

    HOMIE_PATTERN   = "\x25\x48\x4f\x4d\x49\x45\x5f\x45\x53\x50\x38\x32\x36\x36\x5f\x46\x57\x25".unpack('H*').first
    NAME_PATTERN    = ["\xbf\x84\xe4\x13\x54".unpack('H*').first, "\x93\x44\x6b\xa7\x75".unpack('H*').first]
    VERSION_PATTERN = ["\x6a\x3f\x3e\x0e\xe1".unpack('H*').first, "\xb0\x30\x48\xd4\x1a".unpack('H*').first]
    BRAND_PATTERN   = ["\xfb\x2a\xf5\x68\xc0".unpack('H*').first, "\x6e\x2f\x0f\xeb\x2d".unpack('H*').first]


    # Homie (>= V.2.0 because of magic bytes)
    class Firmware
      attr_reader :checksum, :name, :filename, :version, :brand, :path

      def initialize(filename)
        @path        = filename.kind_of?(Pathname) ? filename : Pathname.new(filename)
        @filename    = @path.basename
        binfile      = @path.binread  # Not Retained
        @checksum    = Digest::MD5.hexdigest(binfile)
        @_homie_flag = binfile.unpack('H*').first.include?(HOMIE_PATTERN)
        if @_homie_flag
          @brand     = find_pattern(BRAND_PATTERN, binfile)
          @name      = find_pattern(NAME_PATTERN, binfile)
          @version   = find_pattern(VERSION_PATTERN, binfile)
        end
      end

      def as_binary
        @path.binread
      end

      def as_base64
        Base64.strict_encode64(as_binary)
      end

      def homie?
        @_homie_flag
      end

      def find_pattern(pattern, binfile)
        value = ""
        thingy = binfile.unpack('H*').first
        if thingy.include?(pattern.first)
          value = thingy.split(pattern.first)[1].split(pattern.last).first.to_s
          value = [value].pack('H*') unless value.empty?
        end
        value
      end

      def to_hash
        {
            filename: filename,
            name: name,
            checksum: checksum,
            version: version,
            brand: brand,
            path: path.basename.to_s,
            homie: homie?,
            fsize: path.size,
            created: path.ctime.strftime("%Y-%b-%d %H:%M"),
            updated: path.mtime
        }
      end

    end
  end
end

# SPI Flash Filing System, SPIFFS

# # this method for decode base64 code to file
# def parse_image_data(image[1])
#   base64_file = image[1]
#   ext, string = base64_file.split(',')
#
#   ext = MIME::Types[base64_file].first.preferred_extension if ext.include?("base64")
#   tempfile = Tempfile.new(["#{DateTime.now.to_i}", ".#{ext}"])
#   tempfile.binmode
#   tempfile.write Base64.decode64(string)
#   tempfile.rewind
#   tempfile
# end
