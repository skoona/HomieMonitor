# ##
# File: ./main/services/services_registry.rb
# ##

# ##
# Manages Service initiation and dependencies
# - To be called from Roda Route Files
# - See html.helpers for invocation
# ##
module Services
  class ServicesRegistry

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

    # def firmware_send(payload)
    #   SknApp.registry.resolve("firmware_provider").call(
    #       Commands::SendFile.new(payload) )
    # end

  end # end class
end # end module
