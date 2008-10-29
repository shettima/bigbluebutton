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
					MainApplicationConstants.APP_STARTED,
					MainApplicationConstants.APP_MODEL_INITIALIZED,
					MainApplicationConstants.MODULES_LOADED,
					MainApplicationConstants.MODULES_START,
					MainApplicationConstants.MODULE_STARTED
					];
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch(notification.getName()){
				case MainApplicationConstants.APP_STARTED:
					trace("Received APP_STARTED");
					facade.sendNotification(MainApplicationConstants.APP_MODEL_INITIALIZE);
					break;
				case MainApplicationConstants.APP_MODEL_INITIALIZED:
					trace("Received APP_MODEL_INITIALIZED");
					facade.sendNotification(MainApplicationConstants.MODULES_LOAD);
					break;
				case MainApplicationConstants.MODULES_LOADED:
					trace("Received MODULES_LOADED");
					facade.sendNotification(MainApplicationConstants.MODULES_START);
					break;
				case MainApplicationConstants.MODULES_START:
					trace('Received MODULES_START');
					//sendNotification(MainApplicationConstants.MODULE_START, "ChatModule");
					//sendNotification(MainApplicationConstants.MODULE_START, "ViewersModule");
					sendNotification(MainApplicationConstants.MODULE_START, "PresentationModule");
					break;
				case MainApplicationConstants.MODULE_STARTED:
					trace('Received MODULE_STARTED for ' + notification.getBody() as String);
					//sendNotification(MainApplicationConstants.OPEN_WINDOW, "ChatModule");
					break;	
			}
		}				
	}
}