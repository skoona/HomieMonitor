# ##
# File: ./main/services/providers/registry.rb
# ##

# ##
# Manages Service initiation and dependencies
# - To be called from Roda Route Files
# - See html.helpers for invocation
# ##
module Services
  module Providers

    class Registry

      attr_reader :ctx, :req

      def initialize(args={})
        @ctx = args.fetch(:roda_context, nil)
        @req = @ctx.request
        raise ArgumentError, "No Routing Context provided during initialization!" if @ctx.nil?
      end

      def content_broadcasts
        SknApp.registry.resolve("content_provider").call( Commands::HomieBroadcasts.new() )
      end

      def content_devices
        SknApp.registry.resolve("content_provider").call( Commands::HomieDevices.new() )
      end

      def content_management
        SknApp.registry.resolve("content_provider").call( Commands::HomieManagement.new() )
      end

      def content_details(device_name)
        SknApp.registry.resolve("content_provider").call(
            Commands::HomieDevices.new(device_name: device_name) )
      end

      def content_message_transport
        SknApp.registry.resolve("content_action_provider").call(
            Commands::MessageTransport.new(JSON.parse(req.body.read)) ) # id: dd, topic: for_str:, value: }
      end

      def firmware_receive(payload)
        SknApp.registry.resolve("firmware_provider").call(
            Commands::ReceiveFile.new(payload) )
      end

      def firmware_delete(payload)
        SknApp.registry.resolve("firmware_provider").call(
            Commands::FirmwareDelete.new( payload ))
      end

      def schedule_entry_delete(payload)
        SknApp.registry.resolve("content_action_provider").call(
            Commands::ScheduleDelete.new( payload ))
      end

      def schedule_entry_add(payload)
        SknApp.registry.resolve("content_action_provider").call(
            Commands::ScheduleAdd.new( payload ))
      end

      def device_delete(payload)
        SknApp.registry.resolve("content_action_provider").call(
            Commands::DeviceDelete.new( payload["device_id"] ))
      end

      def monitor_settings
        SknApp.registry.resolve("content_action_provider").call(
            Commands::MonitorSettings.new())
      end

      def update_configuration(payload)
        SknApp.registry.resolve("content_action_provider").call(
            Commands::MonitorConfig.new( payload ))
      end

    end # end class
  end
end # end module
