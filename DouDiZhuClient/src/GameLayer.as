package  
{
	import game.DouDiZhu;
	import starling.display.Sprite;
	import starling.events.Event;
	
	/**
	 * 总游戏层
	 * @author Vampire
	 */
	public class GameLayer extends Sprite 
	{
		private static var sGameLayer:GameLayer;//单例模式
		
		public function GameLayer() 
		{
			super();
			
			if (!sGameLayer)
				sGameLayer = this;
			else
				throw new Error("单例模式，直接使用静态变量gGameLayer");
			
			this.addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		//初始化
		protected function init(e:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, init);
			
			addChild(DouDiZhu.sDouDiZhu);
		}
	}
}