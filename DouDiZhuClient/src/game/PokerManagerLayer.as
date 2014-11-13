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
		
		private var mHandPokerManagers:Array = [];	//手牌控件
		private var mOutPokerManagers:Array = [];	//出牌控件
		
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
			mePokerManager.SetParameter(PokerManager.POSITION_ME, 26, "Poker");
			mePokerManager.y = 500;
			addChild(mePokerManager);
			mHandPokerManagers.push(mePokerManager);
			
			//右边玩家的扑克控件
			var rightPokerManager:PokerManager = new PokerManager;
			rightPokerManager.SetParameter(PokerManager.POSITION_RIGHT, 26, "Poker");
			rightPokerManager.touchable = false;
			rightPokerManager.x = stage.stageWidth - 100;
			addChild(rightPokerManager);
			mHandPokerManagers.push(rightPokerManager);
			
			//左边玩家的扑克控件
			var leftPokerManager:PokerManager = new PokerManager;
			leftPokerManager.SetParameter(PokerManager.POSITION_LEFT, 26, "Poker");
			leftPokerManager.touchable = false;
			leftPokerManager.x = 100;
			addChild(leftPokerManager);
			mHandPokerManagers.push(leftPokerManager);
			
			//自身玩家的出牌
			var meOutPokerManager:PokerManager = new PokerManager;
			meOutPokerManager.SetParameter(PokerManager.POSITION_ME, 26, "Poker", false);
			meOutPokerManager.touchable = false;
			meOutPokerManager.y = 350;
			addChild(meOutPokerManager);
			mOutPokerManagers.push(meOutPokerManager);
			
			//右边玩家的出牌
			var rightOutPokerManager:PokerManager = new PokerManager;
			rightOutPokerManager.SetParameter(PokerManager.POSITION_ME, 26, "Poker", false);
			rightOutPokerManager.touchable = false;
			rightOutPokerManager.y = 200;
			addChild(rightOutPokerManager);
			mOutPokerManagers.push(rightOutPokerManager);
			
			//左边玩家的出牌
			var leftOutPokerManager:PokerManager = new PokerManager;
			leftOutPokerManager.SetParameter(PokerManager.POSITION_ME, 26, "Poker", false);
			leftOutPokerManager.touchable = false;
			leftOutPokerManager.y = 200;
			addChild(leftOutPokerManager);
			mOutPokerManagers.push(leftOutPokerManager);
		}
		
		//添加手牌扑克牌
		public function AddHandPoker(viewSeatID:int, pokerValue:Number):void
		{
			var tempPokerManager:PokerManager = mHandPokerManagers[viewSeatID] as PokerManager;
			tempPokerManager.AddPoker(pokerValue);
		}
		
		//插入手牌3张底牌
		public function InsertPokers(viewSeatID:int, pokerValues:Array):void
		{
			var tempPokerManager:PokerManager = mHandPokerManagers[viewSeatID] as PokerManager;
			tempPokerManager.InsertPokers(pokerValues);
		}
		
		//移除手牌出的牌
		public function RemoveHandPokers(viewSeatID:int, pokerValues:Array):void
		{
			var tempPokerManager:PokerManager = mHandPokerManagers[viewSeatID] as PokerManager;
			tempPokerManager.RemovePokers(pokerValues);
		}
		
		//得到弹起的牌
		public function GetUpPokers():Array
		{
			var tempPokerManager:PokerManager = mHandPokerManagers[0] as PokerManager;
			return tempPokerManager.GetUpPokers();
		}
		
		//清空出牌扑克牌
		public function RemoveOutPokers(viewSeatID:int):void
		{
			var tempPokerManager:PokerManager = mOutPokerManagers[viewSeatID] as PokerManager;
			tempPokerManager.removeChildren();
		}
		
		//添加出牌扑克牌
		public function AddOutPokers(viewSeatID:int, pokerValues:Array):void
		{
			var tempPokerManager:PokerManager = mOutPokerManagers[viewSeatID] as PokerManager;
			tempPokerManager.removeChildren();
			tempPokerManager.AddPokers(pokerValues);
			
			if (viewSeatID == 0)
				tempPokerManager.x = int((stage.stageWidth - tempPokerManager.width) / 2);
			else if(viewSeatID == 1)
				tempPokerManager.x = stage.stageWidth - tempPokerManager.width - 150;
			else if (viewSeatID == 2)
				tempPokerManager.x = 150;
		}
	}
}