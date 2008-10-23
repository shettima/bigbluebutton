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
package org.bigbluebutton.common
{
	import flexlib.mdi.containers.MDIWindow;
	
	import mx.controls.Button;
	import mx.modules.Module;
	
	import org.bigbluebutton.common.messaging.Router;

	public interface IBigBlueButtonModule
	{
		function getXPosition():Number;	
		function getYPosition():Number;	
		function getMDIComponent():MDIWindow;	
		function logout():void;	
		function acceptRouter(router:Router):void;		
		function get router():Router;		
		function set router(router:Router):void;
		function hasButton():Boolean;
		function getID():String;			
		function getDisplayName():String;			
		function getStartTime():String;
		function start():void;
		function stop():void;
	}
}