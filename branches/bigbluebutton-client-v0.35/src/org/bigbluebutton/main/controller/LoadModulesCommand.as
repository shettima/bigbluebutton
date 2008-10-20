package org.bigbluebutton.main.controller
{
	import org.bigbluebutton.main.model.ModulesProxy;
	import org.puremvc.as3.multicore.interfaces.ICommand;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;

	public class LoadModulesCommand extends SimpleCommand implements ICommand
	{
		public function LoadModulesCommand()
		{
			super();
		}

		override public function execute(note:INotification):void
		{
			var proxy:ModulesProxy = facade.retrieveProxy(ModulesProxy.NAME) as ModulesProxy;
			if (proxy != null) {
				trace('Found ModulesProxy');
				proxy.loadModules();
			} else {
				trace('ModulesProxy does not exist.');
			}			
		}			
	}
}