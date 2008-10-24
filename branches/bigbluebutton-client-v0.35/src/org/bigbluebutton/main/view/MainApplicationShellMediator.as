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
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.controls.Button;
	
	import org.bigbluebutton.common.BigBlueButtonModule;
	import org.bigbluebutton.common.Constants;
	import org.bigbluebutton.common.messaging.InputPipe;
	import org.bigbluebutton.common.messaging.OutputPipe;
	import org.bigbluebutton.common.messaging.Router;
	import org.bigbluebutton.main.MainApplicationConstants;
	import org.bigbluebutton.main.MainApplicationFacade;
	import org.bigbluebutton.main.model.ModulesProxy;
	import org.bigbluebutton.main.view.components.MainApplicationShell;
	import org.bigbluebutton.modules.log.LogModule;
	import org.bigbluebutton.modules.video.VideoModule;
	import org.bigbluebutton.modules.viewers.ViewersConstants;
	import org.bigbluebutton.modules.viewers.ViewersFacade;
	import org.bigbluebutton.modules.viewers.ViewersModule;
	import org.bigbluebutton.modules.viewers.model.services.SharedObjectConferenceDelegate;
	import org.bigbluebutton.modules.viewers.model.vo.User;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	import org.puremvc.as3.multicore.utilities.pipes.interfaces.IPipeMessage;
	import org.puremvc.as3.multicore.utilities.pipes.plumbing.PipeListener;
	
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
					MainApplicationFacade.ADD_MODULE,
					MainApplicationFacade.MODULES_STARTED
					];
		}
		
		override public function handleNotification(notification:INotification):void{
			switch(notification.getName()){
				case MainApplicationFacade.ADD_MODULE:
					break;
				case MainApplicationConstants.MODULES_START:
					trace('Received MODULES_START');
					//var p:ModulesProxy = facade.retrieveProxy(ModulesProxy.NAME) as ModulesProxy;
					//p.startModule('ViewersModule', router);
					sendNotification(MainApplicationConstants.MODULE_START, "ChatModule");
					break;
			}
		}
	}
}