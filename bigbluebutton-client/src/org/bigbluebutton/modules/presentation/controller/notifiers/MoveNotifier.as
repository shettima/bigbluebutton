package org.bigbluebutton.modules.presentation.controller.notifiers
{
	/**
	 * A convinience class for sending more than one pience of information through a pureMVC notification 
	 * @author Denis Zgonjanin
	 * 
	 */	
	public class MoveNotifier
	{
		public var newXPosition:Number;
		public var newYPosition:Number;
		
		public function MoveNotifier(newXPosition:Number, newYPosition:Number)
		{
			this.newXPosition = newXPosition;
			this.newYPosition = newYPosition;
		}

	}
}