# File: ./main/homie/events/provider.rb
#
##
# Persistence via YAML and YAML::Store
# Ref: https://ruby-doc.org/stdlib-2.5.1/libdoc/yaml/rdoc/YAML/Store.html
# ##

module Homie
  module Events

    # ## Action Sources
    # $implementation/ota/firmware/<md5 checksum>
    # $implementation/ota/status
    #
    # ## Decision Sources
    # $fw/name
    # $fw/version
    # $fw/checksum
    class Provider
      include Singleton

      def initialize()
        @_data_source   = SknApp.registry.resolve("data_source")
        @_subscriptions = subscriptions_restore
        @_events        = []
        @_publishers    = []
      end

      # Notify callback
      def change_event(event)
        @_events.push(event)
      end

      def handle_queue_event?(queue_event)
        !!@_subscriptions.detect {|subscript| subscript.handle_subscription_event(queue_event) }
      end

      def subscriptions
        @_subscriptions
      end

      def create_subscription(device_obj:, firmware_obj:)
        subscript = Homie::Components::Subscription.new(firmware: firmware_obj, device: device_obj)
        subscription_add(subscript)
      rescue
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
      end

      def subscription_save(ary)
        @_data_source.transaction { @_data_source[:subscriptions] = ary }
      end

      def subscriptions_restore
        @_data_source.transaction { @_data_source.fetch(:subscriptions, []) }
      end

    end
  end
end
