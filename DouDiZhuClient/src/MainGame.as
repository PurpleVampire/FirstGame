package  
{
	import flash.display.Sprite;
	import flash.events.Event;
	import starling.core.Starling;
	
	/**
	 * 负责启用starling引擎
	 * @author Vampire
	 */
	public class MainGame extends Sprite 
	{
		private var mStarling:Starling;
		
		public function MainGame() 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);	
		}
		
		private function init(e:Event = null):void 
		{
			Starling.handleLostContext = true;	//设置为true，否则运行的程序双击最大化后会丢失设备句柄，无法显示图片
			mStarling = new Starling(GameLayer, stage);
			mStarling.showStats = true;
			mStarling.start();
		}
	}
}