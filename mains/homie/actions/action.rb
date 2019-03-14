

module Homie
  module Handlers

    class Action

      def self.call(params)
        new(params).call
      end

      def initialize(params)
        @options = params
      end

      def call
        # do work
      end
    end
  end
end