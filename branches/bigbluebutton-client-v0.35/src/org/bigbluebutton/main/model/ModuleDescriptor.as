package org.bigbluebutton.main.model
{
	import flash.events.Event;
	
	import mx.modules.ModuleLoader;
	
	import org.bigbluebutton.common.BigBlueButtonModule;
	
	public class ModuleDescriptor
	{
		public var name:String;
		public var url:String;
		public var loader:ModuleLoader;
		public var module:BigBlueButtonModule;
		
		private var callbackHandler:Function;
		
		public function ModuleDescriptor(name:String, url:String)
		{
			this.name = name;
			this.url = url;
			
			loader = new ModuleLoader();
			loader.addEventListener("urlChanged", onUrlChanged);
			loader.addEventListener("loading", onLoading);
			loader.addEventListener("progress", onProgress);
			loader.addEventListener("setup", onSetup);
			loader.addEventListener("ready", onReady);
			loader.addEventListener("error", onError);
			loader.addEventListener("unload", onUnload);
		}

		public function load(resultHandler:Function):void {
			callbackHandler = resultHandler;
			loader.url = url;
			loader.loadModule();
		}
		
		public function unload(resultHandler:Function):void {
			callbackHandler = resultHandler;
			loader.url = "";
		}

		private function onUrlChanged(event:Event):void {
			trace("Module onUrlChanged Event");
			callbackHandler(event);
		}
			
		private function onLoading(event:Event):void {
			trace("Module onLoading Event");
			callbackHandler(event);
		}
			
		private function onProgress(event:Event):void {
			trace("Module onProgress Event");
			callbackHandler(event);
		}			

		private function onSetup(event:Event):void {
			trace("Module onSetup Event");
			callbackHandler(event);
		}	

		private function onReady(event:Event):void {
			trace("Module onReady Event");
			var loader:ModuleLoader = event.target as ModuleLoader;
			module = loader.child as BigBlueButtonModule;
		}	

		private function onError(event:Event):void {
			trace("Module onError Event");
			callbackHandler(event);
		}

		private function onUnload(event:Event):void {
			trace("Module onUnload Event");
			callbackHandler(event);
		}		
	}
}