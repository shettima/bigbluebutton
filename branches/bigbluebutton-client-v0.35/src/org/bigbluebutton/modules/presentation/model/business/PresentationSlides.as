package org.bigbluebutton.modules.presentation.model.business
{
	import mx.collections.ArrayCollection;
	
	public class PresentationSlides implements IPresentationSlides
	{
		public var _slides:ArrayCollection = new ArrayCollection();
		
		public function PresentationSlides()
		{
		}

		public function get slides():ArrayCollection {
			return _slides;
		}
		
		public function clear():void {
			_slides.removeAll();
		}
		
		public function add(slide:String):void {
			trace('Adding slide ' + slide);
			_slides.addItem(slide);
		}
		
		public function size():int {
			return _slides.length;
		}
	}
}