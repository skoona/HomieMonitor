# ##
#
# Handle Delete
# Services::Handlers::DeleteSchedule
#
#


module Services
  module Handlers

    class DeleteSchedule
      def self.call(fname)
        self.new.call(fname)
      end

      def initialize()
        @_provider       = SknApp.registry.resolve("subscriptions_provider")
        @_stream_manager = SknApp.registry.resolve("device_stream_manager")
        SknApp.logger.debug "#{self.class.name}.#{__method__}"
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
