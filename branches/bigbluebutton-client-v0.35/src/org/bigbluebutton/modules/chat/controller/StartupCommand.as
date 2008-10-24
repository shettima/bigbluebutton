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
package org.bigbluebutton.modules.chat.controller
{
	import org.bigbluebutton.common.IBigBlueButtonModule;
	import org.bigbluebutton.modules.chat.ChatEndpointMediator;
	import org.bigbluebutton.modules.chat.ChatModuleMediator;
	import org.bigbluebutton.modules.chat.model.business.ChatProxy;
	import org.bigbluebutton.modules.chat.view.ChatWindowMediator;
	import org.bigbluebutton.modules.chat.view.components.ChatWindow;
	import org.puremvc.as3.multicore.interfaces.ICommand;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;

	public class StartupCommand extends SimpleCommand implements ICommand
	{	
		override public function execute(notification:INotification):void {
			var m:IBigBlueButtonModule = notification.getBody() as IBigBlueButtonModule;
			
			facade.registerMediator(new ChatModuleMediator(m));
			facade.registerMediator(new ChatEndpointMediator(m));
			var win:ChatWindow = new ChatWindow();
			win.username = m.username;
			facade.registerMediator( new ChatWindowMediator(new ChatWindow()) );
			facade.registerProxy(new ChatProxy(m.uri));
		}
	}
}