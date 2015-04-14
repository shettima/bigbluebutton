

This document assumes the reader understands the current [BigBlueButton architecture](http://code.google.com/p/bigbluebutton/wiki/ArchitectureOverview).


## Overview ##

BigBlueButton records all the events and media data generated during a BigBlueButton session for later playback.

If you want to see the Record and Playback feature in action there is a [demo](http://demo.bigbluebutton.org/demo/demo10.jsp), you can use it to record a BigBlueButton session and play it after it is listed under "Recorded Sessions" on the same page, you should wait a few minutes after your session ends while the media is processed and published for playback. This demo is also available on your server if you have [installed it](https://code.google.com/p/bigbluebutton/wiki/081InstallationUbuntu#6._Install_API_Demos).


Like BigBlueButton sessions, management of recordings should be handled by [third party software](http://www.bigbluebutton.org/open-source-integrations/).  Third party software consumes the [BigBlueButton API](https://code.google.com/p/bigbluebutton/wiki/API) to accomplish that.

From a technical point of view, in the BigBlueButton API, when you pass the parameter 'record=true' with [create](API#Create_Meeting.md), BigBlueButton will create a session and record the slides, chat, audio, desktop, whiteboard events and webcam for later processing.

After the session finishes, the BigBlueButton server will run one (or more) ingest and processing scripts, named as workflows, that will _process_ and _publish_ the captured data into a format for _playback_.

In BigBlueButton 0.81 there are two workflows, **presentation**, which is installed by default; and **matterhorn**, which is part of an integration with Matterhorn and should be [installed manually](081Matterhorn.md). You can have both workflows working in your server and at the end you will have two formats for playback.



## Record and Playback Phases ##

BigBlueButton processes the recordings in the following :

  1. Capture
  1. Archive
  1. Sanity
  1. Process
  1. Publish
  1. Playback


### Capture ###
The Capture phase involves enabling the BigBlueButton modules (chat, presentation, video, voice, etc.) to emit events over an event bus for capture on the BigBlueButton server. Components that generate media (webcam, voice, desktop sharing) must also store their data streams on the server as well.

Whiteboard, cursor, chat and other events are stored on Redis. Webcam videos (.flv) and desktop sharing videos (.flv)  are recorded by Red5. The audio conference file (.wav) is recorded by Freeswitch.


### Archive ###
The Archive phase involves taking the captured media and events into a **raw** directory. That directory contains ALL the necessary media and files to work with.


### Sanity ###
The Sanity phase involves checking that all the archived files are _valid_ for processing. For example
that media files have not zero length and events were archived.


### Process ###
The Process phase involves processing the archived  valid files of the recording according to the workflow (presentation or matterhorn). Usually it involves parsing the archived events, converting media files to other formats or concatenating them, etc.



### Publish ###
The Publish phase involves generating metadata and taking many or all the processed files and placing them in a directory exposed publicly for later playback.


### Playback ###
The Playback phase involves taking the published files (audio, webcam, deskshare, chat, events, metadata) and playing them in the browser.

Using the workflow **presentation**, playback is handled by HTML, CSS and Javascript libraries; it is fully available in Mozilla Firefox and Google Chrome(also in Android devices); in Internet Explorer if you have installed [Google Chrome Frame](http://www.google.com/chromeframe). In other browsers like Opera or Safari the playback will work without all its functionality , e.g, thumbnails won't be shown. There is not a unique video file for playback, there is not an available button or link to download the recording. We have opened an [issue](https://code.google.com/p/bigbluebutton/issues/detail?id=1215) for this enhancement


Using the workflow **matterhorn**, playback is handled by a media player in your Matterhorn server.




## Media storage ##

Some Record and Playback phases store the media they handle in different directories

### Captured files ###

_AUDIO_:
/var/freeswitch/meetings

_WEBCAM_:
/usr/share/red5/webapps/video/streams

_DESKTOP SHARING_:
/var/bigbluebutton/deskshare

_SLIDES_:
/var/bigbluebutton

_EVENTS_:
Redis

### Archived files ###
/var/bigbluebutton/recording/raw/_**internal-meeting-id**_/

### Sanity checked files ###
Same for archived files

### Processed files ###
/var/bigbluebutton/recording/process/presentation/_**internal-meeting-id**_/

### Published files ###
/var/bigbluebutton/recording/publish/presentation/_**internal-meeting-id**_/

### Playback files ###
/var/bigbluebutton/published/presentation/_**internal-meeting-id**_/


## Manage recordings ##

BigBlueButton does not have an administrator web interface to control the sessions or recordings as in both cases they are handled by 3rd party software, but it has a useful tool to monitor the state and control your recordings through the phases described above.

In the terminal of your server you can execute "bbb-record", which will show you each option with its description

```

BigBlueButton Recording Diagnostic Utility (BigBlueButton Version 0.81)

   bbb-record [options]

Reporting:
   --list                          	List all recordings

Monitoring:
   --watch                          	Watch processing of recordings
   --watch --withDesc               	Watch processing of recordings and show their description

Administration:
   --rebuild <internal meetingID>       rebuild the output for the given internal meetingID
   --rebuildall			        rebuild every recording
   --delete <internal meetingID>	delete one meeting and recording
   --deleteall                      	delete all meetings and recordings
   --debug                          	check for recording errors
   --check                          	check for configuration errors
   --enable <workflow>              	enable a recording workflow
   --disable <workflow>             	disable a recording workflow
   --tointernal <external meetingId>	get the internal meeting ids for the given external meetingId
   --toexternal <internal meetingId>	get the external meeting id for the given internal meetingId
   --republish <internal meetingID>	republish the recording for meetingID. (Only for Matterhorn Integration)

```

### Useful terms ###
_**workflow**_ is the way a recording is processed, published and played . In BigBlueButton 0.81 the unique workflow out of the box is the "presentation".

_**internal meetingId**_ is an alphanumeric string that internally identifies your recorded meeting. It is created internally by BigBlueButton. For example "183f0bf3a0982a127bdb8161e0c44eb696b3e75c-1379693236230".

_**external meetingID**_  is the id you set to the meeting, like "English 201" or "My Awesome class", "Chemistry 2". It is passed through the create API call.

_**recording**_ is recorded meeting in BigBlueButton.

In BigBlueButton you can use the same external meeting ID (for example "English 101") in many recordings but each recording will have a different internal meeting id. One external meeting id is associated with **one or many** internal meeting ids.



### List recordings ###

```
bbb-record --list
```

will list all your recordings.


### Watch recordings ###
```
bbb-record --watch
```

will list your latest 20 recordings, refreshing its output every 2 seconds. Its output is similar to this:


```
Every 2.0s: bbb-record --list20                                                                                                                              Mon Sep 23 19:52:14 2013

Internal MeetingID                                               Time                APVD APVDE RAS Slides Processed            Published           External MeetingID
------------------------------------------------------  ---------------------------- ---- ----- --- ------ -------------------- ------------------  -------------------
6e35e3b2778883f5db637d7a5dba0a427f692e91-1379965122603  Mon Sep 23 19:38:42 UTC 2013  X    X  X XXX      1 presentation         presentation        English 101
183f0bf3a0982a127bdb8161e0c44eb696b3e75c-1379965005759  Mon Sep 23 19:36:45 UTC 2013  X                  1
183f0bf3a0982a127bdb8161e0c44eb696b3e75c-1379693236230  Fri Sep 20 16:07:16 UTC 2013  XX                 1
183f0bf3a0982a127bdb8161e0c44eb696b3e75c-1379675205776  Fri Sep 20 11:06:45 UTC 2013  XX                 1
183f0bf3a0982a127bdb8161e0c44eb696b3e75c-1379541285165  Wed Sep 18 21:54:45 UTC 2013  X                  1
183f0bf3a0982a127bdb8161e0c44eb696b3e75c-1379523831933  Wed Sep 18 17:03:51 UTC 2013  XX                 1
183f0bf3a0982a127bdb8161e0c44eb696b3e75c-1379450735750  Tue Sep 17 20:45:35 UTC 2013  XX                 1
183f0bf3a0982a127bdb8161e0c44eb696b3e75c-1379450634935  Tue Sep 17 20:43:54 UTC 2013  X                  1

--
--
Last meeting processed (bbb-web.log): 6e35e3b2778883f5db637d7a5dba0a427f692e91-1379965122603

```


### Rebuild a recording ###

It will go through the Process and Publish phases again.

```
sudo bbb-record --rebuild 6e35e3b2778883f5db637d7a5dba0a427f692e91-1379965122603
```

### Rebuild every recording ###

It will go through the Process and Publish phases again for every recording in your server.
This action will take a long time since it processes every recording.

```
sudo bbb-record --rebuildall
```


### Delete a recording ###

```
sudo bbb-record --delete 6e35e3b2778883f5db637d7a5dba0a427f692e91-1379965122603
```


### Delete all recordings ###

```
sudo bbb-record --deleteall
```

### Debug recordings ###

Check recording log files, looking for errors since the Archive phase.

```
sudo bbb-record --debug
```


### Enable a workflow ###

```
sudo bbb-record --enable presentation
```

### Disable a workflow ###

```
sudo bbb-record --disable presentation
```


### Get internal meeting ids ###

```
sudo bbb-record --tointernal "English 101" 
```

will show

```

Internal meeting ids related to the given external meeting id:
-------------------------------------------------------------
6e35e3b2778883f5db637d7a5dba0a427f692e91-1379965122603
```

Use double quotes for the external meeting id.


### Get external meeting ids ###


```
sudo bbb-record --toexternal "English 101" 
```



Use double quotes for the external meeting id.


### Republish recordings ###

This feature is useful **only** with the workflow "matterhorn", installed with the [Matterhorn integration](https://code.google.com/p/bigbluebutton/wiki/MatterhornIntegration). With the workflow "presentation" it does not work.


```
sudo bbb-record --republish 6e35e3b2778883f5db637d7a5dba0a427f692e91-1379965122603
```



## For Developers ##

Here you will find more details about the Record and Playback feature.


The unique way to start a recorded session in BigBlueButton is setting the value "true" to the parameter "record" in the[create API call](https://code.google.com/p/bigbluebutton/wiki/API#Create_Meeting), which usually is handled by third party software.



### Capture phase ###

The Capture phase is handled by many components, to understand how it works you should have basic, intermediate or advanced understanding about tools like Freeswitch, Flex, Red5 , Redis, dig into the [BigBlueButton source code](https://github.com/bigbluebutton/bigbluebutton), or search for information in the [BigBlueButton mailing list for developers](https://groups.google.com/forum/?hl=es#!forum/bigbluebutton-dev)




### Archive, Sanity, Process and Publish ###

These phases are handled by Ruby scripts. The  directory for those files is /usr/local/bigbluebutton/core/

```
/usr/local/bigbluebutton/core/
+-- Gemfile                                       
+-- Gemfile.lock
+-- lib
¦   +-- recordandplayback                         
¦   ¦   +-- audio_archiver.rb
¦   ¦   +-- deskshare_archiver.rb
¦   ¦   +-- edl
¦   ¦   ¦   +-- audio.rb
¦   ¦   ¦   +-- video.rb
¦   ¦   +-- edl.rb
¦   ¦   +-- events_archiver.rb
¦   ¦   +-- generators  
¦   ¦   ¦   +-- audio_processor.rb
¦   ¦   ¦   +-- audio.rb
¦   ¦   ¦   +-- events.rb
¦   ¦   ¦   +-- matterhorn_processor.rb
¦   ¦   ¦   +-- presentation.rb
¦   ¦   ¦   +-- video.rb
¦   ¦   +-- presentation_archiver.rb
¦   ¦   +-- video_archiver.rb
¦   +-- recordandplayback.rb
+-- scripts
    +-- archive
    ¦   +-- archive.rb                               
    +-- bbb-rap.sh
    +-- bigbluebutton.yml
    +-- cleanup.rb
    +-- presentation.yml
    +-- process
    ¦   +-- presentation.rb
    ¦   +-- README
    +-- publish
    ¦   +-- presentation.rb
    ¦   +-- README
    +-- rap-worker.rb
    +-- sanity
        +-- sanity.rb

```

The main file is rap-worker.rb, it executes all the Record and Playback phases

  1. Detects when new captured media from a session is available.
  1. Go through the Archive phase (/usr/local/bigbluebutton/core/scripts/archive/archive.rb)
  1. Go through the Sanity phase executing (/usr/local/bigbluebutton/core/scripts/sanity/sanity.rb)
  1. Go through the Process phase executing all the scripts under /usr/local/bigbluebutton/core/scripts/process/
  1. Go through the Publish phase executing all the scripts under /usr/local/bigbluebutton/core/scripts/publish/

  * Files ending with "archiver.rb" contain scripts with logic to archive media.

  * Files under /usr/local/bigbluebutton/core/lib/generators/ contains scripts with logic, classes and methods used by other scripts which archive or process  media.

  * Yml files contain information used by process and publish scripts.


### Playback phase ###

Playback works with the javascript library Popcorn.js which shows the slides, chat and webcam according to the current time played in the audio file. Playback files are located in /var/bigbluebutton/playback/presentation/ and used to play any published recording.


## Troubleshooting ##

Apart from the command
```
sudo bbb-record --debug
```

You can use the output from

```
sudo bbb-record --watch 
```

to detect problems with your recordings.

### Understanding output from bbb-record-watch ###

https://bigbluebutton.googlecode.com/files/bbb-record-watch-explanation.PNG




This section is intended to help you to find and in some cases to solve problems in the
Record and Playback component of BigBlueButton, watching the output of the command

```
bbb-record --watch
```

which output is explained [here](https://code.google.com/p/bigbluebutton/wiki/RecordPlaybackSpecification#--watch).

Before trying anything, verify that the "rap worker", (file in charge of the record and playback phases),
is working. Execute this command to verify:

```
ps ax | grep god | grep -v grep
```

Output should be similar to:

```
23317 pts/0    Sl     0:00 /usr/bin/ruby1.9.2 /usr/bin/god -c /etc/bigbluebutton/god/god.rb
```

If you don't get any output, start the rap worker manually

```
sudo god -c /etc/bigbluebutton/god/god.rb
```


##### RAS ( RECORDED - ARCHIVED - SANITY CHECK ) #####

Below **RAS** you won't see any **_X_** until the meeting has finished.

Once the meeting has finished, an **_X_** under **R** appears, if it does not appear:

  * Be sure all users left the meeting.

  * Check out that the parameter _defaultMeetingExpireDuration_ in _/var/lib/tomcat6/webapps/bigbluebutton/WEB-INF/classes/bigbluebutton.properties_ does not have a big value (default to 1).

  * Be sure the parameter _record=true_ was passed in the _create_ api call. If not, you didn't record the meeting.

Once the recording is archived, an **_X_** under **A** appears, if it does not appear:

  * Verify this this file exists

_/var/bigbluebutton/recording/status/recorded/INTERNAL-MEETING-ID.done_

that means that the meeting was recorded.

Once the recording passed the sanity check , an **_X_** appears under **S**, if it does not appear:

  * A media file was not properly archived, find the cause of the problem in the sanity log

```
grep INTERNAL-MEETING-ID /var/log/bigbluebutton/sanity.log
```


##### APVD #####

This section is related to recorded media. By default Audio and Presentation are recorded, if you don't see any **_X_** under **V** or **D**, then you haven't
shared your webcam or desktop, or you haven't enabled webcam or deskshare to be recorded, [ensure BigBlueButton is configured to record video and desktop session](MatterhornIntegration#Ensure_BigBlueButton_records_video_and_desktop_session.md).

##### APVDE #####

This section is related to archived media. If you don't see an **_X_** under a media you are sure that was recorded, check out
the sanity log. Execute this command to find the problem:

```
grep INTERNAL-MEETING-ID /var/log/bigbluebutton/sanity.log
```


##### Processed #####

If a script was applied to process your recording, its name should be listed under the column 'Processed', by default you should see "slides" and
"presentation", if you don't see one of them, find the problem in the log file of the processed recording:

```
grep -B 3 "status: 1" /var/log/bigbluebutton/presentation/process-INTERNAL-MEETING-ID.log | grep ERROR
```

```
grep -B 3 "status: 1" /var/log/bigbluebutton/slides/process-INTERNAL-MEETING-ID.log | grep ERROR
```

If there is some output it should show the problem. If there is not any output then tail the file to see which is the
latest executed task , sure that is the one that failed and an error message with the problem is described few lines after.

##### Published #####

If a script is applied to publish your recording, its name should be listed under the column 'Published', by default you should see "slides" and
"presentation", if you don't see one of them, find the problem in the log file of the published recording .

```
grep -B 3 "status: 1" /var/log/bigbluebutton/presentation/publish-INTERNAL-MEETING-ID.log | grep ERROR
```

```
grep -B 3 "status: 1" /var/log/bigbluebutton/slides/publish-INTERNAL-MEETING-ID.log | grep ERROR
```

If there is some output then you found the problem, if there is not any output then tail the file to see which is the
latest executed task , sure that is the one that failed and an error message with the problem is described few lines after.