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
			
			//设置舞台
			stage.stageWidth = 1024;
			stage.stageHeight = 650;
			stage.frameRate = 60;
			
			var mainGame:MainGame = new MainGame;
			addChild(mainGame);
		}
		
		public function GetMainGame():MainGame 
		{
			return new MainGame;
		}
	}
}