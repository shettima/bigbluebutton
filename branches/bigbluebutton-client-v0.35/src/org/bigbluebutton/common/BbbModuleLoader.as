package org.bigbluebutton.common
{
	import mx.modules.ModuleLoader;

	public class BbbModuleLoader extends ModuleLoader
	{
		public function BbbModuleLoader()
		{
			super();
			addEventListener("urlChanged", onUrlChanged);
			addEventListener("loading", onLoading);
			addEventListener("progress", onProgress);
			addEventListener("setup", onSetup);
			addEventListener("ready", onReady);
			addEventListener("error", onError);
			addEventListener("unload", onUnload);
		}

			public function onUrlChanged(event:Event):void {
				trace("Module onUrlChanged Event");
			}
			
			public function onLoading(event:Event):void {
				trace("Module onLoading Event");
			}
			
			public function onProgress(event:Event):void {
				trace("Module onProgress Event");
			}			

			public function onSetup(event:Event):void {
				trace("Module onSetup Event");
			}	

			public function onReady(event:Event):void {
				trace("Module onReady Event");
			}	

			public function onError(event:Event):void {
				trace("Module onError Event");
			}

			public function onUnload(event:Event):void {
				trace("Module onUnload Event");
			}		
	}
}