/* BigBlueButton - http://www.bigbluebutton.org
 * 
 * 
 * Copyright (c) 2008-2009 by respective authors (see below). All rights reserved.
 * 
 * BigBlueButton is free software; you can redistribute it and/or modify it under the 
 * terms of the GNU Lesser General Public License as published by the Free Software 
 * Foundation; either version 3 of the License, or (at your option) any later 
 * version. 
 * 
 * BigBlueButton is distributed in the hope that it will be useful, but WITHOUT ANY 
 * WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A 
 * PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.
 * 
 * You should have received a copy of the GNU Lesser General Public License along 
 * with BigBlueButton; if not, If not, see <http://www.gnu.org/licenses/>.
 *
 * $Id: $
 */
package org.bigbluebutton.web.controllers

import java.text.MessageFormat;
import org.bigbluebutton.web.domain.ScheduledSession
import org.bigbluebutton.web.domain.Conference
import grails.converters.*
import org.codehaus.groovy.grails.commons.*
import org.bigbluebutton.web.services.DynamicConferenceService;
import org.bigbluebutton.web.services.SchedulingService
import org.bigbluebutton.api.domain.DynamicConference;

class PublicScheduledSessionController {
	DynamicConferenceService dynamicConferenceService;
	def schedulingService

	def DIAL_NUM = /%%DIALNUM%%/
	def CONF_NUM = /%%CONFNUM%%/
	def CONF_NAME = /%%CONFNAME%%/
	
	def keywordList = [DIAL_NUM, CONF_NUM, CONF_NAME];
	
	def beforeInterceptor = {
		if (schedulingService.schedulingServiceEnabled) {
			return true
		}

		response.sendError 403
		return false
	}

	def index = {
	    redirect(action:joinIn)
	}
	
	def show = {
		def tokenId = session['conference']
		def sessionId = session['room']
		
		if (!tokenId || !sessionId) {
			redirect(action:joinIn,id:tokenId)
		}
		
		def scheduledSessionInstance = ScheduledSession.findByTokenId( tokenId )

		if(!scheduledSessionInstance) {
			flash.message = "Could not find conference session."
	        redirect(action:joinIn)
	    }
	    else { 
	    	def config = ConfigurationHolder.config
        	def hostURL = config.bigbluebutton.web.serverURL
        	println "serverURL $hostURL"
	       	def now = new Date().time	       	
	       	def inSession = ((now > scheduledSessionInstance.startDateTime.time) && (now < scheduledSessionInstance.endDateTime.time))
	       	return [ scheduledSessionInstance : scheduledSessionInstance, hostUrl:hostURL, inSession:inSession ] 
	    }
	}
	
	def joinIn = {
	    session.invalidate()
	    def sessionInfo
	    
	    if (params.id) {
	    	def conference = Conference.findByConferenceNumber(params.id)
	    	if (conference) {
	    		def c = ScheduledSession.createCriteria()
				def now = new Date()
				def results = c {
					eq('voiceConferenceBridge', conference.conferenceNumber.toString())
					and {
						le('startDateTime', now)
						and {
							gt('endDateTime', now)
						}
					}
					maxResults(1)
				}	    		
				if (results) {
					def confSession = results[0];
					sessionInfo = [name: confSession.name, description: confSession.description]
				}
	    	}
	    }
       
       	return [ fullname: params.fullname, id:(params.id), password: params.password, info:sessionInfo ]

	}
	
