package org.red5.server.webapp.sip;


import java.util.Map;
import java.util.HashMap;

import java.io.IOException;
import java.io.PipedInputStream;
import java.io.PipedOutputStream;
import java.io.File;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.apache.mina.common.ByteBuffer;
import org.red5.io.ITag;
import org.red5.io.ITagReader;
import org.red5.io.ITagWriter;
import org.red5.io.flv.IFLV;
import org.red5.io.flv.meta.IMetaData;
import org.red5.io.flv.meta.IMetaService;
import org.red5.server.api.cache.ICacheStore;
import org.red5.server.api.cache.ICacheable;

import org.red5.server.api.service.IServiceCapableConnection;
import org.red5.server.api.IConnection;

import local.ua.*;
import org.zoolu.sip.address.*;
import org.zoolu.sip.provider.*;
import org.zoolu.net.SocketAddress;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;


public class SIPUser implements SIPUserAgentListener, SIPRegisterAgentListener {

    protected static Logger log = LoggerFactory.getLogger(SIPUser.class);

	public boolean sipReady = false;
	private IConnection service;
    private long lastCheck;
    private String sessionID;
	private String configFile;
	private SIPUserAgentProfile user_profile;
	private SipProvider sip_provider;

	private boolean opt_regist=false;
	private boolean opt_unregist=false;
	private boolean opt_unregist_all=false;
	private int     opt_expires=-1;
	private long    opt_keepalive_time=-1;
	private boolean opt_no_offer=false;
	private String  opt_call_to=null;
	private int     opt_accept_time=-1;
	private int     opt_hangup_time=-1;
	private String  opt_redirect_to=null;
	private String  opt_transfer_to=null;
	private int     opt_transfer_time=-1;
	private int     opt_re_invite_time=-1;
	private boolean opt_audio=false;
	private boolean opt_video=false;
	private int     opt_media_port=0;
	private boolean opt_recv_only=false;
	private boolean opt_send_only=false;
	private boolean opt_send_tone=false;
	private String  opt_send_file=null;
	private String  opt_recv_file=null;
	private boolean opt_no_prompt=false;

	private String 	opt_from_url=null;
	private String 	opt_contact_url=null;
	private String 	opt_username=null;
	private String 	opt_realm=null;
	private String 	opt_passwd=null;

	private int 	opt_debug_level=-1;
	private String 	opt_outbound_proxy=null;
	private String 	opt_via_addr=SipProvider.AUTO_CONFIGURATION;
	private int 	opt_host_port=SipStack.default_port;

	private PipedOutputStream rtmpOutputStream;
	private PipedInputStream sipInputStream;

	private SIPUserAgent ua;
	private SIPRegisterAgent ra;
	private RTMPUser rtmpUser;
	private PipedOutputStream publishStream;
	private String username;
	private String password;
	private String publishName;
	private String playName;
	private int sipPort;
	private int rtpPort;
	private String proxy;

	public SIPUser(String sessionID, IConnection service, int sipPort, int rtpPort) throws IOException {
		p("SIPUser Constructor: sip port " + sipPort + " rtp port:" + rtpPort);

		try {

			String appPath = System.getProperty("user.dir");
			//appPath = appPath.substring(0, (appPath.length() - 8));   // removing /wrapper sub folder from path

			configFile = appPath + "/webapps/sip/WEB-INF/sip.cfg";

			this.sessionID = sessionID;
			this.service = service;
			this.sipPort = sipPort;
			this.rtpPort = rtpPort;

			sipInputStream = new PipedInputStream();
			rtmpOutputStream = new PipedOutputStream(sipInputStream);

		}  catch (Exception e) {
			p("SIPUser constructor: Exception:>\n" + e);

		}
	}


	public boolean isRunning() {

		boolean resp = false;

		try {
			resp = ua.audio_app.sender.isRunning() && ua.audio_app.receiver.isRunning();

		}  catch (Exception e) {
			resp = false;
		}

		return resp;
	}


	public void login(String username, String password, String realm, String proxy) {
		p("SIPUser login");

		this.username = username;
		this.password = password;
		this.proxy = proxy;

		String fromURL = "\"" + username + "\" <sip:" + username + "@" + proxy + ">";

		try {
			rtmpUser = new RTMPUser();
			SipStack.init(configFile);
			sip_provider = new SipProvider(null, sipPort);
			user_profile = new SIPUserAgentProfile(configFile);

			user_profile.audio_port = rtpPort;
			user_profile.username = username;
			user_profile.passwd = password;
			user_profile.realm = realm;
			user_profile.from_url = fromURL;

			ua = new SIPUserAgent(sip_provider,user_profile,this, sipInputStream, rtmpUser);

			sipReady = false;
			ua.listen();


		} catch(Exception e) {
			p("login: Exception:>\n" + e);
		}
	}



	public void register() {
		p("SIPUser register");

		try {

			if (sip_provider != null) {
				ra = new SIPRegisterAgent(sip_provider, user_profile.from_url, user_profile.contact_url, username, user_profile.realm, password,this);
				loopRegister(user_profile.expires, user_profile.expires/2, user_profile.keepalive_time);
			}

		} catch(Exception e) {
			p("register: Exception:>\n" + e);
		}
	}


	public void dtmf(String digits) {
		p("SIPUser dtmf " + digits);

		try {

			if (ua != null && ua.audio_app != null && ua.audio_app.sender != null)
				ua.audio_app.sender.queueSipDtmfDigits(digits);

		} catch(Exception e) {
			p("dtmf: Exception:>\n" + e);
		}
	}


