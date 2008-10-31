package org.bigbluebutton.modules.viewers.model
{
	import mx.collections.ArrayCollection;
	
	import org.bigbluebutton.modules.viewers.ViewersModuleConstants;
	import org.bigbluebutton.modules.viewers.model.business.Conference;
	import org.bigbluebutton.modules.viewers.model.business.IViewers;
	import org.bigbluebutton.modules.viewers.model.services.IViewersService;
	import org.bigbluebutton.modules.viewers.model.services.ViewersSOService;
	import org.bigbluebutton.modules.viewers.model.vo.User;
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
		
		public function connect(uri:String, room:String, username:String, password:String ):void {
			_uri = uri
			_participants.me.name = username;	
			_viewersService.connect(_uri, room, username, password);		
		}
		
		public function get me():User {
			return _participants.me;
		}
		
		public function get participants():ArrayCollection {
			return _participants.users;
		}
		
		private function connectionStatusListener(connected:Boolean):void {
			if (connected) {
				sendNotification(ViewersModuleConstants.LOGGED_IN);
			} else {
				sendNotification(ViewersModuleConstants.LOGGED_OUT);
			}
		}		
	}
}