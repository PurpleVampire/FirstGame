package help 
{
	/**
	 * 扑克帮助类
	 * @author Vampire
	 */
	public class PokerHelp 
	{
		public static var CardValues:Array = [
			0x11, 0x21, 0x31, 0x41, 0x51, 0x61, 0x71, 0x81, 0x91, 0xa1, 0xb1, 0xc1, 0xd1,	// 方块3--2
			0x12, 0x22, 0x32, 0x42, 0x52, 0x62, 0x72, 0x82, 0x92, 0xa2, 0xb2, 0xc2, 0xd2,	// 梅花3--2
			0x13, 0x23, 0x33, 0x43, 0x53, 0x63, 0x73, 0x83, 0x93, 0xa3, 0xb3, 0xc3, 0xd3,	// 红桃3--2
			0x14, 0x24, 0x34, 0x44, 0x54, 0x64, 0x74, 0x84, 0x94, 0xa4, 0xb4, 0xc4, 0xd4,	// 黑桃3--2
			0xe5, 0xf5];																	// 小王、大王
		
		public function PokerHelp() 
		{
		}
		
		//洗牌
		public static function Shuffle():Array
		{
			//得到一副牌的数量（有的54张，有的去掉大小王，有的没有大小王和3、4、5）
			var cardCount:int = CardValues.length;
			
			for (var i:int = 0; i < cardCount; i++)
			{
				//i-(cardCount-1)之间的随机数
				var j:int = Math.round(Math.random() * ((cardCount - 1) - i)) + i;
				
				//交换值
				var temp:Number = CardValues[i];
				CardValues[i] = CardValues[j];
				CardValues[j] = temp;
			}
			
			return CardValues;
		}
		
		//按照牌值排序(冒泡法，从大到小排序)
		public static function SortByValue(pokerValues:Array):void
		{
			for (var m:int = 0; m < (pokerValues.length - 1); m++)
			{
				for (var n:int = m+1; n < pokerValues.length; n++)
				{
					var temp:Number = 0xff;
					
					if (pokerValues[n] > pokerValues[m])
					{
						temp = pokerValues[m];
						pokerValues[m] = pokerValues[n];
						pokerValues[n] = temp;
					}
				}
			}
		}
	}
}