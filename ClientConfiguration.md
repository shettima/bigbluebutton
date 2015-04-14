

# Introduction #
A detailed discussion of the client's config.xml file. This document shows you how to configure the client to work to your liking, and what options are available.

**Note:** In 0.81 the config.xml is cached by the BigBlueButton server for any active meeting.  That is, making a change to the config.xml and refreshing the browser will not load the new config.xml.  To see the results of editing the config.xml, create a new meeting and join it, or restart the BigBlueButton server.

## Config.xml ##
The config.xml file is located in the deployed client directory, default location /var/www/bigbluebutton/client/conf/config.xml. If you are working with the source code, it is located in the client's src/conf directory, default location /home/firstuser/dev/source/bigbluebutton/bigbluebutton-client/src/conf/config.xml.

Open up the config.xml file. This is a line by line discussion of it's properties, applicable for version 0.8.

The template can be found [here](https://github.com/bigbluebutton/bigbluebutton/blob/master/bigbluebutton-client/resources/config.xml.template)

## Main parameters ##
```
    <localeversion suppressWarning="false">0.8-beta4</localeversion>
    <version>VERSION</version>
    <help url="http://HOST/help.html"/>
    <porttest host="HOST" application="video"/>    
    <application uri="rtmp://HOST/bigbluebutton" host="http://HOST/bigbluebutton/api/enter" />
    <language userSelectionEnabled="true" />
    <skinning enabled="false" url="branding/css/theme.css.swf" />
    <layout showLogButton="false" showVideoLayout="false" 
      showResetLayout="true" showToolbar="true" 
      showHelpButton="true" showLogoutWindow="true"/>
```


```
    <localeversion suppressWarning="false">0.8-beta4</localeversion>
```

This should be left as is. It has to do with the client caching localization files. If you're having problems with the Warning Dialog for old localizations, you can set the suppressWarning parameter to true.

```
    <version>VERSION</version>
```
This has to do with the caching of the client as a whole. Should also be left alone, in general.

```
    <help url="http://HOST/help.html"/>
```

This is the url that you would like users redirected to when they click the Help button in the client.

```
    <porttest host="HOST" application="video"/> 
```

The ip and red5 application the client uses to test whether necessary ports are open, and determine whether tunneling should be used. The host should be your bbb server ip. The application should be left as video.

```
    <application uri="rtmp://HOST/bigbluebutton" host="http://HOST/bigbluebutton/api/enter" />
```

The url that the client queries for the user information when the user joins the meeting.

```
    <language userSelectionEnabled="true" />
```

This enables/disables the language selector combo box in the client. Enable this if you would like your users to be able to select the language of their BigBlueButton client themselves instead of the language being detected automatically for them.

```
    <skinning enabled="false" url="branding/css/theme.css.swf" />
```

Set **enabled** to true and set the **url** to the swf file with your theme modifications. This enables/disables skinning support for the client. If the value is false, the url attribute will be ignored. Otherwise the url attribute specifies the compiled CSS file to load on startup. See [Branding](Branding.md) for more details.

```
    <layout showLogButton="false" showVideoLayout="false" 
       showResetLayout="true" showToolbar="true" 
       showHelpButton="true" showLogoutWindow="true"/>
```

```
  showLogButton="false"
```

Show or hide the button (lower right-hand corner) to display the debug window.  If you are running BigBlueButton 0.8, see [showLogButton](#showLogButton.md).

```
  showVideoLayout="false"
```
Show or hide the video layout button on the lower-right corner of the client.

```
  showResetLayout="true"
```
Show or hide the reset layout button on the lower-right corner of the client.

```
  showToolbar="true"
```
Show or hide the main toolbar on the top part of the client.

```
  showHelpButton="true" 
```
Show the help button on the main toolbar.


```
  showLogoutWindow="true"
```
Show the logout window when the client logs out.


## Modules ##
The BigBlueButton client is comprised of one or more modules. You can specify which modules you would like loaded in the config.xml file. The modules will be loaded at startup. The properties for the different currently available modules are shown here in no particular order. Most of the modules share certain attributes:

#### name ####
The unique name of the module

#### url ####
The url to the compiled module .swf file. Usually has a version appended to it, to prevent caching of old version when a new version of BigBlueButton is released.

#### uri ####
The uri the module will connect to using rtmp. This is usually your bbb server ip with /bigbluebutton appended to it. Apart from making sure the ip is correct, you don't have to worry about it.

#### depends on ####
Optional parameter that should be included in the case that the module being loaded depends on another BigBlueButton module being loaded first in order to work properly.

#### windowVisible ####
Set to false to hide the window.

#### position ####
Location of module on the screen.  There are a number of pre-defined positions that you can assign a module to change its layout.

  1. top-right

### Chat Module ###
```

		<module name="ChatModule" url="ChatModule.swf?v=VERSION" 
			uri="rtmp://HOST/bigbluebutton" 
			dependsOn="ViewersModule"	
			translationOn="false"
			translationEnabled="false"	
			privateEnabled="true"  
			position="top-right"
		/>

```
#### translationOn ####
Determines whether the automatic translation of Chat messages to the users' language on by default. If true, all messages the user receives in the chat will be translated to their detected or selected language. The users can see the original message by rolling over the message in the Chat. They can also disable the translation in the '+' Tab of the chat window.

**NOTE**

This feature won't work because Google has stopped the translate service.

#### translationEnabled ####
If set to true, the user will have the option of enabling/disabling automatic translation from the '+' Tab in the chat window. They will also be able to detect the language they want their messages translated to.

#### privateEnabled ####
Set to true to enable private chat.


### Viewers Module ###
```
		<module name="ViewersModule" url="ViewersModule.swf?v=VERSION" 
			uri="rtmp://HOST/bigbluebutton" 
			host="http://HOST/bigbluebutton/api/enter"
			allowKickUser="false"
			windowVisible="true"
		/>
```
#### allowKickUser ####
Determines whether or not the Moderators of the meeting are able to kick a user from the conference. If set to true, a Moderator will be given the option of kicking a selected user from the conference by clicking on their name and the Kick button inside the Viewers window.

#### windowVisible ####
Whether the viewers window will be displayed or not.


### Listeners Module ###
```
                <module name="ListenersModule" url="ListenersModule.swf?v=VERSION"
                        uri="rtmp://192.168.0.36/bigbluebutton"
                        recordingHost="http://192.168.0.36"
                        windowVisible="true"
                        position="bottom-left"
                />


```
The Listeners Module is the window which shows who is currently connected to the voice conference in the Listeners window. Nothing special here. The recordingHost attribute is not functioning and should be removed.

### Desktop Sharing ###
```
                <module name="DeskShareModule"
                        url="DeskShareModule.swf?v=VERSION"
                        uri="rtmp://192.168.0.36/deskShare"
                        autoStart="false"
                />
```
The Desktop Sharing module. Note that it connects to /deskShare, which is a red5 application on the server separate from the /bigbluebutton application.

#### autoStart ####
Set to true to automatically start the desktop sharing module.

### Phone Module ###
```
                <module name="PhoneModule" url="PhoneModule.swf?v=VERSION"
                        uri="rtmp://192.168.0.36/sip"
                        autoJoin="true"
                        skipCheck="false"
                        showButton="true"
                        enabledEchoCancel="true"
                        dependsOn="ViewersModule"
                />



```
The Phone Module is the shows as the small headset icon in the upper left of the client. It allows users to join the meeting through VoIP by using a headset. Note again the separate /sip server side application.


#### autoStart ####
Set to true to show the button in the title bar.

#### autoJoin ####
Set to true to have the user automatically join the voice conference bridge.

#### showButton ####
Set to true to have the headset icon visible on the toolbar.

#### enabledEchoCancel ####
Set to true to enable the acoustic echo cancellation.

### Videoconf Module ###
```
                <module name="VideoconfModule" url="VideoconfModule.swf?v=3944"
                        uri="rtmp://HOST/video"
                        dependson = "ViewersModule"
                        videoQuality = "100"
                        presenterShareOnly = "false"
                        resolutions = "320x240,640x480,1280x720"
                        autoStart = "false"
                        showButton = "true"
                        showCloseButton = "true"
                        publishWindowVisible = "true"
                        viewerWindowMaxed = "false"
                        viewerWindowLocation = "top"
                        camKeyFrameInterval = "30"
                        camModeFps = "10"
                        camQualityBandwidth = "0"
                        camQualityPicture = "90"
                        enableH264 = "false"
                        h264Level = "2.1"
                        h264Profile = "main"
                />
```

The Video Conferencing Module. Allows users to share their webcams with the room. It connects to the separate /video application on the bbb server. See also [changing quality of webcam picture](http://code.google.com/p/bigbluebutton/wiki/FAQ#How_do_I_change_the_video_quality_of_the_shared_webcams?) in the FAQ.

#### presenterShareOnly ####
If set to true, only the current presenter will have the option of sharing their webcam. This is useful in one-to-many meetings, where there is one presenter that everyone should be focusing on, such as a webcast or a virtual classroom.

#### resolutions ####
Configure the resolutions you want the user to choose from.

#### autoStart ####
Start the webcam automatically. This will choose the first option in the `resolutions` entry.

#### showButton ####
Show button in main toolbar.

#### publishWindowVisible ####
Make the webcam publish window visible. If you set to false, you need to make `autoStart` to true. Otherwise, you won't be able to start camera.

#### viewerWindowMaxed ####
Maximize the webcam viewer window.

#### viewerWindowLocation ####
Set the preferred location of the viewer window when it pops up.

#### camKeyFrameInterval, camModeFps, camQualityBandwidth, camQualityPicture ####
Configure quality and framerate of webcam.
See http://help.adobe.com/en_US/FlashPlatform/beta/reference/actionscript/3/flash/media/Camera.html

#### h264Level, h264Profile ####
**NOTE** You need to uncomment and compile source to make this work. This only works on Flash Player 11 (still in Beta).

See the following:

https://github.com/bigbluebutton/bigbluebutton/blob/master/bigbluebutton-client/src/org/bigbluebutton/modules/videoconf/business/VideoProxy.as

http://help.adobe.com/en_US/FlashPlatform/beta/reference/actionscript/3/flash/media/H264Level.html

http://help.adobe.com/en_US/FlashPlatform/beta/reference/actionscript/3/flash/media/H264Profile.html

### Videodock Module ###
This module will dock viewed webcams and and tile them.

```
                <module name="VideodockModule" url="VideodockModule.swf?v=VERSION"
                        uri="rtmp://192.168.0.36/bigbluebutton"
                        dependsOn="VideoconfModule, ViewersModule"
                        autoDock="true"
                        maximizeWindow="false"
                        position="bottom-right"
                        width="172"
                        height="179"
                        layout="smart"
                        oneAlwaysBigger="false"
                />
```

#### autoDock ####
Automatically dock all webcam windows.

#### maximizeWindow ####
Maximize the docking window.

#### oneAlwaysBigger ####
Always have one of the video windows bigger.


### Present Module ###
```
       <module name="PresentModule" url="PresentModule.swf?v=VERSION"
                        uri="rtmp://192.168.0.36/bigbluebutton"
                        host="http://192.168.0.36"
                        showPresentWindow="true"
                        showWindowControls="true"
                        dependsOn="ViewersModule"
                />

```
The Presentation Module which lets users share slides and other documents in the main viewing area inside of BigBlueButton.

#### showPresentWindow ####
Set true to show the presentation window.

#### showWindowControls ####
Set true to show the presentation window controls.


### Whiteboard Module ###
```
<module name="WhiteboardModule" url="WhiteboardModule.swf?v=VERSION" 
	uri="rtmp://192.168.0.225/bigbluebutton" 
	dependsOn="PresentModule"
/>
```
The Whiteboard Module is a transparent overlaid canvas on top of the presentation window. It allows users to draw annotations on top of uploaded slides and documents.

### Dynamic Info Module ###
```
<module name="DynamicInfoModule" url="DynamicInfoModule.swf?v=VERSION" 
	uri="rtmp://192.168.0.225/bigbluebutton" 
	host="http://192.168.0.225" 
	infoURL="http://HOST/client/conf/example-info-data.xml?user={userID}&role={role}&meetingID={meetingID}"
/>
```
An experimental module that allows you to inject custom data into the conference.

### Example Chat Module ###
```
<module name="ExampleChatModule" url="ExampleChatModule.swf?v=56" 
            uri="rtmp://192.168.0.225/bigbluebutton" 
            host="http://192.168.0.225"
/>
```
A rudimentary module meant to provide sample code on how to build your own BigBlueButton module. For more information see [SampleModule](SampleModule.md)


#### salt ####
The security salt needed to create meeting. This is required by the BigBlueButton API. By default, the salt is found in /var/lib/tomcat/webapps/bigbluebutton/WEB-INF/classes/bigbluebutton.properties


## Layouts ##

Layouts documentation

The layouts are defined in XML format, and the default layouts file is located at /var/www/bigbluebutton/client/conf/layout.xml.

The format is as follows:
```
<layouts>
    <layout name=”LAYOUT_NAME” ... >
        <window name=”WINDOW_NAME” ... />
        <window ... />
        ...
    </layout>
    <layout ... />
    ...
</layouts>
```

### Layout parameters ###

|Name | Required / Optional | Type | Description|
|:----|:--------------------|:-----|:-----------|
|name |Required |String |This is the name that will appear in the list of layouts on BigBlueButton|
|default | Optional (default is “false”) | Boolean | Only one layout in the entire definition should be the default one (that will organize the windows on startup).|
|role | Optional (default is “viewer”) | String | This parameter make possible to define multiple layouts with the same name but with different definitions depending on the participant role. They must have the same name to assign them together. Values are “viewer”, “moderator” and “presenter”.|

### Window parameters ###


|Name | Required / Optional | Type | Description|
|:----|:--------------------|:-----|:-----------|
|name | Required | String | This is the window identifier. Example: NotesWindow, PresentationWindow, VideoDock, ChatWindow, UsersWindow, ViewersWindow, ListenersWindow, BroadcastWindow.|
|width | Required (optional only if hidden=”true” or minimized=”true”) | Number | The width of the window relative to the canvas. Values are [0..1].|
|height | Required (optional only if hidden=”true” or minimized=”true”) | Number | The height of the window relative to the canvas. Values are [0..1].|
|x | Required (optional only if hidden=”true” or minimized=”true”) | Number | The x position of the window relative to the canvas. Values are [0..1].|
|y | Required (optional only if hidden=”true” or minimized=”true”) | Number | The y position of the window relative to the canvas. Values are [0..1].|
|order | Optional | Number | Specifies the z order of the window, i.e, which window is in front of the others.|
|hidden | Optional (default is “false”) | Boolean | If hidden=”true” the window won’t show up in the BigBlueButton interface.|
|minimized | Optional (default is “false”) | Boolean | If minimized=”true” the window will be minimized at the left bottom corner and can be restored.|
|maximized | Optional (default is “false”) | Boolean | If maximized=”true” the window will be maximized to use the entire screen.|
|minWidth | Optional | Number | The minimum width of the window expressed in pixels.|
|minHeight | Optional | Number | The minimum height of the window expressed in pixels. Not implemented yet.|
|draggable | Optional | Boolean | Not implemented yet.|
|resizable | Optional | Boolean | Not implemented yet.|


You can have multiple layout definitions, and inside each layout, multiple window layout definitions.

### Example: ###
```
<layout name="Default minWidth">
<window name="NotesWindow" hidden="true" width="0.7" height="1" x="0" y="0"/>
<window name="BroadcastWindow" hidden="true"/>
<window name="PresentationWindow" width="0.51" height="0.99" x="0.18" y="0"/>
<window name="VideoDock" width="0.17" height="0.30" x="0" y="0.68" minWidth="280"/>
<window name="ChatWindow" width="0.30" height="0.99" x="0.69" y="0"/>
<window name="UsersWindow" width="0.17" height="0.67" x="0" y="0" minWidth="280"/>
<window name="ViewersWindow" width="0.17" height="0.33" x="0" y="0"/>
<window name="ListenersWindow" width="0.17" height="0.33" x="0" y="0.34"/>
</layout>
```

### Configuration on config.xml: ###

|Name | Required / Optional | Type | Description|
|:----|:--------------------|:-----|:-----------|
|layoutConfig | Required | String | URL of the layouts definition file.|
|enableEdit | Required (default is “false”) | Boolean|Enable the buttons for moderators to manage layouts within the session. The buttons enable the moderator to add custom layouts to the list, save layouts to file and load layouts back from file.|

This is the moderator view when enableEdit=”true”.


When the moderator clicks on the “lock layout” button, every participant will see the same layout and won’t be able to change it (except for moderators).
New layouts can be created using the “add layout to list” button. Sysadmins always have the possibility to create a new layout, save it to file, edit is using a text editor to insert constraints like minWidth, and then copy this new layout to the default layouts definition file (/var/www/bigbluebutton/client/conf/layout.xml).

Example of the layouts module definition on config.xml:
```
<module name="LayoutModule" 
    url="LayoutModule.swf?v=VERSION" 
    uri="rtmp://HOST/bigbluebutton" 
    layoutConfig="conf/layout.xml" 
    enableEdit="false"/>
```
