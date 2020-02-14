# File: ./main/homie/providers/subscriptions.rb
#
##
# Persistence via YAML and YAML::Store
# Ref: https://ruby-doc.org/stdlib-2.5.1/libdoc/yaml/rdoc/YAML/Store.html
# ##

module Homie
  module Providers

    # ## Action Sources
    # $implementation/ota/firmware/<md5 checksum>
    # $implementation/ota/status
    #
    # ## Decision Sources
    # $fw/name
    # $fw/version
    # $fw/checksum
    class Subscriptions
      include Singleton

      def initialize()
        @_data_source   = SknApp.registry.resolve("data_source")
        @_subscriptions = subscriptions_restore
        SknApp.logger.debug "#{self.class.name}.#{__method__}"
      end

      def handle_queue_event?(queue_event)
        !!@_subscriptions.detect {|subscript| subscript.handle_queue_event?(queue_event) }
      end

      def subscriptions
        @_subscriptions
      end

      def create_subscription(device_obj:, firmware_obj:)
        subscript = Homie::Components::Subscription.new(firmware: firmware_obj, device: device_obj )
        subscription_add(subscript)
        subscript
      rescue => e
        msg =  "#{self.class.name}##{__method__} Create Failed: klass=#{e.class.name}, cause=#{e.message}, Backtrace=#{e.backtrace[0..4]}"
        SknApp.logger.warn(msg)
        false
      end

      def subscription_add(obj)
        unless @_subscriptions.detect {|sub| sub.eql?(obj) }
          @_subscriptions.push(obj)
          subscription_save(@_subscriptions)
        end
        true  # no leaking objects
      end

      def subscription_delete(obj)
        subscription_save(@_subscriptions) if !!@_subscriptions.delete(obj)
        true
      rescue => e
        SknApp.logger.error "#{self.class.name}##{__method__}: #{e.class} causedBy #{ e.msg }, with inputData: [#{obj}]"
        false
      end

      def subscription_save(ary)
        @_data_source.transaction { @_data_source[:subscriptions] = ary }
      rescue => e
        SknApp.logger.error "#{self.class.name}##{__method__}: #{e.class} causedBy #{ e.msg }, with inputData: [#{ary}]"
        false
      end

      def subscriptions_restore
        @_data_source.transaction { @_data_source.fetch(:subscriptions, []) }
      rescue => e
        SknApp.logger.error "#{self.class.name}##{__method__}: #{e.class} causedBy #{ e.msg }"
        []
      end


    end
  end
end
