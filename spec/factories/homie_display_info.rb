# ##
# Display Data for Testing

module HomieDisplayInfo

  def manager_catalog
    [{:klass=>"Device",
      :name=>"TheaterIR",
      :value=>"Theater IR Server",
      :homie=>"3.0.1",
      :state=>"ready",
      :localip=>"10.100.1.215",
      :mac=>"5C:CF:7F:63:30:AF",
      :stats=>
          {:klass=>"Stats",
           :name=>"interval",
           :value=>"0",
           :signal=>"42",
           :uptime=>"245887",
           :interval=>nil,
           :properties=>
               [{:klass=>"Property", :name=>"interval", :value=>"0", :attributes=>[]},
                {:klass=>"Property", :name=>"signal", :value=>"42", :attributes=>[]},
                {:klass=>"Property",
                 :name=>"uptime",
                 :value=>"245887",
                 :attributes=>[]}]},
      :implementation=>
          {:klass=>"Implementation",
           :name=>"config",
           :value=>
               "{\"name\":\"Theater IR Server\",\"device_id\":\"TheaterIR\",\"device_stats_interval\":180,\"wifi\":{\"ssid\":\"SFNSS1-24G\"},\"mqtt\":{\"host\":\"openhabianpi.skoona.net\",\"port\":1883,\"base_topic\":\"sknSensors/\",\"auth\":true},\"ota\":{\"enabled\":true},\"settings\":{\"sensorsInterval\":300,\"onSequence\":\"3,2FD48B7,32 43,5006,16 3,4BB620DF,32 3,4BB6F00F,32\",\"offSequence\":\"3,2FD48B7,32 43,5006,16 3,4B36E21D,32\"}}",
           :config=>
               "{\"name\":\"Theater IR Server\",\"device_id\":\"TheaterIR\",\"device_stats_interval\":180,\"wifi\":{\"ssid\":\"SFNSS1-24G\"},\"mqtt\":{\"host\":\"openhabianpi.skoona.net\",\"port\":1883,\"base_topic\":\"sknSensors/\",\"auth\":true},\"ota\":{\"enabled\":true},\"settings\":{\"sensorsInterval\":300,\"onSequence\":\"3,2FD48B7,32 43,5006,16 3,4BB620DF,32 3,4BB6F00F,32\",\"offSequence\":\"3,2FD48B7,32 43,5006,16 3,4B36E21D,32\"}}",
           :version=>"3.0.0",
           "ota.enabled"=>nil,
           :properties=>
               [{:klass=>"Property",
                 :name=>"config",
                 :value=>
                     "{\"name\":\"Theater IR Server\",\"device_id\":\"TheaterIR\",\"device_stats_interval\":180,\"wifi\":{\"ssid\":\"SFNSS1-24G\"},\"mqtt\":{\"host\":\"openhabianpi.skoona.net\",\"port\":1883,\"base_topic\":\"sknSensors/\",\"auth\":true},\"ota\":{\"enabled\":true},\"settings\":{\"sensorsInterval\":300,\"onSequence\":\"3,2FD48B7,32 43,5006,16 3,4BB620DF,32 3,4BB6F00F,32\",\"offSequence\":\"3,2FD48B7,32 43,5006,16 3,4B36E21D,32\"}}",
                 :attributes=>[]},
                {:klass=>"Property", :name=>"version", :value=>"3.0.0", :attributes=>[]},
                {:klass=>"Property",
                 :name=>"ota.enabled",
                 :value=>"true",
                 :attributes=>[]}]},
      :firmware=>
          {:klass=>"Firmware",
           :name=>"name",
           :value=>"sknSensors-IRService.d1_mini",
           :version=>"0.2.0",
           :checksum=>"934a0239a5b8513b09e16765dfdba9b5",
           :properties=>
               [{:klass=>"Property",
                 :name=>"name",
                 :value=>"sknSensors-IRService.d1_mini",
                 :attributes=>[]},
                {:klass=>"Property", :name=>"version", :value=>"0.2.0", :attributes=>[]},
                {:klass=>"Property",
                 :name=>"checksum",
                 :value=>"934a0239a5b8513b09e16765dfdba9b5",
                 :attributes=>[]}]},
      :attributes=>
          [{:klass=>"Attribute", :name=>"$state", :value=>"ready", :properties=>[]},
           {:klass=>"Attribute", :name=>"$homie", :value=>"3.0.1", :properties=>[]},
           {:klass=>"Attribute",
            :name=>"$name",
            :value=>"Theater IR Server",
            :properties=>[]},
           {:klass=>"Attribute",
            :name=>"$mac",
            :value=>"5C:CF:7F:63:30:AF",
            :properties=>[]},
           {:klass=>"Attribute",
            :name=>"$localip",
            :value=>"10.100.1.215",
            :properties=>[]},
           {:klass=>"Attribute",
            :name=>"$nodes",
            :value=>"irservice",
            :properties=>[]},
           {:klass=>"Attribute", :name=>"$stats", :value=>"uptime", :properties=>[]},
           {:klass=>"Attribute",
            :name=>"$implementation",
            :value=>"esp8266",
            :properties=>[]}],
      :nodes=>
          ["irservice",
           [{:klass=>"Node",
             :name=>"irservice",
             :value=>"IR Provider",
             :type=>"theater-remote",
             :array=>nil,
             :properties=>
                 ["command,received",
                  [{:klass=>"Property",
                    :name=>"command",
                    :value=>"IR Broadcaster",
                    :attributes=>
                        [{:klass=>"Attribute",
                          :name=>"$name",
                          :value=>"IR Broadcaster",
                          :properties=>[]},
                         {:klass=>"Attribute",
                          :name=>"$settable",
                          :value=>"true",
                          :properties=>[]},
                         {:klass=>"Attribute",
                          :name=>"$datatype",
                          :value=>"string",
                          :properties=>[]},
                         {:klass=>"Attribute",
                          :name=>"$unit",
                          :value=>"%s",
                          :properties=>[]}]},
                   {:klass=>"Property",
                    :name=>"received",
                    :value=>"IR Listener",
                    :attributes=>
                        [{:klass=>"Attribute",
                          :name=>"$name",
                          :value=>"IR Listener",
                          :properties=>[]},
                         {:klass=>"Attribute",
                          :name=>"$datatype",
                          :value=>"string",
                          :properties=>[]},
                         {:klass=>"Attribute",
                          :name=>"$unit",
                          :value=>"%s",
                          :properties=>[]}]}]],
             :attributes=>
                 [{:klass=>"Attribute",
                   :name=>"$name",
                   :value=>"IR Provider",
                   :properties=>[]},
                  {:klass=>"Attribute",
                   :name=>"$type",
                   :value=>"theater-remote",
                   :properties=>[]},
                  {:klass=>"Attribute",
                   :name=>"$properties",
                   :value=>"command,received",
                   :properties=>[]}]}]]},
     {:klass=>"Device",
      :name=>"GuestRoom",
      :value=>"Guest Room",
      :homie=>"3.0.1",
      :state=>"ready",
      :localip=>"10.100.1.230",
      :mac=>"BC:DD:C2:81:04:72",
      :stats=>
          {:klass=>"Stats",
           :name=>"interval",
           :value=>"0",
           :signal=>"36",
           :uptime=>"1156122",
           :interval=>nil,
           :properties=>
               [{:klass=>"Property", :name=>"interval", :value=>"0", :attributes=>[]},
                {:klass=>"Property", :name=>"signal", :value=>"36", :attributes=>[]},
                {:klass=>"Property",
                 :name=>"uptime",
                 :value=>"1156122",
                 :attributes=>[]}]},
      :implementation=>
          {:klass=>"Implementation",
           :name=>"config",
           :value=>
               "{\"name\":\"Guest Room\",\"device_id\":\"GuestRoom\",\"device_stats_interval\":180,\"wifi\":{\"ssid\":\"SFNSS1-24G\"},\"mqtt\":{\"host\":\"openhabianpi.skoona.net\",\"port\":1883,\"base_topic\":\"sknSensors/\",\"auth\":true},\"ota\":{\"enabled\":true},\"settings\":{\"sensorsInterval\":300}}",
           :config=>
               "{\"name\":\"Guest Room\",\"device_id\":\"GuestRoom\",\"device_stats_interval\":180,\"wifi\":{\"ssid\":\"SFNSS1-24G\"},\"mqtt\":{\"host\":\"openhabianpi.skoona.net\",\"port\":1883,\"base_topic\":\"sknSensors/\",\"auth\":true},\"ota\":{\"enabled\":true},\"settings\":{\"sensorsInterval\":300}}",
           :version=>"3.0.0",
           "ota.enabled"=>nil,
           :properties=>
               [{:klass=>"Property",
                 :name=>"config",
                 :value=>
                     "{\"name\":\"Guest Room\",\"device_id\":\"GuestRoom\",\"device_stats_interval\":180,\"wifi\":{\"ssid\":\"SFNSS1-24G\"},\"mqtt\":{\"host\":\"openhabianpi.skoona.net\",\"port\":1883,\"base_topic\":\"sknSensors/\",\"auth\":true},\"ota\":{\"enabled\":true},\"settings\":{\"sensorsInterval\":300}}",
                 :attributes=>[]},
                {:klass=>"Property", :name=>"version", :value=>"3.0.0", :attributes=>[]},
                {:klass=>"Property",
                 :name=>"ota.enabled",
                 :value=>"true",
                 :attributes=>[]}]},
      :firmware=>
          {:klass=>"Firmware",
           :name=>"name",
           :value=>"sknSensors-Rcwl_Dht22",
           :version=>"0.2.5",
           :checksum=>"b3f61ac429e0d5371aff0e651759be5c",
           :properties=>
               [{:klass=>"Property",
                 :name=>"name",
                 :value=>"sknSensors-Rcwl_Dht22",
                 :attributes=>[]},
                {:klass=>"Property", :name=>"version", :value=>"0.2.5", :attributes=>[]},
                {:klass=>"Property",
                 :name=>"checksum",
                 :value=>"b3f61ac429e0d5371aff0e651759be5c",
                 :attributes=>[]}]},
      :attributes=>
          [{:klass=>"Attribute", :name=>"$state", :value=>"ready", :properties=>[]},
           {:klass=>"Attribute", :name=>"$homie", :value=>"3.0.1", :properties=>[]},
           {:klass=>"Attribute",
            :name=>"$name",
            :value=>"Guest Room",
            :properties=>[]},
           {:klass=>"Attribute",
            :name=>"$mac",
            :value=>"BC:DD:C2:81:04:72",
            :properties=>[]},
           {:klass=>"Attribute",
            :name=>"$localip",
            :value=>"10.100.1.230",
            :properties=>[]},
           {:klass=>"Attribute",
            :name=>"$nodes",
            :value=>"motion,temperature,humidity",
            :properties=>[]},
           {:klass=>"Attribute", :name=>"$stats", :value=>"uptime", :properties=>[]},
           {:klass=>"Attribute",
            :name=>"$implementation",
            :value=>"esp8266",
            :properties=>[]}],
      :nodes=>
          ["motion,temperature,humidity",
           [{:klass=>"Node",
             :name=>"motion",
             :value=>"Humans Present",
             :type=>"motion",
             :array=>nil,
             :properties=>
                 ["motion",
                  [{:klass=>"Property",
                    :name=>"motion",
                    :value=>"false",
                    :attributes=>
                        [{:klass=>"Attribute",
                          :name=>"$name",
                          :value=>"Motion",
                          :properties=>[]},
                         {:klass=>"Attribute",
                          :name=>"$datatype",
                          :value=>"boolean",
                          :properties=>[]},
                         {:klass=>"Attribute",
                          :name=>"$unit",
                          :value=>"s",
                          :properties=>[]}]}]],
             :attributes=>
                 [{:klass=>"Attribute",
                   :name=>"$name",
                   :value=>"Humans Present",
                   :properties=>[]},
                  {:klass=>"Attribute",
                   :name=>"$type",
                   :value=>"motion",
                   :properties=>[]},
                  {:klass=>"Attribute",
                   :name=>"$properties",
                   :value=>"motion",
                   :properties=>[]}]},
            {:klass=>"Node",
             :name=>"temperature",
             :value=>"Room Temperature",
             :type=>"temperature",
             :array=>nil,
             :properties=>
                 ["degrees",
                  [{:klass=>"Property",
                    :name=>"degrees",
                    :value=>"73.40",
                    :attributes=>
                        [{:klass=>"Attribute",
                          :name=>"$name",
                          :value=>"Degrees",
                          :properties=>[]},
                         {:klass=>"Attribute",
                          :name=>"$datatype",
                          :value=>"float",
                          :properties=>[]},
                         {:klass=>"Attribute",
                          :name=>"$unit",
                          :value=>"ºF",
                          :properties=>[]}]}]],
             :attributes=>
                 [{:klass=>"Attribute",
                   :name=>"$name",
                   :value=>"Room Temperature",
                   :properties=>[]},
                  {:klass=>"Attribute",
                   :name=>"$type",
                   :value=>"temperature",
                   :properties=>[]},
                  {:klass=>"Attribute",
                   :name=>"$properties",
                   :value=>"degrees",
                   :properties=>[]}]},
            {:klass=>"Node",
             :name=>"humidity",
             :value=>"Room Humidity",
             :type=>"humidity",
             :array=>nil,
             :properties=>
                 ["percent",
                  [{:klass=>"Property",
                    :name=>"percent",
                    :value=>"27.80",
                    :attributes=>
                        [{:klass=>"Attribute",
                          :name=>"$name",
                          :value=>"Percent",
                          :properties=>[]},
                         {:klass=>"Attribute",
                          :name=>"$datatype",
                          :value=>"float",
                          :properties=>[]},
                         {:klass=>"Attribute",
                          :name=>"$unit",
                          :value=>"%",
                          :properties=>[]}]}]],
             :attributes=>
                 [{:klass=>"Attribute",
                   :name=>"$name",
                   :value=>"Room Humidity",
                   :properties=>[]},
                  {:klass=>"Attribute",
                   :name=>"$type",
                   :value=>"humidity",
                   :properties=>[]},
                  {:klass=>"Attribute",
                   :name=>"$properties",
                   :value=>"percent",
                   :properties=>[]}]}]]},
     {:klass=>"Device",
      :name=>"HomeOffice",
      :value=>"Home Office",
      :homie=>"3.0.1",
      :state=>"ready",
      :localip=>"10.100.1.163",
      :mac=>"84:F3:EB:B7:55:D5",
      :stats=>
          {:klass=>"Stats",
           :name=>"interval",
           :value=>"0",
           :signal=>"40",
           :uptime=>"409456",
           :interval=>nil,
           :properties=>
               [{:klass=>"Property", :name=>"interval", :value=>"0", :attributes=>[]},
                {:klass=>"Property", :name=>"signal", :value=>"40", :attributes=>[]},
                {:klass=>"Property",
                 :name=>"uptime",
                 :value=>"409456",
                 :attributes=>[]}]},
      :implementation=>
          {:klass=>"Implementation",
           :name=>"config",
           :value=>
               "{\"name\":\"Home Office\",\"device_id\":\"HomeOffice\",\"device_stats_interval\":180,\"wifi\":{\"ssid\":\"SFNSS1-24G\"},\"mqtt\":{\"host\":\"openhabianpi.skoona.net\",\"port\":1883,\"base_topic\":\"sknSensors/\",\"auth\":true},\"ota\":{\"enabled\":true},\"settings\":{\"sensorsInterval\":300}}",
           :config=>
               "{\"name\":\"Home Office\",\"device_id\":\"HomeOffice\",\"device_stats_interval\":180,\"wifi\":{\"ssid\":\"SFNSS1-24G\"},\"mqtt\":{\"host\":\"openhabianpi.skoona.net\",\"port\":1883,\"base_topic\":\"sknSensors/\",\"auth\":true},\"ota\":{\"enabled\":true},\"settings\":{\"sensorsInterval\":300}}",
           :version=>"3.0.0",
           "ota.enabled"=>nil,
           :properties=>
               [{:klass=>"Property",
                 :name=>"config",
                 :value=>
                     "{\"name\":\"Home Office\",\"device_id\":\"HomeOffice\",\"device_stats_interval\":180,\"wifi\":{\"ssid\":\"SFNSS1-24G\"},\"mqtt\":{\"host\":\"openhabianpi.skoona.net\",\"port\":1883,\"base_topic\":\"sknSensors/\",\"auth\":true},\"ota\":{\"enabled\":true},\"settings\":{\"sensorsInterval\":300}}",
                 :attributes=>[]},
                {:klass=>"Property", :name=>"version", :value=>"3.0.0", :attributes=>[]},
                {:klass=>"Property",
                 :name=>"ota.enabled",
                 :value=>"true",
                 :attributes=>[]}]},
      :firmware=>
          {:klass=>"Firmware",
           :name=>"name",
           :value=>"sknSensors-Rcwl_Dht11",
           :version=>"0.2.5",
           :checksum=>"aff42a25572516ac5abbca989ddaf2aa",
           :properties=>
               [{:klass=>"Property",
                 :name=>"name",
                 :value=>"sknSensors-Rcwl_Dht11",
                 :attributes=>[]},
                {:klass=>"Property", :name=>"version", :value=>"0.2.5", :attributes=>[]},
                {:klass=>"Property",
                 :name=>"checksum",
                 :value=>"aff42a25572516ac5abbca989ddaf2aa",
                 :attributes=>[]}]},
      :attributes=>
          [{:klass=>"Attribute", :name=>"$state", :value=>"ready", :properties=>[]},
           {:klass=>"Attribute", :name=>"$homie", :value=>"3.0.1", :properties=>[]},
           {:klass=>"Attribute",
            :name=>"$name",
            :value=>"Home Office",
            :properties=>[]},
           {:klass=>"Attribute",
            :name=>"$mac",
            :value=>"84:F3:EB:B7:55:D5",
            :properties=>[]},
           {:klass=>"Attribute",
            :name=>"$localip",
            :value=>"10.100.1.163",
            :properties=>[]},
           {:klass=>"Attribute",
            :name=>"$nodes",
            :value=>"motion,temperature,humidity",
            :properties=>[]},
           {:klass=>"Attribute", :name=>"$stats", :value=>"uptime", :properties=>[]},
           {:klass=>"Attribute",
            :name=>"$implementation",
            :value=>"esp8266",
            :properties=>[]}],
      :nodes=>
          ["motion,temperature,humidity",
           [{:klass=>"Node",
             :name=>"motion",
             :value=>"Humans Present",
             :type=>"motion",
             :array=>nil,
             :properties=>
                 ["motion",
                  [{:klass=>"Property",
                    :name=>"motion",
                    :value=>"false",
                    :attributes=>
                        [{:klass=>"Attribute",
                          :name=>"$name",
                          :value=>"Motion",
                          :properties=>[]},
                         {:klass=>"Attribute",
                          :name=>"$datatype",
                          :value=>"boolean",
                          :properties=>[]},
                         {:klass=>"Attribute",
                          :name=>"$unit",
                          :value=>"s",
                          :properties=>[]}]}]],
             :attributes=>
                 [{:klass=>"Attribute",
                   :name=>"$name",
                   :value=>"Humans Present",
                   :properties=>[]},
                  {:klass=>"Attribute",
                   :name=>"$type",
                   :value=>"motion",
                   :properties=>[]},
                  {:klass=>"Attribute",
                   :name=>"$properties",
                   :value=>"motion",
                   :properties=>[]}]},
            {:klass=>"Node",
             :name=>"temperature",
             :value=>"Room Temperature",
             :type=>"temperature",
             :array=>nil,
             :properties=>
                 ["degrees",
                  [{:klass=>"Property",
                    :name=>"degrees",
                    :value=>"69.80",
                    :attributes=>
                        [{:klass=>"Attribute",
                          :name=>"$name",
                          :value=>"Degrees",
                          :properties=>[]},
                         {:klass=>"Attribute",
                          :name=>"$datatype",
                          :value=>"float",
                          :properties=>[]},
                         {:klass=>"Attribute",
                          :name=>"$unit",
                          :value=>"ºF",
                          :properties=>[]}]}]],
             :attributes=>
                 [{:klass=>"Attribute",
                   :name=>"$name",
                   :value=>"Room Temperature",
                   :properties=>[]},
                  {:klass=>"Attribute",
                   :name=>"$type",
                   :value=>"temperature",
                   :properties=>[]},
                  {:klass=>"Attribute",
                   :name=>"$properties",
                   :value=>"degrees",
                   :properties=>[]}]},
            {:klass=>"Node",
             :name=>"humidity",
             :value=>"Room Humidity",
             :type=>"humidity",
             :array=>nil,
             :properties=>
                 ["percent",
                  [{:klass=>"Property",
                    :name=>"percent",
                    :value=>"25.00",
                    :attributes=>
                        [{:klass=>"Attribute",
                          :name=>"$name",
                          :value=>"Percent",
                          :properties=>[]},
                         {:klass=>"Attribute",
                          :name=>"$datatype",
                          :value=>"float",
                          :properties=>[]},
                         {:klass=>"Attribute",
                          :name=>"$unit",
                          :value=>"%",
                          :properties=>[]}]}]],
             :attributes=>
                 [{:klass=>"Attribute",
                   :name=>"$name",
                   :value=>"Room Humidity",
                   :properties=>[]},
                  {:klass=>"Attribute",
                   :name=>"$type",
                   :value=>"humidity",
                   :properties=>[]},
                  {:klass=>"Attribute",
                   :name=>"$properties",
                   :value=>"percent",
                   :properties=>[]}]}]]},
     {:klass=>"Device",
      :name=>"MediaRoom",
      :value=>"Media Room",
      :homie=>"3.0.1",
      :state=>"ready",
      :localip=>"10.100.1.229",
      :mac=>"B4:E6:2D:15:50:3A",
      :stats=>
          {:klass=>"Stats",
           :name=>"interval",
           :value=>"0",
           :signal=>"28",
           :uptime=>"331532",
           :interval=>nil,
           :properties=>
               [{:klass=>"Property", :name=>"interval", :value=>"0", :attributes=>[]},
                {:klass=>"Property", :name=>"signal", :value=>"28", :attributes=>[]},
                {:klass=>"Property",
                 :name=>"uptime",
                 :value=>"331532",
                 :attributes=>[]}]},
      :implementation=>
          {:klass=>"Implementation",
           :name=>"config",
           :value=>
               "{\"name\":\"Media Room\",\"device_id\":\"MediaRoom\",\"device_stats_interval\":180,\"wifi\":{\"ssid\":\"SFNSS1-24G\"},\"mqtt\":{\"host\":\"openhabianpi.skoona.net\",\"port\":1883,\"base_topic\":\"sknSensors/\",\"auth\":true},\"ota\":{\"enabled\":true},\"settings\":{\"sensorsInterval\":300}}",
           :config=>
               "{\"name\":\"Media Room\",\"device_id\":\"MediaRoom\",\"device_stats_interval\":180,\"wifi\":{\"ssid\":\"SFNSS1-24G\"},\"mqtt\":{\"host\":\"openhabianpi.skoona.net\",\"port\":1883,\"base_topic\":\"sknSensors/\",\"auth\":true},\"ota\":{\"enabled\":true},\"settings\":{\"sensorsInterval\":300}}",
           :version=>"3.0.0",
           "ota.enabled"=>nil,
           :properties=>
               [{:klass=>"Property",
                 :name=>"config",
                 :value=>
                     "{\"name\":\"Media Room\",\"device_id\":\"MediaRoom\",\"device_stats_interval\":180,\"wifi\":{\"ssid\":\"SFNSS1-24G\"},\"mqtt\":{\"host\":\"openhabianpi.skoona.net\",\"port\":1883,\"base_topic\":\"sknSensors/\",\"auth\":true},\"ota\":{\"enabled\":true},\"settings\":{\"sensorsInterval\":300}}",
                 :attributes=>[]},
                {:klass=>"Property", :name=>"version", :value=>"3.0.0", :attributes=>[]},
                {:klass=>"Property",
                 :name=>"ota.enabled",
                 :value=>"true",
                 :attributes=>[]}]},
      :firmware=>
          {:klass=>"Firmware",
           :name=>"name",
           :value=>"sknSensors-Rcwl_Dht22",
           :version=>"0.2.5",
           :checksum=>"b3f61ac429e0d5371aff0e651759be5c",
           :properties=>
               [{:klass=>"Property",
                 :name=>"name",
                 :value=>"sknSensors-Rcwl_Dht22",
                 :attributes=>[]},
                {:klass=>"Property", :name=>"version", :value=>"0.2.5", :attributes=>[]},
                {:klass=>"Property",
                 :name=>"checksum",
                 :value=>"b3f61ac429e0d5371aff0e651759be5c",
                 :attributes=>[]}]},
      :attributes=>
          [{:klass=>"Attribute", :name=>"$state", :value=>"ready", :properties=>[]},
           {:klass=>"Attribute", :name=>"$homie", :value=>"3.0.1", :properties=>[]},
           {:klass=>"Attribute",
            :name=>"$name",
            :value=>"Media Room",
            :properties=>[]},
           {:klass=>"Attribute",
            :name=>"$mac",
            :value=>"B4:E6:2D:15:50:3A",
            :properties=>[]},
           {:klass=>"Attribute",
            :name=>"$localip",
            :value=>"10.100.1.229",
            :properties=>[]},
           {:klass=>"Attribute",
            :name=>"$nodes",
            :value=>"motion,temperature,humidity",
            :properties=>[]},
           {:klass=>"Attribute", :name=>"$stats", :value=>"uptime", :properties=>[]},
           {:klass=>"Attribute",
            :name=>"$implementation",
            :value=>"esp8266",
            :properties=>[]}],
      :nodes=>
          ["motion,temperature,humidity",
           [{:klass=>"Node",
             :name=>"motion",
             :value=>"Humans Present",
             :type=>"motion",
             :array=>nil,
             :properties=>
                 ["motion",
                  [{:klass=>"Property",
                    :name=>"motion",
                    :value=>"true",
                    :attributes=>
                        [{:klass=>"Attribute",
                          :name=>"$name",
                          :value=>"Motion",
                          :properties=>[]},
                         {:klass=>"Attribute",
                          :name=>"$datatype",
                          :value=>"boolean",
                          :properties=>[]},
                         {:klass=>"Attribute",
                          :name=>"$unit",
                          :value=>"s",
                          :properties=>[]}]}]],
             :attributes=>
                 [{:klass=>"Attribute",
                   :name=>"$name",
                   :value=>"Humans Present",
                   :properties=>[]},
                  {:klass=>"Attribute",
                   :name=>"$type",
                   :value=>"motion",
                   :properties=>[]},
                  {:klass=>"Attribute",
                   :name=>"$properties",
                   :value=>"motion",
                   :properties=>[]}]},
            {:klass=>"Node",
             :name=>"temperature",
             :value=>"Room Temperature",
             :type=>"temperature",
             :array=>nil,
             :properties=>
                 ["degrees",
                  [{:klass=>"Property",
                    :name=>"degrees",
                    :value=>"67.64",
                    :attributes=>
                        [{:klass=>"Attribute",
                          :name=>"$name",
                          :value=>"Degrees",
                          :properties=>[]},
                         {:klass=>"Attribute",
                          :name=>"$datatype",
                          :value=>"float",
                          :properties=>[]},
                         {:klass=>"Attribute",
                          :name=>"$unit",
                          :value=>"ºF",
                          :properties=>[]}]}]],
             :attributes=>
                 [{:klass=>"Attribute",
                   :name=>"$name",
                   :value=>"Room Temperature",
                   :properties=>[]},
                  {:klass=>"Attribute",
                   :name=>"$type",
                   :value=>"temperature",
                   :properties=>[]},
                  {:klass=>"Attribute",
                   :name=>"$properties",
                   :value=>"degrees",
                   :properties=>[]}]},
            {:klass=>"Node",
             :name=>"humidity",
             :value=>"Room Humidity",
             :type=>"humidity",
             :array=>nil,
             :properties=>
                 ["percent",
                  [{:klass=>"Property",
                    :name=>"percent",
                    :value=>"27.40",
                    :attributes=>
                        [{:klass=>"Attribute",
                          :name=>"$name",
                          :value=>"Percent",
                          :properties=>[]},
                         {:klass=>"Attribute",
                          :name=>"$datatype",
                          :value=>"float",
                          :properties=>[]},
                         {:klass=>"Attribute",
                          :name=>"$unit",
                          :value=>"%",
                          :properties=>[]}]}]],
             :attributes=>
                 [{:klass=>"Attribute",
                   :name=>"$name",
                   :value=>"Room Humidity",
                   :properties=>[]},
                  {:klass=>"Attribute",
                   :name=>"$type",
                   :value=>"humidity",
                   :properties=>[]},
                  {:klass=>"Attribute",
                   :name=>"$properties",
                   :value=>"percent",
                   :properties=>[]}]}]]}
    ]
  end
end