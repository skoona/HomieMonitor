# File: ./main/homie/events/event.rb
#


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
    class Manager

      def initialize()
        @_events        = []
        @_subscriptions = []
        @_publishers    = []
        @_subscription_archive = YAML::Store.new(SknSetting.data_source.store)
      end

      # Notify callback
      def change_event(event)
        @_events.push(event)
      end

      def subscription_add(obj)

      end
      def subscription_delete(obj)

      end
      def subscriptions_list

      end
      def subscription_save

      end
      def subscriptions_restore

      end

      def store_key(event)
        event.topic_ary.join("/")
      end

    end
  end
end
