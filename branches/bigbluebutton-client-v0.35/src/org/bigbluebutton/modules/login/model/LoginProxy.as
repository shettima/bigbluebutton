package org.bigbluebutton.modules.login.model
{
	import org.puremvc.as3.multicore.interfaces.IProxy;
	import org.puremvc.as3.multicore.patterns.proxy.Proxy;

	public class LoginProxy extends Proxy implements IProxy
	{
		public static const NAME:String = 'LoginProxy';
		public static const LOGIN_SUCCESS:String = 'loginSuccess';
		public static const LOGIN_FAILED:String = 'loginFailed';
		public static const LOGGED_OUT:String = 'loggedOut';
		
		public function LoginProxy(proxyName:String=null, data:Object=null)
		{
			//TODO: implement function
			super(proxyName, data);
		}
		
		public function getProxyName():String
		{
			//TODO: implement function
			return null;
		}
		
		public function setData(data:Object):void
		{
			//TODO: implement function
		}
		
		public function getData():Object
		{
			//TODO: implement function
			return null;
		}
		
		public function onRegister():void
		{
			//TODO: implement function
		}
		
		public function sendNotification(notificationName:String, body:Object=null, type:String=null):void
		{
			//TODO: implement function
		}
		
		public function onRemove():void
		{
			//TODO: implement function
		}
		
		public function initializeNotifier(key:String):void
		{
			//TODO: implement function
		}
		
	}
}