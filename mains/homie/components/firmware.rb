

module Homie
  module Components

    HOMIE_PATTERN   = "\x25\x48\x4f\x4d\x49\x45\x5f\x45\x53\x50\x38\x32\x36\x36\x5f\x46\x57\x25".unpack('H*').first
    NAME_PATTERN    = ["\xbf\x84\xe4\x13\x54".unpack('H*').first, "\x93\x44\x6b\xa7\x75".unpack('H*').first]
    VERSION_PATTERN = ["\x6a\x3f\x3e\x0e\xe1".unpack('H*').first, "\xb0\x30\x48\xd4\x1a".unpack('H*').first]
    BRAND_PATTERN   = ["\xfb\x2a\xf5\x68\xc0".unpack('H*').first, "\x6e\x2f\x0f\xeb\x2d".unpack('H*').first]


    # Homie (>= V.2.0 because of magic bytes)
    class Firmware
      attr_reader :checksum, :name, :filename, :version, :brand, :path, :homie_version

      def initialize(filename, topic=nil)
        @_topic      = topic
        @path        = filename.kind_of?(Pathname) ? filename : Pathname.new(filename)
        @filename    = @path.basename
        binfile      = @path.binread  # Not Retained
        @checksum    = Digest::MD5.hexdigest(binfile)
        @homie_version = 3
        @_homie_flag = binfile.unpack('H*').first.include?(HOMIE_PATTERN)
        if @_homie_flag
          @brand     = find_pattern(BRAND_PATTERN, binfile)
          @name      = find_pattern(NAME_PATTERN, binfile)
          @version   = find_pattern(VERSION_PATTERN, binfile)
        end
        SknApp.debug_logger.debug "#{self.class.name}.#{__method__} for: #{@name}:#{@_topic}"
      end

      def as_binary
        @path.binread
      end

      def as_base64_no_pad_url
        urlsafe_encode64(as_binary, padding: false)
      end

      def as_base64_with_pad_url
        Base64.urlsafe_encode64(as_binary, padding: true)
      end

      def as_strict_base64
        Base64.strict_encode64(as_binary)
      end

      def as_base64
        Base64.encode64(as_binary)
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

      def id
        1000
      end

      def topic
        SknSuccess.(@_topic)
      end

      def value
        case Homie::Handlers::Stream.ota_type
        when 'RFC4648_pad'
          as_base64_no_pad_url
        when 'RFC4648'
          as_base64_with_pad_url
        when 'base64strict'
          as_strict_base64
        when 'base64'
          as_base64
        else
          as_binary
        end
      end

      def retain
        false
      end

      def qos
        1
      end


      def to_hash
        {
            filename: filename,
            name: name,
            checksum: checksum,
            version: version,
            brand: brand,
            path: path,
            homie: homie?,
            fsize: path.size,
            created: path.ctime.strftime("%Y-%b-%d %H:%M"),
            updated: path.mtime
        }
      end

    end
  end
end
