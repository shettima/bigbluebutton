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
package org.bigbluebutton.modules.presentation
{
	import flash.system.Capabilities;
	
	import flexlib.mdi.containers.MDIWindow;
	
	import org.bigbluebutton.common.BigBlueButtonModule;
	import org.bigbluebutton.common.Constants;
	import org.bigbluebutton.common.IRouterAware;
	import org.bigbluebutton.common.Router;
	import org.bigbluebutton.main.view.components.MainApplicationShell;
	import org.bigbluebutton.modules.presentation.model.PresentationApplication;
	import org.bigbluebutton.modules.presentation.view.FileUploadWindowMediator;
	import org.bigbluebutton.modules.viewers.ViewersFacade;
	import org.bigbluebutton.modules.viewers.model.business.Conference;
	
	/**
	 * The main class of the Presentation Module
	 * <p>
	 * This class extends the ModuleBase of the Flex Framework 
	 * @author Denis Zgonjanin
	 * 
	 */	
	public class PresentationModule extends BigBlueButtonModule implements IRouterAware
	{
		public static const NAME:String = "Presentation Module";
		
		public static const DEFAULT_RED5_URL:String = "rtmp://" + Constants.red5Host;
		public static const DEFAULT_PRES_URL:String = "http://" + Constants.presentationHost;
		
		private var facade:PresentationFacade;
		public var activeWindow:MDIWindow;
		
		/**
		 * Creates a new Presentation Module 
		 * 
		 */		
		public function PresentationModule()
		{
			super(NAME);
			facade = PresentationFacade.getInstance();
			this.preferedX = 250;
			this.preferedY = 20;
			this.startTime = BigBlueButtonModule.START_ON_LOGIN;
		}
		
		/**
		 * Accepts a piping router object through which messages can be sent through different modules 
		 * @param router - the router being passed in
		 * @param shell - the main application shell of the bigbluebutton project
		 * 
		 */		
		override public function acceptRouter(router:Router, shell:MainApplicationShell):void{
			super.acceptRouter(router, shell);
			facade.startup(this);
			var conf:Conference = ViewersFacade.getInstance().retrieveMediator(Conference.NAME) as Conference;
			facade.setPresentationApp(conf.me.userid, conf.room, DEFAULT_RED5_URL, DEFAULT_PRES_URL);
			facade.presApp.join();
		}
		
		override public function getMDIComponent():MDIWindow{
			return activeWindow;
		}
		
		override public function logout():void{
			var presentation:PresentationApplication = 
				facade.retrieveMediator(PresentationApplication.NAME) as PresentationApplication;
			presentation.leave();
			
			var uploadMediator:FileUploadWindowMediator = 
				facade.retrieveMediator(FileUploadWindowMediator.NAME) as FileUploadWindowMediator;
			if (uploadMediator != null){
				uploadMediator.removeWindow();
			}
			
			facade.removeCore(PresentationFacade.ID);
		}

	}
}