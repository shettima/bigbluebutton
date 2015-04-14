# Introduction #
BigBlueButton provides flexibility in the ability to customize the interface using CSS.


# Details #
The CSS file needs to be compiled before bbb-client can use it. In order to brand the client, you first need to check out the bigbluebutton source code. The instructions for this are outlined [developing](Developing.md). If you are not a developer or are not comfortable with checking out the source and compiling it yourself, you can hire one of the companies that provide [commercial support](http://bigbluebutton.org/support) for BigBlueButton.

## Finding the files ##
Go to the directory where you've checkout out your source code. The branding files are located in the directory bigbluebutton-client/branding/default/style/css/BBBDefault.css. Here you will find a file called BBBDefault.css, among other files. BBBDefault.css is the main style sheet that will be loaded by the bigbluebutton client. The other files are examples of different branding styles for BigBlueButton (more on how you can try out these files later on in this document). The assets directory contains images and other files that are needed by the sample themes. You may not need these for your own branding, so you can ignore them for now.

## Compiling the style sheet ##
In order for Flash to load your CSS file, it needs to be compiled to an .swf format. There are two ways to do this:
### Compiling using Flash Builder ###
In Flash Builder, right click on the BBBDefault.css file and check off 'Compile CSS to SWF'. This will compile the css file to swf, and the it should now appear as bigbluebutton-client/client/branding/css/theme.swf
### Compiling using Ant ###
In the command line, go to the bigbluebutton-client root directory and type in:
```
ant branding -DthemeFile=BBBDefault.css
```
If the build succeeds, you should be able to find the compiled .css file as bigbluebutton-client/client/branding/css/BBBDefault.css.swf
If you would like to compile any other .css file in the branding directory, you can substitute the name of the file in the ant branding command, so for example:
```
ant branding -DthemeFile=myTheme.css
```
will compile the file myTheme.css and put it into client/bin/branding/css/myTheme.css.swf

Note that you should not need to move any images that you are using to the bin directory. As long as you are using @Embed() tags in your .css file, your images will be compiled directly into the resulting .swf file.

### Deploying the file to your production server ###
To deploy the theme file to your production server, find the client directory. You can run bbb-conf --check to find out where it is. Look at the part of the output which mentions where the client is. On a default install if will be something like:
```
/etc/nginx/sites-available/bigbluebutton
                      server name: example.bbb.org
                             port: 80
                   bbb-client dir: /var/www/bigbluebutton
```
In this case, the client is being loaded from /var/www/bigbluebutton/client. According to this configuration, if your theme file is named theme.css.swf, you need to place it there as:
```
/var/www/bigbluebutton/client/branding/css/theme.css.swf
```
And you need to edit the config file:
```
/var/www/bigbluebutton/client/conf/config.xml
```
to include the following line for the branding:
```
<skinning enabled="true" url="branding/css/theme.css.swf" />
```

## Editing the config.xml ##
To tell the BigBlueButton client to load your the compiled .swf file you just created, open the file bigbluebutton-client/client/conf/config.xml. Near the top of the file, you'll find the line:
```
<skinning enabled="false" />
```
Change this to:
```
<skinning enabled="true" url="branding/css/theme.swf" />
```

## Styling the client ##
All the usual rules for .css files hold. You can style the BigBlueButton client through CSS the same way you would style a web page.

This document is still in it's early stages. If you're having trouble styling, or applying styles to a particular component in BigBlueButton, write to the [bigbluebutton-dev](http://groups.google.com/group/bigbluebutton-dev) mailing list with questions or suggestions on how to improve this tutorial.