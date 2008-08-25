/**
 * 
 */
package org.bigbluebuttonproject.vcr.EventStreams;

import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.red5.server.api.so.IClientSharedObject;
import org.red5.server.api.so.ISharedObjectBase;
import org.red5.server.net.rtmp.RTMPConnection;
import org.red5.server.net.rtmp.codec.RTMP;

import org.bigbluebuttonproject.vcr.EvenstVCR.*;

 
 
/**
 * @author nnoori
 *v  
 */  


@SuppressWarnings("unused")
public class ChatEventStream extends EventStream {

protected IClientSharedObject chatSO;
	
	public ChatEventStream(String host, String room) {
		super(host,room);
		}

	public String getApplication() {
		return "chatServer";
	}
	
	public void connectionOpened(RTMPConnection conn, RTMP state) {
		super.connectionOpened(conn, state);
		chatSO = subscribeSharedObject(conn, "chatSO");
		if (chatSO == null){
			System.out.println("connectionOpened could not subscribe chatSO");
		}else System.out.println("connectionOpened could  subscribe chatSO");
		
	}
	 
	@SuppressWarnings("unchecked")
	public void onSharedObjectSend(ISharedObjectBase so, String method, List params) {
				
		if (method.equals("receiveNewMessage")) {
			
			out.println("<chat time=\"" + getTimestamp() + 
				"\" user=\"" + params.get(0) +"\" color= \"" + params.get(2)+
				"\">" + params.get(1) + "</chat>");
			out.flush();
			/*Pattern p = Pattern.compile("\\[(.+)\\]</b> (.+)</font>");
			Matcher m = p.matcher((String) params.get(0));
			if (m.find()) {
				String name = m.group(1);
				String message = m.group(2);
				out.println("<chat second  time=\"" + getTimestamp() + 
						"\" user=\"" + name + "\">" + message + "</chat>");
				out.flush();
				*/
			}
		}
	}
