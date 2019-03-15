# ##
#
# Handle Delete Firmware
# Services::Handlers::DeleteFile
#
#

# File Params
# {
# "filename":"Homie-LightOnOff.ino.d1_mini.bin",
# "name":"Homie-light-onoff",
# "checksum":"97333f3275feeea19380df6f7f1706e4",
# "version":"2.0.2",
# "brand":"sknSensors",
# "path":"Homie-LightOnOff.ino.d1_mini.bin",
# "homie":true,
# "fsize":432672,
# "created":"2019-Mar-12 20:31",
# "updated":"2019-03-12 20:31:05 -0400"
# }

module Services
  module Handlers

    class DeleteFile
      def self.call(fname)
        self.new.call(fname)
      end

      def initialize()
        @_temp_path = SknSettings.content_service.firmware_path
        SknApp.logger.debug "#{self.class.name}.#{__method__} "
      end

      def call(fname)
        fpath = Pathname.new("#{@_temp_path}#{fname}")
        rc = delete_file(fpath)

        msg = "#{self.class.name}##{__method__} Processed(#{fpath})"
        SknApp.logger.debug msg
        SknSuccess.call({success: true,
                         error: "",
                         payload: {}
                        })
        
      rescue => ex
        msg = "#{self.class.name}##{__method__} Failure: klass=#{ex.class.name}, cause=#{ex.message}, Backtrace=#{ex.backtrace[0..8]}"
        SknApp.logger.error msg
        SknSuccess.call({success: false,
                         error: msg,
                         payload: {}
                        },
                        msg
        )
      end

      def delete_file(filename)
          filename.delete if filename.exist?
      end

    end # end class
  end
end
