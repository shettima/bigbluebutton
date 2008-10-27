package org.bigbluebutton.modules.presentation
{
	import org.bigbluebutton.common.IBigBlueButtonModule;
	import org.bigbluebutton.common.messaging.Endpoint;
	import org.bigbluebutton.common.messaging.Router;
	import org.puremvc.as3.multicore.interfaces.IMediator;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;

	public class PresentationEndpointMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "PresentationEndpointMediator";

		private var _module:IBigBlueButtonModule;
		private var _router:Router;
		private var _endpoint:Endpoint;	

		private static const TO_PRESENTATION_MODULE:String = "TO_PRESENTATION_MODULE";
		private static const FROM_PRESENTATION_MODULE:String = "FROM_PRESENTATION_MODULE";
						
		public function PresentationEndpointMediator(module:IBigBlueButtonModule)
		{
			super(NAME);
		}
			
		override public function getMediatorName():String
		{
			return NAME;
		}
			
		override public function listNotificationInterests():Array
		{
			return null;
		}
		
		override public function handleNotification(notification:INotification):void
		{
		}
		
		
	}
}