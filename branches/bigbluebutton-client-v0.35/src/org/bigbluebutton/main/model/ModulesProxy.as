package org.bigbluebutton.main.model
{
	import org.puremvc.as3.multicore.interfaces.IProxy;
	import org.puremvc.as3.multicore.patterns.proxy.Proxy;

	public class ModulesProxy extends Proxy implements IProxy
	{
		private var modulesManager:BbbModuleManager;
		
		public function ModulesProxy(proxyName:String=null, data:Object=null)
		{
			super(proxyName, data);
			modulesManager = new BbbModuleManager();
			//modulesManager.initialize();
		}
	}
}