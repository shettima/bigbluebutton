

# Introduction #
As the popularity of BigBlueButton increases, we are increasingly asked "when are you going to release BigBlueButton 1.0?"

We first released BigBlueButton version 0.4 on June 12, 2009 (see [project history](http://en.wikipedia.org/wiki/BigBlueButton#History)).  Since then, we've had ten subsequent releases: 0.50, 0.60, 0.61, 0.62, 0.63, 0.64, 0.70, 0.71, 0.71a, 0.80, 0.81 – each release improving on the previous, each reflecting the desire by the core development team to build a solid product.

This document outlines the **DRAFT** requirements for BigBlueButton 1.0.

For many the version number is arbitrary -- it's a marketing name.  Whether its 0.80, 1.2, 4.5 or some other number, we see more universities, colleges, and K12 institutions using BigBlueButton in their classes, and more commercial companies integrating BigBlueButton into their products.

For others -- including the core BigBlueButton developers -- the version number is **not** arbitrary.  It represents a level of quality, stability, and completeness in BigBlueButton that we want to achieve before calling it 1.0.  When BigBlueButton 1.0 is released, it will be in substance, not name.

The requirements for BigBlueButton 1.0 are driven by our target market: on-line learning. We are also often asked "why are you focusing on only one market -- don’t you realize that BigBlueButton would be great for market X, Y, and Z?"  We realize this, but we also realize that the core features -- shared chat, presentation, voice, video, and desktop -- are the same core features for many markets (including distance education).  It is our belief that by focusing and delivering a world-class open source solution for distance education, we will, in essence, deliver a world class solution for other markets as well.

What are the requirements for distance education?  At the highest level, the requirement is to provide remote students a high-quality learning experience.  We can analyze this further using the following user stories:

  * As a **teacher**, I want to start my on-line class within five minutes without any problems so I can focus my energies on teaching students.

  * As a **student**, I want to clearly see and hear the teacher and his or her presentation so I can focus my energies on learning.

  * As an **administrator**, I want to install BigBlueButton in under thirty minutes so I can focus my energies on getting feedback from teachers and students using the software.

  * As the manager of **technical support**, I want the students and teachers to require minimal assistance (phone or e-mail) using BigBlueButton so I can focus my support resources on other products.

  * As a **developer**, I want to integrate BigBlueButton into my product in less than four hours so I can offer integrated real-time collaboration to my customer base.

There are five distinct roles: teacher, student, administrator, support, and developer.  People in each role have a job to accomplish.  We want BigBlueButton to fade into the background and enable them to accomplish that job efficiently.

In drafting this document, we have some important outcomes that not specific to any requirement; rather, they underlie **all** requirements.

  * **Stability** - Translating an initial positive impression into long-term adoption requires rock-solid stability.  We do extensive testing for each release (the recent release of BigBlueButton 0.80 had four beta releases and three release candidates).  We run our [BigBlueButton demo server](http://demo.bigbluebutton.org) for days without reboot.   We monitor our community **very close** for any issues that might reduce stability.

  * **Usability** - Usability touches all human-facing aspect of the product, including the quality of audio and video.  Whenever a first time user of BigBlueButton is able to get started quickly with minimal effort, then the product establishes a very positive first impression.  We believe that in each new release of BigBlueButton if we are able to enhance the capabilities of BigBlueButton while making the user interface more consistent and elegant, then we are headed in the right direction for product development.

  * **API** - BigBlueButton's provides a simple API for integration, and simple is good.  The API has enabled a [growing list](http://www.bigbluebutton.org/open-source-integrations/) of 3rd party integrations with other open source products.  As we work towards 1.0, we want to keep the APIs simple to further encourage integration.

Much of the feedback we receive on improving BigBlueButton is captured in our mailing list and our issue tracking system.

In drafting this document, to avoid duplication,  we have linked a requirement in this document to its corresponding issue.  Many of the items in this road map are being implemented in BigBlueButton 0.81 (our eleventh release).  Click on the corresponding issue for details on its status.  At the end of this document, you'll see a heading titled "Areas under investigation", which list those requirements that may (or may not) make the 1.0 release.

Obviously, if we tried to do everything everyone wants do with BigBlueButton 1.0, we’d never finish (and the product would be very complex too); therefore, there is section at the end of this document for those items planned for post 1.0.

If you have feedback on this document, please post to [BigBlueButton-dev](https://groups.google.com/group/bigbluebutton-dev/topics?gvc=2) mailing list.


# The DRAFT Requirements for BigBlueButton 1.0 #

## Core Features ##
This section covers the enhancements to BigBlueButton’s core features.

### Record and Playback ###
Start/stop button for record and playback


### Audio ###
BigBlueButton must have **no** perceptual voice delay for 50 users running within a LAN environment (see [forum post](http://groups.google.com/group/bigbluebutton-dev/browse_thread/thread/a36d61df9b9fc45b)).


### Presentation ###
Support full-screen mode, similar to hitting F5 in power point.  Full screen mode should have optional notifications of new chat messages or join/leave events ([872](http://code.google.com/p/bigbluebutton/issues/detail?id=872)).

### Whiteboard ###
Support keyboard input of text and symbols ([591](http://code.google.com/p/bigbluebutton/issues/detail?id=591)).


### Desktop sharing ###
Reduce the effort by viewers to view the screen sharing by automatically centring the screen sharing window and make it show original size if there is sufficient on the viewer’s monitor ([903](http://code.google.com/p/bigbluebutton/issues/detail?id=903)).

Support full-screen mode for desktop sharing as well.

## General Requirements ##
### Pre-flight Checklist ###
Sometimes Flash has difficulty picking the right microphone, speaker, or webcam for the user’s setup.  Other times the presenter can’t start their desktop sharing because Java is not properly installed.  These problems can delay the start of a session.

Add a “pre-flight” checklist that appears in a web page just before the user joins the BigBlueButton session to check internet connection, Flash version, Java version, and allow the user to adjust their audio levels and check that their webcam is working ([813](http://code.google.com/p/bigbluebutton/issues/detail?id=813)).


### Development Environment ###
It should be possible to setup a development environment in under 30 minutes.  We made progress on this in 0.81 (see [developing for BigBlueButton](Developing.md)).

### Documentation ###
Ensure all classes in BigBlueButton, both on the server (Java) and client (ActionScript) -- have sufficient javadoc documentation for a developer to understand their role relative to others.

Ensure all classes are documented to the level where another programmer could understand their intent.  The development environment (i.e ant scripts) should automatically compile the Java docs.

### All Stability Issues Closed ###
All critical, high, and medium [stability issues](http://code.google.com/p/bigbluebutton/issues/list?can=2&q=label:Stability&colspec=ID+Type+Status+Priority+Milestone+Owner+Component+Summary&x=priority&y=component&mode=grid&cells=tiles) are closed.

### Unit Testing ###
All the core client modules (voice, video, chat, presentation, and desktop sharing) have unit tests to verify their functionality.

All the core server modules have unit tests to verify their functionality.

The development environment should enable developers to run the unit tests to verify conformance.

### Integration Testing ###
The API should have a complete test suite to verify stability and conformance to documentation.


### Stress Testing ###
Verify that a BigBlueButton server can run under heavy load with large number of users for 48 hours without any failure.

The term "large number of users" will need to be calibrated according to the server capacity (memory and CPU).  The stress test should repeatedly start, stop, and generate user activity in multiple simultaneous classrooms.   The traffic should cover using all of the core elements of voice, video, chat, presentations, and desktop sharing.

The term "without any errors" means there were no freezes on the client, nor are there any exceptions in the server logs that indicate memory leaks or logic errors.

### API ###
Add an API call to enable external applications to inject messages into the chat window (see [905](http://code.google.com/p/bigbluebutton/issues/detail?id=905)).



### Installation and Upgrade ###
Support installation of BigBlueButton on Ubuntu 12.04 or 64-bit (see [1275](http://code.google.com/p/bigbluebutton/issues/detail?id=1275)).

### Troubleshooting tools ###
Add more capabilities to bbb-conf to change the logging levels of all applications, making it easier to spot errors ([906](http://code.google.com/p/bigbluebutton/issues/detail?id=906)).

Add more checks to bbb-conf to continue to trouble shoot any problems with the installation.  Once the error messages have been removed, any error message would be a real error.


## Areas for investigation ##
We are reviewing these requirements for inclusion in 1.0.

While the synchronized playback of content (slides, video, audio, and chat) using popcorn.js gives a rich playback experience, other times a video of the recording is easier to disseminate to YouTube and other content distribution sites that only work with video files.   To support this, add a playback format that creates a single video from the presentation + desktop sharing  ([900](http://code.google.com/p/bigbluebutton/issues/detail?id=900)).

Support ability to move objects around the whiteboard ([1599](https://code.google.com/p/bigbluebutton/issues/detail?id=1599))

Add additional modules:
  * Polling module ([831](http://code.google.com/p/bigbluebutton/issues/detail?id=831))
  * Breakout rooms module (see [831](http://code.google.com/p/bigbluebutton/issues/detail?id=831))
  * Shared notes module ([1180](http://code.google.com/p/bigbluebutton/issues/detail?id=1180))
  * Synchronized audio and video playback ([218](http://code.google.com/p/bigbluebutton/issues/detail?id=218))


## Parallel Development ##
We have projects that are occurring in parallel to the core development with the expectation that this work will merge into core.

### HTML5 ###

Create an HTML5 BigBlueButton client (see [850)](http://code.google.com/p/bigbluebutton/issues/detail?id=850) and [HTML5 Client Specification](https://code.google.com/p/bigbluebutton/wiki/HTML5).

### WebRTC ###

Investigate use of WebRTC for higher quality audio and video ([1544](https://code.google.com/p/bigbluebutton/issues/detail?id=1544))
Include the following additional modules.

The use of WebRTC would benefit both the Flash and HTML5 client.


# Beyond 1.0 #

There are a number of capabilities that we want to add that have
  * **Plug-in Architecture** - Currently, BigBlueButton is self-contained product.  Everything comes pre-assembled, ready to go.  That is great for initial adoption, but we want BigBlueButton to become modular platform (like eclipse) to enable other developers to easily create an integrate their own modules.
  * **Native support for android** - For Android ([851](http://code.google.com/p/bigbluebutton/issues/detail?id=851)), BlackBerry, and iPhone/iPad client ([852](http://code.google.com/p/bigbluebutton/issues/detail?id=852)).
  * **Native support for iOS devices** - For iOS phones and tables (see [852](http://code.google.com/p/bigbluebutton/issues/detail?id=852)).

  * **Integration with H.323** - This would enable BigBlueButton to integrate with other commercial conferencing systems that support [H.323](http://en.wikipedia.org/wiki/H.323)

  * **Support for Jabber** - This would enable us to integrate with other popular IM systems ([921](http://code.google.com/p/bigbluebutton/issues/detail?id=921)).

  * **Support right-left languages** - See [686](http://code.google.com/p/bigbluebutton/issues/detail?id=686).