/**
* BigBlueButton open source conferencing system - http://www.bigbluebutton.org/
*
* Copyright (c) 2008 by respective authors (see below).
*
* This program is free software; you can redistribute it and/or modify it under the
* terms of the GNU Lesser General Public License as published by the Free Software
* Foundation; either version 2.1 of the License, or (at your option) any later
* version.
*
* This program is distributed in the hope that it will be useful, but WITHOUT ANY
* WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A
* PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.
*
* You should have received a copy of the GNU Lesser General Public License along
* with this program; if not, write to the Free Software Foundation, Inc.,
* 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
* 
*/
package org.bigbluebutton.modules.listeners.model.service
{
	import flash.events.AsyncErrorEvent;
	import flash.events.NetStatusEvent;
	import flash.net.NetConnection;
	import flash.net.Responder;
	import flash.net.SharedObject;
	
	import org.bigbluebutton.modules.listeners.ListenersModuleConstants;
	import org.bigbluebutton.modules.listeners.model.vo.IListeners;
	import org.bigbluebutton.modules.listeners.model.vo.Listener;

	public class ListenersSOService implements IListenersService
	{
		public static const NAME:String = "ListenersSOService";
		private static const LOGNAME:String = "[ListenersSOService]";
		
		private var _listenersSO : SharedObject;
		private static const SHARED_OBJECT:String = "meetMeUsersSO";
		
		private var _listeners:IListeners;
		private var netConnectionDelegate: NetConnectionDelegate;
		private var _msgListener:Function;
		private var _connectionListener:Function;
		private var _uri:String;
		private var _messageSender:Function;
		private var nc_responder : Responder;
		private var _soErrors:Array;
		private var pingCount:int = 0;
		private var _module:ListenersModule;
							
		public function ListenersSOService(listeners:IListeners, module:ListenersModule)
		{			
			_listeners = listeners;		
			_module = module;				
		}
		
		public function connect(uri:String):void {
			_uri = uri;
			join();
		}
		
		public function disconnect():void {
			leave();
		}
		
		private function connectionListener(connected:Boolean, errors:Array=null):void {
			if (connected) {
				LogUtil.debug(LOGNAME + ":Connected to the VOice application");
				join();
			} else {
				leave();
				LogUtil.debug(LOGNAME + ":Disconnected from the Voice application");
				notifyConnectionStatusListener(false, errors);
			}
		}
		
	    private function join() : void
		{
			trace("ListenertsSOService " + _module.uri);
			_listenersSO = SharedObject.getRemote(SHARED_OBJECT, _module.uri, false);
			_listenersSO.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
			_listenersSO.addEventListener(AsyncErrorEvent.ASYNC_ERROR, asyncErrorHandler);
			_listenersSO.client = this;
			_listenersSO.connect(_module.connection);
			LogUtil.debug(LOGNAME + ":Voice is connected to Shared object");
			notifyConnectionStatusListener(true);		
				
			// Query the server if there are already listeners in the conference.
			getCurrentUsers();
		}
		
	    private function leave():void
	    {
	    	if (_listenersSO != null) {
	    		_listenersSO.close();
	    	}
	    	notifyConnectionStatusListener(false);
	    }

		public function addConnectionStatusListener(connectionListener:Function):void {
			_connectionListener = connectionListener;
		}

		public function addMessageSender(msgSender:Function):void {
			_messageSender = msgSender;
		}
				
		public function userJoin(userId:Number, cidName:String, cidNum:String, 
									muted:Boolean, talking:Boolean, locked:Boolean):void
		{
			if (! _listeners.hasListener(userId)) {
				var n:Listener = new Listener();
				n.callerName = (cidName != null) ? cidName : "<Unknown Caller>";
				n.callerNumber = cidNum;
				n.muted = muted;
				n.userid = userId;
				n.talking = talking;
				n.locked = locked;
				n.moderator = _module.isModerator();
				
				LogUtil.info(LOGNAME + "Adding listener [" + n.callerName + "," + userId + "]");
				_listeners.addListener(n);
				/**
				 * Let's send an event that the first user has joined the voice conference.
				 * We use this as a trigger to playback the recorded audio.
				 * NOTE: THis is just a hack...need to do this properly. (ralam - march 26, 2009)
				 */
				if (_module.mode == 'PLAYBACK') {
					if (_listeners.listeners.length == 1) {
						sendMessage(ListenersModuleConstants.FIRST_LISTENER_JOINED_EVENT);
					}
				}				
			} else {
				LogUtil.debug(LOGNAME + "There is a listener with userid " + userId + " " + cidName + " in the conference.");
			}
		}

		public function userMute(userId:Number, mute:Boolean):void
		{
			var l:Listener = _listeners.getListener(userId);			
			if (l != null) {
				l.muted = mute;
//				LogUtil.debug(LOGNAME + 'Un/Muting user ' + userId + " mute=" + mute);
			}					
		}

		public function userLockedMute(userId:Number, locked:Boolean):void
		{
			var l:Listener = _listeners.getListener(userId);			
			if (l != null) {
				l.locked = locked;
				LogUtil.debug(LOGNAME + 'Lock Un/Muting user ' + userId + " locked=" + locked);
			}					
		}
		
		public function userTalk(userId:Number, talk:Boolean) : void
		{
			var l:Listener = _listeners.getListener(userId);			
			if (l != null) {
				l.talking = talk;
			}	
		}

		public function userLeft(userId:Number):void
		{
			_listeners.removeListener(userId);	
		}
		
		public function ping(message:String):void {
			if (pingCount < 100) {
				pingCount++;
			} else {
				var date:Date = new Date();
				var t:String = date.toLocaleTimeString();
				LogUtil.debug(LOGNAME + "[" + t + '] - Received ping from server: ' + message);
				pingCount = 0;
			}
		}
		
		public function lockMuteUser(userid:Number, lock:Boolean):void
		{
			var nc:NetConnection = _module.connection;
			nc.call(
				"voice.lockMuteUser",// Remote function name
				new Responder(
	        		// participants - On successful result
					function(result:Object):void { 
						LogUtil.debug("Successfully lock mute/unmute: " + userid); 	
					},	
					// status - On error occurred
					function(status:Object):void { 
						LogUtil.error("Error occurred:"); 
						for (var x:Object in status) { 
							LogUtil.error(x + " : " + status[x]); 
							} 
					}
				),//new Responder
				userid,
				lock
			); //_netConnection.call		
		}
		
		public function muteUnmuteUser(userid:Number, mute:Boolean):void
		{
			var nc:NetConnection = _module.connection;
			nc.call(
				"voice.muteUnmuteUser",// Remote function name
				new Responder(
	        		// participants - On successful result
					function(result:Object):void { 
						LogUtil.debug("Successfully mute/unmute: " + userid); 	
					},	
					// status - On error occurred
					function(status:Object):void { 
						LogUtil.error("Error occurred:"); 
						for (var x:Object in status) { 
							LogUtil.error(x + " : " + status[x]); 
							} 
					}
				),//new Responder
				userid,
				mute
			); //_netConnection.call		
		}

		public function muteAllUsers(mute:Boolean):void
		{	
			var nc:NetConnection = _module.connection;
			nc.call(
				"voice.muteAllUsers",// Remote function name
				new Responder(
	        		// participants - On successful result
					function(result:Object):void { 
						LogUtil.debug("Successfully mute/unmute all users: "); 	
					},	
					// status - On error occurred
					function(status:Object):void { 
						LogUtil.error("Error occurred:"); 
						for (var x:Object in status) { 
							LogUtil.error(x + " : " + status[x]); 
							} 
					}
				),//new Responder
				mute
			); //_netConnection.call		
		}
		
		public function ejectUser(userId:Number):void
		{
			var nc:NetConnection = _module.connection;
			nc.call(
				"voice.kickUSer",// Remote function name
				new Responder(
	        		// participants - On successful result
					function(result:Object):void { 
						LogUtil.debug("Successfully kick user: userId"); 	
					},	
					// status - On error occurred
					function(status:Object):void { 
						LogUtil.error("Error occurred:"); 
						for (var x:Object in status) { 
							LogUtil.error(x + " : " + status[x]); 
							} 
					}
				),//new Responder
				userId
			); //_netConnection.call		
		}
		
		private function getCurrentUsers():void {
			var nc:NetConnection = _module.connection;
			nc.call(
				"voice.getMeetMeUsers",// Remote function name
				new Responder(
	        		// participants - On successful result
					function(result:Object):void { 
						LogUtil.debug("Successfully queried participants: " + result.count); 
						if (result.count > 0) {
							for(var p:Object in result.participants) 
							{
								var u:Object = result.participants[p]
								userJoin(u.participant, u.name, u.name, u.muted, u.talking, u.locked);
							}							
						}	
					},	
					// status - On error occurred
					function(status:Object):void { 
						LogUtil.error("Error occurred:"); 
						for (var x:Object in status) { 
							LogUtil.error(x + " : " + status[x]); 
							} 
					}
				)//new Responder
			); //_netConnection.call
		}
		
		private function notifyConnectionStatusListener(connected:Boolean, errors:Array=null):void {
			if (_connectionListener != null) {
				LogUtil.debug(LOGNAME + 'notifying connectionListener for Voice');
				_connectionListener(connected, errors);
			} else {
				LogUtil.debug(LOGNAME + "_connectionListener is null");
			}
		}

		private function sendMessage(msg:String, body:Object=null):void {
			if (_messageSender != null) _messageSender(msg, body);
		}
		
		private function netStatusHandler (event:NetStatusEvent):void
		{
			var statusCode:String = event.info.code;
			
			switch (statusCode) 
			{
				case "NetConnection.Connect.Success":
					LogUtil.debug(LOGNAME + ":Connection Success");			
					break;
			
				case "NetConnection.Connect.Failed":	
					LogUtil.error(LOGNAME + "ChatSO connection failed.");		
					addError("ChatSO connection failed");
					break;
					
				case "NetConnection.Connect.Closed":			
					LogUtil.error(LOGNAME + "Connection to VoiceSO was closed.");						
					addError("Connection to VoiceSO was closed.");									
					notifyConnectionStatusListener(false, _soErrors);
					break;
					
				case "NetConnection.Connect.InvalidApp":	
					LogUtil.error(LOGNAME + "VoiceSO not found in server");			
					addError("VoiceSO not found in server");	
					break;
					
				case "NetConnection.Connect.AppShutDown":
					LogUtil.error(LOGNAME + "VoiceSO is shutting down");	
					addError("VoiceSO is shutting down");
					break;
					
				case "NetConnection.Connect.Rejected":
					LogUtil.error(LOGNAME + "No permissions to connect to the voiceSO");
					addError("No permissions to connect to the voiceSO");
					break;
					
				default:
				   LogUtil.debug(NAME + ":default - " + event.info.code );
				   break;
			}
		}
			
		private function asyncErrorHandler (event:AsyncErrorEvent):void
		{
			LogUtil.error(LOGNAME + "ListenersSO asynchronous error.");
			addError("ListenersSO asynchronous error.");
		}

		private function addError(error:String):void {
			if (_soErrors == null) {
				_soErrors = new Array();
			}
			_soErrors.push(error);
		}
	}
}