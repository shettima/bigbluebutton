

Welcome to the installation guide for BigBlueButton 0.9.0-beta.  BigBlueButton is an open source web conferencing system for on-line learning.

For an overview what new in this release, see [overview](090Overview.md).

If you already have a BigBlueButton 0.81 server, these instructions will **not** upgrade your server.  To install BigBlueButton 0.9.0-beta, you need to install on a clean installation of Ubuntu 14.04 64-bit.  The reason is that BigBlueButton ran on Ubuntu 10.04 64-bit, whereas BigBlueButton 0.9.0 runs on Ubuntu 14.04 64-bit.  We recommend setting up a new Ubuntu 14.04 64-bit server and [copying over the recordings](090TransferRecordings.md) from the old BigBlueButton server to the new.


# Before you install #

The requirements for BigBlueButton 0.9.0-beta server are

  * Ubuntu 14.04 64-bit
  * 4 GB of memory (8 GB is better) with swap enabled
  * Quad-core 2.6 GHZ CPU (or faster)
  * TCP ports 80, 1935, 9123 are accessible
  * UDP ports 16384 - 32768 are accessible
  * Port 80 is **not** used by another application
  * 500G of free disk space (or more) for recordings
  * 100 Mbits/sec bandwidth (symmetrical)

For users we recommend (a minimum of) 1.0 Mbits/sec download speed and 0.5 Mbits/sec upload speed.

In addition to ensuring your server meets the above requirements, there are a few more checks.  First, the locale of the server must be en\_US.UTF-8.  To verify , enter the following command

```
$ cat /etc/default/locale
LANG="en_US.UTF-8"
```

If you don't see `LANG="en_US.UTF-8"`, then enter the following commands.

```
$ sudo apt-get install language-pack-en
$ sudo update-locale LANG=en_US.UTF-8
```

Next, logout and log back into your session (this will reload your configuration).  Run `cat /etc/default/locale` again.  Verify you see only the single line `LANG="en_US.UTF-8"`.  Note: if you see an additional line `LC_ALL=en_US.UTF-8`, then remove the setting for `LC_ALL` before continuing.

Check that you are running under 64-bit.

```
$ uname -m
x86_64
```

And check your version of Ubuntu is Ubuntu 14.04.  If you try to install BigBlueButton 0.9.0-beta on any other release, it won't work.

```
$ cat /etc/lsb-release
DISTRIB_ID=Ubuntu
DISTRIB_RELEASE=14.04
DISTRIB_CODENAME=trusty
DISTRIB_DESCRIPTION="Ubuntu 14.04.X LTS"
```

Your now ready to install BigBlueButton.

# Installing BigBlueButton 0.9.0-beta #

If you've already installed an earlier build, see [upgrading BigBlueButton 0.9.0](#Upgrading_BigBlueButton.md).

