(DRAFT)
# Introduction #

The following page describes the specification of the Webhook API for BigBlueButton.

This will allow a 3rd party application subscribe to the different events that happen during a BigBlueButton session. Events such as user join, user leaves, etc.

**Currently, this is in development phase, it's not yet a working prototype or even a production feature. These instructions are only for developers.**

# Setting up #

## Get the latest code ##
In a BigBlueButton git repo, do:
<a href='Hidden comment: 
```
git checkout polling-module
git pull origin polling-module
```
'></a>
```
git checkout merge-polling-with-master
git pull origin merge-polling-with-master
```

## Compile and Build ##
You will need to compile and deploy BigBlueButton-Web. After that, install Node.js (check out labs/bbb-callbacks/README for instructions).

Then run the webhook module:
```
cd labs/bbb-callbacks
npm install -d
nohup node app.js > output.log &
```

# API Description #

We have created three new API calls in order to enable webhooks:

Name: **subscribeEvent**
Parameters:
| Param | Description |
|:------|:------------|
| meetingID | String. the meeting that you would to check the events |
| callbackURL | String. It's the URL of your third party application that will handle the events |
Response: Status and SubscriptionID

Name: **unsubscribeEvent**
Parameters:
| Param | Description |
|:------|:------------|
| meetingID | String. the meeting that you would to check the events |
| subscriptionID | Identifier. It's the identifier of the subscription |
Response: Status

Name: **listSubscriptions**
Parameters:
| Param | Description |
|:------|:------------|
| meetingID | String. the meeting that you would to check the events |
Response: List of the subscriptions with their status

# Usage #
## EndPoint service ##
For testing this feature, you will need to have already the 3rd party application for handling the events. If you don't have it, you can use the following service: http://postcatcher.in/

This service will help you to display all the events that you would like to track down. PostCatcher will give you an unique endpoint URL that you can use for testing. The URL should be in this format: "http://postcatcher.in/catchers/XXX"

## Generate API Calls ##
Like this is a development feature, you will need to create the URLs for the API calls. However, you can also try the following tool which is based on the library of the [API-Mate](http://mconf.github.io/api-mate/) tool.

For example, for generate the subscribeEvent API Call:
  * Fill in the fields according to your server
  * Click "Custom parameters" to open the custom section
  * Under "Custom API calls" write "call1=subscribeEvent"
  * Under "Custom parameters" write param `callbackURL=PostCatcher-EndPoint-URL`

## Testing ##
You will need to create a BigBlueButton session, then subscribe to the Meeting Events, and finally test with a generated event.

Click on the create link, then click on the custom api call which should have the name that you put in the previous step, in this case: "call1".

Now, it's time to test with a generated event.

We still need to do changes in BigBlueButton-apps which is the component that handle the realtime conference. However, you can generate a redis pubsub event in order to test the webhook feature. This can be a little tricky.

Once that you created the meeting, you need to look for the internal meeting ID, which you can find in the API logs. After you find the internalMeetingID, go to the console and type:

```
redis-cli
# Now in the redis console
redi> publish "bigbluebutton:events" "{\"data\":\"hola ola\",\"meetingID\":\"your-meeting-id\",\"event\":\"TestEvent\"}
```

This will generated a `TestEvent` which will be read it by the webhooks module and then it will perform a POST request to the EndPoint URL that you passed. Now, go to the PostCatcher site and you will see the generated event.