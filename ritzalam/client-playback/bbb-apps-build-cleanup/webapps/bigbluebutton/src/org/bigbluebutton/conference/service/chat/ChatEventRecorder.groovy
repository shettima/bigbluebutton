
package org.bigbluebutton.conference.service.chat

import java.util.Map
import org.bigbluebutton.conference.service.archive.record.IEventRecorder
import org.bigbluebutton.conference.service.archive.record.IRecorder
import org.bigbluebutton.conference.service.chat.IChatRoomListenerimport org.red5.server.api.so.ISharedObject
import org.bigbluebutton.conference.Participant
import org.slf4j.Logger
import org.slf4j.LoggerFactory
import org.red5.logging.Red5LoggerFactory
import groovy.xml.MarkupBuilder

public class ChatEventRecorder implements IEventRecorder, IChatRoomListener {
	private static Logger log = Red5LoggerFactory.getLogger( ChatEventRecorder.class, "bigbluebutton" )
	
	IRecorder recorder
	private ISharedObject so
	private final Boolean record
	
	def name = 'CHAT'
	
	def acceptRecorder(IRecorder recorder){
		log.debug("Accepting IRecorder")
		this.recorder = recorder
	}
	
	def getName() {
		return name
	}
	
	def recordEvent(Map event){
		if (record) {
			recorder.recordEvent(event)
		}		
	}
	
	public ChatEventRecorder(ISharedObject so, Boolean record) {
		this.so = so 
		this.record = record
	}
	
	def newChatMessage(msg) {
		log.debug("New chat message...")
		so.sendMessage("newChatMessage", [msg])
		
		recordYamlEvent(msg)
	}
	
	private def recordXmlEvent(msg) {
		def writer = new StringWriter()
		def xml = new MarkupBuilder(writer)
		xml.event(name:'newChatMessage', date:new Date().time, application:name) {
			message(msg)
		}
		recorder.recordXmlEvent(writer.toString())
	}
	
	private def recordYamlEvent(msg) {
		Map event = new HashMap()
		event.put("date", new Date().time)
		event.put("application", name)
		event.put("event", "newChatMessage")
		event.put("message", msg)
		recordEvent(event)		
	}

}
