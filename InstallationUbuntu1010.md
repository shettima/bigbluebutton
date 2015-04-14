# Introduction #

Note: Ubuntu 10.10 is not officially supported by the BigBlueButton project.  If possible, we recommend using the [Ubuntu 10.04 packages](InstallationUbuntu.md) have been extensively designed and tested.

If you **really** want to try installing BigBlueButton on 10.10, the following gives you some guidelines.

## Installing sun java ##

```
   sudo nano /etc/apt/sources.list
```

add: "deb http://archive.canonical.com/ lucid partner" (without the quotes), to the end of the list.

```
   sudo apt-get update
   sudo apt-get install sun-java6-jre sun-java6-plugin  sun-java6-fonts sun-java6-jdk
```



## Installing FreeSWITCH ##

```
   sudo apt-get install git-core subversion build-essential autoconf automake libtool libncurses5 libncurses5-dev
   cd ~
   git clone git://git.freeswitch.org/freeswitch.git
   cd freeswitch
   ./bootstrap.sh
   ./configure
   make
   sudo make install
   sudo make uhd-sounds-install
   sudo make uhd-moh-install
   sudo make samples
```

Now that freeswitch is installed you can clean up the temporary directory

```
   cd ..
   rm -rf freeswitch/
```



## Installing BigBlueButton ##

```
   wget http://ubuntu.bigbluebutton.org/bigbluebutton.asc -O- | sudo apt-key add -
   echo "deb http://ubuntu.bigbluebutton.org/lucid/ bigbluebutton-lucid main" | sudo tee /etc/apt/sources.list.d/bigbluebutton.list
   echo "deb http://us.archive.ubuntu.com/ubuntu/ lucid multiverse" | sudo tee -a /etc/apt/sources.list
   sudo apt-get install bigbluebutton
   sudo bbb-conf --clean
   sudo bbb-conf --check
```

Go to http://youripaddress and it should show the bbb welcome screen.



## Setting BigBlueButton to run on a different port than 80 ##

This is useful if you already run an apache webserver on your server and want to use bbb without interfering.

```
   cd /etc/nginx/sites-enabled/
   sudo nano default
```

change the listen port to something other than 80, 8089 for example. Save and exit nano

```
   sudo nano bigbluebutton
```

change the listen port to something else, 8085 for example. Save and exit nano

```
   sudo /etc/init.d/nginx restart
   sudo bbb-conf -restart
```

You should be good to go by navigating to http://youripaddress:port