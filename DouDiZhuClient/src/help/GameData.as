package help 
{
	/**
	 * 游戏数据
	 * @author Vampire
	 */
	public class GameData 
	{
		public static var gGameData:GameData = new GameData;	//单例模式
		
		public static const STATE_GAMESTART:int = 0;	//游戏开始
		public static const STATE_JIAO:int = 1;			//叫地主阶段
		public static const STATE_QIANG:int = 2;		//抢地主阶段
		public static const STATE_PLAYCARD:int = 3;		//打牌阶段
		
		public var mGameState:int = 0;			//游戏阶段
		
		public var mSelfLogicSeatID:int = 0;	//自身的逻辑座位号
		
		public var mPlayerDatas:Array = [];		//视图座位号
		public var mDiPais:Array = [];			//3张底牌
		
		public function GameData() 
		{
			if (!gGameData)
				gGameData = this;
			else
				throw new Error("单例模式，直接使用静态变量gGameData");
			
			Init();
		}
		
		//初始化
		private function Init():void
		{
			for (var i:int = 0; i < 3; i++)
			{
				var playerData:PlayerData = new PlayerData;
				mPlayerDatas.push(playerData);
			}
		}
	}
}