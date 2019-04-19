# ##
#
#
# Require:
# @_subscribers =  array in :initialize
# @_notify_topic_parts = queue_event.topic_parts in :handle_queue_event
#
# Class must also have tha :name attribute defined
# The some number of :watch_attribute(subscriber) invocations
#
# Subscribers require this method, call is synchronous!
# #  def attribute_changed(name, attr, old, new)
# #    ...
# #  end
module Homie
  module Components

    module Notifier

      def self.included(klass)
        klass.extend ClassMethods
      end

      def subscribe(obj_name, subscriber)
        if @name.eql?(obj_name)
          @_subscribers.push(subscriber) unless @_subscribers.include?(subscriber)
          true
        else
          false
        end
      end

      def unsubscribe(subscriber)
        @_subscribers.delete(subscriber)
        true
      end

      # `source` is copy of original
      # Remove the SubScriber array where found
      def initialize_copy(source)
        self.instance_variable_set(:@_subscribers, [])
        if self.respond_to?(:attributes)
          self.attributes.each do |attr|
            attr.properties.each do |prop|
              prop.instance_variable_set(:@_subscribers, [])
            end
          end
        end
        if self.respond_to?(:nodes)
          self.nodes.each do |node|
            node.properties.each do |prop|
              prop.instance_variable_set(:@_subscribers, [])
            end
            node.attributes.each do |attr|
              attr.properties.each do |prop|
                prop.instance_variable_set(:@_subscribers, [])
              end
            end
          end
        end
        # puts "#{self.class.name}##{__method__} INSPECT: #{source.inspect}"
        super
      end
      private_methods :initialize_copy

      module ClassMethods
        # create writer-with-notify and reader
        def watch_attributes(*attrs)
          attrs.each do |attr|
            instance_variable_set("@#{attr}", nil)
            define_method(attr) do
              instance_variable_get("@#{attr}")
            end
            define_method("#{attr}=") do |value|
              old_value = instance_variable_get("@#{attr}")
              unless (value == old_value)
                instance_variable_set("@#{attr}", value)
                @_subscribers.each do |subscriber|
                  subscriber.change_event(
                      Homie::Events::ValueChanged.new(topic_array: @_notify_topic_parts,
                                               source: attr,
                                               from: old_value,
                                               to: value,
                                               description: self.class.name )
                  )
                end
              end
            end
          end # loop on attrs
        end # end of attribute method
      end # end ClassMethods

    end # End Notify
  end# end Events
end  # end Homie