package help 
{
	/**
	 * 游戏帮助类（常用的函数的集合）
	 * @author Vampire
	 */
	public class GameHelp 
	{
		private var mPlayerNumber:int;	//该游戏参与的玩家的数量
		
		public function GameHelp(playerNumber:int) 
		{
			mPlayerNumber = playerNumber;
		}
		
		//逻辑座位转换为视图座位（参数1：需要转换的玩家的逻辑座位号  参数2：游戏者本身（视图座位号为0）的逻辑座位号）
		public function GetViewSeatByLogicSeat(logicSeatID:int, selfLogicSeatID:int):int
		{
			var viewSeat:int = (logicSeatID - selfLogicSeatID + mPlayerNumber) % mPlayerNumber;
			
			return viewSeat;
		}
		
		//视图座位转换为逻辑座位（参数1：需要转换的玩家的视图座位号  参数2：游戏者本身（视图座位号为0）的逻辑座位号）
		public function GetLogicSeatByViewSeat(viewSeatID:int, selfLogicSeatID:int):int
		{
			var logicSeat:int = (viewSeatID + selfLogicSeatID) % mPlayerNumber;
			
			return logicSeat;
		}
	}
}