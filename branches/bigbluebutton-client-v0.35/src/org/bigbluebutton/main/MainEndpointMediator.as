package org.bigbluebutton.main
{
	import org.bigbluebutton.common.messaging.EndpointMessageConstants;
	import org.bigbluebutton.common.messaging.InputPipe;
	import org.bigbluebutton.common.messaging.OutputPipe;
	import org.bigbluebutton.common.messaging.Router;
	import org.bigbluebutton.main.model.ModulesProxy;
	import org.puremvc.as3.multicore.interfaces.IMediator;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	import org.puremvc.as3.multicore.utilities.pipes.interfaces.IPipeMessage;
	import org.puremvc.as3.multicore.utilities.pipes.plumbing.PipeListener;
	
	public class MainEndpointMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "MainEndpointMediator";

		private var _outpipe : OutputPipe;
		private var _inpipe : InputPipe;
		private var _router : Router;
		private var _inpipeListener : PipeListener;
				
		public function MainEndpointMediator()
		{
			super(NAME);
			_router = new Router();
			_inpipe = new InputPipe(MainApplicationConstants.TO_MAIN);
			_outpipe = new OutputPipe(MainApplicationConstants.FROM_MAIN);
			_inpipeListener = new PipeListener(this, messageReceiver);
			_inpipe.connect(_inpipeListener);
			_router.registerOutputPipe(_outpipe.name, _outpipe);
			_router.registerInputPipe(_inpipe.name, _inpipe);			
		}
		
		public function get router():Router
		{
			return _router;
		}
		
		override public function sendNotification(notificationName:String, body:Object=null, type:String=null):void
		{
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
				MainApplicationConstants.MODULE_STOP
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
					break;
				case EndpointMessageConstants.MODULE_STOPPED:
					trace("Got MODULE_STOPPED from " + message.getBody() as String);
					modulesProxy.moduleStarted(message.getBody() as String, false);
					break;

			}
		}	
	}
}