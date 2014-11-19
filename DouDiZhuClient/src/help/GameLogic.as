package help 
{
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
		
		private var mLastWinLogicSeatID:int = GameDefine.INVALID_SEAT_ID;	//上一个打牌玩家的座位号（逻辑座位号）
		private var mLastWinCards:Array = [];								//上一个打牌玩家打的牌
		
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
		
		//游戏开始
		public function GameStart():void
		{
			//重置数据
			GameReset();
		}
		
		//叫地主
		public function JiaoDiZhu(jiaoLogicSeatID:int, bJiao:Boolean):void
		{
			//如果叫地主，存储叫地主的玩家逻辑座位号
			if (bJiao)
				mJiaoLogicSeatID = jiaoLogicSeatID;
		}
		
		//抢地主
		public function QiangDiZhu(qiangLogicSeatID:int, bQiang:Boolean):void
		{
			//如果抢地主，存储最后抢地主的玩家逻辑座位号
			if (bQiang)
				mQiangLogicSeatID = qiangLogicSeatID;
		}
		
		//抢地主成功
		public function QiangDiZhuSuccess(lordLogicSeatID:int):void
		{
			mLordLogicSeatID = lordLogicSeatID;
			mCurrentLogicSeatID = mLordLogicSeatID;
		}
		
		//出牌成功
		public function OutCardSuccess(outLogicSeatID:int, pokerValues:Array):void
		{
			mLastWinLogicSeatID = outLogicSeatID;
			mLastWinCards = pokerValues.slice(0);
		}
	}
}