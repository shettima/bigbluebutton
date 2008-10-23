package org.bigbluebutton.main.model
{
	import flash.utils.Dictionary;
	
	import org.bigbluebutton.common.IBigBlueButtonModule;
	import org.bigbluebutton.common.messaging.Router;
	import org.bigbluebutton.main.MainApplicationConstants;
	import org.puremvc.as3.multicore.interfaces.IProxy;
	import org.puremvc.as3.multicore.patterns.proxy.Proxy;

	public class ModulesProxy extends Proxy implements IProxy
	{
		public static const NAME:String = 'ModulesProxy';
		
		private var modulesManager:BbbModuleManager;
		private var _modules:Dictionary;
		
		public function ModulesProxy(proxyName:String=null, data:Object=null)
		{
			super(NAME, data);
			modulesManager = new BbbModuleManager();
			modulesManager.initialize(onInitializeComplete);
		}

		private function onInitializeComplete(modules:Dictionary):void {
			_modules = modules;
			trace('Listing all modules2');
			for (var key:Object in _modules) {
				trace(key, _modules[key].url);
			}
			facade.sendNotification(MainApplicationConstants.APP_MODEL_INITIALIZED);
		}
		
		public function initialize():void {
			modulesManager.initialize(onInitializeComplete);			
		}
		
		public function loadModules():void {
			trace('Loading all modules');
			for (var key:Object in _modules) {
				trace(key, _modules[key].url);
				loadModule(key, loadModuleResultHandler);
			}
		}
		
		public function startModules(router:Router):void {
			trace('Starting all modules');
			for (var key:Object in _modules) {
				trace('Starting ' + _modules[key].name);
				var m:ModuleDescriptor = _modules[key] as ModuleDescriptor;
				var bbb:IBigBlueButtonModule = m.module as IBigBlueButtonModule;
				if (m.name == 'ViewersModule') {
					bbb.acceptRouter(router);	
				}
			}		
		}

		public function startModule(name:String, router:Router):void {
			trace('Request to start module ' + name);
			for (var key:Object in _modules) {				
				var m:ModuleDescriptor = _modules[key] as ModuleDescriptor;
				if (m.name == name) {
					trace('Starting ' + _modules[key].name);
					var bbb:IBigBlueButtonModule = m.module as IBigBlueButtonModule;
					bbb.acceptRouter(router);	
					bbb.start();
				}
			}		
		}
		
		private function loadModule(name:Object,resultHandler:Function):void {
			trace('Loading ' + name);
			var m:ModuleDescriptor = _modules[name] as ModuleDescriptor;
			if (m != null) {
				trace('Found module ' + m.name);
				m.load(resultHandler);
			} else {
				trace(name + " not found.");
			}
		}
				
		private function loadModuleResultHandler(moduleName:Object):void {
			var allLoaded:Boolean = true;			
			for (var key:Object in _modules) {
				if (! _modules[key].loaded) allLoaded = false;
			}			
			if (allLoaded) {
				trace('All modules have been loaded');
				facade.sendNotification(MainApplicationConstants.MODULES_LOADED);
			}
		}
		
		private function start(name:String):void {
			_modules[name].module.start();
		}
		
		public function get modules():Dictionary {
			return _modules;
		}
	}
}