package org.bigbluebutton.modules.chat
{
	import org.bigbluebutton.common.IBigBlueButtonModule;
	import org.bigbluebutton.common.messaging.Endpoint;
	import org.bigbluebutton.common.messaging.EndpointMessageConstants;
	import org.bigbluebutton.common.messaging.Router;
	import org.puremvc.as3.multicore.interfaces.IMediator;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	import org.puremvc.as3.multicore.utilities.pipes.interfaces.IPipeMessage;

	public class ChatEndpointMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "ChatEndPointMediator";
		
		private var _module:IBigBlueButtonModule;
		private var _router:Router;
		private var _endpoint:Endpoint;		
		private static const TO_CHAT_MODULE:String = "TO_CHAT_MODULE";
		private static const FROM_CHAT_MODULE:String = "FROM_CHAT_MODULE";
		
		private static const PLAYBACK_MESSAGE:String = "PLAYBACK_MESSAGE";
		private static const PLAYBACK_MODE:String = "PLAYBACK_MODE";
				
		public function ChatEndpointMediator(module:IBigBlueButtonModule)
		{
			super(NAME,module);
			_module = module;
			_router = module.router
			trace("Creating endpoint for ChatModule");
			_endpoint = new Endpoint(_router, FROM_CHAT_MODULE, TO_CHAT_MODULE, messageReceiver);	
		}
		
		override public function sendNotification(notificationName:String, body:Object=null, type:String=null):void
		{
		}
		
		override public function getMediatorName():String
		{
			return NAME;
		}
				
		override public function listNotificationInterests():Array
		{
			return [
				ChatModuleConstants.CONNECTED,
				ChatModuleConstants.DISCONNECTED
			];
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch(notification.getName()){
				case ChatModuleConstants.CONNECTED:
					trace("Sending Chat MODULE_STARTED message to main");
					_endpoint.sendMessage(EndpointMessageConstants.MODULE_STARTED, 
							EndpointMessageConstants.TO_MAIN_APP, _module.moduleId);
					break;
				case ChatModuleConstants.DISCONNECTED:
					trace('Sending Chat MODULE_STOPPED message to main');
					_endpoint.sendMessage(EndpointMessageConstants.MODULE_STOPPED, 
							EndpointMessageConstants.TO_MAIN_APP, _module.moduleId);
					break;
			}
		}
	
		private function messageReceiver(message : IPipeMessage) : void
		{
			var msg : String = message.getHeader().MSG as String;
			switch(msg){
				case PLAYBACK_MODE:
					break;
				case PLAYBACK_MESSAGE:
					playMessage(message.getBody() as XML);					
					break;
			}
		}
		
		private function playMessage(message:XML):void{

		}				
	}
}