# Introduction #

Add your content here.


## Startup ##
Sequence of events when the VOIP application starting up.

![http://bigbluebutton.googlecode.com/svn/trunk/bbb-images/bbb_diagramsPNG_06/voice-conf-detailed-design-startup.png](http://bigbluebutton.googlecode.com/svn/trunk/bbb-images/bbb_diagramsPNG_06/voice-conf-detailed-design-startup.png)

  1. The application starts initializing the SipPeerManager which manages connections to one or more peers
  1. The SipPeerManager initializes the SipPeer
  1. The SipPeer initiated registration with !Asterisk or !FreeSWITCH
  1. The SipRegister service is in-charged of registering and re-registering for keep-alive

## Join ##
Sequence of events when a user joins the voice conference.

![http://bigbluebutton.googlecode.com/svn/trunk/bbb-images/bbb_diagramsPNG_06/voice-conf-detailed-design-join.png](http://bigbluebutton.googlecode.com/svn/trunk/bbb-images/bbb_diagramsPNG_06/voice-conf-detailed-design-join.png)

  1. The client connects to the application.
  1. The ClientConnectionManager store the client connection
  1. The ClientConnection will be used to send messages from the server to the client
  1. The client then tells the Service to call into the voice conference
  1. The Service forwards the request to the SipPeerManager which finds the SipPeer for the voice conference
  1. The SipPeer receives the request to call into the conference
  1. SipPeer tells the CallManager to start the call.
  1. The CallManager create the Call instance.
  1. The Call instance connects to FS/Asterisk (INVITE, SDP negotation, etc.)
  1. Once the call is connected, the Call instance will create a CallStream which encapsulates 2 streams. One stream from Red5 to FS and the other in the opposite direction.
  1. The stream that handles audio packets from FS/Asterisk is SipToFlashAudioStream
  1. The stream for the opposite directions is FlashToSipAudioStream.
  1. Now that the streams have been setup, notify the ClientConnection about the stream.
  1. The ClientConnection invokes a method on the client passing in the all relevant information (stream name, codec) to be able to connect to the streams.
  1. Both stream are told to start processing the audio packets.
  1. Audio RTP packets from Asterisk/FS are handled by the RtpStreamReceiver and forwarded to the !Transcoder and then pushed to the Client. Audio RTMP packets from the Client are received by FlashToSipAudioStream and forwarded to the Transcoder then to the RtpStreamSender which packages the packet using RTP to Asterisk/FS. During the SDP codec negotiation, the type (SPEEX, ULAW) of Transcoder is initialized. The different Trancoders are [here](https://github.com/bigbluebutton/bigbluebutton/tree/master/bbb-voice/src/main/java/org/bigbluebutton/voiceconf/red5/media/transcoder).

## Leave ##
Sequence of events when the user leaves the conference.

![http://bigbluebutton.googlecode.com/svn/trunk/bbb-images/bbb_diagramsPNG_06/voice-conf-detailed-design-leave.png](http://bigbluebutton.googlecode.com/svn/trunk/bbb-images/bbb_diagramsPNG_06/voice-conf-detailed-design-leave.png)

  1. When the user clicks hangup, the Client invoke a method on the Service class located server.
  1. The Service class forwards the request to the SipPeerManager.
  1. Which then forwards it to SipPeer.
  1. And then to the CallManager.
  1. The CallManager tells Call to terminate.
  1. The Call instance will stop the streams by informing CallStream
  1. CallStream then stop both streams.
  1. And Call will disconnect (BYE) from Asterisk/FS.
  1. Tells the ClientConnection that the call has been hanged-up.
  1. The ClientConnection invokes a method on the Client telling it the the call has ended.