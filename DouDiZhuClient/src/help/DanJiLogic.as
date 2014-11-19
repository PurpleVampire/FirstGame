package help 
{
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import game.DouDiZhu;
	/**
	 * 单机版的逻辑，主要处理机器人打牌
	 * @author Vampire
	 */
	public class DanJiLogic 
	{
		public static var sDanJiLogic:DanJiLogic = new DanJiLogic;	//单例模式
		
		private var mPlayerDatas:Array = [];	//三个玩家的手牌数据，逻辑座位号
		private var mDiPais:Array = [];			//三张底牌
		
		private var mCurrentLogicSeatID:int = GameDefine.INVALID_SEAT_ID;	//当前操作的玩家的座位号，逻辑座位号
		private var mStartLogicSeatID:int = GameDefine.INVALID_SEAT_ID;		//第一个开始操作的玩家的逻辑座位号
		private var mJiaoLogicSeatID:int = GameDefine.INVALID_SEAT_ID;		//叫地主的逻辑座位号
		private var mQiangLogicSeatID:int = GameDefine.INVALID_SEAT_ID;		//抢地主的逻辑座位号
		private var mLordLogicSeatID:int = GameDefine.INVALID_SEAT_ID;		//地主的逻辑座位号
		
		private var mLastWinLogicSeatID:int = GameDefine.INVALID_SEAT_ID;	//上一个打牌玩家的座位号（逻辑座位号）
		private var mLastWinCards:Array = [];								//上一个打牌玩家打的牌
		
		private var mTimer:Timer;				//控制机器人打牌的定时器
		
		public function DanJiLogic() 
		{
			if (!sDanJiLogic)
				sDanJiLogic = this;
			else
				throw new Error("单例模式，直接使用静态变量sDanJiLogic");
			
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
		
		//重置数据
		public function GameReset():void
		{
			//清空3个玩家的数据
			for (var i:int = 0; i < mPlayerDatas.length; i++)
			{
				var playerData:PlayerData = mPlayerDatas[i] as PlayerData;
				playerData.mHandPokers.splice(0);
			}
			
			//清空3张底牌
			mDiPais.splice(0);
			
			mCurrentLogicSeatID = GameDefine.INVALID_SEAT_ID;
			mStartLogicSeatID = GameDefine.INVALID_SEAT_ID;
			mJiaoLogicSeatID = GameDefine.INVALID_SEAT_ID;	
			mQiangLogicSeatID = GameDefine.INVALID_SEAT_ID;
			mLordLogicSeatID = GameDefine.INVALID_SEAT_ID;
			
			mLastWinLogicSeatID = GameDefine.INVALID_SEAT_ID;
			mLastWinCards.splice(0);
		}
		
		//单机版斗地主游戏开始
		public function GameStart():void
		{
			//重置数据
			GameReset();
			
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
			
			//向客户端广播
			DouDiZhu.sDouDiZhu.GameStart(0, mPlayerDatas[0].mHandPokers, mPlayerDatas[1].mHandPokers, mPlayerDatas[2].mHandPokers);
		}
		
		//开始叫地主
		public function JiaoDiZhuStart():void
		{
			//随机一个玩家叫地主
			mStartLogicSeatID = (int(Math.random() * 10)) % 3;
			mCurrentLogicSeatID = mStartLogicSeatID;
			
			//是否要启动机器人
			if(mCurrentLogicSeatID != 0)
			{
				mTimer.delay = 3 * 1000;
				mTimer.reset();
				mTimer.start();
			}
			
			//向客户端广播
			DouDiZhu.sDouDiZhu.JiaoDiZhuStart(mCurrentLogicSeatID);
		}
		
		//叫地主
		public function JiaoDiZhu(jiaoLogicSeatID:int, bJiao:Boolean):void
		{
			//向客户端广播
			DouDiZhu.sDouDiZhu.JiaoDiZhu(jiaoLogicSeatID, bJiao);
			
			if (bJiao)
			{
				//叫地主的玩家逻辑座位号
				mJiaoLogicSeatID = jiaoLogicSeatID;
				QiangDiZhuStart();
			}
			else
			{
				mCurrentLogicSeatID = (jiaoLogicSeatID + 1) % 3;
				if (mCurrentLogicSeatID == mStartLogicSeatID && mJiaoLogicSeatID == GameDefine.INVALID_SEAT_ID)
				{
					//游戏结束--没人叫地主
				}
				else
				{
					//是否需要启动机器人
					if(mCurrentLogicSeatID != 0)
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
			//抢地主玩家的座位号
			mCurrentLogicSeatID = (mJiaoLogicSeatID + 1) % 3;
			
			//是否需要启动机器人
			if(mCurrentLogicSeatID != 0)
			{
				mTimer.reset();
				mTimer.start();
			}
			
			//向客户端广播
			DouDiZhu.sDouDiZhu.QiangDiZhuStart(mCurrentLogicSeatID);
		}
		
		//抢地主
		public function QiangDiZhu(qiangLogicSeatID:int, bQiang:Boolean):void
		{
			//向客户端广播
			DouDiZhu.sDouDiZhu.QiangDiZhu(qiangLogicSeatID, bQiang);
			
			if (bQiang)
			{
				mQiangLogicSeatID = qiangLogicSeatID;
				mCurrentLogicSeatID = (qiangLogicSeatID + 1) % 3;
				
				//叫地主的玩家也抢了地主
				if (qiangLogicSeatID == mJiaoLogicSeatID)	
					QiangDiZhuSuccess(mJiaoLogicSeatID);
				else
				{
					//是否需要启动机器人
					if (mCurrentLogicSeatID != 0)
					{
						mTimer.reset();
						mTimer.start();
					}
				}
			}
			else
			{
				mCurrentLogicSeatID = (qiangLogicSeatID + 1) % 3;;
				//到叫地主的玩家之前，大家都没抢，则叫地主的成功
				if (mCurrentLogicSeatID == mJiaoLogicSeatID && mQiangLogicSeatID == GameDefine.INVALID_SEAT_ID)
					QiangDiZhuSuccess(mJiaoLogicSeatID);
				else if (qiangLogicSeatID == mJiaoLogicSeatID)	//叫地主的玩家没抢，则地主给最后抢的那个人
					QiangDiZhuSuccess(mQiangLogicSeatID);
				else
				{
					//是否需要启动机器人
					if(mCurrentLogicSeatID != 0)
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
			
			//向客户端广播
			DouDiZhu.sDouDiZhu.QiangDiZhuSuccess(lordLogicSeatID, mDiPais);
		}
		
		//出牌
		public function OutCard(outLogicSeatID:int, pokerValues:Array):void
		{
			mLastWinLogicSeatID = outLogicSeatID;
			mLastWinCards = pokerValues.slice(0);
			mCurrentLogicSeatID = (outLogicSeatID + 1) % 3;
			
			if (outLogicSeatID == 0)	//说明是自己出的牌，要启动机器人打牌
			{
				mTimer.reset();
				mTimer.start();
			}
			
			//向客户端广播
			DouDiZhu.sDouDiZhu.OutCard(outLogicSeatID, pokerValues);
		}
		
		//机器人叫地主操作
		public function RobotJiaoDiZhu():void
		{
			var bJiao:Boolean = Boolean((int(Math.random() * 10)) % 2);
			JiaoDiZhu(mCurrentLogicSeatID, bJiao);
		}
		
		//机器人抢地主操作
		public function RobotQiangDiZhu():void
		{
			var bQiang:Boolean = Boolean((int(Math.random() * 10)) % 2);
			QiangDiZhu(mCurrentLogicSeatID, bQiang);
		}
		
		//机器人打牌
		private function RobotOutCard():void
		{
			//暂时定义随便打一张牌
			var playerData:PlayerData = mPlayerDatas[mCurrentLogicSeatID] as PlayerData;
			var nextLogicSeatID:int = (mCurrentLogicSeatID + 1) % 3;
			OutCard(mCurrentLogicSeatID, [playerData.mHandPokers[playerData.mHandPokers.length - 1]]);
			
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
					RobotOutCard();
					break;
			}
		}
	}
}