
package org.bigbluebuttonproject.vcr;

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


/**
 * @author nnoori
 *
 */

import org.red5.server.adapter.ApplicationAdapter;
import org.red5.server.api.IClient;
import org.red5.server.api.IConnection;
import org.red5.server.api.IScope;
import org.red5.server.api.service.IPendingServiceCall;
import org.red5.server.api.service.IPendingServiceCallback;
import org.red5.server.api.service.IServiceCapableConnection;
import org.red5.server.api.so.ISharedObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import java.util.Set; 
import org.bigbluebuttonproject.vcr.*;
import java.io.File;
   
/** 
 * This is the base class of chat server application. It overwrites the methods of ApplicationAdapter class.
 * [See ApplicationAdapter description in Conference Application section.]
 * 
 * Chat server uses SharedObjectListener to listen to the chat messages passed between clients using ChatSO SharedObject. It stores all the chat history.
 * When a new client join the group chat, server send the chat history to the client.
 */
public class Application extends ApplicationAdapter 
				implements IPendingServiceCallback
{
 
	/** Logger log is used for logging vcr messages in log file. */
	public static Logger log = LoggerFactory.getLogger( Application.class );

	/** The debug mode. */
	boolean debugMode = true;
	
	protected  VCR testvcr;
	//Create the VCR directory to store the sessions
	//the present server path for sessions storage
	//private String VCRPath = new String("/usr/local/tomcat-5.5.20/webapps/vcrfiles");
	private String VCRPath = new String("C:\\tools\\tomcat-5.5.26\\webapps\\vcrfiles");
	
		 
	  /** 
  	 * This method is called once on scope start. overrides MultiThreadedApplicationAdapter.appStart(IScope).
  	 * Since this is the Application start handler method, all the initialization tasks that the server application needs, have to go here.
  	 * 
  	 * @param app the Application scope
  	 * 
  	 * @return true if Application can be started, or else false
  	 * 
  	 * @see org.red5.server.adapter.MultiThreadedApplicationAdapter#appStart(org.red5.server.api.IScope)
  	 */
	  public boolean appStart (IScope app)
	  {
		  if (!super.appStart(app))
	    		return false;
		  
		  boolean success = new File(VCRPath).mkdir();
		  
		  if (!success){
			  log.info("VCRPath wasn't created!!!");
		  }else log.info("VCRPath already exist!!!");
		  log.info("VCR::appStart" + app.getName().toString()+"room"+app.toString());
		  log.info("VCR::appPath" + app.getPath().toString());
		  		  		  
		  return true;
	  }
	  
	  /**
  	 * This method is automatically called when chat Server application is stopped.
  	 * The tasks that are needed to be done before exiting the server, have to go here.
  	 */
	  public void appStop ()
	  {
		  log.info("VCR::appStop");
	  }
	  
  	/**
  	 * Called once on room scope start (when first client connects to the scope). overrides MultiThreadedApplicationAdapter.roomStart(IScope).
  	 * 
  	 * @param room the Room scope
  	 * 
  	 * @return true 
  	 * 
  	 * @see org.red5.server.adapter.MultiThreadedApplicationAdapter#roomStart(org.red5.server.api.IScope)
  	 */
	  public boolean roomStart(IScope room) {
				  
		if (!super.roomStart(room))
    		return false;
		log.info("VCR::roomStart: "+ room.toString());
		return true;            
	  }
	  
  	/**
  	 * This method is called every time client leaves room scope. Developer can add tasks here that are needed to be executed when a client disconnects from the server.
  	 * 
  	 * @param client chat client
  	 * @param room room scope
  	 * 
  	 * @see org.red5.server.adapter.MultiThreadedApplicationAdapter#roomLeave(org.red5.server.api.IClient, org.red5.server.api.IScope)
  	 */
	  
	  public void roomLeave(IClient client, IScope room) {
		  log.info("VCR::roomLeave: "+ room.toString());	  		  		  
	  }

	  	  
  	/**
  	 * Called every time client joins room scope.
  	 * 
  	 * @param client chat client
  	 * @param room Room scope
  	 * 
  	 * @return true, if room join
  	 */ 
	  public boolean roomJoin(IClient client, IScope room) {
	     	
		  log.info("VCR::roomJoin: "+ room.toString());
		  return true;
	  } 
	  
  	/**
  	 * This method is called every time new client connects to the application. NetConnection.connect() call from client side, call this function in server side.
  	 * It also takes parameters from the client. This method is a powerful handler method which allows developers to add tasks here that needs to be done every time a new client connects to the server.
  	 * In this method, server invokes setChatLog() method remotely to send chat history to the new client
  	 * 
  	 * @param conn the connection between server and client
  	 * @param params parameter array passed from client
  	 * 
  	 * @return true
  	 */
	  public boolean roomConnect(IConnection conn, Object[] params) {
		
		  log.info("VCR::roomConnect:"+ conn.getScope().toString());
		return true;
	  }
	    
    	/**
    	 * Called when the result comes from remote method invokation.
    	 * 
    	 * @param call IPendingServiceCall
    	 */
	 
	  public void resultReceived(IPendingServiceCall call) {
			log.info("Received result " + call.getResult() + " for "
					+ call.getServiceMethodName());		
		}
	  public void VCRStart (String host, String room)
	  {
		
	    testvcr = new VCR(host,room);
		testvcr.startRecording();
		log.info("VCR::VCR Start");
	  }	  
	
	  public String VCRStop()
	  {	
		String str = testvcr.stopRecording();
		log.info("VCR::VCR Stop");
		return str;
	  }
	  
}