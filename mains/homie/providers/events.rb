# File: ./main/homie/providers/events.rb
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
    class Events
      include Singleton

      def initialize()
        @_data_source   = SknApp.registry.resolve("data_source")
        @_events        = events_restore
        @_publishers    = []
        SknApp.logger.debug "#{self.class.name}.#{__method__}"
      end

      # Notify callback
      def change_event(event)
        @_events.push(event)
      end

      def events
        @_events
      end

      def events_add(obj)
        unless @_events.detect {|sub| sub.eql?(obj) }
          @_events.push(obj)
          events_save(@_events)
        end
        true  # no leaking objects
      end

      def events_delete(obj)
        events_save(@_events) if !!@_events.delete(obj)
        true
      end

      def events_save(ary)
        @_data_source.transaction { @_data_source[:events] = ary }
      end

      def events_restore
        @_data_source.transaction { @_data_source.fetch(:events, []) }
      end

    end
  end
end
