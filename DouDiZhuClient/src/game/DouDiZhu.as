package game 
{
	import help.GameData;
	import help.PlayerData;
	import help.PokerHelp;
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
		
		private var mIndex:int = 0;
		
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
			
			//添加背景
			addChild(BackgroundLayer.sBackgroundLayer);
			
			//添加3个玩家的扑克牌层
			addChild(PokerManagerLayer.sPokerManagerLayer);
			
			//添加操作层
			addChild(OperateLayer.sOperateLayer);
			
			//添加操作状态层
			addChild(OperateStateLayer.sOperateStateLayer);
			
			//添加开始层
			addChild(StartLayer.sStartLayer);
			StartLayer.sStartLayer.x = (stage.stageWidth - StartLayer.sStartLayer.width) / 2;
			StartLayer.sStartLayer.y = (stage.stageHeight - StartLayer.sStartLayer.height) / 2;
		}
		
		//游戏开始
		public function GameStart():void
		{
			//洗牌
			var pokerValues:Array = PokerHelp.Shuffle();
			
			//发牌
			(GameData.gGameData.mPlayerDatas[0] as PlayerData).mHandPokers = pokerValues.slice(0, 17);
			(GameData.gGameData.mPlayerDatas[1] as PlayerData).mHandPokers = pokerValues.slice(17, 34);
			(GameData.gGameData.mPlayerDatas[2] as PlayerData).mHandPokers = pokerValues.slice(34, 51);
			GameData.gGameData.mDiPais = pokerValues.slice(51, 54);
			
			//排序
			PokerHelp.SortByValue((GameData.gGameData.mPlayerDatas[0] as PlayerData).mHandPokers);
			PokerHelp.SortByValue((GameData.gGameData.mPlayerDatas[1] as PlayerData).mHandPokers);
			PokerHelp.SortByValue((GameData.gGameData.mPlayerDatas[2] as PlayerData).mHandPokers);
			
			Starling.juggler.repeatCall(AddPoker, 0.2, 17);
		}
		
		//添加扑克牌
		public function AddPoker():void
		{
			PokerManagerLayer.sPokerManagerLayer.AddHandPoker(0, (GameData.gGameData.mPlayerDatas[0] as PlayerData).mHandPokers[mIndex]);
			PokerManagerLayer.sPokerManagerLayer.AddHandPoker(1, (GameData.gGameData.mPlayerDatas[1] as PlayerData).mHandPokers[mIndex]);
			PokerManagerLayer.sPokerManagerLayer.AddHandPoker(2, (GameData.gGameData.mPlayerDatas[2] as PlayerData).mHandPokers[mIndex]);
			mIndex++;
			
			if (mIndex == 17)
				OperateLayer.sOperateLayer.SetJiao();
		}
		
		//叫地主
		public function JiaoDiZhu(viewSeatID:int, bJiao:Boolean):void
		{
			OperateStateLayer.sOperateStateLayer.SetState(viewSeatID, bJiao ? "叫地主" : "不叫");
			
			if(viewSeatID == 0)
				OperateLayer.sOperateLayer.Reset();
			
			//添加三张牌
			PokerManagerLayer.sPokerManagerLayer.InsertPokers(0, GameData.gGameData.mDiPais);
		}
		
		//抢地主
		public function QiangDiZhu(viewSeatID:int, bQiang:Boolean):void
		{
			OperateStateLayer.sOperateStateLayer.SetState(viewSeatID, bQiang ? "抢地主" : "不抢");
			
			if (viewSeatID == 0)
				OperateLayer.sOperateLayer.Reset();
		}
	}
}