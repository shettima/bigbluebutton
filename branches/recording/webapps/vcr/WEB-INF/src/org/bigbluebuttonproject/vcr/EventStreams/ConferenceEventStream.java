/**
 * 
 */
package org.bigbluebuttonproject.vcr.EventStreams;

import java.util.Map;
import java.util.HashMap;
import java.util.List;

import org.bigbluebuttonproject.vcr.EvenstVCR.*;
import org.red5.server.api.so.IClientSharedObject;
import org.red5.server.api.so.ISharedObjectBase;
import org.red5.server.net.rtmp.RTMPConnection;
import org.red5.server.net.rtmp.codec.RTMP;
/**
 * @author nnoori
 *
 */
public class ConferenceEventStream extends EventStream {

	protected IClientSharedObject participantsSO;

	public ConferenceEventStream(String host, String room) {
		super(host, room);
		System.out.println(" constructor Conference call");
		init();
	}
   
	public String getApplication() {
		System.out.println(" get app Conference call");
		return "conference";
	}
	
	public void init() {
			
		Map<String, Object> tparams = new HashMap<String, Object>();
		tparams.put("password", "modpass");
		tparams.put("username", "vcr");
		Object[] obj = new Object[] { tparams };
	
	}

	public void connectionOpened(RTMPConnection conn, RTMP state) {
		super.connectionOpened(conn, state);
		participantsSO = subscribeSharedObject(conn, "participantsSO");
		if (participantsSO == null) {
			System.out.println("Could not connect to shared object particiantsSO");
		}else System.out.println("Could connect to shared object particiantsSO");
	}

	public void onSharedObjectSend(ISharedObjectBase so, String method, List params) {
			
		if (method.equals("join")) {
			out.println("<status time=\"" + getTimestamp() + 
					"\" user Join=\"" + params.get(1) +
					"\" Host=\"" + params.get(0) +
					"\" Password=\"" + params.get(2) +
					"\" room=\"" + params.get(3) +
					"\"/>");
			out.flush();
		}
		
		
	}
	
	public void onSharedObjectUpdate(ISharedObjectBase so, String key, Object value) {
		
		//if (debug) {
			System.out.println("Update on shared object (conference): " + key + "{" + value + "}");
		//}
	}

}
