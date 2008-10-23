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
package org.bigbluebutton.modules.chat
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import org.bigbluebutton.common.IBigBlueButtonModule;
	import org.bigbluebutton.common.messaging.InputPipe;
	import org.bigbluebutton.common.messaging.OutputPipe;
	import org.bigbluebutton.common.messaging.Router;
	import org.bigbluebutton.main.MainApplicationConstants;
	import org.bigbluebutton.modules.chat.model.business.ChatProxy;
	import org.bigbluebutton.modules.chat.model.business.PlaybackProxy;
	import org.bigbluebutton.modules.chat.model.vo.MessageVO;
	import org.bigbluebutton.modules.chat.view.components.ChatWindow;
	import org.puremvc.as3.multicore.interfaces.IMediator;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	import org.puremvc.as3.multicore.utilities.pipes.interfaces.IPipeMessage;
	import org.puremvc.as3.multicore.utilities.pipes.messages.Message;
	import org.puremvc.as3.multicore.utilities.pipes.plumbing.PipeListener;
	
	/**
	 * This class is a mediator for the ChatModule viewComponent
	 * 
	 * 
	 */	
	public class ChatModuleMediator extends Mediator implements IMediator
	{
		public static const NAME:String = 'ChatModuleMediator';

		private var _outpipe : OutputPipe;
		private var _inpipe : InputPipe;
		private var _router : Router;
		private var _inpipeListener : PipeListener;
		private var _module:IBigBlueButtonModule;
		
		private static const TO_CHAT_MODULE:String = "TO_CHAT_MODULE";
		private static const FROM_CHAT_MODULE:String = "FROM_CHAT_MODULE";
		
		private static const PLAYBACK_MESSAGE:String = "PLAYBACK_MESSAGE";
		private static const PLAYBACK_MODE:String = "PLAYBACK_MODE";
		
		/**
		 * Constructor
		 * It sets the required initialization for the router and piping 
		 * @param viewComponent
		 * 
		 */		
		public function ChatModuleMediator( module:IBigBlueButtonModule )
		{
			super( NAME, module );	
			_module = module;
			_router = module.router;
			trace("initializing input pipes for chat module...");
			_inpipe = new InputPipe(TO_CHAT_MODULE);
			trace("initializing output pipes for chat module...");
			_outpipe = new OutputPipe(FROM_CHAT_MODULE);
			trace("initializing pipe listener for chat module...");
			_inpipeListener = new PipeListener(this, messageReceiver);
			_inpipe.connect(_inpipeListener);
			_router.registerOutputPipe(_outpipe.name, _outpipe);
			_router.registerInputPipe(_inpipe.name, _inpipe);	
		}
		
		/**
		 * handler for incoming messages 
		 * @param message
		 * 
		 */		
		private function messageReceiver(message : IPipeMessage) : void
		{
			var msg : String = message.getHeader().MSG as String;
			switch(msg){
				case PLAYBACK_MODE:
					//var proxy:ChatProxy = facade.retrieveProxy(ChatProxy.NAME) as ChatProxy;
					//proxy = new PlaybackProxy(new MessageVO());
					//Alert.show("playbackproxy registered");
//					facade.removeProxy(ChatProxy.NAME);
//					facade.registerProxy(new PlaybackProxy());
					break;
				case PLAYBACK_MESSAGE:
					playMessage(message.getBody() as XML);					
					break;
			}
		}
		
		private function playMessage(message:XML):void{

		}
	}
}