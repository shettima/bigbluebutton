package org.bigbluebutton.modules.presentation.model.business
{
	public interface IPresentationSlides
	{
		function clear():void;
		function add(slide:String):void;
		function size():int;
		
	}
}