package org.bigbluebutton.main
{
	import flexlib.mdi.containers.MDIWindow;
	
	import org.bigbluebutton.common.messaging.Endpoint;
	import org.bigbluebutton.common.messaging.EndpointMessageConstants;
	import org.bigbluebutton.common.messaging.Router;
	import org.bigbluebutton.main.model.ModulesProxy;
	import org.puremvc.as3.multicore.interfaces.IMediator;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	import org.puremvc.as3.multicore.utilities.pipes.interfaces.IPipeMessage;
	
	public class MainEndpointMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "MainEndpointMediator";

		private var _router : Router;
		private var _endpoint:Endpoint;
				
		public function MainEndpointMediator()
		{
			super(NAME);
			_router = new Router();
			_endpoint = new Endpoint(_router, EndpointMessageConstants.FROM_MAIN_APP, EndpointMessageConstants.TO_MAIN_APP, messageReceiver);		
		}
		
		public function get router():Router
		{
			return _router;
		}
		
		override public function getMediatorName():String
		{
			return NAME;
		}
		
		private function get modulesProxy():ModulesProxy {
			return facade.retrieveProxy(ModulesProxy.NAME) as ModulesProxy;
		}
		
		override public function listNotificationInterests():Array
		{
			return [
				MainApplicationConstants.MODULE_START,
				MainApplicationConstants.MODULE_STOP,
				MainApplicationConstants.OPEN_WINDOW,
				MainApplicationConstants.CLOSE_WINDOW
			];
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch(notification.getName()){
				case MainApplicationConstants.MODULE_START:
					var startModule:String = notification.getBody() as String;
					trace("Request to start module " + startModule);
					modulesProxy.startModule(startModule, _router);						
					break;
				case MainApplicationConstants.MODULE_STOP:
					var stopModule:String = notification.getBody() as String;
					trace("Request to stop module " + stopModule);
					modulesProxy.stopModule(stopModule);						
					break;
				case MainApplicationConstants.OPEN_WINDOW:
					trace('Sending OPEN_WINDOW message to chatmodule');
					_endpoint.sendMessage(EndpointMessageConstants.OPEN_WINDOW, 
							EndpointMessageConstants.TO_CHAT_MODULE, EndpointMessageConstants.OPEN_WINDOW);					
			}
		}

		private function messageReceiver(message : IPipeMessage) : void
		{
			var msg : String = message.getHeader().MSG as String;						
			switch (msg)
			{
				case EndpointMessageConstants.MODULE_STARTED:
					trace("Got MODULE_STARTED from " + message.getBody() as String);
					modulesProxy.moduleStarted(message.getBody() as String, true);
					trace("Sending MODULE_STARTED from " + message.getBody() as String);
					sendNotification(MainApplicationConstants.MODULE_STARTED, message.getBody());
					break;
				case EndpointMessageConstants.MODULE_STOPPED:
					trace("Got MODULE_STOPPED from " + message.getBody() as String);
					modulesProxy.moduleStarted(message.getBody() as String, false);
					break;
				case EndpointMessageConstants.ADD_WINDOW:
					trace("Got ADD_WINDOW from " + message.getHeader().SRC as String);
					sendNotification(MainApplicationConstants.ADD_WINDOW_MSG, message.getBody() as MDIWindow);
					break;
					
			}
		}	
	}
}