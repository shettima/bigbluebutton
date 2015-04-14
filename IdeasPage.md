_Note: BigBlueButton didn't get accepted this year in GSOC 2011 -- but we'll be trying hard for 2012!  Further discussion on these projects has moved to the issue tracker with labels of [Research](http://code.google.com/p/bigbluebutton/issues/list?can=2&q=label:Type-Research&colspec=ID+Type+Status+Priority+Milestone+Owner+Component+Summary&x=priority&y=component&mode=grid&cells=tiles)._



# Introduction #

Welcome!  This page gives a summary of BigBlueButton projects for the 2011 Google Summer of Code (GSoC).  Many of these projects are based on requests from our community.

If you are interested in one of these projects, please post to [bigbluebutton-dev](http://groups.google.com/group/bigbluebutton-dev) with any questions or suggestions.  If you are interested in working on a BigBlueButton project not listed here, we welcome your suggestions!

For some background on the BigBlueButton project, see the FAQ, [wikipedia](http://en.wikipedia.org/wiki/BigBlueButton), [videos](http://bigbluebutton.org/content/videos).

# GSOC 2011 Student Projects #

## HTML5 Client ##
Create an HTML5 client for BigBlueButton.  This project touches on creating a WebSockets server that can bridge communications to the red5 RTMP server.  Once you have the WebSockets server in place, you need to create a UI that mimics (or improves!) on the current Flash UI.

## Flex 4 Prototype ##
We need a shiny new Flex 4 client to replace our Flex 3 client.  The current version of BigBlueButton uses the [FlexLib component library](http://code.google.com/p/flexlib/).  Flex 4 brings the [Spark component architecture](http://opensource.adobe.com/wiki/display/flexsdk/Gumbo+Component+Architecture).

## XMPP Integration ##
Convert the Chat module to work with XMPP.  This would enable people to log into bigbluebutton chat with their favorite XMPP compatible chat client, such as OpenFire, GTalk, Pidgin, etc...

## IRC Bridge ##
A bridge from Chat to IRC.  This could be done in conjunction with the XMPP idea, as there are already some XMPP to IRC solutions.

## Accessibility Support ##
Find ways to make BigBlueButton more accessible, in accordance with [Section 508](http://www.section508.gov/).

## Android Client ##
Create an Android client for BigBlueButton.  There is some initial work that you can build upon, see [BigBlueButton on Android Phone](http://bigbluebutton-blog.blogspot.com/2011/02/bigbluebutton-on-android-phone.html).

## iPhone/iPad Client ##
Create a native Objective-C client for the iPhone or iPad.