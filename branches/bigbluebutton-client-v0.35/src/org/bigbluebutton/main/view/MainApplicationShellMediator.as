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
package org.bigbluebutton.main.view 
{
	import flexlib.mdi.containers.MDIWindow;
	
	import org.bigbluebutton.common.Constants;
	import org.bigbluebutton.common.IBbbModuleWindow;
	import org.bigbluebutton.main.MainApplicationConstants;
	import org.bigbluebutton.main.view.components.MainApplicationShell;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
/**
*   This is the Mediator class for MainApplicationShell view compom\nent
*/	
	public class MainApplicationShellMediator extends Mediator
	{
		public static const NAME:String = 'MainApplicationShellMediator';
		public static const OPEN_CHAT_MODULE:String = 'openChatModule';
		public static const OPEN_LOG_MODULE:String = 'openLogModule';
		public static const LOGOUT:String = "Logout";
		public static const START_WEBCAM:String = "Start Webcam";

		private var mshell:MainApplicationShell;
			
		public function MainApplicationShellMediator( viewComponent:MainApplicationShell )
		{
			super( NAME, viewComponent );
			trace("red5:" + Constants.red5Host);
			trace("present:" + Constants.presentationHost);
			trace("url:" + Constants.TEST_URL);		
		}
							
		protected function get shell():MainApplicationShell
		{
			return viewComponent as MainApplicationShell;
		}
		
		override public function listNotificationInterests():Array{
			return [
					MainApplicationConstants.MODULES_START,
					MainApplicationConstants.MODULE_STARTED,
					MainApplicationConstants.ADD_WINDOW_MSG,
					MainApplicationConstants.REMOVE_WINDOW_MSG
					];
		}
		
		override public function handleNotification(notification:INotification):void{
			switch(notification.getName()){
				case MainApplicationConstants.MODULES_START:
					trace('Received MODULES_START xxxx');
					//sendNotification(MainApplicationConstants.MODULE_START, "ChatModule");
					//sendNotification(MainApplicationConstants.MODULE_START, "ViewersModule");
					sendNotification(MainApplicationConstants.MODULE_START, "PresentationModule");
					break;
				case MainApplicationConstants.MODULE_STARTED:
					trace('Received MODULE_STARTED for ' + notification.getBody() as String);
					//sendNotification(MainApplicationConstants.OPEN_WINDOW, "ChatModule");
					break;		
				case MainApplicationConstants.ADD_WINDOW_MSG:
					var win:IBbbModuleWindow = notification.getBody() as IBbbModuleWindow;
					trace("putting window in " + win.xPosition + " " + win.yPosition);
					shell.mdiCanvas.windowManager.add(win as MDIWindow);
					shell.mdiCanvas.windowManager.absPos(win as MDIWindow, win.xPosition, win.yPosition);						
					break;			
				case MainApplicationConstants.REMOVE_WINDOW_MSG:
					var rwin:IBbbModuleWindow = notification.getBody() as IBbbModuleWindow;
					trace("removing window " + (rwin as MDIWindow).name);
					shell.mdiCanvas.windowManager.remove(rwin as MDIWindow);						
					break;
			}
		}
	}
}