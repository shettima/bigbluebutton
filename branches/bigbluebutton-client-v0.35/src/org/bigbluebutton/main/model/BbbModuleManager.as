package org.bigbluebutton.main.model
{
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.Dictionary;
	
	import mx.collections.ArrayCollection;
	
	import org.bigbluebutton.common.IBigBlueButtonModule;
	import org.bigbluebutton.common.messaging.Router;
	
	public class BbbModuleManager
	{
		public static const FILE_PATH:String = "org/bigbluebutton/common/modules.xml";
		private var _urlLoader:URLLoader;
		private var _initializedListeners:ArrayCollection = new ArrayCollection();
		private var _moduleLoadedListeners:ArrayCollection = new ArrayCollection();
		
		private var _numModules:int = 0;		
		public var  _modules:Dictionary = new Dictionary();
		
		public function BbbModuleManager()
		{
			_urlLoader = new URLLoader();
			_urlLoader.addEventListener(Event.COMPLETE, handleComplete);			
		}
		
		public function initialize():void {
			loadXmlFile(_urlLoader, FILE_PATH);
		}
		
		public function addInitializedListener(initializedListener:Function):void {
			_initializedListeners.addItem(initializedListener);
		}
		
		public function addModuleLoadedListener(loadListener:Function):void {
			_moduleLoadedListeners.addItem(loadListener);
		}
		
		public function loadXmlFile(loader:URLLoader, file:String):void {
			loader.load(new URLRequest(file));
		}
				
		private function handleComplete(e:Event):void{
			parse(new XML(e.target.data));	
			if (_numModules > 0) {
				notifyInitializedListeners(true);
			} else {
				notifyInitializedListeners(false);
			}			
		}
		
		private function notifyInitializedListeners(inited:Boolean):void {
			for (var i:int=0; i<_initializedListeners.length; i++) {
				var listener:Function = _initializedListeners.getItemAt(i) as Function;
				listener(inited);
			}
		}

		private function notifyModuleLoadedListeners(name:String):void {
			for (var i:int=0; i<_moduleLoadedListeners.length; i++) {
				var listener:Function = _moduleLoadedListeners.getItemAt(i) as Function;
				listener(name);
			}
		}
				
		public function parse(xml:XML):void{
			var list:XMLList = xml.module;
			var item:XML;
						
			for each(item in list){
				var attributes:Object = parseAttributes(item);
				var mod:ModuleDescriptor = new ModuleDescriptor(attributes);
				_modules[item.@name] = mod;
				_numModules++;
			}					
		}
		
		public function parseAttributes(item:XML):Object {
			var atts:Object = new Object();
			var attNamesList:XMLList = item.@*;

			for (var i:int = 0; i < attNamesList.length(); i++)
			{ 
			    var attName:String = attNamesList[i].name();
			    var attValue:String = item.attribute(attName);
			    atts[attName] = attValue;
			} 
			return atts;
		}
		
		public function addUserIntoAttributes(user:Object):void {
			for (var key:Object in _modules) {				
				var m:ModuleDescriptor = _modules[key] as ModuleDescriptor;
				m.attributes.userid = user.userid;
				m.attributes.username = user.name;
				m.attributes.userrole = user.role;
				m.attributes.room = user.room;
				m.attributes.authToken = user.authToken;		
			}				
		}
		
		
		public function get numberOfModules():int {
			return _numModules;
		}
		
		public function getModule(name:String):ModuleDescriptor {
			for (var key:Object in _modules) {				
				var m:ModuleDescriptor = _modules[key] as ModuleDescriptor;
				if (m.attributes.name == name) {
					return m;
				}
			}		
			return null;	
		}

		public function loadModules():void {
			trace('Loading all modules');
			for (var key:Object in _modules) {
				trace(key, _modules[key].attributes.url);
				loadModule(key as String);
			}
		}
		
		public function startModules(router:Router):void {
			trace('Starting all modules');
			for (var key:Object in _modules) {
				trace('Starting ' + _modules[key].name);
				var m:ModuleDescriptor = _modules[key] as ModuleDescriptor;
				var bbb:IBigBlueButtonModule = m.module as IBigBlueButtonModule;
				if (m.attributes.name == 'ViewersModule') {
					bbb.acceptRouter(router);	
				}
			}		
		}

		public function startModule(name:String, router:Router):void {
			trace('Request to start module ' + name);
			var m:ModuleDescriptor = getModule(name);
			if (m != null) {
				trace('Starting ' + name);
				var bbb:IBigBlueButtonModule = m.module as IBigBlueButtonModule;
				bbb.acceptRouter(router);
				bbb.start(m.attributes);		
			}	
		}

		public function stopModule(name:String):void {
			trace('Request to stop module ' + name);
			var m:ModuleDescriptor = getModule(name);
			if (m != null) {
				trace('Stopping ' + name);
				var bbb:IBigBlueButtonModule = m.module as IBigBlueButtonModule;
				bbb.stop();		
			}	
		}
						
		public function loadModule(name:String):void {
			trace('BBBManager Loading ' + name);
			var m:ModuleDescriptor = getModule(name);
			if (m != null) {
				if (m.loaded) {
					loadModuleResultHandler(name);
				} else {
					trace('Found module ' + m.attributes.name);
					m.load(loadModuleResultHandler);
				}
			} else {
				trace(name + " not found.");
			}
		}
				
		private function loadModuleResultHandler(name:String):void {
			var m:ModuleDescriptor = getModule(name);
			if (m != null) {
				trace('Loaded module ' + m.attributes.name);
				notifyModuleLoadedListeners(name);
			} else {
				trace(name + " not found.");
			}
		}
		
		public function moduleStarted(name:String, started:Boolean):void {			
			var m:ModuleDescriptor = getModule(name);
			if (m != null) {
				trace('Setting ' + name + ' started to ' + started);
				m.started = started;
			}	
		}
				
		public function get modules():Dictionary {
			return _modules;
		}
	}
}