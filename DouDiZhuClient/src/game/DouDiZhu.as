package game 
{
	import help.GameData;
	import help.GameLogic;
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
		public function GameStart(meHandPokers:Array, rightHandPokers:Array, leftHandPokers:Array):void
		{
			//三家手牌数据，目前要测试机器人AI，所以传3个人的数据，后期只传自己的数据，其他人的数据为未知
			(GameData.gGameData.mPlayerDatas[0] as PlayerData).mHandPokers = meHandPokers.slice(0);
			(GameData.gGameData.mPlayerDatas[1] as PlayerData).mHandPokers = rightHandPokers.slice(0);
			(GameData.gGameData.mPlayerDatas[2] as PlayerData).mHandPokers = leftHandPokers.slice(0);
			
			Starling.juggler.repeatCall(AddPoker, 0.2, 17);
		}
		
		//添加扑克牌
		public function AddPoker():void
		{
			PokerManagerLayer.sPokerManagerLayer.AddHandPoker(0, (GameData.gGameData.mPlayerDatas[0] as PlayerData).mHandPokers[mIndex]);
			PokerManagerLayer.sPokerManagerLayer.AddHandPoker(1, (GameData.gGameData.mPlayerDatas[1] as PlayerData).mHandPokers[mIndex]);
			PokerManagerLayer.sPokerManagerLayer.AddHandPoker(2, (GameData.gGameData.mPlayerDatas[2] as PlayerData).mHandPokers[mIndex]);
			mIndex++;
			
			//if (mIndex == 17)
				//OperateLayer.sOperateLayer.SetJiao();
		}
		
		//叫地主
		public function JiaoDiZhu(viewSeatID:int, bJiao:Boolean):void
		{
			GameLogic.gGameLogic.JiaoDiZhu(bJiao);
			
			if(viewSeatID == 0)
				OperateLayer.sOperateLayer.Reset();
		}
		
		//抢地主
		public function QiangDiZhu(viewSeatID:int, bQiang:Boolean):void
		{
			GameLogic.gGameLogic.QiangDiZhu(bQiang);
			
			if (viewSeatID == 0)
				OperateLayer.sOperateLayer.Reset();
		}
	}
}