package org.bigbluebutton.common.messaging
{
	public class EndpointMessageConstants
	{	
		public static const MODULE_READY:String = 'MODULE_READY';	
		public static const MODULE_STARTED:String = 'MODULE_STARTED';
		public static const MODULE_STOPPED:String = 'MODULE_STOPPED';
		
		public static const CONFERENCE_DESCRIPTOR_QUERY:String = 'CONFERENCE_DESCRIPTOR_QUERY';
		public static const CONFERENCE_DESCRIPTOR_QUERY_REPLY:String = 'CONFERENCE_DESCRIPTOR_QUERY_REPLY';

		public static const FROM_MAIN_APP:String = 'FROM_MAIN_APP';
		public static const TO_MAIN_APP:String = 'TO_MAIN_APP';
		
		public static const FROM_CHAT_MODULE:String = 'FROM_CHAT_MODULE';
		public static const TO_CHAT_MODULE:String = 'TO_CHAT_MODULE';
		
		public static const FROM_VIEWERS_MODULE:String = 'FROM_VIEWERS_MODULE';
		public static const TO_VIEWERS_MODULE:String = 'TO_VIEWERS_MODULE';
	}
}