# HTML5 Development Environment Setup #



**Note**: These instructions are currently out-of-date.  Work is underway to release a newer version of the HTML5 client on BigBlueButton 0.9.0-beta.  Watch the mailing list https://groups.google.com/forum/#!forum/bigbluebutton-dev for updates.

## BigBlueButton HTML5 Client Design ##
If you have not already done so, you should read through an [Overview of HTML5 Client](HTML5.md).

## Initial setup ##

Before you begin, you will need to have a BigBlueButton server installed from packages built from the master branch, referred hereafter as 0.81.  The BigBlueButton HTML5 client is based on 0.81-dev. To install 0.81 from packages, follow the instructions at [Installing 0.81 packages](InstallationUbuntu.md).

Once you have 0.81 installed, you need to setup a development environment on the BigBlueButton server.  This will allow you to rebuild specific components from source.  Since the HTML5 client is on a separate branch from master, setting up a development environment requires a few changes to the default steps for setting up a standard development environment.

To setup the standard development environment for the HTML5 client, follow the instructions at [Developing](Developing.md) with the following changes:

  * Under "Checking out the source", use the git command
```
git checkout -b html5-bridge origin/html5-bridge
```
to switch to the HTML5 client branch.

Compile BBB-Client following the instructions in   https://code.google.com/p/bigbluebutton/wiki/Developing#Client_Development

Compile BBB-Web following the instructions
https://code.google.com/p/bigbluebutton/wiki/Developing#Developing_BBB-Web

Compile BBB-Apps following the instructions
https://code.google.com/p/bigbluebutton/wiki/Developing#Developing_the_Red5_Applications


## HTML5 Bridge component ##

### Installation ###

The HTML5 bridge component is currently written using node.js. Since Ubuntu 10.04 doesn't ship an up-to-date version of node.js, it's easiest to use a PPA:

```
sudo add-apt-repository ppa:chris-lea/node.js
sudo apt-get update
sudo apt-get install nodejs
```

Now you can use `npm` to install the node.js dependencies:

```
cd ~/dev/bigbluebutton/labs/bbb-html5-client
npm install
```

### Running ###

The HTML5 client uses the redis database to store information about the meetings. Right now, there isn't an "automatic" way to delete the keys, so it's recommended that each time that you run the html5 client, you should clean the redis database.

Clean the database:

```
redis-cli flushdb
```

Perform a clean restart of BigBlueButton

```
sudo bbb-conf --clean
```

Run the HTML5 client bridge:

```
cd ~/dev/bigbluebutton/labs/bbb-html5-client
node app.js
```

### Usage ###

  1. Before using the HTML5 client, you must create a meeting and join it using the Flash client. The easiest way to do this is to join the Demo Meeting.

2.  Open another tab or a new browser


3.  Go to the address: http://yourIP:3000


4.  Demo Meeting should appear from the dropdown menu


5.  Write your name and you will join to the meeting throught the HTML5 client

What is working?

  * Users module: Join, leave, get list of participants, change presenter
  * Chat Module: send public chat, get history chat
  * Presentation Module: load slides from Flex client, change slide, red dot
  * Whiteboard Module: Draw and store pencil shape from Flex client

### Documentation ###
We use codo, a program we installed via npm to generate html documentation pages based on comments in the code in the javadocs format.  https://github.com/coffeedoc/codo

To generate the documentation:
```
cd ~/dev/bigbluebutton/labs/bbb-html5-client
cake docs
```

### Testing Message Handling ###

A tool has been created to test that messages passed through the redis pub/sub are handled correctly by the client. Follow set-up instructions in its Github page.

https://github.com/mohamed-ahmed/html5-api-mate/