If you encounter an error at any step, STOP and double-check you've entered the proper commands.  Don't continue onto the next step (you'll only compound the errors).  If you can't resolve it (use Google to search for the error messages), please see [support options](http://bigbluebutton.org/support).


## 1. Update your server ##

First, ensure that you have `trusty multiverse` in your `sources.list`.  Do the following.

```
$ grep "multiverse" /etc/apt/sources.list
```

and you should see the line that has a URL to the trusty multiverse uncommented, such as

```
deb http://archive.ubuntu.com/ubuntu trusty multiverse
```

or

```
deb http://archive.ubuntu.com/ubuntu trusty main restricted universe multiverse
```

Don't worry if your URL is different, what's important is you see an uncommented link that contains multiverse.  If you don't, then execute the following line this repository to `sources.list`.

```
$ echo "deb http://us.archive.ubuntu.com/ubuntu/ trusty multiverse" | sudo tee -a /etc/apt/sources.list
```

Before proceeding further, do a dist-upgrade to ensure all the current packages on your server are up-to-date.

```
$ sudo apt-get update
$ sudo apt-get dist-upgrade
```

If you've not updated in a while, apt-get may recommend you reboot your server after `dist-upgrade` finishes.  Do the reboot before proceeding to the next step.

## 2. Install PPA for LibreOffice 4.3 ##
Ubuntu 14.04 installs LibreOffice  4.2.7 by default, but we want to use LibreOffice 4.3 for improved stability on conversion of Microsoft Office documents to PDF.

In a terminal window, copy and paste the following commands.

```
$ sudo apt-get install software-properties-common
$ sudo add-apt-repository ppa:libreoffice/libreoffice-4-3
```

## 3. Install key for BigBlueButton ##

You first need to give your server access to the BigBlueButton package repository.

```
# Add the BigBlueButton key
$ wget http://ubuntu.bigbluebutton.org/bigbluebutton.asc -O- | sudo apt-key add -

# Add the BigBlueButton repository URL and ensure the multiverse is enabled
$ echo "deb http://ubuntu.bigbluebutton.org/trusty-090/ bigbluebutton-trusty main" | sudo tee /etc/apt/sources.list.d/bigbluebutton.list

# Update packages
$ sudo apt-get update
```

## 4.  Install ffmpeg ##
BigBlueButton 0.9.0-beta uses ffmpeg to process recordings of a session for playback.

To install ffmpeg, create a file called `install-ffmpeg.sh` and copy and paste in the following script.

```
sudo apt-get install build-essential git-core checkinstall yasm texi2html libvorbis-dev libx11-dev libvpx-dev libxfixes-dev zlib1g-dev pkg-config netcat libncurses5-dev

FFMPEG_VERSION=2.3.3

cd /usr/local/src
if [ ! -d "/usr/local/src/ffmpeg-${FFMPEG_VERSION}" ]; then
  sudo wget "http://ffmpeg.org/releases/ffmpeg-${FFMPEG_VERSION}.tar.bz2"
  sudo tar -xjf "ffmpeg-${FFMPEG_VERSION}.tar.bz2"
fi

cd "ffmpeg-${FFMPEG_VERSION}"
sudo ./configure --enable-version3 --enable-postproc --enable-libvorbis --enable-libvpx
sudo make
sudo checkinstall --pkgname=ffmpeg --pkgversion="5:${FFMPEG_VERSION}" --backup=no --deldoc=yes --default
```

Next, run the commands

```
$ chmod +x install-ffmpeg.sh
$ ./install-ffmpeg.sh
```

After the script finishes, check that ffmepg is installed by typing the command `ffmpeg -version`.  You should see the following

```
$ ffmpeg -version
ffmpeg version 2.3.3 Copyright (c) 2000-2014 the FFmpeg developers
  built on Aug 18 2014 17:35:05 with gcc 4.8 (Ubuntu 4.8.2-19ubuntu1)
  configuration: --enable-version3 --enable-postproc --enable-libvorbis --enable-libvpx
  libavutil      52. 92.100 / 52. 92.100
  libavcodec     55. 69.100 / 55. 69.100
  libavformat    55. 48.100 / 55. 48.100
  libavdevice    55. 13.102 / 55. 13.102
  libavfilter     4. 11.100 /  4. 11.100
  libswscale      2.  6.100 /  2.  6.100
  libswresample   0. 19.100 /  0. 19.100
```


## 5.  Install BigBlueButton ##
We're now ready to install BigblueButton 0.9.0-beta. Type

```
$ sudo apt-get update
$ sudo apt-get install bigbluebutton
```

This single command is where all the magic happens.  This command installs **all** of BigBlueButton's components with their dependencies.  The packaging will do all the work for you to install and configure your BigBlueButton server.

![http://bigbluebutton.googlecode.com/svn/trunk/bbb-images/090/090install.png](http://bigbluebutton.googlecode.com/svn/trunk/bbb-images/090/090install.png)

Type 'Y' and press enter to install.

If you get an error message
```
...... Error: FreeSWITCH didn't start 
```
you can ignore it as we'll do a clean restart of all the components in step 6.

If you get an error message
```
Setting up bbb-playback-presentation (0.9.0-1ubuntu5) ...
chown: invalid user: ‘tomcat7:tomcat7’
```

then run the install again

```
$ sudo apt-get install bigbluebutton
```

it should finish without errors.


## 6. Install API Demos (optional) ##

To interactively test your BigBlueButton server, you can install a set of API demos.

```
$ sudo apt-get install bbb-demo
```

You'll need the bbb-demo package installed if you want to join the Demo Meeting from your BigBlueButton server's welcome page.  This is the same welcome page you see at [demo server](http://demo.bigbluebutton.org).

Later on, if you wish to remove the API demos, you can enter the command

```
$ sudo apt-get purge bbb-demo
```

## 7. Install Client Self-Check (optional) ##

To install the client self-check page:

```
$ sudo apt-get install bbb-check
```

This is the same welcome page you see at [client self-check](http://demo.bigbluebutton.org/check).

Later on, if you wish to remove the client self-check page, you can enter the command

```
$ sudo apt-get purge bbb-check
```

## 8. Enable WebRTC audio ##

To enable WebRTC audio, do the following

```
$ sudo bbb-conf --enablewebrtc
```

## 9. Do a Clean Restart ##

To ensure BigBlueButton has started cleanly, enter the following commands:

```
$ sudo bbb-conf --clean
$ sudo bbb-conf --check
```

The `--clean` option will clear out all the log files for BigBlueButton.  The `--check` option will grep through the log files looking for errors.

The output from `sudo bbb-conf --check` will display your current settings and, after the text, " Potential problems described below ", print any potential configuration or startup problems it has detected.

# Transferring recordings from a BigBlueButton 0.81 server #

Please see [090TransferRecordings](090TransferRecordings.md)


# Upgrading BigBlueButton 0.9.0-beta #

If already have a BigBlueButton 0.81 server, these instructions will **not** upgrade your server.  To install BigBlueButton 0.9.0-beta, you need to install on a clean installation of Ubuntu 14.04 64-bit and follow the steps previous in this document.

First, add the package repository for LibreOffice 4.3.  You only need to do this once and can skip this step in applying future updates to BigBlueButton 0.9.0-beta.

```
$ sudo apt-get install software-properties-common
$ sudo add-apt-repository ppa:libreoffice/libreoffice-4-3
```

To upgrade earlier versions of BigBlueButton 0.9.0-beta, do the following:

```
$ sudo apt-get update
$ sudo apt-get dist-upgrade

$ sudo bbb-conf --enablewebrtc
$ sudo bbb-conf --clean
$ sudo bbb-conf --check
```

Respond with 'Y', if you get prompted to update any configuration file during the upgrade


# Troubleshooting #

If you encounter an error at one of the installation/upgrade steps,


## Run sudo bbb-conf --check ##
We've built in a BigBlueButton configuration utility, called `bbb-conf`, to help you configure your BigBlueButton server and trouble shoot your setup if something doesn't work right.

If you think something isn't working correctly, the first step is enter the following command.

```
$ sudo bbb-conf --check
```

This will check your setup to ensure the correct processes are running, the BigBlueButton components have correctly started, and look for common configuration problems that might prevent BigBlueButton from working properly.

If you see text after the line `** Potential problems described below **`, then it may be warnings (which you can ignore if you've change settings) or errors with the setup.




Some hosting providers do not provide a complete `/etc/apt/source.list`.  If you are finding your are unable to install a package, try replacing your `/etc/apt/sources.list` with the following


```
deb http://archive.ubuntu.com/ubuntu trusty main restricted universe multiverse
deb http://archive.ubuntu.com/ubuntu trusty-updates main restricted universe multiverse
deb http://security.ubuntu.com/ubuntu trusty-security main restricted universe multiverse

```

then do

```
$ sudo apt-get update
```

and try installing BigBlueButton again from the beginning steps.


## Change the BigBlueButton Server's IP ##

A common problem is the default install scripts in for BigBlueButton configure it to list for an IP address, but if you are accessing your server via a DNS hostname, you'll see the 'Welcome to Nginx' message.

To change all of BigBlueButton's configuration files to use a different IP address or hostname, enter

```
$ sudo bbb-conf --setip <ip_address_or_hostname>
```

For more information see [bbb-conf options](BBBConf.md).

## Audio not working ##

If you are installing on EC2 or a hosting provider that has a number of network interfaces, you need to tell FreeSWITCH to listen on your external interface on it's IP address (shown below as EXTERNAL\_IP\_ADDRESS).  You must use the external IP address where EXTERNAL\_IP\_ADDRESS is show (not the external hostname).

Edit `/opt/freeswitch/conf/vars.xml`

Remove this line

```
<X-PRE-PROCESS cmd="set" data="local_ip_v4=xxx.yyy.zzz.qqq"/>
```

Change

```
<X-PRE-PROCESS cmd="set" data="bind_server_ip=auto"/>
```

To

```
<X-PRE-PROCESS cmd="set" data="bind_server_ip=EXTERNAL_IP_ADDRESS"/>
```

Change

```
<X-PRE-PROCESS cmd="set" data="external_rtp_ip=stun:stun.freeswitch.org"/>
```

To

```
<X-PRE-PROCESS cmd="set" data="external_rtp_ip=EXTERNAL_IP_ADDRESS"/>
```

Change
```
<X-PRE-PROCESS cmd="set" data="external_sip_ip=stun:stun.freeswitch.org"/>
```

To

```
<X-PRE-PROCESS cmd="set" data="external_sip_ip=EXTERNAL_IP_ADDRESS"/>
```


Edit `/opt/freeswitch/conf/sip_profiles/external.xml` and change

```
    <param name="rtp-ip" value="$${local_ip_v4}"/>
    <param name="sip-ip" value="$${local_ip_v4}"/>
    <param name="ext-rtp-ip" value="$${local_ip_v4}"/>
    <param name="ext-sip-ip" value="$${local_ip_v4}"/>
```

to

```
    <param name="rtp-ip" value="$${local_ip_v4}"/>
    <param name="sip-ip" value="$${local_ip_v4}"/>
    <param name="ext-rtp-ip" value="$${external_rtp_ip}"/>
    <param name="ext-sip-ip" value="$${external_sip_ip}"/>
```

Edit `/usr/share/red5/webapps/sip/WEB-INF/bigbluebutton-sip.properties`

```
bbb.sip.app.ip=<internal ip>
bbb.sip.app.port=5070

freeswitch.ip=<internal ip>
freeswitch.port=5060
```

Edit `/etc/bigbluebutton/nginx/sip.nginx` to

```
location /ws {
        proxy_pass http://EXTERNAL_IP_ADDRESS:5066;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "Upgrade";
        proxy_read_timeout 6h;
        proxy_send_timeout 6h;
        client_body_timeout 6h;
        send_timeout 6h;
}
```

changing `EXTERNAL_IP_ADDRESS` to your server's elastic IP address.

Open the firewall (if you have on installed) and Security Groups (if your using EC2) the following ports:

TCP - 5066

UDP - 16384 to 32768

## Client WebRTC Error Codes ##

**1001: WebSocket disconnected** - The WebSocket had connected successfully and has now disconnected.  Possible Causes:
  * Loss of internet connection
  * Nginx restarting can cause this

**1002: Could not make a WebSocket connection** - The initial WebSocket connection was unsuccessful.  Possible Causes:
  * Firewall blocking ws protocol
  * Server is down or improperly configured

**1003: Browser version not supported** - Browser doesn’t implement the necessary WebRTC API methods.  Possible Causes:
  * Out of date browser

**1004: Failure on call** - The call was attempted, but failed.  Possible Causes:
  * For a full list of causes refer here, http://sipjs.com/api/0.6.0/causes/
  * There are 24 different causes so I don’t really want to list all of them

**1005: Call ended unexpectedly** - The call was successful, but ended without user requesting to end the session.  Possible Causes:
  * Unknown

**1006: Call timed out** - The library took too long to try and connect the call.  Possible Causes:
  * Previously caused by Firefox 33-beta on Mac.   We've been unable to reproduce since release of FireFox 34

**1007: ICE negotiation failed** - The browser and !FreeSWITCH try to negotiate ports to use to stream the media and that negotiation failed.  Possible Causes:
  * NAT is blocking the connection
  * Firewall is blocking the UDP connection/ports

**1008: Call transfer failed** - A timeout while waiting for FreeSWITCH to transfer from the echo test to the real conference. This might be caused by a misconfiguration in FreeSWITCH, or there might be a media error and the DTMF command to transfer didn't go through (In this case, the voice in the echo test probably didn't work either.)

**1009: Could not fetch STUN/TURN server information** - This indicates either a BigBlueButton bug (or you're using an unsupported new client/old server combination), but could also happen due to a network interruption.