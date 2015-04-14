

# Introduction #

This document summarizes the major updates in BigBlueButton 0.81  (referred hereafter as 0.81) over the previous release.  For a list of details, see [issues closed in 0.81](https://code.google.com/p/bigbluebutton/issues/list?can=1&q=milestone=Release0.81%20status=Fixed).

Since we released the first version of BigBlueButton on July 12, 2009, BigBlueButton 0.81 represents our eleventh release of BigBlueButton.  We've closed [over 200](https://code.google.com/p/bigbluebutton/issues/list?can=1&q=milestone=Release0.81%20status=Fixed&colspec=ID%20Type%20Status%20Priority%20Milestone%20Owner%20Component%20Summary) issues in 0.81!  To follow the development of 0.81, subscribe to the [bigbluebutton-dev mailing list](https://groups.google.com/group/bigbluebutton-dev/topics?gvc=2).


# Overview of new features in BigBlueButton 0.81 #

## Record and Playback ##

BigBlueButton 0.81 now records and playback (archives) all activity in the session for playback. Specifically, it records all whiteboard activity (see [1191](http://code.google.com/p/bigbluebutton/issues/detail?id=1191)) which includes

  * Mouse movement
  * Whiteboard marks
  * Pan/Zoom

It also records all webcams (see [1326](http://code.google.com/p/bigbluebutton/issues/detail?id=1326)), and desktop sharing (see [1470](https://code.google.com/p/bigbluebutton/issues/detail?id=1470)).  For technical details see [RecordAndPlayback](081RecordAndPlayback.md).

To see what a recording looks like, see [sample recording](http://www.bigbluebutton.org/playback/presentation/playback.html?meetingId=cc6507847430b317c4ec8de1ad7083330d9756b5-1374785573783) using BigBlueButton 0.81.

## Accessibility ##
This release adds accessibility features for blind students using screen readers (see [853](http://code.google.com/p/bigbluebutton/issues/detail?id=853)) to navigate through the BigBlueButton user interface.

For the chat module:
  * keyboard navigation
  * Input box focus
  * Screen reader cooperation
  * Audio alerts

For record and playback
  * Thumbnail for labels
  * Access to text from presentation
  * Chat messages

General changes
  * Resize and move windows
  * Hotkey Reference window
  * Localized hotkeys

There is a new 'Shortcuts' dialog that shows you all the keyboard shortcuts.

![http://bigbluebutton.googlecode.com/svn/trunk/bbb-images/081/shortcut.png](http://bigbluebutton.googlecode.com/svn/trunk/bbb-images/081/shortcut.png)

For technical details see [Accessibility](081Accessibility.md).

## Whiteboard ##
The whiteboard now has a line tool and text tool (see [591](http://code.google.com/p/bigbluebutton/issues/detail?id=591)).

## Layout Manger ##
The Layout Manager now keeps your windows organized as you resize the browser window.  It also gives you a number of preset layouts to choose from (see [1060](http://code.google.com/p/bigbluebutton/issues/detail?id=1060)).

![http://bigbluebutton.googlecode.com/svn/trunk/bbb-images/081/layout-1.png](http://bigbluebutton.googlecode.com/svn/trunk/bbb-images/081/layout-1.png)

For example, on startup BigBlueButton will use the default layout.

![http://bigbluebutton.googlecode.com/svn/trunk/bbb-images/081/layout-1a.png](http://bigbluebutton.googlecode.com/svn/trunk/bbb-images/081/layout-1a.png)

You can the switch to a different layout and your windows will automatically resize.

![http://bigbluebutton.googlecode.com/svn/trunk/bbb-images/081/layout-1b.png](http://bigbluebutton.googlecode.com/svn/trunk/bbb-images/081/layout-1b.png)

The layout manager is developer friendly.  You can create a new layout on the screen, save the layout to new\_layouts.xml, and then use the new layout to update the contents


For developers, you can use also [define your own layout configuration](https://code.google.com/p/bigbluebutton/wiki/ClientConfiguration#Layouts) for loading on startup.

## Unified Users and Listeners window ##
See [this blog post](http://www.bigbluebutton.org/2012/10/19/simplifying-the-bigbluebutton-ui/).

## New Skin ##
See [this blog post](http://www.bigbluebutton.org/2012/11/16/more-updates-to-the-bigbluebutton-ui/).


## API Examples/Updates ##
### Browser ID ###

There is an API example showing how to use Mozilla Persona (BrowserID) to let users connect into a BigBlueButton session (see [1276](http://code.google.com/p/bigbluebutton/issues/detail?id=1276)).

### OpenID ###

There is an API example demonstrating how to use OpenID to login to a session (see [1361](http://code.google.com/p/bigbluebutton/issues/detail?id=1361)).

### Per-user configuration of client ###
Developers can now specify the BigBlueButton client config.xml (configuration parmeters) on a per-user basis.  This enables developers to modify any parameter, such as turning of webcam or specifying the default layout (see [Dynamic config.xml API demo](http://demo.bigbluebutton.org/demo/demo12.jsp)).

### JavaScript Integration ###

Developers can now control the BigBlueButton client from within a web page via a JavaScript interface.

See [JavaScript API demo](http://demo.bigbluebutton.org/demo/demo11.jsp).  For details on the integration, see the source for [demo11.jsp](https://github.com/bigbluebutton/bigbluebutton/blob/master/bbb-api-demo/src/main/webapp/demo11.jsp) and [demo11.html](https://github.com/bigbluebutton/bigbluebutton/blob/master/bbb-api-demo/src/main/webapp/demo11.html).



## IMS Learning Tools Interoperability Support ##

BigBlueButton now implements the IMS Learning Tools Interoperability (LTI) standard to enable BigBlueButton to be a tool provider (see [907](http://code.google.com/p/bigbluebutton/issues/detail?id=907)).

For more technical details see [IMS LTI support in BigBlueButton](LTI.md).  For an example of using the support for LTI to integrate with an LMS, see [BigBlueButton LTI Integration video](https://www.youtube.com/watch?v=OSTGfvICYX4).

# Documentation Updates #
The setup of development environment now includes more step-by-step instructions (see 081DevelopingBigBlueButton).  For a full list of updates to documentation for 0.81, see [0.81 Documentation](081Docs.md).