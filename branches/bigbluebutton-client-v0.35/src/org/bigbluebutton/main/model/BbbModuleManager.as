package org.bigbluebutton.main.model
{
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import mx.controls.Alert;
	
	import org.bigbluebutton.common.BigBlueButtonModule;
	
	public class BbbModuleManager
	{
		public static const FILE_PATH:String = "org/bigbluebutton/common/modules.xml";
		private var urlLoader:URLLoader;
		public var modules:Array = new Array();
		
		public function BbbModuleManager()
		{
			urlLoader = new URLLoader();
			urlLoader.addEventListener(Event.COMPLETE, handleComplete);
			loadXmlFile(urlLoader, FILE_PATH);
		}
		
		public function loadXmlFile(loader:URLLoader, file:String):void {			
			trace("Loading xml file " + FILE_PATH);
			loader.load(new URLRequest(file));
		}
		
		public function loadModule(name:String,resultHandler:Function):void{
			var m:ModuleDescriptor = modules[name];
			if (m != null) {
				m.load(resultHandler);
			}
		}
		
		private function handleComplete(e:Event):void{
			try{
				trace("parsing xml file " + FILE_PATH);
				parse(new XML(e.target.data));
			} catch(error:TypeError){
				Alert.show(error.message);
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
		}
		
		public function start(name:String):void {
			modules[name].module.start();
		}
	}
}