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
package org.bigbluebutton.modules.chat.model.business
{
	import flash.events.AsyncErrorEvent;
	import flash.events.NetStatusEvent;
	import flash.net.SharedObject;
	
	import org.bigbluebutton.modules.chat.ChatModuleConstants;

	public class ChatSOService implements IChatService
	{
		public static const NAME:String = "ChatSOService";
		
		private var chatSO : SharedObject;
		private var netConnectionDelegate: NetConnectionDelegate;
		private var _uri:String;
		private var _msgListener:Function;
		
		public function ChatSOService(uri:String)
		{			
			_uri = uri;
			netConnectionDelegate = new NetConnectionDelegate(uri, connectionListener);			
		}
		
		public function connect(uri:String):void {
			_uri = uri
			netConnectionDelegate.connect();
		}
		
		public function disconnect():void {
			leave();
			netConnectionDelegate.disconnect();
		}
		
		private function connectionListener(connected:Boolean):void {
			if (connected) {
				trace(NAME + ":Connected to the Chat server");
				join();
			} else {
				leave();
				trace(NAME + ":Disconnected from the Chat server");
			}
		}
		
	    private function join() : void
		{
			chatSO = SharedObject.getRemote("chatSO", _uri, false);
			chatSO.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
			chatSO.addEventListener(AsyncErrorEvent.ASYNC_ERROR, asyncErrorHandler);
			chatSO.client = this;
			chatSO.connect(netConnectionDelegate.connection);
			trace(NAME + ":Chat is connected to Shared object");			
		}
		
	    private function leave():void
	    {
	    	if (chatSO != null) chatSO.close();
	    }

		public function addMessageListener(messageListener:Function):void {
			_msgListener = messageListener;
		}
		
		public function sendMessage(message:String):void
		{
			chatSO.send("receiveNewMessage", message);
		}
			
		public function receiveNewMessage(message:String):void{
			_msgListener( message);		   
		}

		/**
		 * Method is called when a new NetStatusEvent is received 
		 * @param event
		 * 
		 */		
		private function netStatusHandler ( event : NetStatusEvent ) : void
		{
			var statusCode : String = event.info.code;
			
			switch ( statusCode ) 
			{
				case "NetConnection.Connect.Success" :
					trace(NAME + ":Connection Success");					
					break;
			
				case "NetConnection.Connect.Failed" :			
					trace(NAME + ":Connection to chat server failed");
					break;
					
				case "NetConnection.Connect.Closed" :									
					trace(NAME + ":Connection to chat server closed");
					break;
					
				case "NetConnection.Connect.InvalidApp" :				
					trace(NAME + ":Chat application not found on server");
					break;
					
				case "NetConnection.Connect.AppShutDown" :
					trace(NAME + ":Chat application has been shutdown");
					break;
					
				case "NetConnection.Connect.Rejected" :
					trace(NAME + ":No permissions to connect to the chat application" );
					break;
					
				default :
				   trace(NAME + ":default - " + event.info.code );
				   break;
			}
		}
			
		private function asyncErrorHandler ( event : AsyncErrorEvent ) : void
		{
			trace( "ChatSO asyncErrorHandler " + event.error);
		}
	}
}