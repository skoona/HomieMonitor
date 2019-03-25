# HomieMonitor
An exploration into [Homie-esp8266](https://homieiot.github.io/homie-esp8266/docs/develop/quickstart/getting-started/), using modules from [Dry-RB](http://dry-rb.org), 
[Paho.MQTT.Ruby](https://github.com/RubyDevInc/paho.mqtt.ruby), [JRuby](https://www.jruby.org) and 
[Roda](https://github.com/jeremyevans/roda) tooling.  This application is designed to act as a `Homie Controller`, or `Monitor`, 
in support of IOT/Devices using [Homie-esp8266](https://github.com/homieiot/homie-esp8266); although any `Homie Device` implementation should be supported.

#### References: 
* [Homie: An MQTT Convention for IOT/M2M](https://homieiot.github.io/specification/)
* [Homie-ESP8266 Example of RCWL-0516 Microwave Presence Detector and DHT22 Temperature and Humidity sensors](https://github.com/skoona/sknSensors-Rcwl_Dht22)

#### Screenshots
<img src="public/images/homepage.png" width="23%" /> <img src="public/images/devices.png" width="23%" /> <img src="public/images/details.png" width="23%" /> <img src="public/images/details-blink.png" width="23%" /> <img src="public/images/manage.png" width="23%" /> <img src="public/images/iphone-broadcasts.png" width="23%" /> <img src="public/images/iphone-discovered.png" width="23%" />

| | | |
|:-------------------------:|:-------------------------:|:-------------------------:|
|<img src="public/images/homepage.png" width="23%" />|<img src="public/images/devices.png" width="23%" />|<img src="public/images/details.png" width="23%" />|
|<img src="public/images/details-blink.png" width="23%" />|<img src="public/images/manage.png" width="23%" />|<img src="public/images/iphone-broadcasts.png" width="23%" />|
|<img src="public/images/iphone-discovered.png" width="23%" />||
 

#### Features
* Default build using `Ruby-2.6.2`, would require `Ruby-2.5.1+`
    * To use MRI edit `.ruby-version` and change `jruby-9.2.6.0` or `ruby-2.6.2`, then `$ bundle install`
* Monitor Homie V2, and V3 Devices (Initial Focus on `ESP8266`)
* Controller model for Esp8266 devices
* MQTT OTA operations
* `Discover Devices` page auto-refreshes every 30 seconds
* Self contained Application packaged as Java Executable warFile; using Warbler.gem -- port 8080
* Internally designed to tollerate potentially Homie Specification 1.5+, but focused on V3.
* Attribute and Property retention, via YAML:Store file, as Homie considers some discovery related attributes optional and they are not always retained!


## Demonstration Mode
If you do not have a MQTT Broker accessable, it is possible to use a mock mqtt stream.  Edit/create
your `./config/settings/development.local.yml` file and add the following starting at line 0 or 1:

    ---
    Packaging:
      short_name: esp
    
    content_service:
      demo_mode: true
    
    # ##
    # Override (restate) by development, stage, production, etc
    mqtt:
      debug_log_file: './log/paho.log'


The `content_service` entry controls which mqtt stream is used; live or mocked.  You can find the 
source files for the mock in directory: `./spec/factories/homie_*.txt`.  The class which transform these 
text entries into mqtt messages is `./main/homie/handlers/mock_stream.rb`

However, if MQTT `host` has not been configured, `demo_mode` will default to true!

    See `./spec/factories` and `./spec/support` for test data
        * `$  mosquitto_sub -v -h hostname -t homie/#  -u username -P password`
        * Above will produce a console log that can be used as test data by this system.


#### Shared Link for executable java warFile
    $ vim homieMonitor.sh  (* and supply values for mqtt and others, then execute
    $ cp <Downloads>/homie_monitor_esp-<version>.war $HOME/homieMonitor/bin/
     -- OR --
    $ java -jar homie_monitor_esp-<version>.war  (* demo mode
    
Too big for GitHub [HomieMonitor warFile](https://www.dropbox.com/sh/xpv5a6gyexthnev/AAB0eY59kxTsMQJg7FOT3Pw9a?dl=0)



## Following Along: Installation
#### (a) Ruby/JRuby
<dl>   
    <dt>Setup Application and Create Directories</dt>
        <dd><code>$ bin/setup</code></dd>
    <dt>Start Server with Puma, Port 8585:</dt>
        <dd><code>$ bundle exec puma config.ru -v</code></dd>
    <dt>Start Server with RackUp, Port 9292:</dt>
        <dd><code>$ rackup</code></dd>
    <dt>Start Console with Pry:</dt>
        <dd><code>$ bin/console</code></dd>
</dl>

#### (b) Java warFile
<dl>
    <dt>Download warFile and `homieMonitor.sh`</dt>
        <dd>[HomieMonitor warFile and script](https://www.dropbox.com/sh/xpv5a6gyexthnev/AAB0eY59kxTsMQJg7FOT3Pw9a?dl=0)</dd>
    <dt>Edit `homieMonitor.sh` script</dt>
        <dd>set your mqtt credentials</dd>
    <dt>Start the app on port 8585</dt>
        <dd><code>$ homieMonitor</code></dd>
</dl>

#### Helpful Environmental Vars
The configuration module will prefers environment variables over yaml config file values.

    RACK_ENV            defaults to `'development'`
    HM_MQTT_HOST        defaults are invalid
    HM_MQTT_PORT        defaults to 1883
    HM_MQTT_USER        defaults are invalid
    HM_MQTT_PASS        defaults are invalid
    HM_BASE_TOPICS      defaults to `'[["sknSensors/#",1],["homie/#",1]]'`

    HM_MQTT_SSL_ENABLE_FLAG defaults to false
    HM_MQTT_SSL_CERT_PATH   defaults are invalid
    HM_MQTT_SSL_KEY_PATH    defaults are invalid

    HM_MQTT_LOG         defaults to `/tmp/homieMonitor/paho-debug.log`
    HM_FIRMWARE_PATH    defaults to './content/firmwares/'
    HM_SPIFFS_PATH      defaults to './content/spiffs/'
    HM_DATA_STORE       defaults to './db/HomieMonitor_store.yml'
    HM_OTA_TYPE         binary, base64strict, base64, RFC4648_pad, RFC4648_no_pad 
                        - are the choice for OTA transmissions; defaults to `binary`

#### Example Bash script [homieMonitor.sh]

<details><summary>#### homieMonitor.sh</summary>
<p>

```bash
#!/bin/bash

# ##
# Setup HomieMonitor Java executable
# - Ref: https://github.com/skoona/HomieMonitor
#
# ##
#  Description
#  ----------------------------------------------
# RACK_ENV='production'         Use `production` for UI performance, or `development` for debug logging
# HM_MQTT_HOST='<mqtt-server-fqdn-or-ip_address>'
# HM_MQTT_PORT=<mqtt-connection-port>
# HM_MQTT_USER='<mqtt-username>'
# HM_MQTT_PASS='<mqtt-user-password>'
# HM_MQTT_SSL_ENABLE_FLAG defaults to false
# HM_MQTT_SSL_CERT_PATH   defaults are invalid, full-path required if ssl=true
# HM_MQTT_SSL_KEY_PATH    defaults are invalid, full-path required if ssl=true
# HM_BASE_TOPICS='[["sknSensors/#",1],["homie/#",1]]'   base mqtt message name <homie>/<device-id>/<node-id>/...
# HM_MQTT_LOG=`/tmp/homieMonitor/paho-debug.log`        extra mqtt specific logfile, from paho-mqtt-ruby.gem
# HM_FIRMWARE_PATH="$HOME/homieMonitor/content/firmwares/"      Directory to store uploaded homie Firmware
# HM_DATA_STORE="$HOME/homieMonitor/db/HomieMonitor_store.yml"  Full path and filename of YAML storage of OTA Subscriptions
# HM_OTA_TYPE='base64strict'          binary, base64strict, base64, RFC4648_pad, RFC4648_no_pad
#                                     - are the choice for OTA transmissions; defaults to `binary`

#
# Special Paths
# 1. with HM_MQTT_SSL_CERT_PATH & HM_MQTT_SSL_KEY_PATH value empty `''`, set HM_MQTT_SSL_ENABLE_FLAG='true'
# 2. if above fails then certs are required.  populate HM_MQTT_SSL_CERT_PATH & HM_MQTT_SSL_KEY_PATH with proper file paths
#

# Make runtime dirs
[ -w $HOME/homieMonitor/ ] || {
	echo 'Setting Up HomieMonitor' ;	 
	mkdir -p $HOME/homieMonitor/{content/firmwares,content/spiffs,db,bin,log} ;
}

# Set Environment Vars
RACK_ENV='production'
HM_MQTT_HOST='localhost'
# HM_MQTT_PORT=1883
# HM_MQTT_USER=''
# HM_MQTT_PASS=''
HM_BASE_TOPICS='[["sknSensors/#",1],["homie/#",1]]'
HM_MQTT_LOG="$HOME/homieMonitor/log/paho-debug.log"
HM_FIRMWARE_PATH="$HOME/homieMonitor/content/firmwares/"
HM_DATA_STORE="$HOME/homieMonitor/db/HomieMonitor_store.yml"
HM_OTA_TYPE='binary'
HM_MQTT_SSL_ENABLE_FLAG='false'
HM_MQTT_SSL_CERT_PATH=''
HM_MQTT_SSL_KEY_PATH=''


# Export Environment (not required)
export RACK_ENV HM_MQTT_HOST HM_MQTT_PORT HM_MQTT_USER HM_MQTT_PASS 
export HM_OTA_TYPE HM_MQTT_SSL_ENABLE_FLAG HM_MQTT_SSL_CERT_PATH HM_MQTT_SSL_KEY_PATH
export HM_BASE_TOPICS HM_MQTT_LOG HM_FIRMWARE_PATH HM_DATA_STORE 

# copy homie_monitor-0.7.1.war to bin directory
# cp -v $HOME/Downloads/homie_monitor* $HOME/homieMonitor/bin/

# Java warFile execution
# java -Dwarbler.port=8585 -jar $HOME/homieMonitor/bin/homie_monitor_esp-0.7.5.war

# or Ruby execution
bundle exec puma config.ru

#end

```

</p>
</details>


## Alternate Builds
To use MRI edit `.ruby-version` and change `jruby-9.2.6.0` to `ruby-2.6.2`, before proceeding.


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

Find me on Gitter!

## License

The application is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
