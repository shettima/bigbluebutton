_Note: These instructions are for 0.70 and are now out of date._

# Introduction #

This how-to has been tested on FreeBSD and PC-BSD 8.1 and 8.2. It assumes some familiarity with installing software using FreeBSD ports and packages. All commands should be run as the superuser.

# Method 1: Using the FreeBSD Port #

The recommended way to install `BigBlueButton` on a FreeBSD or PC-BSD system is to compile the FreeBSD port. Additional instructions will be added here once the FreeBSD package and the PC-BSD PBI become available as they will considerably simplify installing `BigBlueButton` on these systems.

## Obtain/Update the Ports Tree and Compile the Port ##

If your system does not currently have the ports tree (i.e. there is nothing in /usr/ports), install the ports tree using these instructions: http://www.freebsd.org/doc/en_US.ISO8859-1/books/handbook/ports-using.html. If your system does have the ports tree but it hasn't been updated in a while, follow the instructions for the heading **CVSup Method** at that link.

Once you have an updated ports tree, open the file _/usr/ports/www/tomcat6/Makefile_ in your favourite editor and edit this line:

HTTP\_PORT?=     8180

so that it reads:

HTTP\_PORT?=     8080

Save your change. Next, compile `BigBlueButton`:

**cd /usr/ports/www/bigbluebutton**

**make install clean**

A menu will open with a list of options. The first three determine which asterisk module(s) will be installed:

**meetme:** requires a Zaptel hardware device to provide timing

**konference:** (the default selection) doesn't require any specialized hardware

**freeswitch:** may be a better choice if you will be supporting many simultaneous users

If you don't have a preference, the default selection is fine. Otherwise, use your arrow and enter keys to change the selection.

