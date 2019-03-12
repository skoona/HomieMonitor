# ##
# File: ./web/views/helpers/homie_html_helpers.rb
#

class SknWeb

  # values
  # --------------------
  def get_property_attribute_value(node, pname, aname)
    get_attribute(get_property(node, pname), aname)&.value
  rescue => e
    # $stderr.puts "#{self.class.name}.#{__method__} #{e.class.name}, #{e.message}, #{e.backtrace[0..3]}"
    nil
  end
  def get_attribute_property_value(device, aname, pname)
    get_property(get_attribute(device, aname), pname)&.value
  rescue => e
    # $stderr.puts "#{self.class.name}.#{__method__} #{e.class.name}, #{e.message}, #{e.backtrace[0..3]}"
    nil
  end
  def get_attribute_value(device, name)
    get_attribute(device, name).value
  rescue => e
    # $stderr.puts "#{self.class.name}.#{__method__} #{e.class.name}, #{e.message}, #{e.backtrace[0..3]}"
    nil
  end

  def get_attribute(base_obj, name)
    base_obj&.attributes&.detect {|element| [name].include?(element[:name]) }
  end
  def get_property(base_obj, name)
    base_obj&.properties&.detect {|element| [name].include?(element[:name]) }
  end

  def get_online_value(device)
    device&.attributes&.any? do |attr|
      ['$state','$online'].include?(attr[:name]) and ['ready','true'].include?(attr[:value])
    end
  end

  # lists
  # --------------------
  def get_node(nodes, name)
    nodes.detect {|rec| rec.name.eql?(name)}
  end
  def attributes(base_obj)
    base_obj.attributes
  end
  def attribute_properties(base_obj,name)
    base_obj.attributes.detect {|rec| rec.name.eql?(name)}&.properties
  end
  def properties(base_obj)
    base_obj.properties
  end
  def property_attributes(base_obj,name)
    base_obj.properies.detect {|rec| rec.name.eql?(name)}&.attributes
  end

  # Special Handling V2
  # --------------------
  def v2_nodes(device)
    device.nodes.empty? ? (device.properties&.map {|rec| rec.name } || []) : device.nodes.map {|rec| rec.name }
  end

  def node_array_helper(device_hash)
    v3 = false
    nds = get_attribute_value(device_hash, '$nodes')&.split(',')
    puts "NDS-A:[#{nds}]:#{nds.class.name}"
    v3 = nds.is_a?(Array)
    nds = v2_nodes(device_hash) unless nds.is_a?(Array)
    puts "NDS-B:[#{nds}]:#{nds.class.name}"
    nds.empty? ? ( puts("V2 Properties: #{device_hash.properties}"); puts("V2 Attributes: #{device_hash.attributes}") ) : puts("V2 Node(s) Found ~> #{get_node(device_hash.nodes, nds.first) unless v3}")
    nds.is_a?(Array) ? nds : []
  end



end


#V2(B) Attributes:
# [
#   #<SknUtils::DottedHash:0x21927819 @container={:klass=>"Attribute", :name=>"$homie", :value=>"2.0.0", :properties=>[]}>,
#   #<SknUtils::DottedHash:0x379c021f @container={:klass=>"Attribute", :name=>"$mac", :value=>"B4:E6:2D:53:A8:F0", :properties=>[]}>,
#   #<SknUtils::DottedHash:0x3956fb31 @container={:klass=>"Attribute", :name=>"$name", :value=>"Blinking light", :properties=>[]}>,
#   #<SknUtils::DottedHash:0x4973c1d4 @container={:klass=>"Attribute", :name=>"$localip", :value=>"10.100.1.233", :properties=>[]}>,
#   #<SknUtils::DottedHash:0x7cb8b3f9 @container={:klass=>"Attribute", :name=>"$stats", :value=>"0",
#       :properties=>[
#             #<SknUtils::DottedHash:0x48c8b603 @container={:klass=>"Property", :name=>"interval", :value=>"0", :settable=>false, :attributes=>[]}>,
#             #<SknUtils::DottedHash:0x37c4fe7b @container={:klass=>"Property", :name=>"signal", :value=>"76", :settable=>false, :attributes=>[]}>,
#             #<SknUtils::DottedHash:0x7bcc0320 @container={:klass=>"Property", :name=>"uptime", :value=>"1", :settable=>false, :attributes=>[]}>
#   }>,
#   #<SknUtils::DottedHash:0x2d677307 @container={:klass=>"Attribute", :name=>"$fw", :value=>"light-onoff",
#       :properties=>[
#             #<SknUtils::DottedHash:0x30a34137 @container={:klass=>"Property", :name=>"name", :value=>"Homie-light-onoff", :settable=>false, :attributes=>[]}>,
#             #<SknUtils::DottedHash:0x53f4f292 @container={:klass=>"Property", :name=>"version", :value=>"2.0.1", :settable=>false, :attributes=>[]}>,
#             #<SknUtils::DottedHash:0x614db99f @container={:klass=>"Property", :name=>"checksum", :value=>"13c7297b4f3d85ea16ee1e5578dda3eb", :settable=>false, :attributes=>[]}>
#       ]
#   }>,
#   #<SknUtils::DottedHash:0x64797fbf @container={:klass=>"Attribute", :name=>"$implementation", :value=>"esp8266",
#       :properties=>[
#             #<SknUtils::DottedHash:0x37e8ad49 @container={:klass=>"Property", :name=>"config", :value=>"{\"name\":\"Blinking light\",\"device_id\":\"LabTarget\",\"device_stats_interval\":180,\"wifi\":{\"ssid\":\"SFNSS1-24G\"},\"mqtt\":{\"host\":\"openhabianpi.skoona.net\",\"port\":1883,\"base_topic\":\"sknSensors/\",\"auth\":true},\"ota\":{\"enabled\":true}}", :settable=>false, :attributes=>[]}>,
#             #<SknUtils::DottedHash:0x14e3dbf3 @container={:klass=>"Property", :name=>"version", :value=>"2.0.0", :settable=>false, :attributes=>[]}>,
#             #<SknUtils::DottedHash:0x89a2a96 @container={:klass=>"Property", :name=>"ota.enabled", :value=>"true", :settable=>false, :attributes=>[]}>
#       ]
#   }>,
#   #<SknUtils::DottedHash:0x72e1ad2 @container={:klass=>"Attribute", :name=>"$online", :value=>"true", :properties=>[]}>
# ]

