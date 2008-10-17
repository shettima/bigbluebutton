package org.bigbluebutton.main
{
	import org.puremvc.as3.multicore.interfaces.IMediator;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;

	public class MainApplicationMediator extends Mediator implements IMediator
	{
		public static const NAME:String = 'MainApplicationMediator';
		
		public function MainApplicationMediator(mediatorName:String=null, viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		
		override public function listNotificationInterests():Array
		{
			return [
					MainApplicationConstants.APP_MODEL_INITIALIZED
					];
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch(notification.getName()){
				case MainApplicationConstants.APP_MODEL_INITIALIZED:

					break;
			}
		}
				
	}
}