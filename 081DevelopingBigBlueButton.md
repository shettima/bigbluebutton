

# Overview #
**Note:** These instructions refer to BigBlueButton 0.81-RC4 (referred hereafter as simply 0.81).

This guide is written for BigBlueButton 0.81.  If you are using an earlier version of BigBlueButton, you'll need to update you server (see 081InstallationUbuntu).

A BigBlueButton server is built from a number of compnents that corresponding to Ubuntu packages.  Some of these components are

  * bbb-web -- Implements the BigBlueButton API and conversion of documents for presentation
  * bbb-client -- Flash based client that loads within the browser
  * bbb-apps -- Server side applications for supporting client modules
  * bbb-deskshare -- Desktop sharing server

You don't need to understand everything about each component, but you do need to understand the [overall architecture](ArchitectureOverview.md) works together.

This document describes how to setup a development environment using an existing BigblueButton 0.81 server.  Once the environment is setup, you will be able to make custom changes to BigBlueButton source, compile the source, and replace the corresponding components on the server (such as updating the BigBigBlueButton client).

The instructions in this guide are step-by-step so you can understand each step needed to modify a component.  If you encounter problems or errors at any step, don't ignore the errors.  Stop and double-check that you have done the step correctly.  If your unable to determine the cause of the error, do the following

  * First, use Google to search for the error.  There is a wealth of information in bigbluebutton-dev that Google indexes.
  * Try doing the same steps on a different BigBlueButton server.
  * Post a question to bigbluebutton-dev with a description of the problem and the steps to reproduce.


## Before you begin ##