# <tr id="HomeOffice" data-package="
#
# {
#     "klass":"device",
#     "name":"homeoffice",
#     "value":"home="" office",
#     "attributes":[
#         {"klass":"attribute","name":"$state","value":"ready","properties":[]},
#         {"klass":"attribute","name":"$homie","value":"3.0.1","properties":[]},
#         {"klass":"attribute","name":"$name","value":"home="" office","properties":[]},
#         {"klass":"attribute","name":"$mac","value":"84:f3:eb:b7:55:d5","properties":[]},
#         {"klass":"attribute","name":"$localip","value":"10.100.1.163","properties":[]},
#         {"klass":"attribute","name":"$nodes","value":"motion,temperature,humidity","properties":[]},
#         {"klass":"attribute","name":"$stats","value":"uptime","properties":[
#                     {"klass":"property","name":"interval","value":"0","settable":false,"attributes":[]},
#                     {"klass":"property","name":"signal","value":"40","settable":false,"attributes":[]},
#                     {"klass":"property","name":"uptime","value":"409816","settable":false,"attributes":[]}
#         ]},
#         {"klass":"attribute","name":"$fw","value":"sknsensors-rcwl_dht11","properties":[
#                     {"klass":"property","name":"name","value":"sknsensors-rcwl_dht11","settable":false,"attributes":[]},
#                     {"klass":"property","name":"version","value":"0.2.5","settable":false,"attributes":[]},
#                     {"klass":"property","name":"checksum","value":"aff42a25572516ac5abbca989ddaf2aa","settable":false,"attributes":[]}
#         ]},
#         {"klass":"attribute","name":"$implementation","value":"esp8266","properties":[
#                     {"klass":"property","name":"config","value":"{\"name\":\"home="" office\",\"device_id\":\"homeoffice\",\"device_stats_interval\":180,\"wifi\":{\"ssid\":\"sfnss1-24g\"},\"mqtt\":{\"host\":\"openhabianpi.skoona.net\",\"port\":1883,\"base_topic\":\"sknsensors="" \",\"auth\":true},\"ota\":{\"enabled\":true},\"settings\":{\"sensorsinterval\":300}}","settable":false,"attributes":[]},
#                     {"klass":"property","name":"version","value":"3.0.0","settable":false,"attributes":[]},
#                     {"klass":"property","name":"ota.enabled","value":"true","settable":false,"attributes":[]}
#         ]}
#     ],
#     "nodes":[
#     {
#         "klass":"node",
#         "name":"motion",
#         "value":"humans="" present",
#         "properties":[
#             {"klass":"property","name":"motion","value":"true","settable":false,"attributes":[
#                 {"klass":"attribute","name":"$name","value":"motion","properties":[]},
#                 {"klass":"attribute","name":"$datatype","value":"boolean","properties":[]},
#                 {"klass":"attribute","name":"$unit","value":"s","properties":[]}
#             ]}
#         ],
#         "attributes":[
#             {"klass":"attribute","name":"$name","value":"humans="" present","properties":[]},
#             {"klass":"attribute","name":"$type","value":"motion","properties":[]},
#             {"klass":"attribute","name":"$properties","value":"motion","properties":[]}
#         ]
#     },
#     {
#         "klass":"node",
#         "name":"temperature",
#         "value":"room="" temperature",
#         "properties":[
#             {"klass":"property","name":"degrees","value":"69.80","settable":false,"attributes":[
#                 {"klass":"attribute","name":"$name","value":"degrees","properties":[]},
#                 {"klass":"attribute","name":"$datatype","value":"float","properties":[]},
#                 {"klass":"attribute","name":"$unit","value":"ºf","properties":[]}
#             ]}
#         ],
#         "attributes":[
#             {"klass":"attribute","name":"$name","value":"room="" temperature","properties":[]},
#             {"klass":"attribute","name":"$type","value":"temperature","properties":[]},
#             {"klass":"attribute","name":"$properties","value":"degrees","properties":[]}
#         ]
#     },
#     {
#         "klass":"node",
#         "name":"humidity",
#         "value":"room="" humidity",
#         "properties":[
#             {"klass":"property","name":"percent","value":"25.00","settable":false,"attributes":[
#                 {"klass":"attribute","name":"$name","value":"percent","properties":[]},
#                 {"klass":"attribute","name":"$datatype","value":"float","properties":[]},
#                 {"klass":"attribute","name":"$unit","value":"%","properties":[]}
#             ]}
#         ],
#         "attributes":[
#             {"klass":"attribute","name":"$name","value":"room="" humidity","properties":[]},
#             {"klass":"attribute","name":"$type","value":"humidity","properties":[]},
#             {"klass":"attribute","name":"$properties","value":"percent","properties":[]}
#         ]
#     }
# ]
# }


