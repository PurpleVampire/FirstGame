package help 
{
	/**
	 * 游戏数据
	 * @author Vampire
	 */
	public class GameData 
	{
		public static var gGameData:GameData = new GameData;	//单例模式
		
		public var mPlayerDatas:Array = [];	//视图座位号
		public var mDiPais:Array = [];		//3张底牌
		
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