The last menu option is whether or not to include `OpenOffice` support. While `OpenOffice` is mandatory for the proper functioning of `BigBlueButton`, it requires **much** time and disk space to compile. If OpenOffice is already installed, you can leave this unchecked. If it is not installed, consider leaving this option unchecked and instead installing the package from [ftp://ooopackages.good-day.net/pub/OpenOffice.org/FreeBSD/](ftp://ooopackages.good-day.net/pub/OpenOffice.org/FreeBSD/).

Once you have made your selections, use the tab key to highlight OK and press enter. `BigBlueButton` will now build on your system.

## Start `BigBlueButton` ##

Once the installation is complete, a message will be displayed indicating how to start `BigBlueButton`. If you missed the message or would like to read it again, use the command:

**pkg\_info -Dx bigbluebutton**

Before starting `BigBlueButton`, you will need to add the hostname and IP address of the system to _/etc/hosts_. If you forget to do this, `BigBlueButton` will load in the client's browser but will fail to connect to a meeting. The **hostname** and **ifconfig** commands can be used to get the system's hostname and IP address.

Next, add the following lines to _/etc/rc.conf_:

tomcat60\_enable="YES"

mysql\_enable="YES"

nginx\_enable="YES"

asterisk\_enable="YES"

activemq\_enable="YES"

openoffice\_enable="YES"

red5\_enable="YES"

Next, populate the `BigBlueButton` database with this command:

**/usr/local/etc/rc.d/mysql-server start**

Finally, install and start `BigBlueButton`:

**bbb-conf install -h `<ip_address>` -c `<konference|meetme|freeswitch>`**

Replace `<ip_address>` with the address you input into _/etc/hosts_ and `<konference|meetme|freeswitch>` with one module type that you selected in the port's configuration menu. You are now ready to start BigBlueButton:

**bbb-conf start**

You should now be able to connect to your `BigBlueButton` server. Input the IP address into a flash-capable web browser and input a name to join a demo meeting.

If you wish to stop `BigBlueButton`, use this command:

**bbb-conf stop**

## Troubleshooting ##

If you have any issues with functionality please let me know (http://code.google.com/u/dru.lavigne/).

This is a fix for a currently known issue: the latest version of `ImageMagick` fails to convert uploaded presentations correctly. If you are running a version of `ImageMagick` higher than 6.6.4.10 (which does work correctly) you can do this:

**cd /usr/ports/graphics/`ImageMagick`**
**make deinstall**

replace the existing distinfo file with this one: http://www.freebsd.org/cgi/cvsweb.cgi/ports/graphics/ImageMagick/distinfo?rev=1.151;content-type=text%2Fplain

replace the existing Makefile with this one: http://www.freebsd.org/cgi/cvsweb.cgi/ports/graphics/ImageMagick/Makefile?rev=1.311;content-type=text%2Fplain

edit the new Makefile so that this line:

USE\_AUTOTOOLS=	libltdl:22

looks like this:

USE\_AUTOTOOLS=	libltdl

Now, build the corrected version:

**make install clean**

# Method 2: Reinventing the Wheel #

Since the FreeBSD port became available in January, 2011, the remaining instructions can be considered deprecated. They are left here for readers who wish to know what the FreeBSD port is doing or for users who are considering what steps would be required in order to create an OpenBSD port or a NetBSD or `DragonFly` BSD pkgsrc module.

## Install Required Software ##

Note that some software may already be installed on your system and you can check first with the pkg\_info command. JDK must be installed from ports due to licensing restrictions; follow the port's instructions for manually downloading the required software. Jython must be installed from ports as the package does not expect the diablo JDK. Asterisk must be forced with the -f switch on a PC-BSD system as it conflicts with the already installed libiodbc/virtuoso.

```
cd /usr/ports/java/diablo-jdk16 && make install clean 
cd /usr/ports/lang/jython && make install clean 
pkg_add -r mysql55-server
pkg_add -r mysql-connector-java
pkg_add -r log4j
pkg_add -r slf4j
pkg_add -r tomcat60
pkg_add -r ImageMagick
pkg_add -r swftools
pkg_add -r nginx
pkg_add -r linux_base 
pkg_add -rf asterisk 
pkg_add -r unzip 
pkg_add -rf activemq
```

## Misc Settings ##

#add to /root/.cshrc:

```
setenv RED5_home /usr/local/share/red5/
```

# add after comment section of /usr/local/etc/rc.d/tomcat6:

```
TOMCAT6_SECURITY=no
```

# make mysql happy

# add to /etc/hosts.allow

```
mysqld : ALL : allow 
```

# add to /etc/rc.conf:

```
tomcat60_enable="YES" 
mysql_enable="YES" 
nginx_enable="YES" 
asterisk_enable="YES"
```

# tell tomcat to use 8080 instead of default of 8180

# in /usr/local/apache-tomcat-6.0/conf/server.xml

## Configure Asterisk ##

```
cd /usr/local/etc/asterisk
fetch http://bigbluebutton.org/downloads/0.70/bbb_extensions.conf
fetch http://bigbluebutton.org/downloads/0.70/bbb_sip.conf
```

# add these 2 lines to extensions.conf in #include section:

```
#include bbb_extensions.conf
#include bbb_sip.conf
```

```
cd /usr/local/lib/asterisk/modules
fetch http://bigbluebutton.org/downloads/0.70/32bit/app_konference.so
chmod 755 app_konference.so
echo "load => app_konference.so" >> /usr/local/etc/asterisk/modules.conf
```

# edit /usr/local/etc/asterisk/manager.conf, change enabled = no to = yes, and add these lines:

```
; BigBlueButton: Enable Red5 to connect 

[bbb]

secret = secret

permit = 0.0.0.0/0.0.0.0

read = system,call,log,verbose,command,agent,user

write = system,call,log,verbose,command,agent,user
```

## Configure Webserver ##

```
cd /usr/local/etc/nginx
fetch http://bigbluebutton.org/downloads/0.70/nginx-bigbluebutton.conf
```

#edit nginx-bigbluebutton.conf to change the server\_name IP, change /var/www/ paths to /usr/local/www/, and correct nginx-dist to nginx-default

```
mkdir sites-available sites-enabled
mv nginx-bigbluebutton.conf sites-available/bigbluebutton
ln -s /usr/local/etc/nginx/sites-available/bigbluebutton /usr/local/etc/nginx/sites-enabled/bigbluebutton
mkdir /var/log/nginx
touch /var/log/nginx/bigbluebutton.access.log
```

#replace /usr/local/etc/nginx/nginx.conf with:

```
worker_processes 1; 

events {

    worker_connections  1024;

}

http {

    include       mime.types;

    default_type  application/octet-stream;

    sendfile        on;

    keepalive_timeout  65;

include /usr/local/etc/nginx/sites-enabled/*;

    }
```

```
cd /usr/local/www
fetch http://bigbluebutton.org/downloads/0.70/packages/bbb-default.tar.gz
tar xzvf bbb-default.tar.gz && rm bbb-default.tar.gz
mkdir bigbluebutton && cd bigbluebutton
fetch http://bigbluebutton.org/downloads/0.70/packages/client.tar.gz
tar xzvf client.tar.gz && rm client.tar.gz
```

# edit client/conf/config.xml and edit 192.168. URLs

## Configure Red5 ##

```
cd /usr/local/share
fetch http://bigbluebutton.org/downloads/0.70/red5-0.9.1.tar.gz
tar xzvf red5-0.9.1.tar.gz
mv red5-0.9.1 red5 && cd red5/webapps
fetch http://bigbluebutton.org/downloads/0.70/packages/bigbluebutton-apps.tar.gz
tar xzvf bigbluebutton-apps.tar.gz && rm bigbluebutton-apps.tar.gz
fetch http://bigbluebutton.org/downloads/0.70/packages/video.tar.gz
tar xzvf video.tar.gz && rm video.tar.gz
fetch http://bigbluebutton.org/downloads/0.70/packages/sip.tar.gz
tar xzvf sip.tar.gz && rm sip.tar.gz
chmod +x red5.sh
```

#vipw and add line:

```
red5:*:1935:1935::0:0:Red5 User:/usr/local/share/red5:/sbin/nologin
```

#add lines to /etc/group:

```
red5:*:1935
```

```
cd /usr/local/share/red5/log
touch deskshare.log sip.log video.log
```

## Configure Tomcat ##

```
cd /usr/local/apache-tomcat-6.0/webapps
fetch http://bigbluebutton.org/downloads/0.70/packages/bigbluebutton.war
mkdir bigbluebutton && cd bigbluebutton
unzip ../bigbluebutton.war
```

#edit IP in bigbluebutton/WEB-INF/classes/bigbluebutton.properties

# edit IP in /usr/local/apache-tomcat-6.0/webapps/bigbluebutton /demo/bbb\_api\_conf.jsp

```
mkdir /usr/local/etc/bigbluebutton
```

## Various BBB Configuration ##

# create /usr/local/etc/bigbluebutton/nopdfmark.ps with:

```
%!
/pdfmark {cleartomark} bind def
```

```
mkdir /var/log/bigbluebutton
touch /var/log/bigbluebutton/bbb-web.log
chmod 777 /var/log/bigbluebutton/bbb-web.log
mkdir -p /var/bigbluebutton/blank
fetch http://bigbluebutton.org/downloads/0.64/blank/blank-slide.swf
fetch http://bigbluebutton.org/downloads/0.64/blank/blank-thumb.png
```

## Create Database ##

```
/usr/local/etc/rc.d/mysql-server start
```

```
mysql -u root 

mysql> create database bigbluebutton_dev;

mysql > grant all on bigbluebutton_dev.* to 'bbb'@'localhost' identified by 'secret';  

mysql> commit;

mysql> quit
```

## Start Services ##

```
/usr/local/etc/rc.d/asterisk start
/usr/local/etc/rc.d/nginx start
/usr/local/etc/rc.d/tomcat6 start
/usr/local/lib/activemq/bin/activemq &
cd /usr/local/share/red5/&& ./red5.sh &
```

## Testing ##

Use your browser to go to localhost. You should see a BBB page and be able to successfully Join a session.

If necessary, open these ports in firewall:

80 (nginx); 8080 (tomcat); 8088, 5080, 1935 (red5); 5080 (deskshare); 8161, 61616 (activemq)