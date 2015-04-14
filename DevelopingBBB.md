Note: This documentation is depreciated.  See [Developing BigBlueButton 0.81](Developing.md).



Note: If you are looking to develop on 0.81, please see [these instructions](Developing.md).

# Overview #
BigBlueButton is developed by a dedicated core team of developers and a broad community that work together on all aspects of development: design, development, testing, documentation, localization, editing wikis, and, most importantly, supporting others.

This document describes how to setup a development environment on a BigblueButton server.  Once setup, you can develop and extend your local server and become part of the community of developers improving BigBlueButton .

BigBlueButton has a lot of components.  The main components are bbb-web, bbb-client, bbb-apps, bbb-voice, and desktop sharing.  You don't need to understand everything to develop or extend one component.  For example, if you are interested in improving the BigBlueButton client, you need, at a minimum, to understand the bigbluebutton-client and the overall architgecture (see ArchitectureOverview).

To help you setup the necessary developer environment, we've put in much of the setup logic in `bbb-conf`, the BigBlueButton configuration script.  While it's good to let the script do most the work, as you become more familiar with BigBlueButton, you should take a look at the source code in `bbb-conf`

```
/usr/local/bin/bbb-conf
```

to understand what it is doing.  The more you know about BigBlueButton, the easier it is to make your own changes and contribute to the project.

In BigBlueButton 0.8-beta-4 (and later), we've generalized these instructions so you can use any unix account on a BigBlueButton server.



