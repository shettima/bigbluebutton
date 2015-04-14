## Final Video of All Polling Module Features ##

Updated April 23 2012

<a href='http://www.youtube.com/watch?feature=player_embedded&v=0HApxf6fzsY' target='_blank'><img src='http://img.youtube.com/vi/0HApxf6fzsY/0.jpg' width='425' height=344 /></a>


## Polling Module  Demo Video ##


Updated February 24

<a href='http://www.youtube.com/watch?feature=player_embedded&v=0zE4iYHLySI' target='_blank'><img src='http://img.youtube.com/vi/0zE4iYHLySI/0.jpg' width='425' height=344 /></a>






## Polling Module Progress Map ##


### bbb-client part ###

> _**0.001**_ Created Polling Module Architecture (folders: events, managers, maps, views) <br /> <br />
> _**0.002**_ Created PollingInstructionsWindow  - window designed following the Polling Mockup which consist of: <br />
```

Title : text box for title
Questions: text area for questions
Responses: text are for responses
Checkbox with label: Allow users to check ,more than one response
Two Buttons: Create New Poll and Cancel that does not invoke any methods so far
```

> Here is the screen-shot of the design:

> ![http://myprogrammingblog.files.wordpress.com/2011/10/pollinginstructions.png](http://myprogrammingblog.files.wordpress.com/2011/10/pollinginstructions.png)

> _**0.003**_ PollingInstructionsWindow.mxml! receives new method:
> _**getPrefferedPosition()**_ -> states how the window should appear in the interface (set to POPUP)

> _**0.004**_ Created _**PollingManager**_  that is responsible for all communication processes between EventMap and Views<br /> <br />
> _**0.005**_ Created _**PollingEventMap**_ <br /> <br />
> _**0.006**_ Created _**ToolBar icon**_ and _**ToolBarButtonManager**_ that is responsible for all ToolBarButton actions <br /> <br />
> _**0.007**_ ToolBarButton Manager receives method _**addToolbarButton()**_ that enables ToolBarButton to show on MainToolBar <br /> <br />
> _**0.008**_ Created _**ToolbarButton**_ that states alignment of Button <br /> <br />
> _**0.009**_ ToolBar icon is Integrated into interface <br /> <br />

> ![http://myprogrammingblog.files.wordpress.com/2011/10/toolbarbutton.png](http://myprogrammingblog.files.wordpress.com/2011/10/toolbarbutton.png)
> _**0.010**_ ToolBar icon became  clickable <br /> <br />
> _**0.011**_ Created _**PollingEventMap**_ <br /> <br />
> _**0.012**_ 2 events created inside events:  <br /> <br />

> ```

1. _*!OpenInstructionsEvent*  -> opens instructions window (window for Presenter to create a new poll)
2. _*!CloseInstructionsEvent* -> event that closes Instrucitons window
```

> _**0.013**_ ToolBar button  on click invokes PollingInstructionsWindow

```

_*Problem Encountered:* _When !ToolBarButton invokes Window, toolbarbutton becomes stays, when trying to solve this problem, window does not close._
```
> _**0.014**_ PollingInstructionsWindow.mxml receives 2 new methods:<br />

```

1.overloaded _*close*_ function that uses custom method to Close Instructions Window
2. _*closeInstructionsWindow()*_ method that uses !CloseInstructionsEvent to dispatch parameters to !EventMap
```

> _**0.015**_ _Problem Solved_ by adding two separate invokes into CloseInstructionsEvent one invokes method from manager other from PollingEventmap.<br /><br />
> _**0.016**_ ToolBarButton.mxml received new method:

> ```

** _*openPollingInstructions()*_ -> opens !PollingInstructionsWindow.mxml
```

> _**0.017**_ ToolBarButton becomes active when window closes<br /> <br />

> _**0.018**_ ToolBarButtonManager receives _**removeToolBarButton**_ method that  hides toolbarButton<br /> <br />
> _**0.019**_ ToolBarButtonManager receives _**enableToolbarButton**_ method that enables ToolBarButton in MainToolbar<br /> <br />
> _**0.02**_ Two Event added to PollingEventMap:
> ```

** _*!MadePresenterEvent.SWITCH_TO_PRESENTER_MODE*_ - shows toolbarbutton only to Presenter
** _*!MadePresenterEvent.SWITCH_TO_VIEWER_MODE*_ - hides toolbarbutton from Viewers
```
> > _**0.021**_ New Events integrated in the System - ToolBarButton appears only to presenter, disappears when Presenter changes to Viewer.


<a href='http://www.youtube.com/watch?feature=player_embedded&v=fQHPOjuxnfo' target='_blank'><img src='http://img.youtube.com/vi/fQHPOjuxnfo/0.jpg' width='425' height=344 /></a>


> _**0.023**_ Polling Service now allows to share the object between moderator and viewers

> _**0.024**_ Feature added to Polling Service: only viewers see the poll, moderator does not

> _**0.025**_ Module design has changed allowing to cut 200 lines of code, without compromising on performance

> _**0.026**_ PollingWindowManager is added, it takes control strictly over the actions of opening, closing windows

> _**0.027**_  PollPreview feature is added. Demo video:

> <a href='http://www.youtube.com/watch?feature=player_embedded&v=BuZ47aGLWGQ' target='_blank'><img src='http://img.youtube.com/vi/BuZ47aGLWGQ/0.jpg' width='425' height=344 /></a>


> _**0.028**_  PollInstrucuctionsWindow got rid of star symbol when creating answers.

> _**0.029**_  Script created that trims whitespaces and return characters in PollingInstructionsWindow

> _**0.030**_ Script created that does not allow duplicate answers


> _**0.031**_ PollingService received method **!savePoll** that sends polling info to the red5

> ### bbb-app part ###

> _**0.032**_ PollService.java created to receive and direct calls between reed5 and bbb-client

> _**0.033**_ !Poll.java is created. It encapsulates poll data into an object

> _**0.034**_ PollService.java have received method !savePoll that receives info from the bbb-client thus communication between apps and  client is established

> _**0.035**_ PollApllication.java is created - it receives information from Service and makes sure info goes to the correct room by sending info to the PollRoomsManager

> _**0.036**_ PolRoom.java receives info from PollRoomsManager and sends info to the listener

> _**0.037**_ PollEventRecorder build an event and maps poll data so it could be recorded to Redis

> _**0.038**_ PollHandler.java is created to give a specific instructions when the BigBlueButton starts

> _**0.039**_ PublicPollRecorder creates key-value pairs that can be recorded to the redis

> _**0.040**_ Data is successfully sent to redis database and recorded as key-value pairs





