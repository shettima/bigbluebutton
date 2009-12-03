package org.bigbluebutton.webconference.red5.voice;

import org.red5.server.api.so.ISharedObject;

class SharedObjectInfo {

	private final String webRoom;
	private final String voiceRoom;
	private final ISharedObject sharedObject;
	
	SharedObjectInfo(String webRoom, String voiceRoom, ISharedObject sharedObject) {
		this.webRoom = webRoom;
		this.voiceRoom = voiceRoom;
		this.sharedObject = sharedObject;
	}

	public String getWebRoom() {
		return webRoom;
	}

	public String getVoiceRoom() {
		return voiceRoom;
	}

	public ISharedObject getSharedObject() {
		return sharedObject;
	}
}
