Not for beginners. This is a rough set of guidelines on how to set up the bbb dev environment on Unix system. These notes are complimentary to the notes on [Developing BigBlueButton](DevelopingBBB.md)

We recommend installing on Ubuntu 10.04 32-bit system. You'll need to have a BigBlueButton VM running to copy some of the files.

  1. Make sure you have git installed by running `sudo apt-get install git-core`.
  1. [Install BigBlueButton from packages](http://code.google.com/p/bigbluebutton/wiki/InstallationUbuntu).
  1. Copy the /home/firstuser/dev/tools directory off the VM and copy it to the dev machine ~/dev/tools. If you don't have a VM handy, you can grab the files from the Downloads page:
    1. wget http://bigbluebutton.googlecode.com/files/grails-1.1.1.tar
    1. wget http://bigbluebutton.googlecode.com/files/gradle-0.8.tar
    1. wget http://bigbluebutton.googlecode.com/files/flex3.tar
    1. Put these tars in ~/dev/tools and untar them there. These were grabbed off a VM and they should be configured as good to go.
  1. Copy the ~/.profile script from the VM to ~/.profile. Then do 'source .profile'. You may need to change 'firstuser' in the script. Again, if you don't have a VM, see [this page](DevEnvironmentVariables.md) for the environment variables you need to export.
  1. Install openjdk-6-jdk: sudo apt-get install openjdk-6-jdk . You could do another java but I know everything works well with openjdk and the paths will be easier to midify.
  1. Do bbb-conf --setup-samba anyway, the script has some side-effects
  1. Do bbb-conf --setup-dev client
  1. Try building the client with 'ant'
  1. If client build fails, find flexTasks.jar in ~/dev/tools/flex dir and copy it to where ant says it expects it
  1. Edit /etc/nginx/sites-available/bigbluebutton. Change the client to load from where you have it instead of /home/firstuser. Restart nginx.
  1. Do bbb-conf --setup-dev apps
  1. Go to the bbb-apps source (~/dev/source/bbb/bbb-apps/). Edit build.gradle and change any instances of 'firstuser' to whatever your user name is.
  1. Build and deploy apps as normal (gradle war deploy). Then restart red5. make sure it starts with no errors.
  1. Do bbb-conf --setup-dev web.
  1. Go to bbb source, edit bigbluebutton-web/grails-app/conf/bigbluebutton.properties. Change the salt there to your salt and the ip of the server to your server/domain. This is so you don't have to run bbb-conf --setip and --setsalt after you deploy.
  1. Instead of the usual instructions to run bbb-web, go to bbb-web source and do 'grails war'. This should create bigbluebutton.war if you're lucky ;) . Copy it to /var/lib/tomcat6/webapps/bigbluebutton.war.
  1. Restart tomcat (/etc/init.d/tomcat6 restart). Make sure it starts fine with no errors in /var/lib/tomcat6/logs/catalina.out
  1. The instructions for bbb-common-message should be straight forward, but you most likely won't need to set up the dev env for this. Just use bbb-common-message.jar in bbb-web.
  1. I have not gone over the instructions for bbb-voice yet as I haven't needed it. if you want to fill in this part let me know the instructions and I'll put them in.


## Check Out the Source Code ##
Note - June 3, 2011: You want to checkout the source tagged for 0.71a as master is under active development for 0.8 and is currently not stable.

Type the following command to checkout BigBlueButton from our [github repository](http://www.github.com/bigbluebutton).
```
bbb-conf --checkout
cd ~/dev/source/bigbluebutton
git init
git checkout v0.71a
```

This will checkout into `~/dev/source/bigbluebutton`.