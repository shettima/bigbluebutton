package org.bigbluebutton.main.controller
{
	import org.puremvc.as3.multicore.interfaces.ICommand;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	import org.puremvc.as3.multicore.interfaces.INotification;

	public class ViewPrepCommand extends SimpleCommand implements ICommand
	{
		public function ViewPrepCommand()
		{
			super();
		}
		
		override public function execute(note:INotification):void
		{
			var app:MainApplicationShell = note.getBody() as MainApplicationShell;
			facade.registerMediator( new MainApplicationShellMediator( app ) );			
			facade.registerMediator(new MainApplicationMediator());
		}	
		
		public function sendNotification(notificationName:String, body:Object=null, type:String=null):void
		{
		}
		
		public function initializeNotifier(key:String):void
		{
		}
		
	}
}