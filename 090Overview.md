

# BigBlueButton 0.9.0-beta #
This document summarizes the major updates in BigBlueButton 0.9.0-beta  (referred hereafter as 0.9.0).

BigBlueButton 0.9.0 has the following new features:

  * Improved Audio Setup (see [1699](https://code.google.com/p/bigbluebutton/issues/detail?id=1699))
  * WebRTC Audio (see [1544](https://code.google.com/p/bigbluebutton/issues/detail?id=1544))
  * Listen Only Audio (see [353](https://code.google.com/p/bigbluebutton/issues/detail?id=353))
  * Start/Stop button (see [1037](https://code.google.com/p/bigbluebutton/issues/detail?id=1037))

Other improvements include:

  * Ability to disable features for viewers (see [1702](https://code.google.com/p/bigbluebutton/issues/detail?id=1702))
  * XML pasted into chat now properly displays (see [1769](https://code.google.com/p/bigbluebutton/issues/detail?id=1769))
  * UTF-8 presentation file names now displayed (see [594](https://code.google.com/p/bigbluebutton/issues/detail?id=594))
  * Moderators can raise hand (see [1788](https://code.google.com/p/bigbluebutton/issues/detail?id=1788))
  * Enhance the Text Tool to allow user to enter in new lines (see [1772](https://code.google.com/p/bigbluebutton/issues/detail?id=1772))
  * Installation on Ubuntu 14.04 64-bit (see [1275](https://code.google.com/p/bigbluebutton/issues/detail?id=1275))


See  [detailed list](https://code.google.com/p/bigbluebutton/issues/list?can=1&q=milestone=Release0.9.0) for the items completed in this release.

The following sections gives you some visuals of the new features.  You can try them yourself by visiting the [BigBlueButton Demo Server](http://demo.bigbluebutton.org/).  Use Mozilla's FireFox browser or Google's Chrome browser to experience the WebRTC audio.


# Improved audio #

We had two main goals for improving audio in this release
  1. Improve overall sound quality
  1. Increase the likelihood user has a functioning microphone when entering the session

Compared with Flash Audio, WebRTC audio uses UDP for transmission and is encoded using OPUS.  The browser transmits audio directly to FreeSWITCH.  The browser's acoustic echo cancellation is better than Flash, and both browsers support auto-leveling of that audio, removing the need for the user to manually adjust the sensitivity.  WebRTC audio is transmitted securely via SRTP at a rate of 48 Khz, whereas speex is transmitted via RTMP (not encrypted) at a rate of 16 khz.

Overall, WebRTC should provide the user a higher quality and lower latency audio transmission.

## Listen Only audio ##

Users now have the ability to quickly join the session as a listener, which does not require any permissions from the browser.

![http://bigbluebutton.googlecode.com/svn/trunk/bbb-images/090/audiochooser.png](http://bigbluebutton.googlecode.com/svn/trunk/bbb-images/090/audiochooser.png)

Unlike BigBlueButton 0.81, which setup a two-way audio channel in FreeSWITCH for every user (even when users joined muted), thereby increasing the CPU load with each new user, in BigBlueButton 0.9.0 users joining as Listen Only now share a single audio stream broadcasted from red5, which needs only one connection to FreeSWITCH for all Listen Only users.

## Highlight the browser’s request for permission ##

With Chrome, users are prompted twice for access to their microphone -- once from Flash, and once from Chrome. A common issue with Chrome 36 (and earlier versions) was that users miss Chrome's prompt for permissions to access their microphone.  If a user missed this request and does not give Chrome permission, the user's microphone will not work.

BigBlueButton 0.9.0 now calls the user's attention to the browser's request for permissions to access their microphone.

Here's how the dialog looks in Chrome:

![http://bigbluebutton.googlecode.com/svn/trunk/bbb-images/090/chromerequest.png](http://bigbluebutton.googlecode.com/svn/trunk/bbb-images/090/chromerequest.png)

And here is the FireFox version:

![http://bigbluebutton.googlecode.com/svn/trunk/bbb-images/090/firefoxrequest.png](http://bigbluebutton.googlecode.com/svn/trunk/bbb-images/090/firefoxrequest.png)

## Audio test ##

Once the user has given permission, BigBlueButton will enable the user to test their microphone by saying a few words.  The user is placed in a private "echo test" room where their audio will be sent to the server and back to their speakers.

This steps serves two functions:
  1. It emphasizes the need to have a headset for best audio experience
  1. It ensures they have a functioning microphone _before_ entering the voice bridge for the session.

![http://bigbluebutton.googlecode.com/svn/trunk/bbb-images/090/aduiotest.png](http://bigbluebutton.googlecode.com/svn/trunk/bbb-images/090/aduiotest.png)

In most cases, the default microphone chosen by the operating system is a functioning microphone.

If the user clicks 'Yes', they are joined into the audio bridge with their default microphone using WebRTC audio (FireFox and Chrome)

![http://bigbluebutton.googlecode.com/svn/trunk/bbb-images/090/webrtcaudio.png](http://bigbluebutton.googlecode.com/svn/trunk/bbb-images/090/webrtcaudio.png)


## Microphone chooser ##

If the user clicks 'No', they are brought to a new dialog to connect via Flash and choose a microphone.  This dialog is larger than the built-in dialog for Flash.

![http://bigbluebutton.googlecode.com/svn/trunk/bbb-images/090/flashchoose.png](http://bigbluebutton.googlecode.com/svn/trunk/bbb-images/090/flashchoose.png)

Here the user gets immediate feedback on whether the current microphone is generating energy.

If they click 'Next', they can return to the Audio Test to confirm their microphone is working before joining the session.

If the user is unable to get their microphone to work, they can always join Listen Only.  This lets other users in the session know upfront the user can only hear the session.


# Start/Stop Recording #
Moderators can now choose the segments of their session that are recorded by clicking the Stop/Start Recording button.

![http://bigbluebutton.googlecode.com/svn/trunk/bbb-images/090/startstop.png](http://bigbluebutton.googlecode.com/svn/trunk/bbb-images/090/startstop.png)

To help ensure that moderators do not forget to start recording their session, BigBlueButton will remind them, after they join the audio bridge, they they can record the meeting.

![http://bigbluebutton.googlecode.com/svn/trunk/bbb-images/090/remind.png](http://bigbluebutton.googlecode.com/svn/trunk/bbb-images/090/remind.png)



# Other Improvements #

## Configuration Notifications ##

While users can run BigBlueButton in a variety of browsers and configurations, if a user is running BigBlueButton on an out-of-date browser or behind a firewall that restricts access, for example, the user could have a better experience if they knew they could switch network locations.

If the BigBlueButton client detects the are possible improvements the user could make to their environment, the client will display a configuration notification icon.

![http://bigbluebutton.googlecode.com/svn/trunk/bbb-images/090/configurationnotifications.png](http://bigbluebutton.googlecode.com/svn/trunk/bbb-images/090/configurationnotifications.png)

Clicking on the icon will display one of the possible configuration messages

  * Flash is out-of­‐date
  * The current browser is not FireFox or Chrome
  * FireFox or Chrome is out-­of­‐date
  * Client is behind a firewall
  * Client had troubles connecting to webRTC audio

![http://bigbluebutton.googlecode.com/svn/trunk/bbb-images/090/possiblenotifications.png](http://bigbluebutton.googlecode.com/svn/trunk/bbb-images/090/possiblenotifications.png)

The configuration notification should help ensure users have a good experience and reduce the support effort for deploying BigBlueButton.


## Lock Viewers ##
The moderator now has the ability to lock (restrict) viewers from having the following abilities:

  1. Webcam
  1. Microphone
  1. Public Chat
  1. Private Chat
  1. Layout

![http://bigbluebutton.googlecode.com/svn/trunk/bbb-images/090/lock.png](http://bigbluebutton.googlecode.com/svn/trunk/bbb-images/090/lock.png)

## Chat supports pasting in XML ##

Users can now paste XML content into the chat window and BigBlueButton will properly display it.

![http://bigbluebutton.googlecode.com/svn/trunk/bbb-images/090/xml-chat.png](http://bigbluebutton.googlecode.com/svn/trunk/bbb-images/090/xml-chat.png)

This will assist sessions that are covering HTML design or XML content -- example of which can be shared by users in the chat.

## UTF-8 presentation file names now displayed ##
When the presenter uploads a presentation with a UTF-8 file name, BigBlueButton now properly displays the file name in the upload dialog box.

![http://bigbluebutton.googlecode.com/svn/trunk/bbb-images/090/utf8.png](http://bigbluebutton.googlecode.com/svn/trunk/bbb-images/090/utf8.png)

## Moderators can raise hand ##
Moderators can now raise their hand.
![http://bigbluebutton.googlecode.com/svn/trunk/bbb-images/090/moderatorraisehand.png](http://bigbluebutton.googlecode.com/svn/trunk/bbb-images/090/moderatorraisehand.png)

## Presenters can use enter key in text tool ##
When typing into the presentation using the text tool, pressing the Enter key now puts in a new line instead of submitting the text.  Yeah!


## Ubuntu 14.04 64-bit ##

BigBlueButton 0.9.0 now installs on Ubuntu 14.04 64-bit.

Compared with Ubuntu 10.04 64-bit (the distribution for 0.81), Ubuntu 14.04 64-bit gives BigBlueButton a number of significant updates to the underlying packages.

| **Package** | **0.81** | **0.9.0** |
|:------------|:---------|:----------|
| tomcat | 6.0.24 | 7.0.52 |
| javaJDK | 1.6.0\_27 | 1.7.0\_75 |
| redis | 2.2.4 | 2.8.4 |
| ruby | 1.9.2p290 | 1.9.3p484 |
| nginx | 0.7.65 | 1.4.6 |
| LibreOffice | 4.0.2 | 4.3.6 |

The installation instructions have simplified: with Ubuntu 10.04 64-bit, administrators don't need to manually install ruby or LibreOffice -- both are now well supported in Ubuntu's packaging.

Other notable updates include

| **Component** | **0.81** | **0.9.0** |
|:--------------|:---------|:----------|
| FreeSWITCH | 1.5.1b | 1.5.14b |
| swftools | 0.9.1 | 0.9.2 |
| ffmpeg | 2.1.4 | 2.3.3 |
| red5 | 1.0.2 | 1.0.3 |

Most notable has been the upgrade to FreeSWITCH, which now enabled BigBlueButton to support WebRTC audio calls from the browser (Chrome and FireFox), while still remaining backward compatible with audio calls from Chrome and IE (via red5phone).

To start (and restart) the recording a playback scripts and LibreOffice headless, BigBlueButton 0.9.0 now uses monit instead of god.