/**
 * 
 */
package org.bigbluebuttonproject.vcr;

import java.util.Date;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileOutputStream;
import java.io.FileWriter;
import java.io.IOException;
import java.io.PrintWriter;
import java.io.OutputStream;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
  
import org.bigbluebuttonproject.vcr.EvenstVCR.*;
import org.bigbluebuttonproject.vcr.EventStreams.*;
import org.mortbay.log.Log;
import org.red5.server.api.so.IClientSharedObject;
import org.bigbluebuttonproject.vcr.*;

/**
 * @author nnoori
 *
 */
@SuppressWarnings("unused")

public class VCR {

	boolean debugMode = true;
	//Change it to present.carleton.ca
	//private String host = "present.carleton.ca";
	private String host = "134.117.58.103";
	//This needs to be changes later, it will be passed from the client 
	private String room = "85115";
	//this later should include at least the class name and the date
	private String file = "lecture.xml";
	
	protected String root = "C:\\tools\\tomcat-5.5.26\\webapps\\VCRFILES\\Session_";
	
	protected String urlIndex = "http://134.117.58.103:8080/VCRFILES/index.html";
	
	//protected String rootSlides; 
	protected String rootSession;
	
	protected EventWriter out;
	
	public static Logger log = LoggerFactory.getLogger( Application.class );
		
	public static void main(String[] args) {
		
		VCR vcr = new VCR(args);
		vcr.startRecording();
		
		System.out.println("Press 's' to stop recording");
		char a = Keyboard.getCharacter();
		if (a == 's'){
			String str = vcr.stopRecording();
			System.out.println("Session was stored @:  "+ str);
			System.exit(0);			
		}
		
	}
	
	public VCR(String[] args) {
		getArgs(args);
	}
		
	public void getArgs(String[] args) {
		if (args.length >= 3) {
			host = args[0];
			room = args[0];
			file = args[2];
		}
		//args[0]= host;
		//args[1]= room;
		//args[2]= file;
		//System.out.println("Host: "+args[0] + "Room: "+ args[1]+ "File: "+ args[2]);
						
	}
	
	
	public String getTimestampFormat() {
		
		//System.out.println("recording has been started");
		DateFormat dateFormat = new SimpleDateFormat("yyyy_MM_dd HH_mm_ss");
        Date date = new Date();
        return dateFormat.format(date);
		
	}
	public long getTimestamp(){
		return System.currentTimeMillis();
	}
		@SuppressWarnings("static-access")
		public void startRecording() {
			
			log.info("recording has been started");
			rootSession = root.concat(room + "_" + getTimestampFormat()+"\\");
			new File(rootSession).mkdir();
						
			try {
				file = rootSession.concat(file);
				//System.out.println("++++ File Name +++++"+ file + "++++++");
				log.info("++++ File Name +++++"+ file + "++++++");
				out = new EventWriter(new FileOutputStream(file));
				out.println("<lecture host=\"" + host + "\" room=\"" + room + 
						"\" start=\"" + getTimestamp() + "\">");
				out.println("<par>");
				//Either at the begining of the code or at the end 
				//i.e add it to the finalize funcion :)
				//out.println("<audio src="audio-1215122005.mp3"/>");
				out.println("<seq>");
				out.flush();
				
				ChatEventStream.debug = true;
				PresentationEventStream.debug = true;
				MeetMeEventStream.debug = true;
				ConferenceEventStream.debug = true;
				
				EventStream chat = new ChatEventStream(host, room);
				chat.setWriter(out);
				
				EventStream presentation = new PresentationEventStream(host, room, rootSession);
				presentation.setWriter(out);
				
				//EventStream meetme = new MeetMeEventStream("134.117.254.226", room);
				//meetme.setWriter(out);
	  			
				EventStream conference = new ConferenceEventStream(host, room);
				conference.connect(host, 1935, conference.getApplication());
				conference.setWriter(out);
				
				out.flush();
			} catch (Exception e) {
				System.err.println("Something went wrong: " + e);
			}	
			out.flush();
	}
		
		
	public String stopRecording() {
		//add the URL for the destination for the lecture location on server
		//add the audio file URL at the end of the session and TimeStamp for
		//the end of the session
		out.println("</seq>");
		out.println("</par>");
		out.println("</lecture>");
		out.flush();
		finalize(rootSession);
		//System.out.println("recording has been stopped: Session locatin"+ rootSession);
		//log.info("recording has been stopped: Session locatin"+ rootSession);
		return urlIndex;
	}
	
	public void finalize(String sessionPath) {
		// TODO: this is not the appropriate place to do this
		//Add the session location on the server to the index.html 
		// at the http://SERVER/VCRFILES/
		File file = new File("C:\\tools\\tomcat-5.5.26\\webapps\\VCRFILES\\index.html");
	     	try {
	      		if (! file.exists())
	      			if (file.createNewFile()) {
	      				System.out.println("index file was crated");
	      				// File did not exist and was created
	      			}else {
	     				System.out.println("index file already exist");
	      			}
	      		
	      		BufferedWriter outIndex = new BufferedWriter(new FileWriter("C:\\tools\\tomcat-5.5.26\\webapps\\VCRFILES\\index.html", true));
	            outIndex.write("<p><br>"+sessionPath+"<p>");
	            outIndex.close();
	            
	     	} catch (IOException e) {
	  			System.out.println("IO exception in the finalize function");
	  			}
    		}
	
	public String getRoom(){
		return room;
	}
	
}

