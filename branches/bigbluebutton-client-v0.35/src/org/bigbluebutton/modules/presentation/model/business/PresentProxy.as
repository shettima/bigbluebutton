package org.bigbluebutton.modules.presentation.model.business
{
	import flash.net.FileReference;
	
	import org.bigbluebutton.common.IBigBlueButtonModule;
	import org.bigbluebutton.modules.presentation.model.services.FileUploadService;
	import org.puremvc.as3.multicore.interfaces.IProxy;
	import org.puremvc.as3.multicore.patterns.proxy.Proxy;

	public class PresentProxy extends Proxy implements IProxy
	{
		public static const NAME:String = "PresentProxy";
		
		private var _module:PresentationModule;
		
		private var _slides:IPresentationSlides = new PresentationSlides();
		
		public function PresentProxy(module:IBigBlueButtonModule)
		{
			super(NAME);
			_module = module as PresentationModule;
		}

		/**
		 * Upload a presentation to the server 
		 * @param fileToUpload - A FileReference class of the file we wish to upload
		 * 
		 */		
		public function uploadPresentation(fileToUpload:FileReference) : void
		{
			trace("PresentationApplication::uploadPresentation()... ");
			var fullUri : String = "/bigbluebutton/file/upload";
						
//			var service:FileUploadService = new FileUploadService(fullUri, _room);
//			facade.registerProxy(service);
			trace("using  FileUploadService...");
//			service.upload(fileToUpload);
		}

		/**
		 * Loads a presentation from the server. creates a new PresentationService class 
		 * 
		 */		
		public function loadPresentation() : void
		{
//			var fullUri : String = _docServiceAddress + Constants.relativeFileUpload + "/xmlslides?room=" + _room;	
//			trace("PresentationApplication::loadPresentation()... " + fullUri);
//			model.presentationLoaded = false;
//			
//			var service:PresentationService = new PresentationService(fullUri, this);
		}				
	}
}