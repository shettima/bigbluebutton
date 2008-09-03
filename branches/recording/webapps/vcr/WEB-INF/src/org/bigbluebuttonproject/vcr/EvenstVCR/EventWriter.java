/**
 * 
 */
package org.bigbluebuttonproject.vcr.EvenstVCR;

import java.io.PrintWriter;
import java.io.OutputStream;

import java.util.concurrent.locks.ReentrantLock;
        
/** 
 * @author nnoori
 *      
 */ 
public class EventWriter extends PrintWriter {
	
	protected final ReentrantLock mutex;
	
	public EventWriter(OutputStream out) {
		super(out);
		mutex = new ReentrantLock();
	}      
	               
	/**    
	 * Acquire a lock. Need this since events arrive asynchronously.
	 * Locks are reentrant (@see also java.util.concurrent).
	 */
	public void acquireLock() {
		mutex.lock();
	}
	      
	/**
	 * Release a lock.
	 */
	public void releaseLock() {
		mutex.unlock();
	}
	//in the print here we are just trying to catch the thread for the
	//events happening and print it out to the text output stream
	public void print(String s) {
		//check if the current thread owns the lock
		if (mutex.isHeldByCurrentThread()) {
			// we are inside a critical section
			super.print(s);
			
		} else {
			//acquire a lock
			mutex.lock();
			try {
		
				super.print(s);
				super.flush();
		
			} finally {
				mutex.unlock();
			}
		}
	}   
	
	public void println(String s) {
		if (mutex.isHeldByCurrentThread()) {
			// we are inside a critical section
		
			super.println(s);
			super.flush();
		
		} else {
			mutex.lock();
			try {
		
				super.println(s);
				super.flush();
		
			} finally {
				mutex.unlock();
			}
		}
	}
	
}