# <tr id="TheaterIR" data-package="
#
# {
#   "klass":"device",
#   "name":"theaterir",
#   "value":"theater="" ir="" server",
#   "attributes":[
#       {"klass":"attribute","name":"$state","value":"ready","properties":[]},
#       {"klass":"attribute","name":"$homie","value":"3.0.1","properties":[]},
#       {"klass":"attribute","name":"$name","value":"theater="" server","properties":[]},
#       {"klass":"attribute","name":"$mac","value":"5c:cf:7f:63:30:af","properties":[]},
#       {"klass":"attribute","name":"$localip","value":"10.100.1.215","properties":[]},
#       {"klass":"attribute","name":"$nodes","value":"irservice","properties":[]},
#       {"klass":"attribute","name":"$stats","value":"uptime","properties":[
#             {"klass":"property","name":"interval","value":"0","settable":false,"attributes":[]},
#             {"klass":"property","name":"signal","value":"42","settable":false,"attributes":[]},
#             {"klass":"property","name":"uptime","value":"246247","settable":false,"attributes":[]}
#       ]},
#       {"klass":"attribute","name":"$fw","value":"sknsensors-irservice.d1_mini","properties":[
#             {"klass":"property","name":"name","value":"sknsensors-irservice.d1_mini","settable":false,"attributes":[]},
#             {"klass":"property","name":"version","value":"0.2.0","settable":false,"attributes":[]},
#             {"klass":"property","name":"checksum","value":"934a0239a5b8513b09e16765dfdba9b5","settable":false,"attributes":[]}
#       ]},
#       {"klass":"attribute","name":"$implementation","value":"esp8266","properties":[
#             {"klass":"property","name":"config","value":"{\"name\":\"theater="" server\",\"device_id\":\"theaterir\",\"device_stats_interval\":180,\"wifi\":{\"ssid\":\"sfnss1-24g\"},\"mqtt\":{\"host\":\"openhabianpi.skoona.net\",\"port\":1883,\"base_topic\":\"sknsensors="" \",\"auth\":true},\"ota\":{\"enabled\":true},\"settings\":{\"sensorsinterval\":300,\"onsequence\":\"3,2fd48b7,32="" 43,5006,16="" 3,4bb620df,32="" 3,4bb6f00f,32\",\"offsequence\":\"3,2fd48b7,32="" 3,4b36e21d,32\"}}","settable":false,"attributes":[]},
#             {"klass":"property","name":"version","value":"3.0.0","settable":false,"attributes":[]},
#             {"klass":"property","name":"ota.enabled","value":"true","settable":false,"attributes":[]}
#       ]}
#   ],
#   "nodes":[
#       {
#         "klass":"node",
#         "name":"irservice",
#         "value":"ir="" provider",
#         "properties":[
#               {"klass":"property","name":"command","value":"ir="" broadcaster","settable":true,"attributes":[
#                     {"klass":"attribute","name":"$name","value":"ir="" broadcaster","properties":[]},
#                     {"klass":"attribute","name":"$settable","value":"true","properties":[]},
#                     {"klass":"attribute","name":"$datatype","value":"string","properties":[]},
#                     {"klass":"attribute","name":"$unit","value":"%s","properties":[]}
#               ]},
#               {"klass":"property","name":"received","value":"ir="" listener","settable":false,"attributes":[
#                     {"klass":"attribute","name":"$name","value":"ir="" listener","properties":[]},
#                     {"klass":"attribute","name":"$datatype","value":"string","properties":[]},
#                     {"klass":"attribute","name":"$unit","value":"%s","properties":[]}
#               ]}],
#         "attributes":[
#               {"klass":"attribute","name":"$name","value":"ir="" provider","properties":[]},
#               {"klass":"attribute","name":"$type","value":"theater-remote","properties":[]},
#               {"klass":"attribute","name":"$properties","value":"command,received","properties":[]}
#         ]}
#   ]
# }
