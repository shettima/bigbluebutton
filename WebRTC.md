w#summary WebRTC in BigBlueButton

# Introduction #

WebRTC enables real-time communication in the browser using Javascript APIs. In the BigBlueButton project, webrtc  is an alternative to the Flash audio communication.


## Requirements ##

### For users ###
BigBlueButton with support for WebRTC has been tested using these browsers
Google Chrome >= 28
Mozilla Firefox >= 26

Previous versions of these browsers may support WebRTC but won't work properly with BigBlueButton.

##  ##

### Getting Started ###
WebRTC communication is available in BigBlueButton 0.90, it won't work in previous versions of BigBlueButton. Port TCP 5066 should be open for sip over websocket connections from the client.

## Enabling  WebRTC ##

When WebRTC feature is enabled by the server admin, users will have two options to join the audio conference, WebRTC or Flash. If the user's browser is WebRTC capable for BigBlueButton needs, his audio settings dialog will allow him to choose between Flash and WebRTC.

While WebRTC could be a better option for audio during the BigBlueButton conference, it is up to the administrator to enable  WebRTC feature:
Execute

```
bbb-conf --enablewebrtc
```


Open _/opt/freeswitch/conf/vars.xml_ .
If your server is configured with an ip address, edit the value of the variable **local\_ip\_v4** with your server ip address:

```
<X-PRE-PROCESS cmd="set" data="local_ip_v4=YOUR_SERVER_IP_ADDRESS_HERE"/>
```

but if your server is configured with a domain remove the line which sets the variable **local\_ip\_v4**
```
 <!--  <X-PRE-PROCESS cmd="set" data="local_ip_v4=XXX.XXX.XXX.XXX"/> 
```

and edit the variable **domain** in the same file

```
  <X-PRE-PROCESS cmd="set" data="domain=YOUR_SERVER_DOMAIN_HERE"/>
```

Save the changes and finally restart the server
```
sudo bbb-conf --clean
```

PASTE AUDIO SETTINGS WITH WEBRTC OPTION HERE

## Disabling WebRTC ##
```
bbb-conf --disablewebrtc
```


When WebRTC feature is disabled by the server admin, users will have Flash as unique option to join the voice conference, as in previous versions of BigBlueButton.

PASTE AUDIO SETTINGS WITH FLASH OPTION HERE

**By default  the WebRTC feature is disabled in your server.**

## The OPUS codec ##
OPUS is one of the codecs you can use with WebRTC. To use Opus codec during the voice conference in BigBlueButton, open the Freeswitch file _/opt/freeswitch/conf/vars.xml_  ,find the line with the global codec preferences
```
<X-PRE-PROCESS cmd="set" data="global_codec_prefs=speex@16000h@20i,speex@8000h@20i,G7221@32000h,G7221@16000h,G722,PCMU,PCMA,GSM" />
```

and add 'OPUS' at the beginning of the list of codecs
```
<X-PRE-PROCESS cmd="set" data="global_codec_prefs=OPUS,speex@16000h@20i,speex@8000h@20i,G7221@32000h,G7221@16000h,G722,PCMU,PCMA,GSM" />
```

Save your changes and restart the server
```
sudo bbb-conf --restart
```


## Security ##
The WebRTC feature exposes external access to Freeswitch in your BigBlueButton server.


## For developers ##
JSsip is the javascript library which handles the sip communication between the BigBlueButton client and Freeswitch. Port TCP 5066 is used for SIP over websockets connection .