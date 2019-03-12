# file: spec/support/messaging_stream_messages.rb
#

module QueueMessages

  #
  # MQTT Homie Message Types
  #

  def homie_broadcast
   SknHash.new({
                   id: 1,
                   topic: "sknSensors/$broadcast/controller",
                   payload: "HomieMonitor online"})
  end

  def device_attribute
    SknHash.new({
                    id: 1,
                    topic: "sknSensors/TheaterIR/$stats",
                    payload: "uptime"})
  end
  def device_attribute2
    SknHash.new({
                    id: 1,
                    topic: "sknSensors/TheaterIR/$stats",
                    payload: "ready"})
  end
  def device_stats_property
    SknHash.new({
                    id: 1,
                    topic: "sknSensors/TheaterIR/$stats/signal",
                    payload: "64"})
  end

  def device_firmware_property
    SknHash.new({
                    id: 1,
                    topic: "sknSensors/TheaterIR/$fw/name",
                    payload: "sknSensors-IRService.d1_mini"})
  end
  def device_firmware_property2
    SknHash.new({
                    id: 1,
                    topic: "sknSensors/TheaterIR/$fw/version",
                    payload: "1.0.1"})
  end

  def device_implementation_property
    SknHash.new({
                    id: 1,
                    topic: "sknSensors/TheaterIR/$implementation",
                    payload: "esp8266"})
  end
  def device_implementation_property2
    SknHash.new({
                    id: 1,
                    topic: "sknSensors/TheaterIR/$implementation/version",
                    payload: "uptime"})
  end


  def node_property_settable_attribute
    SknHash.new({
                    id: 1,
                    topic: "sknSensors/TheaterIR/irservice/command/$settable",
                    payload: "true"})
  end
  def node_property_set
   SknHash.new({
                   id: 1,
                   topic: "sknSensors/TheaterIR/irservice/command/set",
                   payload: "on"})
  end
  def node_property_attribute
   SknHash.new({
                   id: 1,
                   topic: "sknSensors/TheaterIR/irservice/command/$type",
                   payload: "float"})
  end
  def node_property
   SknHash.new({
                   id: 1,
                   topic: "sknSensors/TheaterIR/irservice/command",
                   payload: "on"})
  end
  def node_property2
    SknHash.new({
                    id: 2,
                    topic: "sknSensors/TheaterIR/irservice/command",
                    payload: "off"})
  end
  def node_attribute
   SknHash.new({
                   id: 1,
                   topic: "sknSensors/TheaterIR/irservice/$name",
                   payload: "irservice"})
  end


  def generate_queue_event(message)
    Homie::Commands::QueueEvent.new(message)
  end

end