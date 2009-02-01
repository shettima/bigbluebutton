package org.bigbluebutton.modules.viewers.model
{
	import mx.collections.ArrayCollection;
	
	import org.bigbluebutton.modules.viewers.ViewersModuleConstants;
	import org.bigbluebutton.modules.viewers.model.business.Conference;
	import org.bigbluebutton.modules.viewers.model.business.IViewers;
	import org.bigbluebutton.modules.viewers.model.services.IViewersService;
	import org.bigbluebutton.modules.viewers.model.services.ViewersSOService;
	import org.bigbluebutton.modules.viewers.model.vo.Status;
	import org.bigbluebutton.modules.viewers.model.vo.User;
	import org.puremvc.as3.multicore.interfaces.IProxy;
	import org.puremvc.as3.multicore.patterns.proxy.Proxy;

	public class ViewersProxy extends Proxy implements IProxy
	{
		public static const NAME:String = "ViewersProxy";

		private var _uri:String;		
		private var _viewersService:IViewersService;
		private var _participants:IViewers = null;
		
		private var isPresenter:Boolean = false;
				
		public function ViewersProxy(uri:String)
		{
			super(NAME);
			_uri = uri;
		}
		
		override public function getProxyName():String
		{
			return NAME;
		}
		
		public function connect(username:String, role:String):void {
			_participants = new Conference();
			_viewersService = new ViewersSOService(_uri, _participants);
			_viewersService.addConnectionStatusListener(connectionStatusListener);
			_viewersService.addMessageSender(messageSender);
			LogUtil.debug(NAME + '::' + username + "," + role);
			_viewersService.connect(_uri, username, role);		
		}
		
		public function stop():void {
			_viewersService.disconnect();
		}
		
		public function get me():User {
			return _participants.me;
		}
		
		public function isModerator():Boolean {
			if (me.role == "MODERATOR") {
				return true;
			}
			
			return false;
		}
		
		public function get participants():ArrayCollection {
			return _participants.users;
		}
		
		public function assignPresenter(assignTo:Number):void {
			_viewersService.assignPresenter(assignTo, me.userid);
		}
		
		public function addStream(userid:Number, streamName:String):void {
			_viewersService.addStream(userid, streamName);
		}
		
		public function removeStream(userid:Number, streamName:String):void {
			_viewersService.removeStream(userid, streamName);
		}
		
		public function queryPresenter():void {
			_viewersService.queryPresenter();
		}
		
		private function connectionStatusListener(connected:Boolean, reason:String = null):void {
			if (connected) {
				sendNotification(ViewersModuleConstants.LOGGED_IN);
			} else {
				_participants = null;
				if (reason == null) reason = ViewersModuleConstants.UNKNOWN_REASON;
				sendNotification(ViewersModuleConstants.LOGGED_OUT, reason);
			}
		}
		
		private function messageSender(msg:String, body:Object=null):void {
			switch (msg) {
				case ViewersModuleConstants.ASSIGN_PRESENTER:
					if (me.userid == body.assignedTo) {
						// I've been assigned as presenter.
						LogUtil.debug('I have become presenter');
						isPresenter = true;
						var newStatus:Status = new Status("presenter", body.assignedBy);
						_viewersService.iAmPresenter(me.userid, true);
						var presenterInfo:Object = {presenterId:body.assignedTo, presenterName:me.name, assignedBy:body.assignedBy}
						sendNotification(msg, presenterInfo);
					} else {
						// Somebody else has become presenter.
						if (isPresenter) {
							LogUtil.debug('Somebody else has become presenter.');
							_viewersService.iAmPresenter(me.userid, false);
						}
						isPresenter = false;
						sendNotification(ViewersModuleConstants.BECOME_VIEWER, body);					
					}
					break;
				default:
					sendNotification(msg, body);
			} 
		}		
	}
}