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
			mStarling = new Starling(GameLayer, stage);
			mStarling.showStats = true;
			mStarling.start();
		}
	}
}