The BigBlueButton project uses git to manage the source code.  Git is a distributed version control system. The source itself is hosted on GitHub (see [source code](https://github.com/bigbluebutton/bigbluebutton).


### You have a Working BigBlueButton Server ###
Before you can start developing on BigBlueButton, you need a working BigBlueButton 0.81 server.

**Note:** You must use ubuntu 10.04 64-bit to setup the BigBlueButton server.  Currently, there are no 32-bit packages for 0.81 (these will be available before the final release).

We emphasize that your BigBlueButton server must be working **before** you start setting up the development environment.  Be sure that you can login, start sessions, join the audio bridge, share your webcam, and record and playback sessions -- all using the built-in API demos.

By starting with a working BigBlueButton server, you have the ability to switch back-and-forth between the default packaged components and your modified equivalents.

For example, suppose you modify the BigBlueButton client and something isn't working (such as the client is not fully loading), you can easily switch back to the default packaged client and check that your environment is still working correctly.

**Note:** These instructions assume you have the `bbb-demo` package installed so you can run any of the API demos to test your setup.

### Developing on Windows ###
To develop BigBlueButton from within a Windows OS, use VMWare Player or Virtual box to first create a Ubuntu 10.04 64-bit virtual machine.  The associated documentation for VMWare Player and Virtual Box will guide you on setting up a new 10.04 64-bit VM.

When setting up the VM, it does not matter to BigBlueButton if you setup Ubuntu 10.04 server or desktop.  If you install desktop, you’ll have the option of using a graphical interface to edit files.

Keep in mind, you’ll need a host capable of running a [64-bit virtual machine](http://stackoverflow.com/questions/56124/can-i-run-a-64-bit-vmware-image-on-a-32-bit-machine).

### Root Privileges ###

**Important:** Make sure you create another user such as "firstuser", otherwise you'll run into permission errors such as Nginx 403 Forbidden error or http://stackoverflow.com/questions/3863066/error-null-while-compiling-resource-bundles-under-linux-with-hudson.

Do not run commands as the root user unless explicitly instructed. Better run the commands using sudo.

These instructions are written for an account called ‘firstuser’, but they will apply to any account that has the permissions to execute commands as root, such as

```
  sudo ls
```

### wget ###
You’ll need to download some files through these instructions using wget. If it’s not installed on your server, you can install using the following command
```
  sudo apt-get install wget
```

### Have a GitHub Account ###

You need a GitHub account.  Also, you need to be very familiar with how git works.  Specifically, you need to know how to

  * clone a repository
  * create a branch
  * push changes back to a repository

If you have not used git before, or if the terms **_clone_**, **_branch_**, and **_commit_** are unfamiliar to you, stop now.  These are fundamental concepts to git that you need to become competent with before trying to develop on BigBlueButton.   To become competent, a good place to start is [free book](http://progit.org/book/) and http://help.github.com/ GitHub Help pages].


Using GitHub makes it easy for you to work on your own copy of the BigBlueButton source, store updates the source to your GitHub account, and, if you are really interested in helping out the project, [contribute](FAQ#Contributing_to_BigBlueButton.md) back updates by sending us pull requests.


### Subscribe to bigbluebutton-dev ###

We recommend you subscribe to the [groups.google.com/group/bigbluebutton-dev/topics?gvc=2 bigbluebutton-dev] mailing list to follow updates to the development of BigBlueButton and to collaborate with other developers.


# Setup a Development Environment #


First you need to install the core development tools.

```
sudo apt-get install git-core ant openjdk-6-jdk	
```

Next you need to make a directory to hold the Flash compiler and other tools needed for BigBlueButton development.

```
mkdir -p ~/dev/tools
cd ~/dev/tools
```

You now need to download a number of tools with wget and then unpack each of these tools in the above directory.

```
wget http://bigbluebutton.googlecode.com/files/gradle-0.8.tar.gz
tar xvfz gradle-0.8.tar.gz

wget http://bigbluebutton.googlecode.com/files/groovy-1.6.5.tar.gz
tar xvfz groovy-1.6.5.tar.gz

wget https://bigbluebutton.googlecode.com/files/grails-1.3.9.tar.gz
tar xvfz grails-1.3.9.tar.gz
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

The Flex SDK is now unzipped, but you need to modify the permissions to use the Flex tools.

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

export GRAILS_HOME=$HOME/dev/tools/grails-1.3.9
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

Check that the tools are now in your path by running the command `mxmlc -version`.

```
$ mxmlc -version
Version 4.5.0 build 20967
```


## Checking out the Source ##

You'll clone the source in the following directory:

```
  /home/firstuser/dev
```

Next, using your GitHub account, do the following
  1. Setup your [ssh keys](http://help.github.com/linux-set-up-git/) on your BigBlueButton server
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

When you first clone the BigBlueButton git repository, git will place you, by default, on the _master branch_, which is the latest code for BigBlueButton.
**Note:** We will soon be tagging the repository for 0.81-beta1, but for the moment you can checkout master.


# Client Development #
With the development environment checked out and the code cloned, we're ready to start developing!

This section will walk you through making a change to the BigBlueButton client.

## Setting up the environment ##
To setup the client for development for the client follow the steps below.

The first thing we need to do is to copy the latest config.xml file and update accordingly to our installation.
```
cd ~/dev/bigbluebutton/
cp bigbluebutton-client/resources/config.xml.template bigbluebutton-client/src/conf/config.xml

```

Next, change the HOST in config.xml with your DOMAIN or IP ADDRESS using a text editor (such as vi).  Alternatively, you can use the following sed command.

```
# Update config.xml (replace the 192.168.1.145 with !BigBlueButton hostname/ip address)
sed -i s/HOST/192.168.1.145/g bigbluebutton-client/src/conf/config.xml
```

Update the file according to your needs.

```
vi bigbluebutton-client/src/conf/config.xml
```

The config.xml file tells the BigBlueButton client what modules are retrieved and how to connect to the server.
Later on, when you deploy your modified client to the BigBlueButton server, there will be two clients: your modified client and the default packaged client (again, this is good as you can switch back and forth).
However, the BigBlueButton configuration command `sudo bbb-conf ` only modifies the packaged client.   If you need to change your config.xml (such as when the IP address of your server changes), you need to do it manually.

Now we need to setup nginx to redirect calls to the client towards your development version. If you don't already have nginx client development file at /etc/bigbluebutton/nginx/client\_dev, create one with the following command.

NOTE: Make sure to replace "firstuser" with your own username if it's different.

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
" | sudo tee /etc/bigbluebutton/nginx/client_dev 
```

Check the contents to ensure it matches below.

Again, make sure you change `\home\firstuser` to match your home directory.

```
$ cat /etc/bigbluebutton/nginx/client_dev

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
```

These rules tell nginx were to find the BigBlueButton client.  Currently, nginx is using the rules with the default BigBlueButton client through a symbolic link.
```
$ ls -al /etc/bigbluebutton/nginx/client.nginx
lrwxrwxrwx 1 root root 31 2013-05-05 15:44 /etc/bigbluebutton/nginx/client.nginx -> /etc/bigbluebutton/nginx/client
```

Modify this symbolic link so it points to the development directory for your BigBlueButton client.

```
sudo ln -f -s /etc/bigbluebutton/nginx/client_dev /etc/bigbluebutton/nginx/client.nginx
```

Check that the modifications are in place.
```
$ ls -al /etc/bigbluebutton/nginx/client.nginx
lrwxrwxrwx 1 root root 35 2013-05-05 21:07 /etc/bigbluebutton/nginx/client.nginx -> /etc/bigbluebutton/nginx/client_dev
```

Now we need to restart nginx so our changes take effect.
```
$ sudo service nginx restart
Restarting nginx: the configuration file /etc/nginx/nginx.conf syntax is ok
configuration file /etc/nginx/nginx.conf test is successful
nginx.
```

## Building the client ##
Let's now build the client.  Note we're not making any changes yet to the source, we’re going to first build it and run the client to make sure it works.

First, we'll build the locales (language translation files).  If you are not modifying the locales, you only need to do this once.

```
cd ~/dev/bigbluebutton/bigbluebutton-client
ant locales
```

This will take about 10 minutes (depending on the speed of your system).

Next, let's build the client
```
ant
```

This will create a build of the BigBlueButton client in the `/home/firstuser/dev/bigbluebutton/bigbluebutton-client/client` directory.

**Note:** In 0.81, the BigBlueButton server will cache the config.xml for a given meetingID.  To ensure we load the new config.xml, restart the BigBlueButton server
```
sudo bbb-conf --clean
```
After this, point your browser to your BigBlueButton server and login to the demo page.  The client should start properly.
**Note:** On the bottom of the client you’ll see ‘VERSION’, but that’s OK.  This is usually replaced in the packaging by the latest build number.  If you see ‘VERSION’, this is good as BigBlueButton is now loading your client.

If you execute `sudo bbb-conf --check`, you’ll notice it gives a warning
```
** Potential problems described below **
# Warning: nginx is not serving the client from /var/www/bigbluebutton/.
# Instead, it's being served from
#
#    /home/firstuser/dev/bigbluebutton/bigbluebutton-client
#
# (This is OK if you have setup a development environment.)
```
This is OK as you are explicitly serving the client from your directory.

## Making a change ##

Now that we have successfully built and loaded the client from a development environment, let's make a small visible change to the interface.
**Note:** We’re using `vi` to edit the client, but you can use any Unix text editor of course.

**Note:** If you are on Windows and developing using the BigBlueButton VM, you may find it easier to setup samba so you can access your files through Windows Explorer and use a Windows editor.  To setup Samba, type the command `bbb-conf –setup-samba`.


```
cd ~/dev/bigbluebutton/bigbluebutton-client
vi src/org/bigbluebutton/main/views/MainApplicationShell.mxml
```

Once you have `MainApplicationShell.mxml` open, go to line 417 and you'll see the following text

```
<<mx:Text htmlText="{ResourceUtil.getInstance().getString('bbb.mainshell.copyrightLabel2',[appVersion])}" id="copyrightLabel2"/>
```

Insert the text ' -- BigBlueButton Rocks!!' as shown below.

```
<<mx:Text htmlText="{ResourceUtil.getInstance().getString('bbb.mainshell.copyrightLabel2',[appVersion])} -- BigBlueButton Rocks!!!" id="copyrightLabel2"/>
```


Now, rebuild the BigBlueButton client again.

```
ant
```

When done, join the demo meeting using the client. You'll see the message `-- BigBlueButton Rocks!` added to the copyright line.

![http://bigbluebutton.googlecode.com/svn/trunk/bbb-images/08/rocks.png](http://bigbluebutton.googlecode.com/svn/trunk/bbb-images/08/rocks.png)

If you don't see your changes, try clearing your browser's cache and then load the client again. It also might be easier to just try this using Firefox since it most likely will not cache this.

## Switching back to the packaged client ##
To switch back to using the packaged BigBlueButton client, you only need to change the symbolic link for nginx and then restart BigBlueButton.

```
sudo ln -s -f /etc/bigbluebutton/nginx/client /etc/bigbluebutton/nginx/client.nginx
sudo bbb-conf --clean
```

To switch back to your development setup, simply recreate the symbolic link and restart nginx.

```
sudo ln -s -f /etc/bigbluebutton/nginx/client_dev /etc/bigbluebutton/nginx/client.nginx
sudo bbb-conf --clean
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

This approach is limited in the sense that you can't use the Run button within Flash Builder to launch the client. You also can't use the Flex debugger.

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
grails -Dserver.port=8888 run-war
```

If you get an error ` "Could not resolve placeholder 'apiVersion'"`., just run `grails -Dserver.port=8888 run-war` again. The error is grails not picking up the "bigbluebutton.properties" the first time.

Now test again if you can join the demo meeting.

This will run a development version of bbb-web, but if you want to instead deploy your custom built bbb-web you need to create a war file.
```
grails war
```
This will create a file with the name bigbluebuttonv0.7dev.war. The version number for the file doesn't matter, but you should rename the war file to bigbluebutton.war. You then need to deploy the archive to tomcat. You can do this by simply copying it into the tomcat6 webapps directory.
```
sudo cp bigbluebutton.war /var/lib/tomcat6/webapps
```
And now just restart tomcat.
```
sudo service tomcat6 restart
```

**If you changed the linking of web.nginx as instructed above you will need to also revert that back to the packaged location for bbb-web.**
```
sudo ln -s -f /etc/bigbluebutton/nginx/web /etc/bigbluebutton/nginx/web.nginx
sudo service nginx restart
```


# Developing the Red5 Applications #

Make red5/webapps writeable. Otherwise, you will get permission error when you try to deploy into Red5.

```
  sudo chmod -R 777 /usr/share/red5/webapps
```

## Developing BBB-Apps ##

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
  [signjar] Signing JAR: /home/firstuser/dev/bigbluebutton/deskshare/applet/build/libs/bbb-deskshare-applet-0.8.1.jar to /home/firstuser/dev/bigbluebutton/deskshare/applet/build/libs/bbb-deskshare-applet-0.8.1.jar as code.signer
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


The signed jar file is located in `/home/firstuser/dev/bigbluebutton/deskshare/applet/build/libs/bbb-deskshare-applet-0.8.1.jar`

**Signing your own jar**

  * Get a pkcs12 certificate from e.g. GoDaddy
  * got to /var/www/bigbluebutton/client
  * Make a backup of bbb-deskshare-applet-0.8.1.jar
  * Sign the jar file overwriting bbb-deskshare-applet-0.8.1.jar.

You need to replace your-keystore, your-password, and your-cert-alias with your values.

```
jarsigner -keystore your-keystore -storepass your-password -storetype pkcs12 -signedjar bbb-deskshare-applet-0.8.1.jar bbb-deskshare-applet-unsigned-0.8.1.jar your-cert-alias
```


We need to copy it to where nginx is loading the client.

If you are developing also the bbb-client, then
```
cp /home/firstuser/dev/bigbluebutton/deskshare/applet/build/libs/bbb-deskshare-applet-0.8.1.jar /home/firstuser/dev/bigbluebutton/bigbluebutton-client/client
```

If you are not developing the client, therefore, nginx will serve the client from the default location. Therefore,
```
cp /home/firstuser/dev/bigbluebutton/deskshare/applet/build/libs/bbb-deskshare-applet-0.8.1.jar /var/www/bigbluebutton/client/
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