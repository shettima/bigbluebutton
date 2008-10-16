package org.bigbluebutton.main
{
	import flash.events.Event;
	import flash.net.URLLoader;
	
	import flexunit.framework.TestCase;
	import flexunit.framework.TestSuite;
	
	import org.bigbluebutton.main.model.BbbModuleManager;

	public class BbbModuleManagerTests extends TestCase
	{
		private var manager:BbbModuleManager;
		private var xml:XML;
		
		public function BbbModuleManagerTests(methodName:String=null)
		{
			super(methodName);
		}

		override public function setUp():void { 
			manager = new BbbModuleManager(); 
		}  
		
		override public function tearDown():void {  } 

 		public static function suite():TestSuite 
 		{
   			var ts:TestSuite = new TestSuite();
   			
   			ts.addTest( new BbbModuleManagerTests( "testParseModuleXml" ) );
   			//ts.addTest( new BbbModuleManagerTests( "testParseModuleXml" ) );
   			return ts;
   		}
   		
   		public function testLoadXmlFile():void {
   			
   		}
   		
   		
   		private function loadCompleteHandler(e:Event):void {
   			try{
				trace("parsing xml file " + new XML(e.target.data));
				manager.parse(new XML(e.target.data));
				assertTrue( "Number of modules is 4", manager.modules.length == 4);
			} catch(error:TypeError){
				trace(error.message);
			}
   		}
   		
   		public function testParseModuleXml():void {   			
   			var urlLoader:URLLoader = new URLLoader();
			urlLoader.addEventListener(Event.COMPLETE, loadCompleteHandler);			
   			manager.loadXmlFile(urlLoader, "org/bigbluebutton/common/modules.xml");
   		}

		public function testLoadXmlModule():void {
			assertTrue( "testParseModuleXml", false);
		}

	}
}