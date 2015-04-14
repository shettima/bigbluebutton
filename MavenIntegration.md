# Introduction #

One of our ongoing goals is to make it easier for other developers to build, extend, and help improve BigBlueButton.

Currently, BigBlueButton uses different build systems (ant and gradle) with the requirement of using the VM for development.  To make it easier to build, we are working on moving to a unified build system using maven 3.

You can try building BigBlueButton using the following instructions.


# Details #

On a Ubuntu 10.04 32-bit or 64-bit server, do the following:

  1. [Install BigBlueButton](InstallationUbuntu.md).
  1. Install [Maven 3](http://maven.apache.org/download.html).
  1. Add the following line to your ~/.bashrc
```
export MAVEN_OPTS="-Xmx512m -XX:MaxPermSize=512M"
```
  1. Enter the command `source ~/.bashrc` to reload the environment variables in ~/.bashrc
  1. Checkout the [BigBlueButton source](https://github.com/bigbluebutton/bigbluebutton) from GitHub.
  1. cd to bigbluebutton/.
  1. Checkout the maven branch:
```
git checkout maven
```
  1. run:
```
mvn clean install -Dmaven.test.skip=true
```
  1. Report errors to [bigbluebutton-dev](http://groups.google.com/group/bigbluebutton-dev)