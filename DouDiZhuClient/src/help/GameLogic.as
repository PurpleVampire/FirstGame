package help 
{
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import game.DouDiZhu;
	import game.OperateLayer;
	import game.OperateStateLayer;
	import game.PokerManagerLayer;
	/**
	 * 游戏逻辑
	 * @author Vampire
	 */
	public class GameLogic 
	{
		public static var gGameLogic:GameLogic = new GameLogic;	//单例模式
		
		private var mPlayerDatas:Array = [];	//三个玩家的手牌数据，逻辑座位号
		private var mDiPais:Array = [];			//三张底牌
		
		private var mCurrentLogicSeatID:int = GameDefine.INVALID_SEAT_ID;	//当前操作的玩家的座位号，逻辑座位号
		private var mStartLogicSeatID:int = GameDefine.INVALID_SEAT_ID;		//第一个开始操作的玩家的逻辑座位号
		private var mJiaoLogicSeatID:int = GameDefine.INVALID_SEAT_ID;		//叫地主的逻辑座位号
		private var mQiangLogicSeatID:int = GameDefine.INVALID_SEAT_ID;		//抢地主的逻辑座位号
		private var mLordLogicSeatID:int = GameDefine.INVALID_SEAT_ID;		//地主的逻辑座位号
		
		private var mTimer:Timer;
		
		public function GameLogic() 
		{
			if (!gGameLogic)
				gGameLogic = this;
			else
				throw new Error("单例模式，直接使用静态变量gGameLogic");
			
			Init();
		}
		
		//初始化
		private function Init():void
		{
			//三个玩家的手牌
			for (var i:int = 0; i < 3; i++)
			{
				var playerData:PlayerData = new PlayerData;
				mPlayerDatas.push(playerData);
			}
			
			//操作用的定时器
			mTimer = new Timer(3 * 1000);
			mTimer.addEventListener(TimerEvent.TIMER, OnTimer);
		}
		
		//游戏开始
		public function GameStart():void
		{
			//分配玩家的逻辑座位号
			GameData.gGameData.mSelfLogicSeatID = 0;
			
			//洗牌
			var pokerValues:Array = PokerHelp.Shuffle();
			
			//发牌
			(mPlayerDatas[0] as PlayerData).mHandPokers = pokerValues.slice(0, 17);
			(mPlayerDatas[1] as PlayerData).mHandPokers = pokerValues.slice(17, 34);
			(mPlayerDatas[2] as PlayerData).mHandPokers = pokerValues.slice(34, 51);
			mDiPais = pokerValues.slice(51, 54);
			
			//排序
			PokerHelp.SortByValue((mPlayerDatas[0] as PlayerData).mHandPokers);
			PokerHelp.SortByValue((mPlayerDatas[1] as PlayerData).mHandPokers);
			PokerHelp.SortByValue((mPlayerDatas[2] as PlayerData).mHandPokers);
			
			//游戏状态--游戏开始
			GameData.gGameData.mGameState = GameData.STATE_GAMESTART;
			
			//设置定时器
			mTimer.delay = 3.5 * 1000;
			mTimer.reset();
			mTimer.start();
			
			//更新界面
			DouDiZhu.sDouDiZhu.GameStart(mPlayerDatas[0].mHandPokers, mPlayerDatas[1].mHandPokers, mPlayerDatas[2].mHandPokers);
			OperateStateLayer.sOperateStateLayer.SetThreePokers([0x00, 0x00, 0x00]);
		}
		
		//开始叫地主
		public function JiaoDiZhuStart():void
		{
			//游戏状态--叫地主
			GameData.gGameData.mGameState = GameData.STATE_JIAO;
			
			//随机一个玩家叫地主
			mStartLogicSeatID = (int(Math.random() * 10)) % 3;
			mCurrentLogicSeatID = mStartLogicSeatID;
			
			OperateStateLayer.sOperateStateLayer.SetCountdown(mCurrentLogicSeatID, 20);
			if (mCurrentLogicSeatID == 0)
				OperateLayer.sOperateLayer.SetJiao();
			else
			{
				mTimer.delay = 3 * 1000;
				mTimer.reset();
				mTimer.start();
			}
		}
		
		//叫地主操作
		public function JiaoDiZhu(bJiao:Boolean):void
		{
			if (bJiao)
			{
				OperateStateLayer.sOperateStateLayer.SetState(mCurrentLogicSeatID, "叫地主");
				
				//叫地主的玩家逻辑座位号
				mJiaoLogicSeatID = mCurrentLogicSeatID;
				
				QiangDiZhuStart();
			}
			else
			{
				OperateStateLayer.sOperateStateLayer.SetState(mCurrentLogicSeatID, "不叫");
				
				mCurrentLogicSeatID = (mCurrentLogicSeatID + 1) % 3;
				
				if (mCurrentLogicSeatID == mStartLogicSeatID && mJiaoLogicSeatID == GameDefine.INVALID_SEAT_ID)
				{
					//游戏结束--没人叫地主
				}
				else
				{
					OperateStateLayer.sOperateStateLayer.SetCountdown(mCurrentLogicSeatID, 20);
					OperateStateLayer.sOperateStateLayer.SetState(mCurrentLogicSeatID, "");
					if (mCurrentLogicSeatID == 0)
						OperateLayer.sOperateLayer.SetJiao();
					else
					{
						mTimer.reset();
						mTimer.start();
					}
				}
			}
		}
		
		//抢地主开始
		public function QiangDiZhuStart():void
		{
			//游戏状态--抢地主
			GameData.gGameData.mGameState = GameData.STATE_QIANG;
			
			//抢地主玩家的座位号
			mCurrentLogicSeatID = (mJiaoLogicSeatID + 1) % 3;
			OperateStateLayer.sOperateStateLayer.SetCountdown(mCurrentLogicSeatID, 20);
			if (mCurrentLogicSeatID == 0)
				OperateLayer.sOperateLayer.SetQiang();
			else
			{
				mTimer.reset();
				mTimer.start();
			}
		}
		
		//抢地主
		public function QiangDiZhu(bQiang:Boolean):void
		{
			if (mCurrentLogicSeatID == mJiaoLogicSeatID && bQiang)	//叫地主的玩家也抢地主
			{
				//抢地主成功
				OperateStateLayer.sOperateStateLayer.SetState(mCurrentLogicSeatID, "抢地主");
				QiangDiZhuSuccess(mJiaoLogicSeatID);
				return;
			}
			else if (mCurrentLogicSeatID == mJiaoLogicSeatID && !bQiang)	//最后一个抢地主的为地主
			{
				//抢地主成功
				OperateStateLayer.sOperateStateLayer.SetState(mCurrentLogicSeatID, "不抢");
				QiangDiZhuSuccess(mQiangLogicSeatID);
				return;
			}
			
			if (bQiang)
			{
				OperateStateLayer.sOperateStateLayer.SetState(mCurrentLogicSeatID, "抢地主");
				
				mQiangLogicSeatID = mCurrentLogicSeatID;
				
				mCurrentLogicSeatID = (mCurrentLogicSeatID + 1) % 3;
				OperateStateLayer.sOperateStateLayer.SetCountdown(mCurrentLogicSeatID, 20);
				OperateStateLayer.sOperateStateLayer.SetState(mCurrentLogicSeatID, "");
				if (mCurrentLogicSeatID == 0)
					OperateLayer.sOperateLayer.SetQiang();
				else
				{
					mTimer.reset();
					mTimer.start();
				}
			}
			else
			{
				OperateStateLayer.sOperateStateLayer.SetState(mCurrentLogicSeatID, "不抢");
				
				mCurrentLogicSeatID = (mCurrentLogicSeatID + 1) % 3;
				
				if (mCurrentLogicSeatID == mJiaoLogicSeatID && mQiangLogicSeatID == GameDefine.INVALID_SEAT_ID)	//没人抢地主，地主是叫地主的那个玩家
				{
					//抢地主成功
					QiangDiZhuSuccess(mJiaoLogicSeatID);
				}
				else
				{
					OperateStateLayer.sOperateStateLayer.SetCountdown(mCurrentLogicSeatID, 20);
					OperateStateLayer.sOperateStateLayer.SetState(mCurrentLogicSeatID, "");
					if (mCurrentLogicSeatID == 0)
						OperateLayer.sOperateLayer.SetQiang();
					else
					{
						mTimer.reset();
						mTimer.start();
					}
				}				
			}
		}
		
		//抢地主成功
		public function QiangDiZhuSuccess(lordLogicSeatID:int):void
		{
			//游戏状态--打牌
			GameData.gGameData.mGameState = GameData.STATE_PLAYCARD;
			
			//翻开底牌
			OperateStateLayer.sOperateStateLayer.SetThreePokers(mDiPais);
			GameData.gGameData.mDiPais = mDiPais.slice(0);
			
			//手牌添加3张底牌并排序
			(GameData.gGameData.mPlayerDatas[lordLogicSeatID] as PlayerData).mHandPokers.push(mDiPais[0], mDiPais[1], mDiPais[2]);
			PokerHelp.SortByValue((GameData.gGameData.mPlayerDatas[lordLogicSeatID] as PlayerData).mHandPokers);
			PokerManagerLayer.sPokerManagerLayer.InsertPokers(lordLogicSeatID, mDiPais);
			
			//设置操作时间
			OperateStateLayer.sOperateStateLayer.SetCountdown(lordLogicSeatID, 20);
		}
		
		//定时器操作
		private function OnTimer(e:TimerEvent):void
		{
			mTimer.stop();
			
			switch(GameData.gGameData.mGameState)
			{
				case GameData.STATE_GAMESTART:
					JiaoDiZhuStart();
					break;
				case GameData.STATE_JIAO:
					var bJiao:Boolean = Boolean((int(Math.random() * 10)) % 2);
					JiaoDiZhu(bJiao);
					break;
				case GameData.STATE_QIANG:
					var bQiang:Boolean = Boolean((int(Math.random() * 10)) % 2);
					QiangDiZhu(bQiang);
					break;
				case GameData.STATE_PLAYCARD:
					break;
			}
		}
	}
}