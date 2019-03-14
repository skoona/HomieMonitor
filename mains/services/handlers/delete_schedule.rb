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

    class DeleteSchedule
      def self.call(fname)
        self.new.call(fname)
      end

      def initialize()
      end

      def call(device_name)

        msg = "#{self.class.name}##{__method__} Processed(#{device_name})"
        SknApp.logger.debug msg
        SknSuccess.call({success: true,
                         error: "",
                         payload: {name: device_name}
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

      def delete_schedule(device_name)
          device_name.nil? ? false : true
      end

    end # end class
  end
end
