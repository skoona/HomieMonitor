# ##
#
# Handle Adding a subscription
# Services::Handlers::AddSchedule
#
#

module Services
  module Handlers

    class AddSchedule
      def self.call(device_name, checksum)
        self.new.call(device_name, checksum)
      end

      def initialize()
      end

      def call(device_name, checksum)

        msg = "#{self.class.name}##{__method__} Processed(#{device_name})"
        SknApp.logger.debug msg
        SknSuccess.call({success: true,
                         error: "",
                         payload: {name: device_name, checksum: checksum}
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

    end # end class
  end
end
