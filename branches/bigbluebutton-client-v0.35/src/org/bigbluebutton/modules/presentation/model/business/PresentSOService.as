package org.bigbluebutton.modules.chat.model.business
{
	import flash.events.AsyncErrorEvent;
	import flash.events.NetStatusEvent;
	import flash.events.SyncEvent;
	import flash.net.SharedObject;
	
	import org.bigbluebutton.modules.presentation.model.business.IPresentationSlides;
	
	public class PresentSOService implements IPresentService
	{
		public static const NAME:String = "PresentSOService";

		private static const SHAREDOBJECT : String = "presentationSO";
		private static const PRESENTER : String = "presenter";
		private static const SHARING : String = "sharing";
		private static const UPDATE_MESSAGE : String = "updateMessage";
		private static const CURRENT_PAGE : String = "currentPage";
		
		private static const UPDATE_RC : String = "UPDATE";
		private static const SUCCESS_RC : String = "SUCCESS";
		private static const FAILED_RC : String = "FAILED";
		private static const EXTRACT_RC : String = "EXTRACT";
		private static const CONVERT_RC : String = "CONVERT";
		
		private var _presentationSO : SharedObject;
		private var netConnectionDelegate: NetConnectionDelegate;
		
		private var _slides:IPresentationSlides;
		private var _uri:String;
		private var _connectionListener:Function;
		
		public function PresentSOService(uri:String, slides:IPresentationSlides)
		{			
			_uri = uri;
			_slides = slides;
			netConnectionDelegate = new NetConnectionDelegate(uri, connectionListener);			
		}
		
		public function connect():void {
			netConnectionDelegate.connect(_uri);
		}
			
		public function disconnect():void {
			leave();
			netConnectionDelegate.disconnect();
		}
		
		private function connectionListener(connected:Boolean):void {
			if (connected) {
				join();
			} else {
				leave();
			}
		}
		
	    private function join() : void
		{
			_presentationSO = SharedObject.getRemote(SHAREDOBJECT, _uri, false);			
			_presentationSO.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
			_presentationSO.addEventListener(AsyncErrorEvent.ASYNC_ERROR, asyncErrorHandler);
			_presentationSO.addEventListener(SyncEvent.SYNC, sharedObjectSyncHandler);			
			_presentationSO.client = this;
			_presentationSO.connect(netConnectionDelegate.connection);
			trace(NAME + ": PresentationModule is connected to Shared object");
			notifyConnectionStatusListener(true);			
		}
		
	    private function leave():void
	    {
	    	if (_presentationSO != null) _presentationSO.close();
	    }

		public function addConnectionStatusListener(connectionListener:Function):void {
			_connectionListener = connectionListener;
		}
		
		/**
		 * Send an event to the server to update the clients with a new slide zoom ratio
		 * @param slideHeight
		 * @param slideWidth
		 * 
		 */		
		public function zoom(slideHeight:Number, slideWidth:Number):void{
			presentationSO.send("zoomCallback", slideHeight, slideWidth);
		}
		
		/**
		 * A callback method for zooming in a slide. Called once zoom gets executed 
		 * @param slideHeight
		 * @param slideWidth
		 * 
		 */		
		public function zoomCallback(slideHeight:Number, slideWidth:Number):void{
			sendNotification(PresentationFacade.ZOOM_SLIDE, new ZoomNotifier(slideHeight, slideWidth));
		}
		
		/**
		 * Sends an event to the server to update the clients with the new slide position 
		 * @param slideXPosition
		 * @param slideYPosition
		 * 
		 */		
		public function move(slideXPosition:Number, slideYPosition:Number):void{
			presentationSO.send("moveCallback", slideXPosition, slideYPosition);
		}
		
		/**
		 * A callback method from the server to update the slide position 
		 * @param slideXPosition
		 * @param slideYPosition
		 * 
		 */		
		public function moveCallback(slideXPosition:Number, slideYPosition:Number):void{
		   sendNotification(PresentationFacade.MOVE_SLIDE, new MoveNotifier(slideXPosition, slideYPosition));
		}
		
		/**
		 * Sends an event out for the clients to maximize the presentation module 
		 * 
		 */		
		public function maximize():void{
			presentationSO.send("maximizeCallback");
		}
		
		/**
		 * A callback method from the server to maximize the presentation 
		 * 
		 */		
		public function maximizeCallback():void{
			sendNotification(PresentationFacade.MAXIMIZE_PRESENTATION);
		}
		
		public function restore():void{
			presentationSO.send("restoreCallback");
		}
		
		public function restoreCallback():void{
			sendNotification(PresentationFacade.RESTORE_PRESENTATION);
		}
		
		/**
		 * Send an event to the server to clear the presentation 
		 * 
		 */		
		public function clear() : void
		{
			presentationSO.send("clearCallback");			
		}
		
		/**
		 * A call-back method for the clear method. This method is called when the clear method has
		 * successfuly called the server.
		 * 
		 */		
		public function clearCallback() : void
		{
			presentationSO.setProperty(SHARING, false);
			sendNotification(PresentationFacade.CLEAR_EVENT);
		}

		/**
		 * Send an event out to the server to go to a new page in the SlidesDeck 
		 * @param page
		 * 
		 */		
		public function gotoPage(page : Number) : void
		{
			presentationSO.send("gotoPageCallback", page);
			trace("Going to page " + page);
//			presentationSO.setProperty(CURRENT_PAGE, {pagenumber : page});
		}
		
		/**
		 * A callback method. It is called after the gotoPage method has successfully executed on the server
		 * The method sets the clients view to the page number received 
		 * @param page
		 * 
		 */		
		public function gotoPageCallback(page : Number) : void
		{
			presentation.decks.selected = page;
			sendNotification(PresentationFacade.UPDATE_PAGE, page);
		}

		/**
		 * Event called automatically once a SharedObject Sync method is received 
		 * @param event
		 * 
		 */								
		private function sharedObjectSyncHandler( event : SyncEvent) : void
		{
			trace( "Presentation::sharedObjectSyncHandler " + event.changeList.length);
		
			for (var i : uint = 0; i < event.changeList.length; i++) 
			{
				trace( "Presentation::handlingChanges[" + event.changeList[i].name + "][" + i + "]");
				handleChangesToSharedObject(event.changeList[i].code, 
						event.changeList[i].name, event.changeList[i].oldValue);
			}
		}
		
		/**
		 * See flash.events.SyncEvent
		 */
		private function handleChangesToSharedObject(code : String, name : String, oldValue : Object) : void
		{
			switch (name)
			{
				case UPDATE_MESSAGE:
					if (presentation.isPresenter) {
						trace( UPDATE_MESSAGE + " = [" + presentationSO.data.updateMessage.returnCode + "]");
						processUpdateMessage(presentationSO.data.updateMessage.returnCode);
					}
					
					break;
															
				case SHARING :
					presentation.isSharing = presentationSO.data.sharing.share;
				
					if (presentationSO.data.sharing.share) {
						trace( "SHARING =[" + presentationSO.data.sharing.share + "]");
						sendNotification(PresentationFacade.READY_EVENT);					
					} else {
						trace( "SHARING =[" + presentationSO.data.sharing.share + "]");
						sendNotification(PresentationFacade.CLEAR_EVENT);
					}
					break;

				case CURRENT_PAGE :
						presentation.decks.selected = presentationSO.data.currentPage.pagenumber;
						trace("Current page is " + presentationSO.data.currentPage.pagenumber);
						sendNotification(PresentationFacade.UPDATE_PAGE, presentationSO.data.currentPage.pagenumber);
					break;
							
				default:
					trace( "default = [" + code + "," + name + "," + oldValue + "]");				 
					break;
			}
		}
		
		/**
		 *  Called when there is an update from the server
		 * @param returnCode - an update message from the server
		 * 
		 */		
		private function processUpdateMessage(returnCode : String) : void
		{
			var totalSlides : Number;
			var completedSlides : Number;
			var message : String;
			
			switch (returnCode)
			{
				case SUCCESS_RC:
					message = presentationSO.data.updateMessage.message;
					sendNotification(PresentationFacade.CONVERT_SUCCESS_EVENT, message);
					trace("PresentationDelegate - Success Note sent");
					break;
					
				case UPDATE_RC:
					message = presentationSO.data.updateMessage.message;
					sendNotification(PresentationFacade.UPDATE_PROGRESS_EVENT, message);
					
					break;
										
				case FAILED_RC:
			
					break;
				case EXTRACT_RC:
					totalSlides = presentationSO.data.updateMessage.totalSlides;
					completedSlides = presentationSO.data.updateMessage.completedSlides;
					trace( "EXTRACTING = [" + completedSlides + " of " + totalSlides + "]");
					
					sendNotification(PresentationFacade.EXTRACT_PROGRESS_EVENT,
										new ProgressNotifier(totalSlides,completedSlides));
					
					break;
				case CONVERT_RC:
					totalSlides = presentationSO.data.updateMessage.totalSlides;
					completedSlides = presentationSO.data.updateMessage.completedSlides;
					trace( "CONVERTING = [" + completedSlides + " of " + totalSlides + "]");
					
					sendNotification(PresentationFacade.CONVERT_PROGRESS_EVENT,
										new ProgressNotifier(totalSlides, completedSlides));							
					break;			
				default:
			
					break;	
			}															
		}		

		private function notifyConnectionStatusListener(connected:Boolean):void {
			if (_connectionListener != null) {
				_connectionListener(connected);
			}
		}

		private function netStatusHandler ( event : NetStatusEvent ) : void
		{
			var statusCode : String = event.info.code;
			
			switch ( statusCode ) 
			{
				case "NetConnection.Connect.Success" :
					trace(NAME + ":Connection Success");		
					notifyConnectionStatusListener(true);			
					break;
			
				case "NetConnection.Connect.Failed" :			
					trace(NAME + ":Connection to viewers application failed");
					notifyConnectionStatusListener(false);
					break;
					
				case "NetConnection.Connect.Closed" :									
					trace(NAME + ":Connection to viewers application closed");
					notifyConnectionStatusListener(false);
					break;
					
				case "NetConnection.Connect.InvalidApp" :				
					trace(NAME + ":Viewers application not found on server");
					notifyConnectionStatusListener(false);
					break;
					
				case "NetConnection.Connect.AppShutDown" :
					trace(NAME + ":Viewers application has been shutdown");
					notifyConnectionStatusListener(false);
					break;
					
				case "NetConnection.Connect.Rejected" :
					trace(NAME + ":No permissions to connect to the viewers application" );
					notifyConnectionStatusListener(false);
					break;
					
				default :
				   trace(NAME + ":default - " + event.info.code );
				   notifyConnectionStatusListener(false);
				   break;
			}
		}
			
		private function asyncErrorHandler ( event : AsyncErrorEvent ) : void
		{
			trace( "participantsSO asyncErrorHandler " + event.error);
			notifyConnectionStatusListener(false);
		}
	}
}