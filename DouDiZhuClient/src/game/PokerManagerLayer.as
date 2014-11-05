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
			mePokerManager.SetParameter(PokerManager.POSITION_BOTTOM, "Poker");
			mePokerManager.x = int((stage.stageWidth - mePokerManager.width) / 2);
			mePokerManager.y = 450;
			addChild(mePokerManager);
			mPokerManagers.push(mePokerManager);
			
			//右边玩家的扑克控件
			var rightPokerManager:PokerManager = new PokerManager;
			rightPokerManager.SetParameter(PokerManager.POSITION_RIGHT, "Poker");
			rightPokerManager.x = stage.stageWidth - 100;
			rightPokerManager.y = int((stage.stageHeight - rightPokerManager.height) / 2);
			rightPokerManager.touchable = false;
			addChild(rightPokerManager);
			mPokerManagers.push(rightPokerManager);
			
			//左边玩家的扑克控件
			var leftPokerManager:PokerManager = new PokerManager;
			leftPokerManager.SetParameter(PokerManager.POSITION_LEFT, "Poker");
			leftPokerManager.x = 100;
			leftPokerManager.y = int((stage.stageHeight - leftPokerManager.height) / 2);
			leftPokerManager.touchable = false;
			addChild(leftPokerManager);
			mPokerManagers.push(leftPokerManager);
		}
		
		//添加扑克牌
		public function AddPoker(viewSeatID:int, pokerValue:Number):void
		{
			var tempPokerManager:PokerManager = mPokerManagers[viewSeatID] as PokerManager;
			tempPokerManager.AddPoker(pokerValue);
			
			UpdatePosition(viewSeatID, tempPokerManager);
		}
		
		//刷新位置
		private function UpdatePosition(viewSeatID:int, pokerManager:PokerManager):void
		{
			//计算位置
			var endX:int, endY:int;
			if (viewSeatID == 0)
			{ 
				endX = int((stage.stageWidth - pokerManager.width) / 2);
				endY = pokerManager.y;
			}
			else
			{
				endX = pokerManager.x;
				endY = int((stage.stageHeight - pokerManager.height) / 2);
			}
			
			//动画
			var tween:Tween = new Tween(pokerManager, 0.2, Transitions.LINEAR);
			tween.moveTo(endX, endY);
			tween.onComplete = OnComplete;
			tween.onCompleteArgs = [tween];
			Starling.juggler.add(tween);
		}
		
		//动画结束
		private function OnComplete(tween:Tween):void
		{
			Starling.juggler.remove(tween);
		}
	}
}