package org.bigbluebutton.main.model
{
	import mx.utils.ObjectUtil;
	
	import org.puremvc.as3.multicore.interfaces.IProxy;
	import org.puremvc.as3.multicore.patterns.proxy.Proxy;

	public class ModulesProxy extends Proxy implements IProxy
	{
		private var modulesManager:BbbModuleManager;
		private var modules:Array;
		
		public function ModulesProxy(proxyName:String=null, data:Object=null)
		{
			super(proxyName, data);
			modulesManager = new BbbModuleManager();
		}

		private function onInitializeComplete(modules:Array):void {
			this.modules = ObjectUtil.copy(modules) as Array;
		}
		
		private function loadModule(name:String,resultHandler:Function):void{
			var m:ModuleDescriptor = modules[name];
			if (m != null) {
				m.load(resultHandler);
			}
		}
				
		private function start(name:String):void {
			modules[name].module.start();
		}
	}
}