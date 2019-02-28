# fluent-plugin-udp_forward

#### Overview

This fluent input plugin allows you to collect incoming events over UDP.
While fluentd's default UDP Input plugin supports adding a tag to the received message statically by configuration,
it does not support extracting a tag from the received message.
This plugin supports extracting the tag from incoming events over UDP. UDP events should be in JSON format.

#### Installation

    gem install fluent-plugin-udp_forward

#### Configuration

    <source>
        @type udp_forward
        bind "localhost"          
        port 5160
        tag_key "tag"
        message_key "data"
     </source>
   
 Optional parameters are as follows:

- bind: The bind address to listen to. Default is "0.0.0.0
- port: The port to listen to. Default is 5160
- tag_key: Name of tag key. Default is "tag"
- message_key: Name of message key. Default is "data"

#### Example 
  If your fluentd source configuration is the same as above and you submitting an event like this:
     
     require "socket"
     require 'json'
     
     my_hash = {tag: 'my_tag', data:{ "level": "INFO", "time": Time.now, "message": "Yayyy!!" }}
     UDPSocket.new.send(JSON.generate(my_hash), 0, 'localhost', 5160) 
    
  The output will be:
      
    2019-02-26 11:11:03.499991000 +0000 my_tag: {"level":"INFO","time":"2019-02-26 11:11:03 +0000","message":"Yayyy!!"}


## Requirements

| fluent-plugin-udp_forward | fluentd |
|-------------------|---------|
| >= 1.0.0 | >= v0.12.0 < 2 |

#### Contributing

1. Fork it ( http://github.com/tombolaltd/fluent-plugin-udp_forward/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

#### Copyright

Copyright (c) 2019 - [tombola](https://www.tombolaarcade.co.uk).

#### License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