The source for BigBlueButton is on [GitHub](https://github.com/bigbluebutton/bigbluebutton).  If you're not familiar with git, a good place to start is [free book](http://progit.org/book/) and http://help.github.com/ GitHub Help pages].  If you don't know what the terms **_clone_**, **_branch_**, and **_commit_** mean in git, make sure you do before working with the BigBlueButton source.


## Prerequisites ##

This guide is written for BigBlueButton 0.8-beta-4 or later.  If you are using an earlier version of BigBlueButton, you'll need to update you server (see InstallationUbuntu).

### The Basics ###
Before setting up a development environment, you should have already

  * An understanding of the BigBlueButton ArchitectureOverview
  * An understand of how git works

### A Working BigBlueButton Server ###

You need to have a working BigBlueButton server 0.8-beta-4 (or later) to setup a development environment.

While it may seem obvious, we emphasize your BigBlueButton server should be working **before** you start setting up the development environment.  That way, if you do run a modified version of the BigBlueButton client and something isn't working, you can switch back to the built-in client to check that your environment is working correctly.


### Developing on Windows ###
If you are on Windows, we recommend you download the [BigBlueButton VM](BigBlueButtonVM.md) and use it for compiling and testing your changes.  That's how we (the core developers) develop BigBlueButton.

### You'll need sudo abilities ###
> setup the BigBlueButton development environment. To verify, you should be able to

```
  sudo ls
```

and get back a list of files in the current directory.


# Setup a Development Environment #

## Setting up the development tools ##

On a BigBlueButton server, you can install all the necessary development tools with the following command:

```
   bbb-conf --setup-dev tools
```

When you run this script, you will be asked to enter your password to sudo into root.  This script will:

  1. Download and setup groovy, grails, and gradle
  1. Download and install Open Source Flex SDK
  1. Install OpenJDK
  1. Install git
  1. Add the necessary environment variables in your ~/.profile


After the initial setup is complete, you'll need to reload your `.profile` to use the new environment variables for groovy, grails, and gradle.  To do this, run

```
  source ~/.profile
```

You need only do this once.  When you next login to your account, you'll have the environment variables in place.

Again, you can use any account on a BigBlueButton server that has sudo rights.  For the rest of this document we'll use the account `firstuser` for the examples.

The `bbb-conf` script create for you a `dev` directory in your account.

```
  /home/firstuser/dev
```

It's in this directory that you'll place the source for BigBlueButton.

## Checking out the Source ##

We recommend you use GitHub to fork BigBlueButton.  This will make it easy for to work on your own copy of BigBlueButton's source, store updates to GitHub, and [contribute](Contributing_to_BigBlueButton.md) back to the project by sending us pull requests.

To checkout the source:

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
cd ~/dev/bigbluebutton
git status
```

You should see

```
# On branch master
nothing to commit (working directory clean)
```

When you installed BigBlueButton from packaging, you have installed components built with the 0.80 release.

However, when you first clone the BigBlueButton git repository, git will place you, by default, on the master branch which is the current snapshot of the latest code for BigBlueButton 0.81.  BigBlueButton 0.81 is under active development.  As such, if you proceed to compile a component of BigBlueButton, such as the BigBlueButton client, using 0.81 source and attempt to run it with the other 0.80-based components on your server, it may not work.  The BigBlueButton client may crash (the master branch is not always stable during a development cycle), or you may see a loading message such as "Connecting to server ..." that never clears.

To get started with development of BigBlueButton, you want build components using the corresponding source from the 0.80 release.

It's easy to switch your local git repository to the stable 0.80 codebase. When 0.80 was release, the git repository was tagged with the label `v0.8`.   To switch your local repository to the 0.80 codebase, you create a branch with a new name and append the label `v0.8`.  For example, to create a branch called 'my-bbb-branch', type the git command

```
git checkout -b my-bbb-branch v0.8
```

You should see

```
Switched to a new branch 'my-bbb-branch'
```

Do

```
git status
```

The output should be

```
# On branch my-bbb-branch
nothing to commit (working directory clean)
```


# Client Development #
With the development environment checked out and the code cloned, we're ready to start developing!

This section will walk you through making a change to the BigBlueButton client.

## Setting up the environment ##
To setup the client for development for the client, do the following

```
bbb-conf --setup-dev client
```

This command modifies the nginx settings for BigBlueButton so that HTTP request for loading the BigBlueButton client are now serviced by

```
~/dev/bigbluebutton/bigbluebutton-client/bin
```

instead of

```
/var/www/bigbluebutton
```

## Build the client ##
Let's now build the client  Note we're not making any changes yet -- we're going to build the client to ensure it works.


```
cd ~/dev/bigbluebutton/bigbluebutton-client
```


First, we'll build the locales (language translation files).  If your not modifying the locales, you need only do this once.


```
cd ~/dev/bigbluebutton/bigbluebutton-client
ant locales
```

This will take about 10 minutes (depending on the speed of your system).

Next, let's build the client
```
ant
```

This will create a build of the BigBlueButton client in the `~/dev/bigbluebutton/bigbluebutton-client/bin` directory.

After this, point your browser to your BigBlueButton server and login ot the demo page.  The client should start properly.  How is it loading your client (and not the default client)?  When you ran `bbb-conf --setup-dev client`, it created an entry in `\etc\bigbluebutton\nginx\client_dev` with the contents

```
        location /client/BigBlueButton.html {
                root    /home/firstuser/dev/bigbluebutton/bigbluebutton-client;
                index  index.html index.htm;
                expires 1m;
        }

        # BigBlueButton Flash client.
        location /client {
                root    /home/firstuser/dev/bigbluebutton/bigbluebutton-client;
                index  index.html index.htm;
        }
```

And in `\etc\bigbluebutton\nginx\` created a link from `client.nginx` to `client_dev`. In other words, when receiving a request for `/client`, nginx is now serving up the client from your development directory.

When setting up a development environment for the client, the `config.xml` file for the BigBlueButton client is now loaded from `~/dev/bigbluebutton/bigbluebutton-client/bin/conf/config.xml`.  This means that any changes made to the default `config.xml` by `sudo bbb-conf --setip <hostname>` will _not_ affect the `config.xml` in your development environment.  Thus, if you change your hostname or IP address for the BigBlueButton server, you'll need to manually change the `config.xml` for your development environment.

## Making a change ##

> Before we build the BigBlueButton client, let's make a small visible change to the interface.

```
  vi ~/dev/bigbluebutton/bigbluebutton-client/src/org/bigbluebutton/main/views/MainApplicationShell.mxml
```

The above command using vi to make a change.  If you are on Windows and developing using the BigBlueButton VM, you may find it easier to setup samba so you can access your files through Windows Explorer and use a Windows editor.  To setup Samba, type

```
bbb-conf --setup-samba
```

When you are editing, `MainApplicationShell.mxml`, at line 311, you'll see the following text

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

If you don't see your changes, try clearing your browser's cache and try loading the client again.


## Switching back to the packaged client ##
To switch to using the built-in version of BigBlueButton, do

```
  sudo ln -s -f /etc/bigbluebutton/nginx/client /etc/bigbluebutton/nginx/client.nginx
  sudo /etc/init.d/nginx restart
```

To switch back to your development setup, do

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
```
bbb-conf --setup-dev web
```

Now let's start grails webapp.
```
cd /home/firstuser/dev/bigbluebutton/bigbluebutton-web/
```

Download the necessary libs.
```
gradle resolveDeps
```

Check if you have the same properties from the master with the ones in your local machine.
```
# Properties file from master: https://github.com/bigbluebutton/bigbluebutton/blob/master/bigbluebutton-web/grails-app/conf/bigbluebutton.properties
# Properties file from your local machine: grails-app/conf/bigbluebutton.properties
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
Run the setup script. This will remove the bbb-apps package from red5/webapps.

```
bbb-conf --setup-dev apps
```

Stop red5
```
    sudo /etc/init.d/red5 stop
```

Compile and deploy bbb-apps
```
cd /home/firstuser/dev/bigbluebutton/bigbluebutton-apps
gradle resolveDeps
gradle clean war deploy

```

Start Red5
```
cd /usr/share/red5/
sudo -u red5 ./red5.sh
```

## Developing BBB-Voice ##
```
# Stop red5
    sudo /etc/init.d/red5 stop

cd /home/firstuser/dev/bigbluebutton/bbb-voice
gradle resolveDeps

# Compile and deploy bbb-voice
gradle war deploy

# On another terminal window, start Red5
cd /usr/share/red5/
sudo -u red5 ./red5.sh

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

**Signing the applet with a self key.**

You can create a self signed key to sign the applet. By running the following command and enter a password when prompted for one. Make sure it is at least 6 chars long.
```
ant create-signing-key
```

Sign the jar file. Enter the password you created from the previous step when prompted.
```
ant sign-jar
```

**Signing the applet with a certificate.**

You can also sign the applet with a certificate. By running the following command, just copy the certificate in the applet directory. When it asks you for the certificate name, enter the name with the extension of the file. This only works with PKCS12 files.

```
ant sign-certificate-jar
```

**Possible problems.**

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

**Deploy the applet.**

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