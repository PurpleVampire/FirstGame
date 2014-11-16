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
		
		private var mLastWinSeat:int = GameDefine.INVALID_SEAT_ID;	//上一个打牌玩家的座位号（逻辑座位号）
		private var mLastWinCards:Array = [];						//上一个打牌玩家打的牌
		
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
			
			//设置定时器
			mTimer.delay = 3.5 * 1000;
			mTimer.reset();
			mTimer.start();
			
			//更新界面
			DouDiZhu.sDouDiZhu.GameStart(0, mPlayerDatas[0].mHandPokers, mPlayerDatas[1].mHandPokers, mPlayerDatas[2].mHandPokers);
			OperateStateLayer.sOperateStateLayer.SetThreePokers([0x00, 0x00, 0x00]);
		}
		
		//叫地主
		public function JiaoDiZhu(jiaoLogicSeatID:int, bJiao:Boolean, nextLogicSeatID:int):void
		{
			if (bJiao)
			{
				//叫地主的玩家逻辑座位号
				mJiaoLogicSeatID = jiaoLogicSeatID;
				QiangDiZhuStart();
			}
			else
			{
				mCurrentLogicSeatID = nextLogicSeatID;
				if (nextLogicSeatID == mStartLogicSeatID && mJiaoLogicSeatID == GameDefine.INVALID_SEAT_ID)
				{
					//游戏结束--没人叫地主
				}
				else
				{
					//是否需要启动机器人
					if(nextLogicSeatID != 0)
					{
						mTimer.reset();
						mTimer.start();
					}
				}
			}
		}
		
		//抢地主
		public function QiangDiZhu(qiangLogicSeatID:int, bQiang:Boolean, nextLogicSeatID:int):void
		{
			if (bQiang)
			{
				mQiangLogicSeatID = qiangLogicSeatID;
				mCurrentLogicSeatID = nextLogicSeatID;
				
				//叫地主的玩家也抢了地主
				if (qiangLogicSeatID == mJiaoLogicSeatID)	
					DouDiZhu.sDouDiZhu.QiangDiZhuSuccess(mJiaoLogicSeatID, mDiPais);
				else
				{
					//是否需要启动机器人
					if (nextLogicSeatID != 0)
					{
						mTimer.reset();
						mTimer.start();
					}
				}
			}
			else
			{
				mCurrentLogicSeatID = nextLogicSeatID;
				//到叫地主的玩家之前，大家都没抢，则叫地主的成功
				if (nextLogicSeatID == mJiaoLogicSeatID && mQiangLogicSeatID == GameDefine.INVALID_SEAT_ID)
					DouDiZhu.sDouDiZhu.QiangDiZhuSuccess(mJiaoLogicSeatID, mDiPais);
				else if (qiangLogicSeatID == mJiaoLogicSeatID)	//叫地主的玩家没抢，则地主给最后抢的那个人
					DouDiZhu.sDouDiZhu.QiangDiZhuSuccess(mQiangLogicSeatID, mDiPais);
				else
				{
					//是否需要启动机器人
					if(nextLogicSeatID != 0)
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
			mLordLogicSeatID = lordLogicSeatID;
			mCurrentLogicSeatID = mLordLogicSeatID;
			
			//是否需要启动机器人
			if (lordLogicSeatID != 0)
			{
				mTimer.reset();
				mTimer.start();
			}
		}
		
		//出牌成功
		public function OutCardSuccess(outLogicSeatID:int, pokerValues:Array, nextLogicSeatID:int):void
		{
			mLastWinSeat = outLogicSeatID;
			mLastWinCards = pokerValues.slice(0);
			
			mCurrentLogicSeatID = nextLogicSeatID;
			
			if (outLogicSeatID == 0)	//说明是自己出的牌，要启动机器人打牌
			{
				mTimer.reset();
				mTimer.start();
			}
		}
		
		//开始叫地主
		public function JiaoDiZhuStart():void
		{
			//随机一个玩家叫地主
			mStartLogicSeatID = (int(Math.random() * 10)) % 3;
			mCurrentLogicSeatID = mStartLogicSeatID;
			
			//更新界面
			DouDiZhu.sDouDiZhu.JiaoDiZhuStart(mCurrentLogicSeatID);
			
			//是否要启动机器人
			if(mCurrentLogicSeatID != 0)
			{
				mTimer.delay = 3 * 1000;
				mTimer.reset();
				mTimer.start();
			}
		}
		
		//抢地主开始
		public function QiangDiZhuStart():void
		{
			//抢地主玩家的座位号
			mCurrentLogicSeatID = (mJiaoLogicSeatID + 1) % 3;
			
			//更新界面
			DouDiZhu.sDouDiZhu.QiangDiZhuStart(mCurrentLogicSeatID);
			
			//是否需要启动机器人
			if(mCurrentLogicSeatID != 0)
			{
				mTimer.reset();
				mTimer.start();
			}
		}
		
		//机器人叫地主操作
		public function RobotJiaoDiZhu():void
		{
			var bJiao:Boolean = Boolean((int(Math.random() * 10)) % 2);
			var nextLogicSeatID:int = (mCurrentLogicSeatID + 1) % 3;
			DouDiZhu.sDouDiZhu.JiaoDiZhu(mCurrentLogicSeatID, bJiao, nextLogicSeatID);
		}
		
		//机器人抢地主操作
		public function RobotQiangDiZhu():void
		{
			var bQiang:Boolean = Boolean((int(Math.random() * 10)) % 2);
			var nextLogicSeatID:int = (mCurrentLogicSeatID + 1) % 3;
			DouDiZhu.sDouDiZhu.QiangDiZhu(mCurrentLogicSeatID, bQiang, nextLogicSeatID);
		}
		
		//机器人打牌
		private function RobotPlayCard():void
		{
			//暂时定义随便打一张牌
			var playerData:PlayerData = mPlayerDatas[mCurrentLogicSeatID] as PlayerData;
			var nextLogicSeatID:int = (mCurrentLogicSeatID + 1) % 3;
			DouDiZhu.sDouDiZhu.OutCard(mCurrentLogicSeatID, [playerData.mHandPokers[playerData.mHandPokers.length - 1]], nextLogicSeatID);
			
			//移除这张牌
			playerData.mHandPokers.splice(playerData.mHandPokers.length - 1, 1);
			
			//如果下一个仍是机器人，启动计时器
			if (nextLogicSeatID != 0)
			{
				mTimer.reset();
				mTimer.start();
			}
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
					RobotJiaoDiZhu();
					break;
				case GameData.STATE_QIANG:
					RobotQiangDiZhu();
					break;
				case GameData.STATE_PLAYCARD:
					RobotPlayCard();
					break;
			}
		}
	}
}