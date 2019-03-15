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
        SknApp.logger.debug "#{self.class.name}.#{__method__}"
      end

      def call(device_name)
        SknApp.logger.debug "#{self.class.name}##{__method__} (Input) Processed(#{device_name})"

        found = @_provider.subscriptions.detect {|rec| rec.device_name.eql?(device_name.gsub(" ",''))}
        @_provider.subscription_delete(found) if found

        msg = "#{self.class.name}##{__method__} (#{!!found}) Processed(#{device_name})"
        SknApp.logger.debug msg
        if found
          SknSuccess.call({success: true, error: "", payload: found.to_hash})
        else
          SknSuccess.call({success: false, error: "Subscription not Found!", payload: { device_name: device_name }})
        end
      rescue => ex
        msg = "#{self.class.name}##{__method__} Failure: klass=#{ex.class.name}, cause=#{ex.message}, Backtrace=#{ex.backtrace[0..8]}"
        SknApp.logger.error msg
        SknFailure.call({success: false, error: msg, payload: {}}, msg)
      end

      def delete_schedule(device_name)
          device_name.nil? ? false : true
      end

    end # end class
  end
end
