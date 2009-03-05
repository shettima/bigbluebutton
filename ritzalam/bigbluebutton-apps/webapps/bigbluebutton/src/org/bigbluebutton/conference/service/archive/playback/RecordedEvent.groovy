
package org.bigbluebutton.conference.service.archive.playback

import java.util.concurrent.Delayed
import java.util.concurrent.TimeUnit

public class RecordedEvent implements Delayed {
	   private long endOfDelay
	   private final Date requestTime
	   private final PlaybackSession session
	   
	   public RecordedEvent(PlaybackSession session) {
	      this.session = session
	   }

	   public long getDelay(TimeUnit timeUnit) {
	      return timeUnit.convert(endOfDelay - System.currentTimeMillis(), TimeUnit.MILLISECONDS)
	   }

	   public int compareTo(Delayed delayed) {
		  RecordedEvent request = (RecordedEvent)delayed;
	      if (this.endOfDelay < request.endOfDelay)
	         return -1;
	      if (this.endOfDelay > request.endOfDelay)
	         return 1;
	      return this.requestTime.compareTo(request.requestTime);
	   }
	   
	   public long getEndOfDelay() {
		   endOfDelay
	   }
	   
	   public void playMessage() {
		   session.playMessage()
	   }
	   
	   public boolean scheduleNextEvent() {
		   session.hasMessageToSend()
	   }
}
