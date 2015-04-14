

# Overview #
This document describes how to setup a development environment on a BigblueButton server.  Once setup, you can make custom changes to BigBlueButton  on your server.

This guide is written for BigBlueButton 0.81-dev or later.  If you are using an earlier version of BigBlueButton, you'll need to update you server (see 081InstallationUbuntu).

A BigBlueButton server is built from a number of core that work together to implement the real-time sharing of audio, video, slides, desktop, chat, and presentations. The components are:

  * bbb-web -- Implements the BigBlueButton API and conversion of documents for presentation
  * bbb-client -- Flash based client that loads within the browser
  * bbb-apps -- Server side applications for supporting client modules
  * bbb-deskshare -- Desktop sharing server

You don't need to understand everything about each component, but you do need to understand the [ArchitectureOverview overall architecture.

We've expanded this guide to provide step-by-step instructions instead of running scripts.  The problem with scripts was if they didn't properly setup a development environment, a new developer had no idea what went wrong.

In this document, we'll go through the steps for setting up a development environment for the above components.


## Before you begin ##

The source for BigBlueButton is managed by git and is hosted on GitHub (see [source code](https://github.com/bigbluebutton/bigbluebutton).  You need to be familiar with how git works.  Specifically, how to

  * clone a repository
  * create a branch
  * push changes back to a repository

If you don't know what the terms **_clone_**, **_branch_**, and **_commit_** mean in git, stop now and spend some time working with git to understand these concepts.  A good place to start is [free book](http://progit.org/book/) and http://help.github.com/ GitHub Help pages].

### Setup a Working BigBlueButton Server ###
You'll setup the development environment on an unmodified BigBlueButton server installed from packages.

While it may seem obvious, we emphasize your BigBlueButton server should be working **before** you start setting up the development environment.  That way, if you start to modify the BigBlueButton client, for example, and something isn't working, you can switch back to the built-in client to check that your environment is working correctly.

### Developing on Windows ###
To develop BigBlueButton from within a Windows OS, first download the [BigBlueButton VM](BigBlueButtonVM.md) and use it for compiling and testing your changes.  Much of the core development of BigBlueButton is done using FlexBuilder on Windows and running the BigBlueButton server in a virtual machine under VMWare Workstation.  (You can use VMWare player, but VMWare Workstation gives you the ability to snapshot the virtual machine, making it easy to return to previous working states.)

### You'll need root privilidges ###
To setup the BigBlueButton development environment, you need to exectue commands as root, such as

```
  sudo ls
```


# Setup a Development Environment #

## Setting up the Development Tools ##

On a BigBlueButton server, you can install all the necessary development tools by following the steps below:

First you need to install the core development tools.
```
sudo apt-get install git-core ant openjdk-6-jdk
```

Next you need to make a directory to hold the tools needed for BigBlueButton development.

```
mkdir -p ~/dev/tools
cd ~/dev/tools
```

You now need to download a tar.gz file with wget and then unpack each of these tools in the above directory.

```
wget http://bigbluebutton.googlecode.com/files/gradle-0.8.tar.gz
tar xvfz gradle-0.8.tar.gz

wget http://bigbluebutton.googlecode.com/files/groovy-1.6.5.tar.gz
tar xvfz groovy-1.6.5.tar.gz

wget http://bigbluebutton.googlecode.com/files/grails-1.1.1.tar.gz
tar xvfz grails-1.1.1.tar.gz
```

Next you need to get the Flex 4.5 SDK package. It's important to note that even though we're downloading the Flex 4.5 SDK, BigBlueButton is developed and built with Flex 3 compatibility mode enabled.

First, you need to download the zipped up SDK from the Adobe site.
```
wget http://fpdownload.adobe.com/pub/flex/sdk/builds/flex4.5/flex_sdk_4.5.0.20967_mpl.zip
```

Next, you need to make a directory for it and unzip it.
```
mkdir -p ~/dev/tools/flex-4.5.0.20967
unzip flex_sdk_4.5.0.20967_mpl.zip -d flex-4.5.0.20967
```

The Flex SDK is now unzipped, but you need to modify the permissions to us the Flex tools.

```
sudo find ~/dev/tools/flex-4.5.0.20967 -type d -exec chmod o+rx '{}' \;
chmod 755 ~/dev/tools/flex-4.5.0.20967/bin/*
sudo chmod -R +r ~/dev/tools/flex-4.5.0.20967
```

Next, create a linked directory with a shortened name for easier referencing.

```
ln -s ~/dev/tools/flex-4.5.0.20967 ~/dev/tools/flex
```

The last step in setting up the Flex SDK environment is to download a Flex library for video.

```
mkdir -p flex-4.5.0.20967/frameworks/libs/player/11.2
cd flex-4.5.0.20967/frameworks/libs/player/11.2
wget http://download.macromedia.com/get/flashplayer/updaters/11/playerglobal11_2.swc
mv -f playerglobal11_2.swc playerglobal.swc
```

With the tools installed, you need to add a set of environment variables to your `.profile` to access these tools.

```
vi ~/.profile
```

Paste the following text at bottom of `.profile`.

```

export GROOVY_HOME=$HOME/dev/tools/groovy-1.6.5
export PATH=$PATH:$GROOVY_HOME/bin

export GRAILS_HOME=$HOME/dev/tools/grails-1.1.1
export PATH=$PATH:$GRAILS_HOME/bin

export FLEX_HOME=$HOME/dev/tools/flex
export PATH=$PATH:$FLEX_HOME/bin

export GRADLE_HOME=$HOME/dev/tools/gradle-0.8
export PATH=$PATH:$GRADLE_HOME/bin

export JAVA_HOME=/usr/lib/jvm/java-6-openjdk
export ANT_OPTS="-Xmx512m -XX:MaxPermSize=512m"

```

Reload your profile to use these tools (this will happen automatically when you next login).

```
source ~/.profile
```

You can use any account on a BigBlueButton server for development (remember: the account must have sudo privileges).  For the remainder of this document we'll the `firstuser` account.

## Checking out the Source ##

You'll clone the source in the following directory:

```
  /home/firstuser/dev
```


We recommend you use GitHub to fork BigBlueButton.  This will make it easy for you to work on your own copy of the source, store updates the source to your GitHub account, and [contribute](FAQ#Contributing_to_BigBlueButton.md) back to the project by sending us pull requests.

To clone the source:

  1. Setup an account on [GitHub](https://github.com/plans) if you don't already have one (it's free!)
  1. Setup your [ssh keys](http://help.github.com/linux-set-up-git/). Skip to the "Set Up SSH Keys" section.
  1. [Fork](http://help.github.com/fork-a-repo/) the BigBlueButton repository into your GitHub account
  1. Clone your repository into your `~/dev` folder


After cloning, you'll have the following directory (make sure the `bigbluebutton` directory is within your `dev` directory).

```
/home/firstuser/dev/bigbluebutton
```

Confirm that you are working on the master branch.

```
cd /home/firstuser/dev/bigbluebutton
git status
```

You should see

```
# On branch master
nothing to commit (working directory clean)
```

When you first clone the BigBlueButton git repository, git will place you, by default, on the _master branch_, which is the the latest code for BigBlueButton.

However, when you setup the BigBlueButton server, you installed using packages that were built from a snapshot of the repository (a release).

BigBlueButton is under active development.  As such, if you proceed to compile a component of BigBlueButton, such as the BigBlueButton client, using master source and attempt to run it against a server-side component (such as bbb-apps) using the packaged source, it may not run.

Furhtermore, you may see the BigBlueButton client crash (the master branch is not always stable during a development cycle), or you may see a loading message such as "Connecting to server ..." that never clears.

To get started with development of BigBlueButton, you want build components using the corresponding source from release stated here, in this case 0.81-dev.

Finally, we recommend you subscribe to the [groups.google.com/group/bigbluebutton-dev/topics?gvc=2 bigbluebutton-dev] mailing list to follow updates to the development of BigBlueButton.


# Client Development #
With the development environment checked out and the code cloned, we're ready to start developing!

This section will walk you through making a change to the BigBlueButton client.

## Setting up the environment ##
To setup the client for development for the client follow the steps below.

The first thing we need to do is to copy the latest config.xml file and update accordingly to our installation.
```
cd /home/firstuser/dev/bigbluebutton/
cp bigbluebutton-client/resources/config.xml.template bigbluebutton-client/src/conf/config.xml

# Update the file according to your needs. i.e. change the HOST to your URL or IP
vi bigbluebutton-client/src/conf/config.xml
```

The config.xml file is one of the first parts of the client that is loaded and it determines what modules are retrieved and what configurable settings they have. New developers should read it over to see what settings they can change without modifying the client code.

It's also important to note that when packaged config.xml is updated by either a repository update or by changing your BigBlueButton server's ip with --setip, the copy of config.xml in your development directory isn't modified. It's up to you to make sure it has the latest changes.

Next we're going to copy an xml file that is used to test the client. **Might be outdated**

```
cp bigbluebutton-client/resources/dev/join-mock.xml bigbluebutton-client/src/conf/join-mock.xml
```

Now we need to setup nginx to redirect calls to the client towards our development version. If you don't already have a nginx client development file at /etc/bigbluebutton/nginx/client\_dev, create one with the following command. Make sure to replace "firstuser" with your own username if it's different.
```
echo "
location /client/BigBlueButton.html {
root /home/firstuser/dev/bigbluebutton/bigbluebutton-client;
index index.html index.htm;
expires 1m;
}

# BigBlueButton Flash client.
location /client {
root /home/firstuser/dev/bigbluebutton/bigbluebutton-client;
index index.html index.htm;
}
" | sudo tee /etc/bigbluebutton/nginx/client_dev > /dev/null 2>&1
```

Now we need to create a symbolic link so our client redirect works.
```
sudo ln -f -s /etc/bigbluebutton/nginx/client_dev /etc/bigbluebutton/nginx/client.nginx
```

Now we need to create a symbolic link between the /bin directory where the client is built to and /client so the name is nicer looking.
```
ln -s bin client
```

Now we need to restart nginx so our changes take effect.
```
sudo service nginx restart
```

## Build the client ##
Let's now build the client  Note we're not making any changes yet -- we're going to build the client to ensure it works.

```
cd /home/firstuser/dev/bigbluebutton/bigbluebutton-client
```

First, we'll build the locales (language translation files).  If your not modifying the locales, you only need to do this once.

```
cd /home/firstuser/dev/bigbluebutton/bigbluebutton-client
ant locales
```

This will take about 10 minutes (depending on the speed of your system).

Next, let's build the client
```
ant
```

This will create a build of the BigBlueButton client in the `/home/firstuser/dev/bigbluebutton/bigbluebutton-client/bin` directory.

After this, point your browser to your BigBlueButton server and login to the demo page.  The client should start properly.

## Making a change ##

Now that we've built the default client let's make a small visible change to the interface.

```
cd /home/firstuser/dev/bigbluebutton/
vi bigbluebutton-client/src/org/bigbluebutton/main/views/MainApplicationShell.mxml
```

The above command uses vi to make a change.  If you are on Windows and developing using the BigBlueButton VM, you may find it easier to setup samba so you can access your files through Windows Explorer and use a Windows editor.  To setup Samba, type

```
bbb-conf --setup-samba
```

Once you have `MainApplicationShell.mxml` open, at line 311, you'll see the following text

```
<mx:Label text="{ResourceUtil.getInstance().getString('bbb.mainshell.copyrightLabel2',[appVersion])}" id="copyrightLabel2"/>
```

Insert the text ' -- BigBlueButton Rocks!!' as shown below.

```
 <mx:Label text="{ResourceUtil.getInstance().getString('bbb.mainshell.copyrightLabel2',[appVersion]) + ' -- BigBlueButton Rocks!'}" id="copyrightLabel2"/>
```


Now, rebuild the BigBlueButton client again.

```
cd ~/dev/bigbluebutton/bigbluebutton-client
ant
```

When done, join the demo meeting using the client. You'll see the message `-- BigBlueButton Rocks!` added to the copyright line.

![http://bigbluebutton.googlecode.com/svn/trunk/bbb-images/08/rocks.png](http://bigbluebutton.googlecode.com/svn/trunk/bbb-images/08/rocks.png)

If you don't see your changes, try clearing your browser's cache and then load the client again.

## Switching back to the packaged client ##
To switch back to using the packaged BigBlueButton client you only need to change the symbolic link for nginx and then restart nginx.

```
sudo ln -s -f /etc/bigbluebutton/nginx/client /etc/bigbluebutton/nginx/client.nginx
sudo /etc/init.d/nginx restart
```

To switch back to your development setup, simply recreate the symbolic link and restart nginx.

```
sudo ln -s -f /etc/bigbluebutton/nginx/client_dev /etc/bigbluebutton/nginx/client.nginx
sudo /etc/init.d/nginx restart
```

### Using Flex/Flash Builder ###
To develop the client using Flash Builder, follow these steps:
  1. Install Flash Builder on your Windows/Mac machine.
  1. Setup samba on the VM and mount the VM drive as described earlier in this document.
  1. In Flash Builder, import the project by going to File -> Import -> Flash Builder Project.
    1. Select the Project Folder radio
    1. Click Browse and choose the bigbluebutton-client directory in your VM. For example W:\dev\source\bigbluebutton\bigbluebutton-client
    1. Click finish.
  1. From the BigBlueButton VM, copy the flx sdk from ~/dev/tools into the Flash Builder SDK dir. You can see the location on the image below. Then, on Flash Builder, click Window -> Preferences -> Installed Flex SDKs and Add the SDK you have just copied. ![http://bigbluebutton.googlecode.com/svn/trunk/bbb-images/08/flex-sdk.png](http://bigbluebutton.googlecode.com/svn/trunk/bbb-images/08/flex-sdk.png)
  1. Right click on the project, go to Properties -> Flex Compiler, and change the Flex version to 3.5. (BigBlueButton does not yet work with Flex 4). Make sure the Flash Player specific version is set to at least 10.3.0. Also, check the "Flex 3 compatibility mode" option. Click Apply. ![http://bigbluebutton.googlecode.com/svn/trunk/bbb-images/08/flex-compiler.png](http://bigbluebutton.googlecode.com/svn/trunk/bbb-images/08/flex-compiler.png)
  1. Right-click on the project, click Properties -> Flex Build Path. Click on MX only component set. Make sure you add the libs directory into the path, the main source folder and the output folder. ![http://bigbluebutton.googlecode.com/svn/trunk/bbb-images/08/flex-build-path.png](http://bigbluebutton.googlecode.com/svn/trunk/bbb-images/08/flex-build-path.png)
  1. In the Flex Modules section of the properties window, add all the modules that you would like compiled with bbb-client. The modules are mxml files located in the src/ directory (default package). ![http://bigbluebutton.googlecode.com/svn/trunk/bbb-images/08/flex-modules.png](http://bigbluebutton.googlecode.com/svn/trunk/bbb-images/08/flex-modules.png)
  1. In the Package Explorer navigate to src/(default package) and _Right Click_ on BigBlueButton.mxml and click on Set As Default Application.
  1. Compile the client in Flash Builder, then open the client in your browser by going to the VM IP. The client running there should now be the client in your Flash Builder environment.

This approach is limited in the sense that you can't use the Run button within Flash Builder to launch the client. You also can't use the Flex debugger. To be able to launch the client from Flash Builder, do the following:
  1. On the client code, edit `src/conf/config.xml` and near the top change the line:

```
<application uri="rtmp://<HOST-IP>/bigbluebutton" host="http://<HOST-IP>/bigbluebutton/api/enter" />
```
to
```
<application uri="rtmp://<HOST-IP>/bigbluebutton" host="conf/join-mock.xml" />
```
  1. You should now be able to launch from Flash Builder using the Run/Debug button.

# Developing BBB-Web #

This section will walk you through the steps to set up development for bigbluebutton-web.

First, we need to update the latest bigbluebutton.properties file according to your setup. Basically, you will have to change the URL and security salt. If you don't know your salt, run `sudo bbb-conf --salt`
```
cd /home/firstuser/dev/bigbluebutton/

# Edit the file and change the values of bigbluebutton.web.serverURL and securitySalt. 
vi bigbluebutton-web/grails-app/conf/bigbluebutton.properties
```

Now you need to give your user account access to upload slides to the presentation directory and also access to write log files.
```
sudo chmod -R ugo+rwx /var/bigbluebutton
sudo chmod -R ugo+rwx /var/log/bigbluebutton
```

Now you need to create the nginx file that will redirect calls to your development bbb-web.
```
echo "
# Handle request to bbb-web running within Tomcat. This is for
# the BBB-API and Presentation.
location /bigbluebutton {
proxy_pass http://127.0.0.1:8888;
proxy_redirect default;
proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;

# Allow 30M uploaded presentation document.
client_max_body_size 30m;
client_body_buffer_size 128k;

proxy_connect_timeout 90;
proxy_send_timeout 90;
proxy_read_timeout 90;

proxy_buffer_size 4k;
proxy_buffers 4 32k;
proxy_busy_buffers_size 64k;
proxy_temp_file_write_size 64k;

include fastcgi_params;
}
" | sudo tee /etc/bigbluebutton/nginx/web_dev > /dev/null 2>&1
```

Now we just need to create a link so that the requests are redirected properly and restart nginx.
```
sudo ln -s -f /etc/bigbluebutton/nginx/web_dev /etc/bigbluebutton/nginx/web.nginx
sudo /etc/init.d/nginx restart
```

Now let's start grails webapp.
```
cd /home/firstuser/dev/bigbluebutton/bigbluebutton-web/
```

Download the necessary libraries.
```
gradle resolveDeps
```

Tell grails to listen on port 8888
```
grails -Dserver.port=8888 run-app
```

If you get an error ` "Could not resolve placeholder 'apiVersion'"`., just run `grails -Dserver.port=8888 run-app` again. The error is grails not picking up the "bigbluebutton.properties" the first time.

Now test again if you can join the demo meeting.

# Developing the Red5 Applications #

Make red5/webapps writeable. Otherwise, you will get permission error when you try to deploy into Red5.

```
  sudo chmod -R o+w /usr/share/red5/webapps
```

### Developing BBB-Apps ###

Before you build and deploy bbb-apps you need to make sure to first stop the red5 service.
```
sudo service red5 stop
```

Now you can compile and deploy bigbluebutton-apps.
```
cd /home/firstuser/dev/bigbluebutton/bigbluebutton-apps
gradle resolveDeps
gradle clean war deploy
```

And finally you can start the red5 service up again.
```
sudo service red5 start
```

## Developing BBB-Voice ##

First you need to stop red5.
```
sudo service red5 stop
```

Then you can compile and deploy the application.
```
cd /home/firstuser/dev/bigbluebutton/bbb-voice
gradle resolveDeps
gradle war deploy
```

And finally start red5 up again.
```
sudo service red5 start
```

## Developing Deskshare ##
```
cd /home/firstuser/dev/bigbluebutton/deskshare
gradle resolveDeps
```

**Building the applet.**
```
cd applet
gradle jar
```

Now we need to create a key to sign the applet. Enter a password when prompted for one. Make sure it is at least 6 chars long.
```
ant create-signing-key
```

Sign the jar file. Enter the password you created from the previous step when prompted.
```
ant sign-jar
```

If you get an error something like
```
sign-jar:
  [signjar] Signing JAR: /home/firstuser/dev/bigbluebutton/deskshare/applet/build/libs/bbb-deskshare-applet-0.71.jar to /home/firstuser/dev/bigbluebutton/deskshare/applet/build/libs/bbb-deskshare-applet-0.71.jar as code.signer
  [signjar] jarsigner: unable to sign jar: java.util.zip.ZipException: duplicate entry: com/myjavatools/web/ClientHttpRequest.class
  [signjar] Enter Passphrase for keystore:

BUILD FAILED
/home/firstuser/dev/bigbluebutton/deskshare/applet/build.xml:70: jarsigner returned: 1

Total time: 3 seconds
```

Somehow, some classes got duplicated. Try recompiling the common dir.
```
  cd ../common
  gradle clean
  gradle jar
```

Then sign the applet again.


The signed jar file is located in `/home/firstuser/dev/bigbluebutton/deskshare/applet/build/libs/bbb-deskshare-applet-0.8.jar`

We need to copy it to where nginx is loading the client.

If you are developing also the bbb-client, then
```
cp /home/firstuser/dev/bigbluebutton/deskshare/applet/build/libs/bbb-deskshare-applet-0.8.jar /home/firstuser/dev/bigbluebutton/bigbluebutton-client/client
```

If you are not developing the client, therefore, nginx will serve the client from the default location. Therefore,
```
cp /home/firstuser/dev/bigbluebutton/deskshare/applet/build/libs/bbb-deskshare-applet-0.8.jar /var/www/bigbluebutton/client/
```

**Building the server side component.**
```

cd /home/firstuser/dev/bigbluebutton/deskshare/app
# Compile
gradle war
# Copy over to Red5
gradle deploy

# Stop red5
    sudo /etc/init.d/red5 stop

cd /home/firstuser/dev/bigbluebutton/bigbluebutton-apps
# Compile and deploy bbb-apps
gradle war deploy

# On another terminal window, start Red5
cd /usr/share/red5/
sudo -u red5 ./red5.sh
```

# Troubleshooting #

## Connecting to the server ##
When the BigBlueButton client loads, it runs a number of modules: chat, voice, desktop sharing, and presentation.  Each of these modules makes a connection back to their corresponding BigBlueButton server components.

The URL for each connection is specified in [config.xml](ClientConfiguration#Config.xml.md).

When setting up a development environment for the client, the `config.xml` file for the BigBlueButton client is now loaded from `~/dev/bigbluebutton/bigbluebutton-client/bin/conf/config.xml`.  This means that any changes made to the default `config.xml` by `sudo bbb-conf --setip <hostname>` will _not_ affect the `config.xml` in your development environment.  Thus, if you change your hostname or IP address for the BigBlueButton server, you'll need to manually change the `config.xml` for your development environment.


## Welcome to Nginx page ##
If you get the "Welcome to Nginx" page. Check if bigbluebutton is enabled in nginx. You should see **bigbluebutton** in `/etc/nginx/sites-enabled`.

If not, enable it.

```
sudo ln -s /etc/nginx/sites-available/bigbluebutton /etc/nginx/sites-enabled/bigbluebutton

sudo /etc/init.d/nginx restart
```

## Old Translation ##
If you get a "Old Translation" warning when starting the client, in `/var/www/bigbluebutton/client/conf/config.xml` change

```
<localeversion suppressWarning="false">0.71</localeversion>
```

to

```
<localeversion suppressWarning="false">0.8</localeversion>
```

# Developing Using Eclipse #
This instructions assumes that you are developing with the VM running on a Windows machine.

Set-up Samba

```
 bbb-conf --setup-samba 
```

Now map the VM as a network drive.

For each project, you need to generate Eclipse project files. So, in bbb-app, you run the following to generate the project file.

```
  gradle eclipse
```

Then you can import the project into Eclipse by clicking on File->New-> Java Project. Uncheck "Use default location" and browse to the project you want to import.