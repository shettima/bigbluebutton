

# Introduction #

`bbb-conf` is the BigBlueButton configuration script for modifying BigBlueButton's configuration, managing the BigBlueButton processes (start/stop/reset), and troubleshooting your installation.

If you are installing BigBlueButton from source, you can download `bbb-conf` from [here](http://github.com/bigbluebutton/bigbluebutton/blob/master/bigbluebutton-config/bin/bbb-conf).

When installed from packages, `bbb-conf` is located in `/usr/local/bin/bbb-conf`.  If you are a developer, look through the source for `bbb-conf` (it's a shell script) will help you understand the various components of BigBlueButton and how they work together.

# Options #

If you type `bbb-conf` with no parameters it will print out the list of available options.

```
BigBlueButton Configuration Utility - Version 0.71a
http://code.google.com/p/bigbluebutton/wiki/BBBConf

   bbb-conf [options]

Configuration:
   --setip <host>                   Set IP/hostname for BigBlueButton
   --conference [konference|meetme|freeswitch]
                                    Switch conference module
   --setsalt <salt>                 Change the security salt in bigbluebutton.properties

Monitoring:
   --check                          Check configuration files and processes for problems
   --debug                          Scan the log files for error messages
   --watch                          Scan the log files for error messages every 2 seconds
   --salt                           View the URL and security salt for the server

Administration:
   --restart                        Restart BigBueButton
   --stop                           Stop BigBueButton
   --start                          Start BigBueButton
   --clean                          Restart and clean all log files
   --zip                            Zip up log files for reporting an error

```

Some of the `bbb-conf` options require that you run the command as root user.  `bbb-conf` will print out a message prompting you to run the command with `sudo` if needed.


### `--setip <hostname_or_ip>` ###

Sets the IP/Hostname for BigBlueButton's configuration.

| **Parameter** | **Required/Optional** | **Additional Information** |
|:--------------|:----------------------|:---------------------------|
| Host | Required || Hostname or IP of the machine where BigBlueButton|

**Example Usage:**

```
   bbb-conf --setip 192.168.0.211
```

or

```
  bbb-conf --setip bbb.mybbbserver.com
```




### `--clean` ###
Clear all the log files and restart BigBlueButton


### `--check` ###
Checks current settings and outlines any potential problems.


### `--checkout <repo>` ###
Checkout BigBlueButton from http://github.com/bigbluebutton/bigbluebutton as READ-ONLY when no `<repo>` is passed. You can pass in a repository if when you want to checkout from your fork of BigBlueButton.  [Note: This command is depreciated in 0.80.]


### `--conference <conference_module>` ###
Switches conference module in Asterisk.  Valid choices are `konference` or `meetme`.  [Note: This command is depreciated in 0.80.]


### `--debug` ###
Checks the log files for errors


### `--network` ###
This command shows you the number of active connections for port 80 (HTTP), 1935 (RTMP), and 9123 (Desktop sharing) for each remote IP address.

The main purpose of this command is to check for users that are tunnelling to the BigBlueButton server.  If you see a connected users that has no entries in 1935 or 9123, then that users is tunnelling (all their connections are going through port 80).


### `--reset-dev` ###
Resets the development environment back to using packages.

### `--salt` ###
Display the current security salt for the BigBlueButton API.  For example:

```
firstuser@clean-vm-20101024-22:~$ bbb-conf --salt

       URL: http://192.168.0.35/bigbluebutton/
      Salt: f6c72afaaae95faa28c3fd90e39e7e6e

```


### `--setup-samba` ###
This command is only available if you are using the BigBlueButton virtual machine.

It sets up a samba share for development.


### `--setsalt <new_salt>` ###
Assign a new security salt for the BigBlueButton API.


### `--setup-dev [web|client|apps]` ###
Sets up the development environment for bbb-web, bbb-client, and bbb-apps.  **NOTE:** Do `bbb-conf --checkout` before running `bbb-conf --setup-dev`.  For more information, see [developing BigBlueButton](DevelopingBBB.md).


### `--start` ###
Starts all the BigBlueButton processes.


### `--stop` ###
Stops all the BigBlueButton processes.


### `--watch` ###
Watch log files for error messages every 2 seconds.  Use this command after `sudo bbb-conf --clean` to clean out all the log files.


### `--zip` ###
Zip up log files for reporting an error.


# Troubleshooting #
In some cases the IP of the VM maybe change while initializing for the first time and, consequently, the BigBlueButton config files would be setup with the wrong IP address. If you're running into problems, execute the following command.

```
   sudo bbb-conf --check
```

If the IP in BigBlueButton's config files don't match the IP of your VM, you will see something like the following.

![http://bigbluebutton.googlecode.com/svn/trunk/bbb-images/bbbconf-wrongip.png](http://bigbluebutton.googlecode.com/svn/trunk/bbb-images/bbbconf-wrongip.png)

To resolve this,  run this command:

```
   bbb-conf --setip <hostname_or_ip>
```