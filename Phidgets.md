# Introduction #

Three phidgets widgets came into play for the physical interface of BigBlueButton. The related functions are implemented as the demonstration to show creating an API in BigBlueButton.

Phidget Servo Motor was using for receiving a response from BigBlueButton when the participator in web conference raises the hand. On the other side, The RFID and Phidget InterfaceKit demonstrated to send the events from Phidget widgets to BigBlueButton.


# Details #

## Setting Up the Environment ##
For using Phidgets, you have to install the drive into your own OS, which can be downloaded from phidgets website. http://www.phidgets.com/drivers.php You can start/trace devices by using the Phidget WebService.

Phidgets supports development in Flash for all types of Phidgets using ActionScript 3. You will need the Phidgets Actionscript Libraries to program with the widgets. The Library can be found in PhidgetsDemo package from BigBlueButton download page.


## Coding For Your Widgets ##
The following steps will tell you how Phidget InfaceKit works:
1. Before you can use the phidgets, you must import references from the library to the device.

2. Afterwards, the phidgets object will need to be declared and the initialized. For example, a start function is set to execute on initialization, and then an instance of a PhidgetInterfaceKit is declared and then set inside with:
```
	public var phid:com.phidgets.PhidgetInterfaceKit;
	public function start():void{
		phid = new PhidgetInterfaceKit();
		//More code goes here
	}
```

3. Next, the program needs to try and connect to the Phidget through an open call. We can handle this by using event driven programming and tracking the AttachEvents and DetachEvents, or checking the isAttached property.
```
	phid.open("localhost", 5001, "pass");
```

4. You can program event driven for phidgets by using hooking an event handler with the code:
```
	phid.addEventListener(PhidgetDataEvent.SENSOR_CHANGE, onSensorChange);
```

5. The onSensorChange method will get executed every time the InterfaceKit reports a change on one of its analog inputs. The values from the report can be accessed from the PhidgetDataEvent object. You can execute more BigBlueButton functions within this method.
```
	private function onSensorChange(evt:PhidgetDataEvent):void{
		//Insert your code here
                //Merge BigBluueButton functions
	}
```

> Some events such as Attach and Detach belong to the base Phidget object and thus are common to all types of Phidgets.

## Working With Multiple Phidgets ##
Multiple Phidgets of the same type can easily be run inside the same program. If you were using a PhidgetRFID instead of an Interfacekit, you would declare a PhidgetRFID instead of a PhidgetInterfaceKit. In our demo, it requires PhidgetInterfaceKit/PhidgetServo/PhidgetRFID instances to be defined and initialized together. The new instance can then be set up, opened and used in the same process as the previous one.

## Uses of Phidgets ##
See the discussion on UsesOfPhidgets.

## Notes ##
1. The effects of demo can be observed by simply replacing three Actionscript files and adding one library file. You can get the PhidgetsDemo.zip files from download page and accommodate the changes into your Flex project.
http://code.google.com/p/bigbluebutton/downloads/list

2. The source code in PhidgetsDemo.zip is based on BigBlueButton-client at reversion 2341
