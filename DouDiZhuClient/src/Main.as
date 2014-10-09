package 
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	/**
	 * 入口文件
	 * @author Vampire
	 */
	public class Main extends Sprite 
	{
		
		public function Main():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			
			var mainGame:MainGame = new MainGame;
			addChild(mainGame);
		}
		
		public function GetMainGame():MainGame 
		{
			return new MainGame;
		}
	}
}