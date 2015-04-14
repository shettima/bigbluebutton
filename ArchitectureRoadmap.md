This document is depreciated.



## Introduction ##

This documents outlines a proposal for a **plug-in architecture** to bbb-client and bbb-apps to facilitate 3rd parties in creating BigBlueButton extensions.

**_THIS DOCUMENT IS A DRAFT. PLEASE READ IT AND PROVIDE YOUR THOUGHTS AND INPUT BELOW_**

## Preliminary work. Status: PENDING ##
Work that needs to be completed to facilitate the move to a plug-in architecture.

### Refactoring to Mate. Status: DONE ###
In May 2009 work was started to move the client from the PureMVC framework to Mate. This has proven to be a very good change overall, making the client smaller and cleaner. However the work hasn't been completed yet. Right now most of the modules run Mate, but the following modules still need to be refactored:
  * The Main Application
  * Listeners Module
  * Viewers Module

The Main app is especially critical to refactor, as it's using both mate (for recent functionality) and PureMVC. Cleaning it up will allow further development, as most of the work for creating the plug-in architecture will

### Cleanup. Status: DONE ###
The following modules aren't being used and should be removed from bbb-client, both to clean up the code base and prevent any confusion from users.
  * Join Module
  * Login Module
  * Playback Module

In addition, the following modules should be removed because they're not part of the core bbb-client. The modules should be put in a branch, or their own 3rd party repositories. As we build a plug-in architecture, these modules can be loaded externally.
  * Notes Module - aka demo module
  * DynamicInfo Module

### Add unit tests. Status: PENDING ###
Add unit tests to the Main app of bbb-client.

## Changes to module loading. Status: PENDING ##
### Better dependency resolution. Status: DONE ###
Right now config.xml requires that a module be specified in another module's 'loadNextModule' property in order to be loaded. This creates a backward dependency that is unnecessary. This should be changed so that each module specifies their own dependencies instead, using a 'depends' property to specify the modules.

### Support for dynamic loading. Status: PENDING ###
Currently all modules need to be loaded at startup. This means the system administrator needs to change the config files to specify which modules will be loaded. This should be changed to allow modules to be loaded dynamically. This has the following benefits:
  * Users can load/unload modules as they need them
  * The client size as startup is kept small, improving performance
  * The UI is kept less cluttered

### Support for loading from external URL. Status: PENDING ###
Right now modules in config.xml are located in the same directory as the main app. This means all modules need to be stored on the server loading them. An ability to load modules from an external url would be beneficial for the following reasons:
  * BigBlueButton modules can be loaded by the conference users regardless of whether the module exists on the BigBlueButton server the conference is being hosted on.
  * It would encourage people to extend BigBlueButton
  * It allows people to more easily provide commercial plugins, since only the binaries of the modules are downloaded.

Security issues would need to be discussed for these changes to take place.

## Creating an Internal API. Status: PENDING ##
Right now BigBlueButton is licensed under the LGPL. This is great from the point of view of someone who would like to extend BigBlueButton. However right now that usually means altering the source code which nullifies the LGPL advantages. It also means that people who change the system usually find their changes broken when updating to a new release. Creating an internal API would encourage more people to develop for BBB.

### Client API. Status: PENDING ###
Most of the API would be on the client. The API should provide:
  * Access conference info
  * Access and receive updates of participants info, such as user names and roles, and notifications of logins and logouts
  * Facilities to add/remove windows to the main app, buttons to the top toolbar, and other UI components in specified places.
  * Common interfaces to facilitate communication between modules.
  * Core modules should provide their own APIs to enable 3rd parties to extend core module functionality.

#### Presentation Module API. Status: PENDING ####
Adding new windows for modules clutters the UI quickly. Modules could be integrated into the presentation window and shown from there. This makes sense when the module functionality is mutually exclusive from one another (for example while showing desktop, the presenter usually wouldn't be also showing a presentation).

Common useful functionality from the presentation window should be extracted and an API created for the presentation module so people could easily create their own modules on top of it. The common functionality to keep is:
  * The Presentation Window shell itself
  * The control bar at the bottom of the window which lets you advance between pages, the zoom/panning capabilities, and the upload button
  * The Red Dot laser pointer
  * The thumbnails viewer at the bottom which lets you see the thumbnail of each page and jump between different pages.

The presentation module would expose functionality to let other modules insert content and functionality of various types into the window. For example:
  * The current functionality - any kind of document converted to swf format (pdf, doc, xls, etc..)
  * Videos  - video co-viewing youtube, desktop sharing video
  * Any other content you'd like to share with a 3rd party module (for example a 3D object viewer)

The presentation module would only keep track of pages, and by advancing to different pages the appropriate content would be loaded. I'm hoping to keep this flexible, with little constraint on what you can insert into the presentation.

### Server API. Status: PENDING ###
#### Persistent Shared Object Data. Status: PENDING ####
The ability to extend the client is limited without at least some ability to connect to red5 and use the RTMP capability. It is possible right now for client side code to create remote Shared Objects and use those to communicate to red5 and propagate changes to other clients. This is great for creating collaborative real time modules. The only downside is that the updates to the shared object aren't stored on the server, so any conference participants joining the conference late would not receive content created before they joined the conference (for example, chat messages that were exchanged before the user joined). If possible, a simple service should be created for red5 that would allow storage of arbitrary data sent using shared objects. Module developers could use this to overcome the above limitation. With this in place, people could develop relatively complex BBB modules without having to do any server side coding.

#### A Development Guide on extending bbb-apps. Status: PENDING ####
A creation of tutorials and a reference manual on how to easily extend bbb-apps to create BigBlueButton modules with a complex server side component.