    def signIn = { 
		if (params.fullname.trim() == "") {
			log.debug "USer entered a blank name"
			flash.message = "Please enter your name."
			render(view:"joinIn", model: [id:params.id, fullname:params.fullname])
			return
		} else {
			log.debug "Fullname is not null ${params.fullname}"
		}
			
		log.debug "Attempting to sign in to ${params.id}"	
		def conference = Conference.findByConferenceNumber(params.id)
		def signedIn = false
		if (conference) {
			def c = ScheduledSession.createCriteria()
			def now = new Date()
			def results = c {
				eq('voiceConferenceBridge', conference.conferenceNumber.toString())
				and {
					le('startDateTime', now)
					and {
						gt('endDateTime', now)
					}
				}
				maxResults(1)
			}

			if (results) {
				def confSession = results[0];
				def role = ''
											
				if (confSession) {
					log.debug "Found conference session ${confSession.name}"
					switch (params.password) {
						case confSession.hostPassword:
							log.debug "Logged in as host"
							// Let us set role to MODERATOR for now as we don't support HOST yet
							role = "MODERATOR"
							signedIn = true
							break
						case confSession.moderatorPassword:
							log.debug "Logged in as as moderator"
							role = "MODERATOR"
							signedIn = true
							break
						case confSession.attendeePassword:
							log.debug "Logged in as viewer"
							role = "VIEWER"
							signedIn = true
							break
					}
					if (signedIn) {						
						log.debug "Login successful...setting in session information"

						def welcomeMessage = dynamicConferenceService.defaultWelcomeMessage
						def dialNumber = dynamicConferenceService.defaultDialAccessNumber
								
						if (welcomeMessage != null || welcomeMessage != "") {
							log.debug "Substituting keywords"
							
							keywordList.each{ keyword ->
								switch(keyword){
									case DIAL_NUM:
										if ((dialNumber != null) || (dialNumber != "")) {
											welcomeMessage = welcomeMessage.replaceAll(DIAL_NUM, dialNumber)
										}
										break
									case CONF_NUM:
										welcomeMessage = welcomeMessage.replaceAll(CONF_NUM, confSession.voiceConferenceBridge)
										break
									case CONF_NAME:
										welcomeMessage = welcomeMessage.replaceAll(CONF_NAME, confSession.getName())
										break
								}			  
							}
						}
						
			   			session["fullname"] = params.fullname 
						session["role"] = role
						session["conference"] = confSession.tokenId
						session["room"] = confSession.sessionId
						session["voicebridge"] = confSession.voiceConferenceBridge
						session["conferencename"] = confSession.getName()
						session['welcome'] = welcomeMessage
				
						def long _10_MINUTES = 10*60*1000
					
						def startTime = confSession.startDateTime.time - _10_MINUTES
						def endTime = confSession.endDateTime.time + _10_MINUTES
							
						if ((startTime <= now.time) && (now.time <= endTime)) {
							session["mode"] = "LIVE"
							session["record"] = false
							if (confSession.record) {
								session["record"] = true
							}
							log.debug "Joining LIVE and recording is ${confSession.record}"
						} else {
							session["mode"] = "PLAYBACK"
							log.debug "Joining PLAYBACK"
						}
						    	
					    log.debug "Displaying session information"
					    //redirect(action:show)		
				    	def config = ConfigurationHolder.config
			        	def hostUrl = config.bigbluebutton.web.serverURL
			        	redirect(url:"${hostUrl}/client/BigBlueButton.html")
					}
				}					
			}	
		}
		
		if (!signedIn) {
			flash.message = "Could not log you into the conference. Please check if your conference number or schedule is correct."
			render(view:"joinIn",model: [id:params.id, fullname:params.fullname])
		}	
	}

	def enter = {
	    def fname = session["fullname"]
	    def rl = session["role"]
	    def cnf = session["conference"]
	    def rm = session["room"]
		def vb = session["voicebridge"]   
	    def rec = session["record"]
	    def md = session["mode"]
	    def confName = session["conferencename"]
	    def welcomeMsg = session['welcome']
	    def meetID = session["meetingID"] 
        def externUID = session["externUserID"] 
        
	    if (!rm) {
	    	response.addHeader("Cache-Control", "no-cache")
	    	withFormat {				
				xml {
					render(contentType:"text/xml") {
						'join'() {
							returncode("FAILED")
							message("Could not find conference ${params.conference}.")
						}
					}
				}
			}
	    } else {	
	    	response.addHeader("Cache-Control", "no-cache")
	    	withFormat {				
				xml {
					render(contentType:"text/xml") {
						'join'() {
							returncode("SUCCESS")
							fullname("$fname")
							confname("$confName")
							meetingID("$meetID")
							externUserID("$externUID")
	        				role("$rl")
	        				conference("$cnf")
	        				room("$rm")
	        				voicebridge("${vb}")
	        				mode("$md")
	        				record("$rec")
	        				welcome("$welcomeMsg")
						}
					}
				}
			}
	    }    
	}

	def signOut = {
	    def config = ConfigurationHolder.config
        def hostURL = config.bigbluebutton.web.logoutURL
        
        log.debug("LogoutURL=$hostURL")
        
        // For backward compatibility. We renamed "loggedOutUrl" to
        // "logoutURL" in 0.64 to be consistent with the API. Remove this
        // in later iterations (ralam mar 26, 2010)
        //if ((hostURL == null) || (hostURL == "")) {
        if (hostURL.isEmpty()) {
            log.debug("No logoutURL property set. Checking for old loggedOutUrl.")
            hostURL = config.bigbluebutton.web.loggedOutUrl
            if (!hostURL.isEmpty()) 
               log.debug("Old loggedOutUrl property set to $hostURL") 
        }
        
	    def meetingToken = session["conference"]
        DynamicConference conf = dynamicConferenceService.getConferenceByToken(meetingToken)
        if (conf != null) {
        	if ((conf.logoutUrl != null) && (conf.logoutUrl != "")) {
        	   hostURL = conf.logoutUrl
        	   log.debug("logoutURL has been set from API. Redirecting to server url $hostURL.")
    		}
        }
	    	    
        if (hostURL.isEmpty()) {           
        	hostURL = config.bigbluebutton.web.serverURL
        	log.debug("No logout url. Redirecting to server url $hostURL.")
        }
        // Log the user out of the application.
	    session.invalidate()
        println "serverURL $hostURL"	
	    redirect(url: hostURL)
	}
}