	public void call(String destination) {
		p("SIPUser Calling " + destination);

		try {

			sipInputStream = new PipedInputStream();
			rtmpOutputStream = new PipedOutputStream(sipInputStream);

			publishName = "microphone_" + System.currentTimeMillis();
			playName = "speaker_" + System.currentTimeMillis();

			rtmpUser.startStream("localhost", "sip", 1935, publishName, playName, rtmpOutputStream);

			sipReady = false;
			ua.setMedia(sipInputStream, rtmpUser);
			ua.hangup();

			if (destination.indexOf("@") == -1) {
				destination = destination + "@" + proxy;
			}

			if (destination.indexOf("sip:") > -1) {
				destination = destination.substring(4);
			}

			ua.call(destination);


		} catch(Exception e) {
			p("call: Exception:>\n" + e);
		}
	}

	public void close() {
		p("SIPUser close");

		try {
			hangup();
			unregister();
			sip_provider.halt();

		} catch(Exception e) {
			p("close: Exception:>\n" + e);
		}

	}


	public void accept() {
		p("SIPUser accept");

		if (ua != null){


			try {
				sipInputStream = new PipedInputStream();
				rtmpOutputStream = new PipedOutputStream(sipInputStream);

				publishName = "microphone_" + System.currentTimeMillis();
				playName = "speaker_"+ System.currentTimeMillis();

				rtmpUser.startStream("localhost", "sip", 1935, publishName, playName, rtmpOutputStream);

				sipReady = false;
				ua.setMedia(sipInputStream, rtmpUser);
				ua.accept();

			} catch(Exception e) {
				p("SIPUser: accept - Exception:>\n" + e);
			}
		}
	}

	public void hangup() {
		p("SIPUser hangup");

		if (ua != null){

			if (ua.call_state!=SIPUserAgent.UA_IDLE)
			{
				ua.hangup();
				ua.listen();
			}
		}

		closeStreams();
		rtmpUser.stopStream();
	}


	public void streamStatus(String status) {
		p("SIPUser streamStatus " + status);

		if ("stop".equals(status)) {
			//ua.listen();
		}
	}


	private void unregister() {
		p("SIPUser unregister");

		if (ra != null)  {
			if (ra.isRegistering()) ra.halt();
			ra.unregister();
			ra = null;
		}

		if (ua != null) ua.hangup();
		ua = null;
	}

	private void closeStreams() {
		p("SIPUser closeStreams");

		try {
			rtmpOutputStream.close();
			sipInputStream.close();

		} catch(Exception e) {
			p("closeStreams: Exception:>\n" + e);
		}
	}


    public long getLastCheck()
    {
        return lastCheck;
    }

    public boolean isClosed()
    {
        return ua == null;
    }

    public String getSessionID()
    {
        return sessionID;
    }


	private void loopRegister(int expire_time, int renew_time, long keepalive_time)
	{  	if (ra.isRegistering()) ra.halt();
		ra.loopRegister(expire_time,renew_time,keepalive_time);
	}


	public void onUaCallIncoming(SIPUserAgent ua, NameAddress callee, NameAddress caller)
	{
		String source = caller.getAddress().toString();
		String sourceName = caller.hasDisplayName() ? caller.getDisplayName() : "";
		String destination = callee.getAddress().toString();
		String destinationName = callee.hasDisplayName() ? callee.getDisplayName() : "";

		if (service != null) {
			((IServiceCapableConnection) service).invoke("incoming", new Object[] {source, sourceName, destination, destinationName});
		}
	}

	public void onUaCallRinging(SIPUserAgent ua)  {

		if (service != null) {
			((IServiceCapableConnection) service).invoke("callState", new Object[] {"onUaCallRinging"});
		}
	}

	public void onUaCallAccepted(SIPUserAgent ua)
	{
		if (service != null) {
			((IServiceCapableConnection) service).invoke("callState", new Object[] {"onUaCallAccepted"});
		}

	}

	public void onUaCallConnected(SIPUserAgent ua)
	{
		p("SIP Call Connected");
		sipReady = true;

		if (service != null) {
			((IServiceCapableConnection) service).invoke("connected", new Object[] {playName, publishName});
		}

	}

	public void onUaCallTrasferred(SIPUserAgent ua)
	{
	}

	public void onUaCallCancelled(SIPUserAgent ua)
	{
		sipReady = false;
		closeStreams();

		if (service != null) {
			((IServiceCapableConnection) service).invoke("callState", new Object[] {"onUaCallCancelled"});
		}

		ua.listen();
	}

	public void onUaCallFailed(SIPUserAgent ua)
	{
		sipReady = false;
		closeStreams();

		if (service != null) {
			((IServiceCapableConnection) service).invoke("callState", new Object[] {"onUaCallFailed"});
		}

		ua.listen();
	}

	public void onUaCallClosed(SIPUserAgent ua)
	{
		sipReady = false;
		closeStreams();

		if (service != null) {
			((IServiceCapableConnection) service).invoke("callState", new Object[] {"onUaCallClosed"});
		}

		ua.listen();
	}

	public void onUaRegistrationSuccess(SIPRegisterAgent ra, NameAddress target, NameAddress contact, String result)
	{
		p("SIP Registration success " + result);

		if (service != null) {
			((IServiceCapableConnection) service).invoke("registrationSucess", new Object[] {result});
		}
	}

	public void onUaRegistrationFailure(SIPRegisterAgent ra, NameAddress target, NameAddress contact, String result)
	{
		p("SIP Registration failure " + result);

		if (service != null) {
			((IServiceCapableConnection) service).invoke("registrationFailure", new Object[] {result});
		}
	}


	private void p(String s) {
		log.debug(s);

	}
}