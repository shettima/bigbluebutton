package org.bigbluebutton.modules.presentation.model.services
{
	import flash.events.*;
	
	import mx.rpc.IResponder;
	import mx.rpc.http.HTTPService;
	
	import org.bigbluebutton.modules.presentation.model.business.IPresentationSlides;
	        	
	/**
	 * This class directly communicates with an HTTP service in order to send and recives files (slides
	 * in this case)
	 * <p>
	 * This class extends the Proxy class of the pureMVC framework
	 * @author dev_team@bigbluebutton.org
	 * 
	 */	        	
	public class PresentationService implements IResponder
	{  
		private var service : HTTPService;
		private var _slides:IPresentationSlides;
		
		public function PresentationService()
		{
			service = new HTTPService();
		}
		
		/**
		 * Load slides from an HTTP service. Response is received in the Responder class' onResult method 
		 * @param url
		 * 
		 */		
		public function load(url:String, slides:IPresentationSlides) : void
		{
			_slides = slides;
			service.url = url;			
			var call : Object = service.send();
			call.addResponder(this);
			
		}

		/**
		 * This is the response event. It is called when the PresentationService class sends a request to
		 * the server. This class then responds with this event 
		 * @param event
		 * 
		 */		
		public function result(event : Object):void
		{
			trace("Got result [" + event.result.toString() + "]");

		}

		/**
		 * Event is called in case the call the to server wasn't successful. This method then gets called
		 * instead of the result() method above 
		 * @param event
		 * 
		 */
		public function fault(event : Object):void
		{
			trace("Got fault [" + event.fault.toString() + "]");		
		}		
	}
}