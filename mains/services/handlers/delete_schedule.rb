# ##
#
# Handle Delete Firmware
# Services::Handlers::DeleteFile
#
#


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
