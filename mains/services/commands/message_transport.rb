# ##
# File: ./main/services/commands/message_transport.rb
#
#
# cmd = Services::Commands::MessageTransport.new(formatted_topic_sting: nil | 'TheaterIR' )
# ##

module Services
  module Commands

    class MessageTransport

      attr_reader :name, :value, :action

      def initialize(parms={})
        @name    = parms["formatted_topic_string"]
        @value   = parms["string_value"]
        @_retain = (parms["retain"] && parms["retain"].eql?("true") ? true : false)       # true, false
        @_qos    = parms.fetch("qos", 1).to_i              # 0, 1, 2
        @action  = "message_transport"
      end

      def id
        rand(1000)
      end
      def topic
        @name
      end
      def payload
        @value
      end
      def retain
        @_retain
      end
      def qos
        @_qos
      end

      def collection
        @action
      end

      def valid?
        !(name.blank? || value.blank?)
      end

    end

  end
end
