# ##
#
# List Firmwares
# Services::Handlers::Firmwares
#
#

module Services
  module Handlers

    class Firmwares
      def self.call(action, value)
        self.new.call(action, value)
      end

      def initialize()
        SknApp.logger.debug "#{self.class.name}.#{__method__} "
      end

      def call(action, value)

        firmware = case action
                   when 'catalog'
                     'hash'.eql?(value) ? firmware_inventory.map(&:to_hash) : firmware_inventory
                   when 'find'
                     firmware_inventory.detect {|rec| value.eql?(rec.filename) || value.eql?(rec.checksum)}
                   else
                     firmware_inventory.map(&:to_hash)
                   end

        msg = "#{self.class.name}##{__method__} Processed(#{action})"
        SknApp.logger.debug msg
        SknSuccess.call({success: true,
                         error: "",
                         payload: firmware.is_a?(Array) ? firmware : [firmware]
                        })
        
      rescue => ex
        msg = "#{self.class.name}##{__method__} Failure: klass=#{ex.class.name}, cause=#{ex.message}, Backtrace=#{ex.backtrace[0..4]}"
        SknApp.logger.error msg
        SknSuccess.call({success: false,
                         error: msg,
                         payload: {}
                        },
                        msg
        )
      end

      def firmware_inventory
        Dir[SknSettings.content_service.firmware_path + "*"].map do |fware|
          Homie::Components::Firmware.new(fware)
        end
      end

    end # end class
  end
end
