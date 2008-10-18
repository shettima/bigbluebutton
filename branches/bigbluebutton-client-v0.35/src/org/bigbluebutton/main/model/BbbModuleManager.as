package org.bigbluebutton.main.model
{
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	public class BbbModuleManager
	{
		public static const FILE_PATH:String = "org/bigbluebutton/common/modules.xml";
		private var urlLoader:URLLoader;
		private var callbackHandler:Function;
		public var  modules:Array = new Array();
		
		public function BbbModuleManager()
		{
			urlLoader = new URLLoader();
			urlLoader.addEventListener(Event.COMPLETE, handleComplete);			
		}
		
		public function initialize(onInitializeComplete:Function):void {
			callbackHandler = onInitializeComplete;
			loadXmlFile(urlLoader, FILE_PATH);
		}
		
		public function loadXmlFile(loader:URLLoader, file:String):void {			
			trace("Loading xml file " + FILE_PATH);
			loader.load(new URLRequest(file));
		}
				
		private function handleComplete(e:Event):void{
			try{
				trace("parsing xml file " + FILE_PATH);
				parse(new XML(e.target.data));				
			} catch(error:TypeError){
				trace('Error loading XML modules file.');
			}
		}
		
		public function parse(xml:XML):void{
			var list:XMLList = xml.module;
			var item:XML;
						
			for each(item in list){
				trace("Available Modules: " + item.@name + " at " + item.@swfpath);
				var mod:ModuleDescriptor = new ModuleDescriptor(item.@name, item.@swfpath);
				modules[item.@name] = mod;
			}			
			callbackHandler(modules);
		}

	}
}