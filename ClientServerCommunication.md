# Introduction #

DRAFT


## Current Client - Server APIs ##

https://github.com/bigbluebutton/bigbluebutton/blob/master/bigbluebutton-apps/src/main/java/org/bigbluebutton/conference/BigBlueButtonApplication.java
```

join(sessionName, userid,  username, role, conference, mode, room, voiceBridge, record, externUserID)
```

PARTICIPANT
https://github.com/bigbluebutton/bigbluebutton/blob/master/bigbluebutton-apps/src/main/java/org/bigbluebutton/conference/service/participants/ParticipantsService.java
```
Map getParticipants(room)
setParticipantStatus(userid, status, value) 
```


https://github.com/bigbluebutton/bigbluebutton/blob/master/bigbluebutton-apps/src/main/java/org/bigbluebutton/conference/service/participants/ParticipantsEventRecorder.java
```
logout(participant)
participantJoined(participant)
participantLeft(participant)
participantStatusChange(participant, status)
```

CHAT
https://github.com/bigbluebutton/bigbluebutton/blob/master/bigbluebutton-apps/src/main/java/org/bigbluebutton/conference/service/chat/ChatService.java
```
sendMessage(String message)

privateMessage(message, sender, receiver)
```

https://github.com/bigbluebutton/bigbluebutton/blob/master/bigbluebutton-apps/src/main/java/org/bigbluebutton/conference/service/chat/ChatEventRecorder.java
```
void newChatMessage(message)
```

PRESENTATION
https://github.com/bigbluebutton/bigbluebutton/blob/master/bigbluebutton-apps/src/main/java/org/bigbluebutton/conference/service/presentation/PresentationService.java
```
assignPresenter(userid, name, assignedBy)
void removePresentation(name)
Map getPresentationInfo()
void gotoSlide(slideNum)
void sharePresentation(presentationName, share)
void resizeAndMoveSlide(xOffset, yOffset, widthRatio, heightRatio)
```

https://github.com/bigbluebutton/bigbluebutton/blob/master/bigbluebutton-apps/src/main/java/org/bigbluebutton/conference/service/presentation/PresentationEventRecorder.java
```
so.sendMessage("conversionUpdateMessageCallback", list);
so.sendMessage("pageCountExceededUpdateMessageCallback", list);
so.sendMessage("generatedSlideUpdateMessageCallback", list);
so.sendMessage("conversionCompletedUpdateMessageCallback", list);
so.sendMessage("removePresentationCallback", list);
so.sendMessage("gotoSlideCallback", list);
so.sendMessage("sharePresentationCallback", list);
so.sendMessage("moveCallback", list);
```

https://github.com/bigbluebutton/bigbluebutton/blob/master/bigbluebutton-
```
apps/src/main/java/org/bigbluebutton/conference/service/presentation/ConversionUpdatesMessageListener.java
```

VOICE
https://github.com/bigbluebutton/bigbluebutton/blob/master/bigbluebutton-apps/src/main/java/org/bigbluebutton/conference/service/voice/VoiceService.java
```
Map<String, List> getMeetMeUsers()
void muteAllUsers(boolean mute)
boolean isRoomMuted()
void muteUnmuteUser(Integer userid,Boolean mute)
lockMuteUser(Integer userid, Boolean lock)
void kickUSer(Integer userid)
```

https://github.com/bigbluebutton/bigbluebutton/blob/master/bigbluebutton-apps/src/main/java/org/bigbluebutton/webconference/voice/ConferenceService.java
```
void startup()
void shutdown()
void createConference(String room)
void destroyConference(String room)
void lock(Integer participant, String room, Boolean lock)
void mute(Integer participant, String room, Boolean mute)
void mute(String room, Boolean mute)
boolean isRoomMuted(String room)
void muteParticipant(Integer participant, String room, Boolean mute)
void eject(Integer participant, String room)
void eject(String room)
void ejectParticipant(String room, Integer participant)
ArrayList<Participant> getParticipants(String room)
```

WHITEBOARD
https://github.com/bigbluebutton/bigbluebutton/blob/master/bigbluebutton-apps/src/main/java/org/bigbluebutton/conference/service/whiteboard/WhiteboardApplication.java
```
void setActivePresentation(String name, int numPages)
void enableWhiteboard(boolean enabled)
drawSO.sendMessage("modifyEnabledCallback", arguments);
boolean isWhiteboardEnabled()
void sendShape(double[] shape, String type, int color, int thickness, double parentWidth, double parentHeight){
drawSO.sendMessage("addSegment", arguments);
List<Object[]> getShapes()
void clear()
drawSO.sendMessage("clear", new ArrayList<Object>());
void undo()
drawSO.sendMessage("undo", new ArrayList<Object>());
```

https://github.com/bigbluebutton/bigbluebutton/blob/master/bigbluebutton-apps/src/main/java/org/bigbluebutton/conference/service/whiteboard/WhiteboardService.java
```
void sendShape(double[] shape, String type, int color, int thickness, double parentWidth, double parentHeight)
int setActivePage(int pageNum)
List<Object[]> getShapes()
void clear()
void undo()
void setActivePresentation(String name, int numPages)
void enableWhiteboard(boolean enable)
boolean isWhiteboardEnabled()
```

VOIP
https://github.com/bigbluebutton/bigbluebutton/blob/master/bbb-voice/src/main/java/org/bigbluebutton/voiceconf/red5/Service.java
```
Boolean hangup(String peerId)
void setCallExtensionPattern(String callExtensionPattern)
```

https://github.com/bigbluebutton/bigbluebutton/blob/master/bbb-voice/src/main/java/org/bigbluebutton/voiceconf/red5/ClientConnection.java
```
connection.invoke("successfullyJoinedVoiceConferenceCallback", new Object[] {publishName, playName, codec});
connection.invoke("failedToJoinVoiceConferenceCallback", new Object[] {"onUaCallFailed"});
connection.invoke("disconnectedFromJoinVoiceConferenceCallback", new Object[] {"onUaCallClosed"});
```