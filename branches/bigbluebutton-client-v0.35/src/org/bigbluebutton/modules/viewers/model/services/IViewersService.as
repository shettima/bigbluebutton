package org.bigbluebutton.modules.viewers.model.services
{
	public interface IViewersService
	{
		function connect(uri:String, username:String, password:String, room:String):void;
		function disconnect():void;
		function addConnectionStatusListener(connectionListener:Function):void;	
		function sendNewStatus(userid:Number, newStatus:String):void;
		function sendBroadcastStream(userid:Number, hasStream:Boolean, streamName:String):void;
		 	
	}
}