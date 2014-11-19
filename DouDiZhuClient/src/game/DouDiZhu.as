package game 
{
	import help.GameData;
	import help.GameHelp;
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
		
		private var mGameHelp:GameHelp;	//游戏帮助类
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
			
			mGameHelp = new GameHelp(3);
			
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
			
			//测试
			//var test:Array = [0x11, 0x12, 0x21, 0x31, 0x32, 0x33, 0x51, 0x63, 0x64];
			//var pokerHelp:PokerHelp = new PokerHelp;
			//var hh:Array = pokerHelp.GetNumberCardFromCards(test, 1);
			//var ii:int = 0;
		}
		
		//游戏开始
		public function GameStart(selfLogicSeatID:int, meHandPokers:Array, rightHandPokers:Array, leftHandPokers:Array):void
		{
			//游戏状态--游戏开始
			GameData.gGameData.mGameState = GameData.STATE_GAMESTART;
			
			//分配玩家的逻辑座位号
			GameData.gGameData.mSelfLogicSeatID = selfLogicSeatID;
			
			//三家手牌数据，目前要测试机器人AI，所以传3个人的数据，后期只传自己的数据，其他人的数据为未知
			(GameData.gGameData.mPlayerDatas[0] as PlayerData).mHandPokers = meHandPokers.slice(0);
			(GameData.gGameData.mPlayerDatas[1] as PlayerData).mHandPokers = rightHandPokers.slice(0);
			(GameData.gGameData.mPlayerDatas[2] as PlayerData).mHandPokers = leftHandPokers.slice(0);
			
			OperateStateLayer.sOperateStateLayer.SetThreePokers([0x00, 0x00, 0x00]);
			
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
		
		//开始叫地主
		public function JiaoDiZhuStart(jiaoLogicSeatID:int):void
		{
			//游戏状态--叫地主
			GameData.gGameData.mGameState = GameData.STATE_JIAO;
			
			//当前玩家的操作倒计时
			var jiaoViewSeatID:int = mGameHelp.GetViewSeatByLogicSeat(jiaoLogicSeatID, GameData.gGameData.mSelfLogicSeatID);
			OperateStateLayer.sOperateStateLayer.SetCountdown(jiaoViewSeatID, 20);
			
			//如果是自己
			if (jiaoViewSeatID == 0)
				OperateLayer.sOperateLayer.SetJiao();
		}
		
		//叫地主
		public function JiaoDiZhu(jiaoLogicSeatID:int, bJiao:Boolean):void
		{
			//操作的玩家
			var jiaoViewSeatID:int = mGameHelp.GetViewSeatByLogicSeat(jiaoLogicSeatID, GameData.gGameData.mSelfLogicSeatID);
			OperateStateLayer.sOperateStateLayer.SetState(jiaoViewSeatID, (bJiao ? "叫地主" : "不叫"));
			
			//下一个玩家的操作
			var nextLogicSeatID:int = (jiaoLogicSeatID + 1) % 3;
			var nextViewSeatID:int = mGameHelp.GetViewSeatByLogicSeat(nextLogicSeatID, GameData.gGameData.mSelfLogicSeatID);
			OperateStateLayer.sOperateStateLayer.SetCountdown(nextViewSeatID, 20);
			
			//如果上一个是自己
			if (jiaoViewSeatID == 0)
				OperateLayer.sOperateLayer.Reset();
			
			//如果下一个是自己
			if (nextViewSeatID == 0)
			{
				if (!bJiao)	//别人叫地主，等待开始抢地主的消息
					OperateLayer.sOperateLayer.SetJiao();
			}
			
			//刷新逻辑
			GameLogic.gGameLogic.JiaoDiZhu(jiaoLogicSeatID, bJiao);
		}
		
		//抢地主开始
		public function QiangDiZhuStart(qiangLogicSeatID:int):void
		{
			//游戏状态--抢地主
			GameData.gGameData.mGameState = GameData.STATE_QIANG;
			
			//当前玩家的操作倒计时
			var qiangViewSeatID:int = mGameHelp.GetViewSeatByLogicSeat(qiangLogicSeatID, GameData.gGameData.mSelfLogicSeatID);
			OperateStateLayer.sOperateStateLayer.SetCountdown(qiangViewSeatID, 20);
			
			//如果是自己
			if (qiangViewSeatID == 0)
				OperateLayer.sOperateLayer.SetQiang();
		}
		
		//抢地主
		public function QiangDiZhu(qiangLogicSeatID:int, bQiang:Boolean):void
		{
			//操作的玩家
			var qiangViewSeatID:int = mGameHelp.GetViewSeatByLogicSeat(qiangLogicSeatID, GameData.gGameData.mSelfLogicSeatID);
			OperateStateLayer.sOperateStateLayer.SetState(qiangViewSeatID, (bQiang ? "抢地主" : "不抢"));
			
			//下一个玩家的操作
			var nextLogicSeatID:int = (qiangLogicSeatID + 1) % 3;
			var nextViewSeatID:int = mGameHelp.GetViewSeatByLogicSeat(nextLogicSeatID, GameData.gGameData.mSelfLogicSeatID);
			OperateStateLayer.sOperateStateLayer.SetCountdown(nextViewSeatID, 20);
			
			//如果上一个是自己
			if (qiangViewSeatID == 0)
				OperateLayer.sOperateLayer.Reset();
			
			//如果下一个是自己
			if (nextViewSeatID == 0)
				OperateLayer.sOperateLayer.SetQiang();
			
			//刷新逻辑
			GameLogic.gGameLogic.QiangDiZhu(qiangLogicSeatID, bQiang);
		}
		
		//抢地主成功
		public function QiangDiZhuSuccess(lordLogicSeatID:int, diPais:Array):void
		{
			//游戏状态--打牌
			GameData.gGameData.mGameState = GameData.STATE_PLAYCARD;
			
			//清空桌面状态
			OperateStateLayer.sOperateStateLayer.SetState(0, "");
			OperateStateLayer.sOperateStateLayer.SetState(1, "");
			OperateStateLayer.sOperateStateLayer.SetState(2, "");
			
			//翻开底牌
			OperateStateLayer.sOperateStateLayer.SetThreePokers(diPais);
			GameData.gGameData.mDiPais = diPais.slice(0);
			
			//地主玩家，手牌添加3张底牌并排序
			var lordViewSeatID:int = mGameHelp.GetViewSeatByLogicSeat(lordLogicSeatID, GameData.gGameData.mSelfLogicSeatID);
			(GameData.gGameData.mPlayerDatas[lordViewSeatID] as PlayerData).mHandPokers.push(diPais[0], diPais[1], diPais[2]);
			PokerHelp.SortByValue((GameData.gGameData.mPlayerDatas[lordViewSeatID] as PlayerData).mHandPokers);
			PokerManagerLayer.sPokerManagerLayer.InsertPokers(lordViewSeatID, diPais);
			OperateStateLayer.sOperateStateLayer.SetCountdown(lordViewSeatID, 20);
			
			//如果是自己
			if (lordViewSeatID == 0)
				OperateLayer.sOperateLayer.SetPlayCard(true);
			
			//刷新逻辑
			GameLogic.gGameLogic.QiangDiZhuSuccess(lordLogicSeatID);
		}
		
		//打牌
		public function OutCard(outLogicSeatID:int, pokerValues:Array):void
		{
			//出牌玩家的操作
			var outViewSeatID:int = mGameHelp.GetViewSeatByLogicSeat(outLogicSeatID, GameData.gGameData.mSelfLogicSeatID);
			PokerManagerLayer.sPokerManagerLayer.AddOutPokers(outViewSeatID, pokerValues);
			PokerManagerLayer.sPokerManagerLayer.RemoveHandPokers(outViewSeatID, pokerValues);
			
			//下一个玩家的操作
			var nextLogicSeatID:int = (outLogicSeatID + 1) % 3;
			var nextViewSeatID:int = mGameHelp.GetViewSeatByLogicSeat(nextLogicSeatID, GameData.gGameData.mSelfLogicSeatID);
			PokerManagerLayer.sPokerManagerLayer.RemoveOutPokers(nextViewSeatID);
			OperateStateLayer.sOperateStateLayer.SetCountdown(nextViewSeatID, 20);
			
			//如果上一个是自己
			if (outViewSeatID == 0)
				OperateLayer.sOperateLayer.Reset();
			
			//如果下一个操作的玩家是自己，显示打牌操作
			if (nextViewSeatID == 0)
				OperateLayer.sOperateLayer.SetPlayCard(false);
			
			//刷新逻辑
			GameLogic.gGameLogic.OutCardSuccess(outLogicSeatID, pokerValues);
		}
	}
}