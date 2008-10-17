package org.bigbluebutton.main
{
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import flexunit.framework.TestCase;
	import flexunit.framework.TestSuite;
	
	import org.bigbluebutton.main.model.BbbModuleManager;

	public class BbbModuleManagerTests extends TestCase
	{
		private var manager:BbbModuleManager;
		private var xmlString:String = 
			'<modules><module name="ChatModule" swfpath="org/bigbluebutton/modules/chat/ChatModule.swf" />' +
			'<module name="PresentationModule" swfpath="org/bigbluebutton/modules/presentation/PresentationModule.swf" />' +
			'<module name="VideoModule" swfpath="org/bigbluebutton/modules/video/VideoModule.swf" />' +
			'<module name="VoiceModule" swfpath="org/bigbluebutton/modules/voiceconference/VoiceModule.swf" />' +
			'</modules> '
		
		private var xml:XML = new XML(xmlString);
		
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
   			ts.addTest( new BbbModuleManagerTests( "testLoadXmlFile" ) );
   			ts.addTest( new BbbModuleManagerTests( "testLoadModule" ) );
   			return ts;
   		}
   		
   		private function loadCompleteHandler(e:Event):void {
   			try{
				manager.parse(new XML(e.target.data));
				assertTrue( "There should be a VideoModule", manager.modules['VideoModule'].name == 'VideoModule');
				assertTrue( "There should be a VoiceModule", manager.modules['VoiceModule'].name == 'VoiceModule');
			} catch(error:TypeError){
				trace(error.message);
			}
   		}
   		
   		public function testParseModuleXml():void {   			
   				manager.parse(new XML(xmlString));
				assertTrue( "There should be a ChatModule", manager.modules['ChatModule'].name == "ChatModule");
   		}

		public function testLoadXmlFile():void {
            var urlLoader:URLLoader = new URLLoader();            
            urlLoader.addEventListener(Event.COMPLETE, addAsync(loadCompleteHandler, 1000));            
            urlLoader.load(new URLRequest("org/bigbluebutton/common/modules.xml"));
		}
		
		public function testLoadModule():void {
			manager.parse(new XML(xmlString));
			assertTrue( "There should be a ChatModule", manager.modules['ChatModule'].name == "ChatModule");
			manager.loadModule('ChatModule', resultHandler);
		}
		
		private function resultHandler(e:Event):void {
			trace(e.type);
		}
	}
}