package org.bigbluebutton.modules.viewers.model
{
	import org.bigbluebutton.modules.viewers.ViewersModuleConstants;
	import org.bigbluebutton.modules.viewers.model.business.Conference;
	import org.bigbluebutton.modules.viewers.model.business.IViewers;
	import org.bigbluebutton.modules.viewers.model.services.IViewersService;
	import org.bigbluebutton.modules.viewers.model.services.ViewersSOService;
	import org.puremvc.as3.multicore.interfaces.IProxy;
	import org.puremvc.as3.multicore.patterns.proxy.Proxy;

	public class ViewersProxy extends Proxy implements IProxy
	{
		public static const NAME:String = "ViewersProxy";

		private var _uri:String;		
		private var _viewersService:IViewersService;
		private var _participants:IViewers = new Conference();
				
		public function ViewersProxy(uri:String)
		{
			super(NAME);
			_uri = uri;
			_viewersService = new ViewersSOService(_uri, _participants);
			_viewersService.addConnectionStatusListener(connectionStatusListener);
		}
		
		override public function getProxyName():String
		{
			return NAME;
		}
		
		public function connect(uri:String, username:String, password:String, room:String):void {
			_uri = uri
			_participants.me.name = username;	
			_viewersService.connect(_uri, room, username, password);		
		}
		
		private function connectionStatusListener(connected:Boolean):void {
			if (connected) {
				sendNotification(ViewersModuleConstants.CONNECTED);
			} else {
				sendNotification(ViewersModuleConstants.DISCONNECTED);
			}
		}		
	}
}