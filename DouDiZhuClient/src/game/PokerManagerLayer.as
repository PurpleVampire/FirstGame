package game 
{
	import myPoker.PokerManager;
	import starling.animation.Juggler;
	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.Sprite;
	import starling.events.Event;
	
	/**
	 * 扑克控件层
	 * @author Vampire
	 */
	public class PokerManagerLayer extends Sprite 
	{
		public static var sPokerManagerLayer:PokerManagerLayer = new PokerManagerLayer;//单例模式
		
		private var mPokerManagers:Array = [];
		
		public function PokerManagerLayer() 
		{
			super();
			
			if (!sPokerManagerLayer)
				sPokerManagerLayer = this;
			else
				throw new Error("单例模式，直接使用静态变量sPokerManagerLayer");
			
			this.addEventListener(Event.ADDED_TO_STAGE, Init);
		}
		
		//初始化
		private function Init(e:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, Init);
			
			//自身玩家的扑克控件
			var mePokerManager:PokerManager = new PokerManager;
			mePokerManager.SetParameter(PokerManager.POSITION_ME, 25, "Poker");
			mePokerManager.y = 450;
			addChild(mePokerManager);
			mPokerManagers.push(mePokerManager);
			
			//右边玩家的扑克控件
			var rightPokerManager:PokerManager = new PokerManager;
			rightPokerManager.SetParameter(PokerManager.POSITION_RIGHT, 30, "Poker");
			rightPokerManager.x = stage.stageWidth - 100;
			rightPokerManager.touchable = false;
			addChild(rightPokerManager);
			mPokerManagers.push(rightPokerManager);
			
			//左边玩家的扑克控件
			var leftPokerManager:PokerManager = new PokerManager;
			leftPokerManager.SetParameter(PokerManager.POSITION_LEFT, 30, "Poker");
			leftPokerManager.x = 100;
			leftPokerManager.touchable = false;
			addChild(leftPokerManager);
			mPokerManagers.push(leftPokerManager);
		}
		
		//添加扑克牌
		public function AddPoker(viewSeatID:int, pokerValue:Number):void
		{
			var tempPokerManager:PokerManager = mPokerManagers[viewSeatID] as PokerManager;
			tempPokerManager.AddPoker(pokerValue);
		}
	}
}