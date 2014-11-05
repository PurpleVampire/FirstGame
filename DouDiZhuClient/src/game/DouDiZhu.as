package game 
{
	import myPoker.PokerManager;
	import starling.animation.IAnimatable;
	import starling.core.Starling;
	import starling.display.Sprite;
	import starling.events.Event;
	
	/**
	 * 斗地主游戏
	 * @author Vampire
	 */
	public class DouDiZhu extends Sprite 
	{
		public static var sDouDiZhu:DouDiZhu = new DouDiZhu;//单例模式
		
		private var mePokerValues:Array = [0x11, 0x12, 0x23, 0x24, 0x34, 0x35, 0x37, 0x38, 0x39, 0x41, 0x42, 0x43, 0x44, 0x45, 0x49, 0x4a, 0x4b];
		private var upPokerValues:Array = [0x60, 0x60, 0x60, 0x60, 0x60, 0x60, 0x60, 0x60, 0x60, 0x60, 0x60, 0x60, 0x60, 0x60, 0x60, 0x60, 0x60];
		private var index:int = 0;
		
		public function DouDiZhu() 
		{
			super();
			
			if (!sDouDiZhu)
				sDouDiZhu = this;
			else
				throw new Error("单例模式，直接使用静态变量sDouDiZhu");
			
			this.addEventListener(Event.ADDED_TO_STAGE, Init);
		}
		
		//初始化
		private function Init(e:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, Init);
			
			//添加开始层
			addChild(StartLayer.sStartLayer);
			StartLayer.sStartLayer.x = (stage.stageWidth - StartLayer.sStartLayer.width) / 2;
			StartLayer.sStartLayer.y = (stage.stageHeight - StartLayer.sStartLayer.height) / 2;
			
			//添加3个玩家的扑克牌层
			addChild(PokerManagerLayer.sPokerManagerLayer);
		}
		
		//添加扑克牌
		public function AddPoker():void
		{
			PokerManagerLayer.sPokerManagerLayer.AddPoker(0, mePokerValues[index]);
			PokerManagerLayer.sPokerManagerLayer.AddPoker(1, upPokerValues[index]);
			PokerManagerLayer.sPokerManagerLayer.AddPoker(2, upPokerValues[index]);
			index++;
		}
	}
}