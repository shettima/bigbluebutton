package org.bigbluebutton.modules.presentation.model.business
{
	import mx.collections.ArrayCollection;
	
	public class PresentationSlides implements IPresentationSlides
	{
		public var _slides:ArrayCollection;
		
		public function PresentationSlides()
		{
		}

		public function get slides():ArrayCollection {
			return _slides;
		}
	}
}