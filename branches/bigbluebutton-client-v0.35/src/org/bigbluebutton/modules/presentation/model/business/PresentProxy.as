package org.bigbluebutton.modules.presentation.model.business
{
	import flash.net.FileReference;
	
	import org.bigbluebutton.common.IBigBlueButtonModule;
	import org.bigbluebutton.modules.presentation.PresentModuleConstants;
	import org.bigbluebutton.modules.presentation.model.services.FileUploadService;
	import org.bigbluebutton.modules.presentation.model.services.PresentationService;
	import org.puremvc.as3.multicore.interfaces.IProxy;
	import org.puremvc.as3.multicore.patterns.proxy.Proxy;

	public class PresentProxy extends Proxy implements IProxy
	{
		public static const NAME:String = "PresentProxy";
		
		private var _module:PresentationModule;
		private var _mode:String = PresentModuleConstants.PRESENTER_MODE;
		
		private var _slides:IPresentationSlides = new PresentationSlides();
		private var _presentService:IPresentService;
		 
		public function PresentProxy(module:IBigBlueButtonModule)
		{
			super(NAME);
			_module = module as PresentationModule;
			connect();
		}

		public function connect():void {
			_presentService = new PresentSOService(_module.uri, _slides);
			_presentService.addConnectionStatusListener(connectionStatusListener);
			_presentService.addMessageSender(messageSender);
			_presentService.connect();
		}
		
		public function get mode():String {
			return _mode;
		}
		
		private function connectionStatusListener(connected:Boolean):void {
			if (connected) {
				sendNotification(PresentModuleConstants.CONNECTED);
			} else {
				sendNotification(PresentModuleConstants.DISCONNECTED);
			}
		}
		
		private function messageSender(msg:String, body:Object=null):void {
			sendNotification(msg, body);
		}

		/**
		 * Upload a presentation to the server 
		 * @param fileToUpload - A FileReference class of the file we wish to upload
		 * 
		 */		
		public function uploadPresentation(fileToUpload:FileReference) : void
		{
			trace("PresentationApplication::uploadPresentation()... ");
			var fullUri : String = _module.host + "/bigbluebutton/file/upload";
						
			var service:FileUploadService = new FileUploadService(fullUri, _module.room);
			service.addProgressListener(uploadProgressListener);
			trace("using  FileUploadService..." + fullUri);
			service.upload(fileToUpload);
		}

		/**
		 * Loads a presentation from the server. creates a new PresentationService class 
		 * 
		 */		
		public function loadPresentation() : void
		{
			var fullUri : String = _module.host + "/bigbluebutton/file/xmlslides?room=" + _module.room;	
			trace("PresentationApplication::loadPresentation()... " + fullUri);
//			model.presentationLoaded = false;
//			
			var service:PresentationService = new PresentationService();
			service.load(fullUri, _slides);
			trace('number of slides=' + _slides.size());
		}	
		
		private function uploadProgressListener(code:String, message:String=""):void {
			trace('Fileupload progress ' + code + ":" + message);
		}			
	}
}