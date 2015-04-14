The main use case for BBB is distance education. This is a coordination page about how to use BigBlueButton for the use case of **remote participation to community events**. The goal is to come up with a global recipe. This will include BigBlueButton of course, but also suggested hardware and setup notes.


Community events do not typically benefit from a permanent setup. Thus, we should figure out a "mobile solution".

The test case is the instance at http://live.tiki.org (which is integrated with Tiki), but it should be relevant with any or no CMS system. This will be a major topic at the [TikiFestBigBlueButton](http://tikiwiki.org/TikiFestBigBlueButton)

## State as of Tiki 5.0 and BigBlueButton 0.64 ##

Following testings in various events:

Good:
  * The overall BBB session is very reliable. It can be broadcasting for several hours without a log off.
  * 1-click login is ideal (from anon or users with tikiwiki.org account)
  * Video quality is good
  * To be able to have several streams is awesome (we can cover a room with several webcams)

Bugs:
  * Voice: remote participants often report that there is no sound (when using BBB flash interface).  (Known bug)
  * Voip: when calling in 613#, accessing the conference room sometimes doesn't work. Hanging up and trying again usually solves it. Perhaps it's related to DTMF detection because my cell phone always works.

Notes:
  * The underlying big challenge is a good setup to capture audio. A high quality multi-directional mic. would help a lot

## The ideal setup ##
Several PCs, some of which are attached to projectors
Each PC's webcam is capturing a different angle of the event/room.
  * The schedule on the wall (open space meetings)
  * The white (or green) board
  * The main presentation/meeting place (this is where audio is captured and a screensharing is available)
  * General activity of the event
  * Ideally, each PC is setup so the on site participants can respond in the chat room

Projectors
  * The desktop of the main presentation space
  * The chat room
  * So all participants can glance at it. This is the main way remote participants can provide feedback

Nice to have
  * Remote participants could voice in to a speakerphone at the event. Must find a way to limit screechy feedback

Remote participants
  * Can view the desktop sharing/slideshow/whiteboard
  * Can listen in to the main space
  * Can check out the action via the various webcam
  * Can participate to the chat room
  * Nice to have: voice participation to the speakerphone of the main area. Perhaps the use of a headset should mandatory?

On site participants
  * Should be informed they are being filmed and perhaps recorded
  * Can follow the chatroom on a projector

To investigate:
  * Wifi projectors, so they are easy to move around (+ some tape and a white bedsheet for mobile setup)
  * Netbooks with webcams


# Projects #
  * Permanent BBB setup at the [CDEC](http://www.cdec-cspmr.org/)
  * [RoCoCo event in Montreal](http://www.rococo2010.org/) June 2010


# Related #
  * http://readytopresent.wordpress.com/
  * http://www.duopixel.com/articles/telepresence.html