

# Overview #

BigBlueButton version 0.81 (and later) supports the IMS Learning Tools Interoperability (LTI).  BigBlueButton is [certified LTI 1.0 compliant](http://www.imsglobal.org/cc/detail.cfm?ID=172).

![http://bigbluebutton.googlecode.com/svn/trunk/bbb-images/lti/imscertifiedsm.png](http://bigbluebutton.googlecode.com/svn/trunk/bbb-images/lti/imscertifiedsm.png)

BigBlueButton can accept incoming LTI launch requests from a tool consumer, which is the IMS term for any platform that can make a LTI request to an external tool (such as BigBlueButton).  Such platforms include Desire2Learn, BlackBoard, Pearson Learning Studio, etc.  See [IMS Interoperability Conformance Certification Status](http://www.imsglobal.org/cc/statuschart.cfm) for a full list of LTI compliant platforms.

What this means is that without any custom code, any LTI compliant platform can add BigBlueButton virtual classrooms to its system.  For example, the following video showshow BigBlueButton uses LTI to integrate with BlackBoard, click [BigBlueButton LTI video](https://www.youtube.com/watch?v=OSTGfvICYX4&feature=youtu.be&hd=1).

## Installation of LTI module ##

You can add LTI support by installing the following package.

```
   sudo apt-get install bbb-lti
```

This should configure the LTI tool for your setup.  If you need to make any custom modifications, edit `/var/lib/tomcat7/webapps/lti/WEB-INF/classes/lti.properties`

You'll see the following parameters

```
bigbluebuttonURL=http://test-install.blindsidenetworks.com/bigbluebutton
# Salt which is used by 3rd-party apps to authenticate api calls
bigbluebuttonSalt=8cd8ef52e8e101574e400365b55e11a6

# LTI basic information
#----------------------------------------------------
# This URL is where the LTI plugin is accessible. It can be a different server than the BigBluebutton one
# Only the hostname or IP address is required, plus the port number in case it is other than port 80
# e.g. localhost or localhost:port
ltiEndPoint=test-install.blindsidenetworks.com
# The list of consumers allowed to access this lti service.
# Format: {consumerId1:sharedSecret1}
ltiConsumers=bbb:b00be971feb0726fa697671c9cf2e883
```

| Parameter | Type | Description |
|:----------|:-----|:------------|
| bigbluebuttonURL | text | URL to the BigBlueButton server (must end in /bigbluebutton) |
| bigbluebuttonSalt | text | The shared secret to the BigBlueButton server for making API calls |
| ltiEndPoint | text | The hostname for the LTI endpoint from which to receive calls.  If it's on the same server, use localhost  |
| ltiConsumers | text | The combination of Key and Share Secret  |

This is the same configuration for the LTI parameters shown in the next section.

If you make modifications to your own lti.properties, be sure to restart BigBlueButton (which restarts tomcat7) to reload the lti.propreties file.

# Configuring BigBlueButton as an External Tool #

All LTI consumers have the ability to launch an external application that is LTI-compliant.  BigBlueButton is [LTI 1.0 compliant](http://www.imsglobal.org/cc/detail.cfm?ID=172).

This means that your BigBlueButton server can receive a single sign-on request that includes roles and additional custom parameters.  To configure an external tool in the LTI consumer, you need to provide three pieces of information: URL, customer identifier, and shared secret.  After installing the `bbb-lti` package, you can use the command `bbb-conf --lti` to retrieve these values.

Here are the LTI configuration variables from a test BigBlueButton server.

```
$ bbb-conf --lti

    URL:    http://test-install.blindsidenetworks.com/lti/tool.xml
    Key:    bbb
    Secret: b00be971feb0726fa697671c9cf2e883

  Icon URL: http://test-install.blindsidenetworks.com/lti/images/icon.ico
```

In the external tool configuration, we recommend privacy settings are set to **public** to allow the LMS to send lis\_person\_sourcedid and lis\_person\_contact\_email\_primary.  The `bbb-lti` module will use these parameters for user identification once logged into the BigBlueButton session.  If none of them is sent by default a generic name is going to be used (Viewer for viewer and Moderator for moderator).


# Launching BigBlueButton as an External Tool #

The LTI launch request passes along the user's role (, which `bbb-lti` will map to the two roles in BigBlueButton: moderator or viewer.

If no role information is given, or if the role is privileged (i.e. . Faculty, Mentor, Administrator, Instructor, etc.), then when `bbb-lti` receives a valid launch request, it will start a BigBlueButton session and join the user as **moderator**.  In all other cases, the user will join as a **viewer**.


## Custom Parameters ##

The `bbb-lti` module also accepts a number of custom parameters.

| Parameter | Type | Description |
|:----------|:-----|:------------|
| record | Boolean | Record meeting (default is false) |
| duration | Integer | Meeting duration. An integer number defines the number of minutes the session is going to last. When reached the number of minutes all the users are kicked off. If parameter is not set or is set to 0 the value taken is the one in the server |
| welcome | Text | Welcome message that appears in chat dialog (default is the global welcome message on the BigBlueButton server) |
| voicebridge | Ingerer | An integer number can be used to define the voicebridge the session is going to have (Be aware that this number must be unique for the Meeting and the BigBlueButton server) |
| mode | String | [simple|extended] When using the launching link, if mode is set to simple only single sign on will be executed, if it is set to extended and record is true, the interface for recordings will be shown as a pre-launching page. The value by default is the one configured in the lti.properties file |
| all\_moderators| Boolean | Defines that all users are going to be moderators (default is false, meaning that the role in bigbluebutton will be assigned according to the role in the LMS) |

For example, if you add `record=true` to as a custom launch parameter, then then `bbb-lti` module will record your session and show you a list of previously recorded sessions.