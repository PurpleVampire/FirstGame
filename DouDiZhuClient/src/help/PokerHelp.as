package help 
{
	/**
	 * 扑克帮助类
	 * @author Vampire
	 */
	public class PokerHelp 
	{
		//牌值定义
		public static var CardValues:Array = [
			0x11, 0x21, 0x31, 0x41, 0x51, 0x61, 0x71, 0x81, 0x91, 0xa1, 0xb1, 0xc1, 0xd1,	// 方块3--2
			0x12, 0x22, 0x32, 0x42, 0x52, 0x62, 0x72, 0x82, 0x92, 0xa2, 0xb2, 0xc2, 0xd2,	// 梅花3--2
			0x13, 0x23, 0x33, 0x43, 0x53, 0x63, 0x73, 0x83, 0x93, 0xa3, 0xb3, 0xc3, 0xd3,	// 红桃3--2
			0x14, 0x24, 0x34, 0x44, 0x54, 0x64, 0x74, 0x84, 0x94, 0xa4, 0xb4, 0xc4, 0xd4,	// 黑桃3--2
			0xe5, 0xf5];																	// 小王、大王
		
		//牌型定义
		{
			private const CARD_ERROR:int = 0;			//错误的牌型
			
			private const CARD_ONE:int = 1;				//任意1张单牌
			private const CARD_TWO:int = 2;				//任意2张点数相同的牌
			private const CARD_THREE:int = 3;			//任意3张点数相同的牌
			private const CARD_FOUR:int = 4;			//任意4张点数相同的牌
			
			private const CARD_LINE_1:int = 5;			//单龙 3张或3张以上点数相连的牌，2不能出现在龙的牌型中
			private const CARD_LINE_2:int = 6;			//双龙 3张或3张以上点数相连的牌，2不能出现在龙的牌型中
			
			private const CARD_THREE_1:int = 7;			//3带单张
			private const CARD_THREE_2:int = 8;			//3带一对
			
			private const CARD_FOUR_1:int = 9;			//4带单张
			private const CARD_FOUR_DOUBLE:int = 10;	//4带一对
			private const CARD_FOUR_TWOSINGLE:int = 11;	//4带2张单
			
			private const CARD_PLANE_1:int = 12;		//飞机带翅膀（带2张单）
			private const CARD_PLANE_2:int = 13;		//飞机带翅膀（带2对子）
			
			private const CARD_ROCKET:int = 16;			//火箭
		}
		
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
		
		//按照牌值相同的牌的数量排序
		public static function SortByCount(pokerValues:Array):Array
		{
			var pokers:Array = [];
			
			//先分别获取
			var oneCards:Array = GetCardsWithNumber(pokerValues, 1);
			var twoCards:Array = GetCardsWithNumber(pokerValues, 2);
			var threeCards:Array = GetCardsWithNumber(pokerValues, 3);
			var fourCards:Array = GetCardsWithNumber(pokerValues, 4);
			
			//赋值
			pokers = pokers.concat(fourCards.slice(0));
			pokers = pokers.concat(threeCards.slice(0));
			pokers = pokers.concat(twoCards.slice(0));
			pokers = pokers.concat(oneCards.slice(0));
			
			return pokers;
		}
		
		//得到所给的牌中数量为number的所有牌（该函数返回的是准确数量，比如要2张的，如果有3个3，则不取3的值，因为3有3张）
		public static function GetCardsWithNumber(pokerValues:Array, number:int):Array
		{
			var pokers:Array = [];
			
			//先进行牌值排序
			SortByValue(pokerValues);
			
			//开始查找
			var pokerValue1:int, pokerValue2:int, frontPokerValue:int, backPokerValue:int;
			for (var i:int = 0; i < pokerValues.length - number + 1; )
			{
				if (i == 0)	//第一轮查找，不用判断前一张扑克牌	
				{
					pokerValue1 = pokerValues[i] >> 4;
					pokerValue2 = pokerValues[i + number - 1] >> 4;
					backPokerValue = pokerValues[i + number] >> 4;
					if (pokerValue1 == pokerValue2 && pokerValue1 != backPokerValue)
					{
						pokers = pokers.concat(pokerValues.slice(i, i + number));
						i += number;
					}
					else
						i++;
				}
				else if ((i + number) == pokerValues.length)//查找的最后一轮，不用判断后一张扑克牌
				{
					pokerValue1 = pokerValues[i] >> 4;
					pokerValue2 = pokerValues[i + number - 1] >> 4;
					frontPokerValue = pokerValues[i - 1] >> 4;
					if (pokerValue1 == pokerValue2 && pokerValue1 != frontPokerValue)
					{
						pokers = pokers.concat(pokerValues.slice(i, i+number));
						i += number
					}	
					else
						i++;
				}
				else
				{
					pokerValue1 = pokerValues[i] >> 4;
					pokerValue2 = pokerValues[i + number - 1] >> 4;
					frontPokerValue = pokerValues[i - 1] >> 4;
					backPokerValue = pokerValues[i + number] >> 4;
					if (pokerValue1 == pokerValue2 && pokerValue1 != frontPokerValue && pokerValue1 != backPokerValue)
					{
						pokers = pokers.concat(pokerValues.slice(i, i + number));
						i += number;
					}
					else
						i++;
				}
			}
			
			return pokers;
		}
		
		//将所给的牌中取出能够满足数量要求的所有牌（该函数返回的是满足数量的，比如要2张的，如果有3个3，则取从小到大拿2张3）
		public function GetNumberCardFromCards(pokerValues:Array, number:int):Array
		{
			var pokers:Array = [];
			
			//先进行数量排序
			pokerValues = SortByCount(pokerValues);
			
			//开始查找
			var pokerValue1:int, pokerValue2:int, frontPokerValue:int;
			for (var i:int = pokerValues.length - 1; i >= number - 1; )
			{
				if (i == (pokerValues.length - 1))
				{
					pokerValue1 = pokerValues[i] >> 4;
					pokerValue2 = pokerValues[i - number + 1] >> 4; 
					if (pokerValue1 == pokerValue2)
					{
						pokers = pokers.concat(pokerValues.slice(i - number + 1, i + 1));
						i -= number;
					}
					else
						i--;
				}
				else
				{
					pokerValue1 = pokerValues[i] >> 4;
					pokerValue2 = pokerValues[i - number + 1] >> 4;
					frontPokerValue = pokerValues[i + 1] >> 4;
					if (pokerValue1 == pokerValue2 && pokerValue1 != frontPokerValue)
					{
						pokers = pokers.concat(pokerValues.slice(i - number + 1, i + 1));
						i -= number;
					}
					else
						i--;
				}
			}
			
			return pokers;
		}
		
		//看是否可以出这手牌
		public function CanOutCard(lastWinCards:Array, outCards:Array):Boolean
		{
			var bRet:Boolean = false;
			
			//检查是否为非法牌型
			var outCardType:int = GetCardType(outCards);
			if (outCardType == CARD_ERROR)
				return false;
			
			//第一手出牌
			if (lastWinCards.length == 0)
				return true;
			
			//不是第一手出牌，则有数量，判断数量是否相同
			if (lastWinCards.length != outCards.length)
				return false;
			
			var lastWinCardType:int = GetCardType(lastWinCards);
			if (lastWinCardType == outCardType)	//类型一样
			{
				//直接比较最大牌的牌值
				if ((outCards[0] >> 4) > (lastWinCards[0] >> 4))
					return true;
			}
			else//类型不一样
			{
				if (lastWinCardType == CARD_ONE || lastWinCardType == CARD_TWO || lastWinCardType == CARD_THREE ||
					lastWinCardType == CARD_LINE_1 || lastWinCardType == CARD_LINE_2 || CARD_THREE_1 || CARD_THREE_2 ||
					CARD_FOUR_1 || CARD_FOUR_DOUBLE || CARD_FOUR_TWOSINGLE || CARD_PLANE_1 || CARD_PLANE_2)
				{
					if (outCardType == CARD_FOUR || outCardType == CARD_ROCKET)
						return true;
				}
				else if (lastWinCardType == CARD_FOUR)
				{
					if (outCardType == CARD_ROCKET)
						return true;
				}
			}
			
			return bRet;
		}
		
		//得到牌的类型
		public function GetCardType(pokerValues:Array):int
		{
			var cardType:int = CARD_ERROR;
			var cardCount:int = pokerValues.length;
			
			switch(cardCount)
			{
				case 1:					//单牌
					cardType = CARD_ONE;
					break;
				case 2:					//对子、火箭
					if ((pokerValues[0] >> 4) == (pokerValues[1] >> 4))
						cardType = CARD_TWO;
					else if (pokerValues[0] == 0xf5 && pokerValues[1] == 0xe5)
						cardType = CARD_ROCKET;
					break;
				case 3:					//三张
					if (((pokerValues[0] >> 4) == (pokerValues[1] >> 4)) && ((pokerValues[0] >> 4) == (pokerValues[2] >> 4)))
						cardType = CARD_THREE;
					break;
				case 4:					//四张、三带一
					if (((pokerValues[0] >> 4) == (pokerValues[1] >> 4)) && ((pokerValues[0] >> 4) == (pokerValues[2] >> 4)) && ((pokerValues[0] >> 4) == (pokerValues[3] >> 4)))
						cardType = CARD_FOUR;
					else if (Is3Dai1(pokerValues))
						cardType = CARD_THREE_1;
					break;
				case 5:					//单连牌、三带二、四带一
					if (IsLineCard(pokerValues, 1))
						cardType = CARD_LINE_1;
					else if (Is3Dai2(pokerValues))
						cardType = CARD_THREE_2;
					else if (Is4Dai1(pokerValues))
						cardType = CARD_FOUR_1;
					break;
				case 6:					//单连牌、双连牌、4带一对、4带2张单
					if (IsLineCard(pokerValues, 1))
						cardType = CARD_LINE_1;
					else if (IsLineCard(pokerValues, 2))
						cardType = CARD_LINE_2;
					else if (Is4Dai2(pokerValues))
						cardType = CARD_FOUR_DOUBLE;
					else if (Is4DaiTwoSingle(pokerValues))
						cardType = CARD_FOUR_TWOSINGLE;
					break;
				case 7:					//单连牌
				case 9:
				case 11:
				case 13:
				case 15:
				case 17:
					if (IsLineCard(pokerValues, 1))
						cardType = CARD_LINE_1;
					break;
				case 8:					//单连牌、双连牌、飞机带翅膀（2张单）
					if (IsLineCard(pokerValues, 1))
						cardType = CARD_LINE_1;
					else if (IsLineCard(pokerValues, 2))
						cardType = CARD_LINE_2;
					else if (IsPlane1(pokerValues))
						cardType = CARD_PLANE_1;
					break;
				case 10:				//单连牌、双连牌、飞机带翅膀（2对子）
					if (IsLineCard(pokerValues, 1))
						cardType = CARD_LINE_1;
					else if (IsLineCard(pokerValues, 2))
						cardType = CARD_LINE_2;
					else if (IsPlane1(pokerValues))
						cardType = CARD_PLANE_2;
					break;
				case 12:				//单连牌、双连牌
				case 14:
				case 16:
					if (IsLineCard(pokerValues, 1))
						cardType = CARD_LINE_1;
					else if (IsLineCard(pokerValues, 2))
						cardType = CARD_LINE_2;
					break;
			}
			
			return cardType;
		}
		
		//是否是3带1
		public function Is3Dai1(pokerValues:Array):Boolean
		{
			var pokers3:Array = [];
			pokers3 = GetCardsWithNumber(pokerValues, 3);
			
			return (pokers3.length == 0) ? false :true;
		}
		
		//是否是3带2
		public function Is3Dai2(pokerValues:Array):Boolean
		{
			var pokers3:Array = [];
			pokers3 = GetCardsWithNumber(pokerValues, 3);
			
			var pokers2:Array = [];
			pokers2 = GetCardsWithNumber(pokerValues, 2);
			
			return (pokers3.length == 0 || pokers2.length == 0) ? false : true;
		}
		
		//是否是4带1
		public function Is4Dai1(pokerValues:Array):Boolean
		{
			var pokers4:Array = [];
			pokers4 = GetCardsWithNumber(pokerValues, 4);
			
			return (pokers4.length == 0) ? false : true;
		}
		
		//是否是4带一对
		public function Is4Dai2(pokerValues:Array):Boolean
		{
			var pokers4:Array = [];
			pokers4 = GetCardsWithNumber(pokerValues, 4);
			
			var pokers2:Array = [];
			pokers2 = GetCardsWithNumber(pokerValues, 2);
			
			return (pokers4.length == 0 || pokers2.length == 0) ? false : true;
		}
		
		//是否是4带2张单
		public function Is4DaiTwoSingle(pokerValues:Array):Boolean
		{
			var pokers4:Array = [];
			pokers4 = GetCardsWithNumber(pokerValues, 4);
			
			var pokers1:Array = [];
			pokers1 = GetCardsWithNumber(pokerValues, 1);
			
			return (pokers4.length == 0 || pokers1.length != 2) ? false : true;
		}
		
		//是否是飞机带翅膀（2张单）
		public function IsPlane1(pokerValues:Array):Boolean
		{
			var pokers3:Array = [];
			pokers3 = GetCardsWithNumber(pokerValues, 3);
			
			//几对3张的
			var count:int = pokers3.length / 3;
			
			//首先判断有没有2对以上的3张牌
			if (count < 2)
				return false;
			
			//判断3张的牌是否连续
			for (var i:int = 0; i < (count - 1); i++)
			{
				if ((pokers3[i*3] >> 4) != ((pokers3[i*3 + 3] >> 4) + 1))
					return false;
			}
			
			return true;
		}
		
		//是否是飞机带翅膀（2对子）
		public function IsPlane2(pokerValues:Array):Boolean
		{
			var pokers3:Array = [];
			pokers3 = GetCardsWithNumber(pokerValues, 3);
			
			var pokers2:Array = [];
			pokers2 = GetCardsWithNumber(pokerValues, 2);
			
			//几对3张，几对2张
			var count3:int = pokers3.length / 3;
			var count2:int = pokers2.length / 2;
			
			//首先判断数量是否满足
			if (count3 < 2 || count2 < 2)
				return false;
				
			//判断3张的牌是否连续
			for (var i:int = 0; i < (count3 - 1); i++)
			{
				if ((pokers3[i*3] >> 4) != ((pokers3[i*3 + 3] >> 4) + 1))
					return false;
			}
			
			return true;
		}
		
		//是否是连子（单连、双连）
		public function IsLineCard(pokerValues:Array, step:int):Boolean
		{	
			var cardCount:int = pokerValues.length;
			
			//如果牌的张数是奇数，则一定是单连，所以步长一定不能为2
			if ((cardCount % 2 != 0) && (step == 2))
				return false;
			
			//牌的张数（连子最多只能3-A，不能有2）
			if (cardCount < 5 || cardCount > 12)
				return false;
			
			//连子不能有2
			if ((pokerValues[0] >> 4) == 13)
				return false;
			
			//如果是双连，首先判断打出的牌是不是相邻2个值相同
			if (step == 2)
			{
				for (var i:int = 0; i < cardCount; i += 2)
				{
					if ((pokerValues[i] >> 4) != (pokerValues[i + 1] >> 4))
						return false;
				}
			}
			
			//判断是否是连续的牌
			for (var j:int = 0; j < (cardCount - step); j += step)
			{
				if ((pokerValues[j] >> 4) != ((pokerValues[j + step] >> 4) + 1))
					return false;
			}
			
			return true;
		}
		
		//得到火箭
		public function GetRocket(pokerValues:Array):Array
		{
			var rocket:Array = [];
			
			//从大到小排序
			SortByValue(pokerValues);
			
			//判断最大的两个是不是大小王即可，是赋值，不是不赋值
			if (pokerValues[0] == 0xf5 && pokerValues[1] == 0xe5)
			{
				rocket.push(pokerValues[0]);
				rocket.push(pokerValues[1]);
			}
			
			return rocket;
		}
		
		private static var mFindSwitch:int = 1;	//提示的查找条件
		//提示出牌
		public function TiShiOutCard(handCards:Array, handCardCount:int, lastWinCards:Array, lastWinCardCount:int, tiShiCards:Array, tiShiCardCount:int):int
		{
			//上一个出牌的玩家出的牌的类型和最大的牌值
			var lastWinCardType:int = GetCardType(lastWinCards);
			var lastWinCardValue:int = lastWinCards[0] >> 4;	
			
			//当前提示的牌的类型和最大的牌值
			var tiShiCardType:int = CARD_ERROR;
			var tiShiCardValue:int = 0;
			var tiShiCard:Number = 0x00;
			if (tiShiCardCount)
			{
				tiShiCardType = GetCardType(tiShiCards);
				tiShiCardValue = tiShiCards[0] >> 4;
				tiShiCard = tiShiCards[0];
			}
			
			//清空提示出牌的数组
			tiShiCards.splice(0);
			
			//查找符合条件的牌
			{
				var bFind:Boolean = false;
				var index:int = 0;
				var oneNumberCards:Array = [];
				var twoNumberCards:Array = [];
				var threeNumberCards:Array = [];
				var fourNumberCards:Array = [];
				var rocket:Array = [];
				
				if (lastWinCardType == CARD_ONE)//单牌
				{
					if (tiShiCardType == CARD_ERROR || tiShiCardType == CARD_ROCKET || (mFindSwitch == 1 && tiShiCardCount > 2))
					{
						tiShiCardCount = 0;
						tiShiCardType = CARD_ERROR;
						tiShiCardValue = 0;
						tiShiCard = 0x00;
					}
					
					//首先找单张
					if (mFindSwitch == 1)
					{
						//先根据数量排序后，都取出一张牌
						oneNumberCards = GetNumberCardFromCards(handCards, 1);
						
						if (oneNumberCards.length > 0)
						{
							//如果还没提示过，则开始查找第一个满足的
							index = twoNumberCards.indexOf(tiShiCard);
							if (tiShiCardCount == 0 || index == -1)
							{
								for (var m0:int = 0; m0 < oneNumberCards.length; m0++)
								{
									if ((oneNumberCards[m0] >> 4) > lastWinCardValue)
									{
										bFind = true;
										tiShiCards.push(oneNumberCards[m0]);
										break;
									}
								}
							}
							
							//如果不是最后一张牌
							if (index != (twoNumberCards.length - 1))
							{
								bFind = true;
								tiShiCards.push(twoNumberCards[index + 1]);
							}
						}
						
						if (!bFind)
							mFindSwitch = 2;
					}
					
					//找4个的炸弹
					if (mFindSwitch == 2)
					{
						fourNumberCards = GetNumberCardFromCards(handCards, 4);
						if (fourNumberCards.length > 0)
						{
							index = fourNumberCards.indexOf(tiShiCard);
							
							//如果是第一次查找炸弹或没有查找到
							if (tiShiCardCount != 4 || index == -1)
								index = 0;
							
							//如果已经提示到最后一张牌，则只能找火箭
							if (index == (oneNumberCards.length - 1))
							{
								bFind = true;
								tiShiCards.push(fourNumberCards[index + 1]);
								tiShiCards.push(fourNumberCards[index + 2]);
								tiShiCards.push(fourNumberCards[index + 3]);
								tiShiCards.push(fourNumberCards[index + 4]);
							}
						}
						
						if (!bFind)
							mFindSwitch = 3;
					}
					
					//找火箭
					if (mFindSwitch == 3)
					{
						rocket = GetRocket(handCards);
						if (rocket.length == 2)
						{
							bFind = true;
							tiShiCards.push(rocket[1]);	//先赋值小王
							tiShiCards.push(rocket[0]);	//再复制大王
						}
						
						mFindSwitch = 1;
					}
				}
				else if (lastWinCardType == CARD_TWO)//对子
				{
					if (tiShiCardType == CARD_ERROR || tiShiCardType == CARD_ROCKET || (mFindSwitch == 1 && tiShiCardCount > 2))
					{
						tiShiCardCount = 0;
						tiShiCardType = CARD_ERROR;
						tiShiCardValue = 0;
						tiShiCard = 0x00;
					}
					
					//首先找对子
					if (mFindSwitch == 1)
					{
						//先根据数量排序后，都取出两张牌
						twoNumberCards = GetNumberCardFromCards(handCards, 2);
						
						if (twoNumberCards.length > 0)
						{
							//如果还没提示过，则从第一个开始
							index = twoNumberCards.indexOf(tiShiCard);
							index = (index == -1) ? 0 : index;
							
							//如果不是最后一副对子
							if (index != (twoNumberCards.length - 1))
							{
								bFind = true;
								tiShiCards.push(twoNumberCards[index + 1]);
								tiShiCards.push(twoNumberCards[index + 2]);
							}
						}
						
						if (!bFind)
							mFindSwitch = 2;
					}
					
					//找4个的炸弹
					if (mFindSwitch == 2)
					{
						fourNumberCards = GetNumberCardFromCards(handCards, 4);
						if (fourNumberCards.length > 0)
						{
							index = fourNumberCards.indexOf(tiShiCard);
							
							//如果是第一次查找炸弹或没有查找到
							if (tiShiCardCount != 4 || index == -1)
								index = 0;
							
							//如果已经提示到最后一张牌，则只能找火箭
							if (index != (oneNumberCards.length - 1))
							{
								bFind = true;
								tiShiCards.push(fourNumberCards[index + 1]);
								tiShiCards.push(fourNumberCards[index + 2]);
								tiShiCards.push(fourNumberCards[index + 3]);
								tiShiCards.push(fourNumberCards[index + 4]);
							}
						}
						
						if (!bFind)
							mFindSwitch = 3;
					}
					
					//找火箭
					if (mFindSwitch == 3)
					{
						rocket = GetRocket(handCards);
						if (rocket.length == 2)
						{
							bFind = true;
							tiShiCards.push(rocket[1]);	//先赋值小王
							tiShiCards.push(rocket[0]);	//再复制大王
						}
						
						mFindSwitch = 1;
					}
				}
				//else if (lastWinCardType == CARD_THREE)//3个的炸弹
				//{
					//if (tiShiCardType == CARD_ERROR || tiShiCardType == CARD_RED10 || (m_FindSwitch == 1 && tiShiCardCount > 3))
					//{
						//lastTiShiCardValue = 0;
						//tiShiCardCount = 0;
					//}
					//
					////找3个的炸弹
					//if (m_FindSwitch == 1)
					//{
						//if (!bFind && threeCards.length > 0)
						//{
							//for (var k2:int = (threeCards.length -1); k2 >= 0; k2 -= 3)
							//{
								//if (getCardNormalValue(threeCards[k2]) <= lastTiShiCardValue)//3个时不区分红十，取普通值
									//continue;
								//
								//bFind = true;
								//tiShiCards.push(threeCards[k2 - 2]);
								//tiShiCards.push(threeCards[k2 - 1]);
								//tiShiCards.push(threeCards[k2]);
								//break;
							//}
						//}	
						//
						//if (!bFind)
						//{
							////清掉lastTiShiCardValue的记录
							//lastTiShiCardValue = 0;
							//m_FindSwitch = 2;
						//}
					//}
					//
					////找4个的炸弹
					//if (m_FindSwitch == 2)
					//{
						//if (!bFind && fourCards.length > 0)
						//{
							//for (var g2:int = (fourCards.length - 1); g2 >= 0; g2 -= 4)
							//{
								//if (getCardNormalValue(fourCards[g2]) <= lastTiShiCardValue)//4个时不区分红十，取普通值
									//continue;
									//
								//bFind = true;
								//tiShiCards.push(fourCards[g2 - 3]);
								//tiShiCards.push(fourCards[g2 - 2]);
								//tiShiCards.push(fourCards[g2 - 1]);
								//tiShiCards.push(fourCards[g2]);
								//break;
							//}
						//}
						//
						//if (!bFind)
						//{
							////清掉lastTiShiCardValue的记录
							//lastTiShiCardValue = 0;
							//m_FindSwitch = 3;
						//}
					//}
					//
					////找双红十
					//if (m_FindSwitch == 3)
					//{
						//if (!bFind && doubleRedTenArray0.length > 0)
						//{
							//bFind = true;
							//tiShiCards.push(doubleRedTenArray0[0]);
							//tiShiCards.push(doubleRedTenArray0[1]);	
						//}
						//
						////清掉lastTiShiCardValue的记录
						//lastTiShiCardValue = 0;
						//m_FindSwitch = 1;
					//}
					//
					//if (bFind)
						//nRet = 1;
				//}
				//else if (lastWinCardType == CARD_FOUR)//4个的炸弹
				//{
					//if (tiShiCardType == CARD_ERROR || tiShiCardType == CARD_RED10 || (m_FindSwitch == 1 && tiShiCardCount > 4))
					//{
						//lastTiShiCardValue = 0;
						//tiShiCardCount = 0;
					//}
					//
					////找4个的炸弹
					//if (m_FindSwitch == 1)
					//{
						//if (!bFind && fourCards.length > 0)
						//{
							//for (var g3:int = (fourCards.length - 1); g3 >= 0; g3 -= 4)
							//{
								//if (getCardNormalValue(fourCards[g3]) <= lastTiShiCardValue)//4个时不区分红十，取普通值
									//continue;
									//
								//bFind = true;
								//tiShiCards.push(fourCards[g3 - 3]);
								//tiShiCards.push(fourCards[g3 - 2]);
								//tiShiCards.push(fourCards[g3 - 1]);
								//tiShiCards.push(fourCards[g3]);
								//break;
							//}
						//}
						//
						//if (!bFind)
						//{
							////清掉lastTiShiCardValue的记录
							//lastTiShiCardValue = 0;
							//m_FindSwitch = 2;
						//}
					//}
					//
					////找双红十
					//if (m_FindSwitch == 2)
					//{
						//if (!bFind && doubleRedTenArray0.length > 0)
						//{
							//bFind = true;
							//tiShiCards.push(doubleRedTenArray0[0]);
							//tiShiCards.push(doubleRedTenArray0[1]);	
						//}
						//
						////清掉lastTiShiCardValue的记录
						//lastTiShiCardValue = 0;
						//m_FindSwitch = 1;
					//}
					//
					//if (bFind)
						//nRet = 1;
				//}
				//else if (lastWinCardType == CARD_LINE_1)//单连
				//{
					//if (tiShiCardType == CARD_ERROR || tiShiCardType == CARD_RED10)
					//{
						//lastTiShiCardValue = 0;
						//tiShiCardCount = 0;
					//}
					//
					////首先找单连
					//if (m_FindSwitch == 1)
					//{
						//var cardOnlyOneArray:Array = new Array();//手中所有的牌取出的单张
						//cardOnlyOneArray = GetCardOnlyOne(handCards);
					//
						//for (var m4:int = (cardOnlyOneArray.length - lastWinCardCount); m4 >= 0; m4--)
						//{
							//var cardLine1:Array = new Array();
							//cardLine1 = cardOnlyOneArray.slice(m4, m4 + lastWinCardCount);//注意slice函数的第二个参数，不是取得个数，而是下标数
						//
							//if (isLineCard(cardLine1, 1))
							//{
								//if (getCardNormalValue(cardLine1[0]) > lastWinCardValue && getCardNormalValue(cardLine1[0]) > lastTiShiCardValue)
								//{
									//bFind = true;
									//for (var n4:int = 0; n4 < cardLine1.length; n4++)
									//{
										//tiShiCards.push(cardLine1[n4]);
									//}
									//break;
								//}
							//}
						//}
						//
						//if (!bFind)
						//{
							////清掉lastTiShiCardValue的记录
							//lastTiShiCardValue = 0;
							//m_FindSwitch = 2;
						//}
					//}
					//
					////找3个的炸弹
					//if (m_FindSwitch == 2)
					//{
						//if (!bFind && threeCards.length > 0)
						//{
							//for (var k4:int = (threeCards.length -1); k4 >= 0; k4 -= 3)
							//{
								//if (getCardNormalValue(threeCards[k4]) <= lastTiShiCardValue)//3个时不区分红十，取普通值
									//continue;
								//
								//bFind = true;
								//tiShiCards.push(threeCards[k4 - 2]);
								//tiShiCards.push(threeCards[k4 - 1]);
								//tiShiCards.push(threeCards[k4]);
								//break;
							//}
						//}	
						//
						//if (!bFind)
						//{
							////清掉lastTiShiCardValue的记录
							//lastTiShiCardValue = 0;
							//m_FindSwitch = 3;
						//}
					//}
					//
					////找4个的炸弹
					//if (m_FindSwitch == 3)
					//{
						//if (!bFind && fourCards.length > 0)
						//{
							//for (var g4:int = (fourCards.length - 1); g4 >= 0; g4 -= 4)
							//{
								//if (getCardNormalValue(fourCards[g4]) <= lastTiShiCardValue)//4个时不区分红十，取普通值
									//continue;
									//
								//bFind = true;
								//tiShiCards.push(fourCards[g4 - 3]);
								//tiShiCards.push(fourCards[g4 - 2]);
								//tiShiCards.push(fourCards[g4 - 1]);
								//tiShiCards.push(fourCards[g4]);
								//break;
							//}
						//}
						//
						//if (!bFind)
						//{
							////清掉lastTiShiCardValue的记录
							//lastTiShiCardValue = 0;
							//m_FindSwitch = 4;
						//}
					//}
					//
					////找双红十
					//if (m_FindSwitch == 4)
					//{
						//if (!bFind && doubleRedTenArray0.length > 0)
						//{
							//bFind = true;
							//tiShiCards.push(doubleRedTenArray0[0]);
							//tiShiCards.push(doubleRedTenArray0[1]);	
						//}
						//
						////清掉lastTiShiCardValue的记录
						//lastTiShiCardValue = 0;
						//m_FindSwitch = 1;
					//}
					//
					//if (bFind)
						//nRet = 1;
				//}
				//else if (lastWinCardType == CARD_LINE_2)//双连
				//{
					//if (tiShiCardType == CARD_ERROR || tiShiCardType == CARD_RED10)
					//{
						//lastTiShiCardValue = 0;
						//tiShiCardCount = 0;
					//}
					//
					////首先找双连
					//if (m_FindSwitch == 1)
					//{
						//var cardOnlyTwoArray:Array = new Array();//手中所有的牌取出的2张
						//cardOnlyTwoArray = GetCardOnlyTwo(handCards);
					//
						//for (var m5:int = (cardOnlyTwoArray.length - lastWinCardCount); m5 >= 0; m5--)
						//{
							//var cardLine2:Array = new Array();
							//cardLine2 = cardOnlyTwoArray.slice(m5, m5 + lastWinCardCount);//注意slice函数的第二个参数，不是取得个数，而是下标数
						//
							//if (isLineCard(cardLine2, 2))
							//{
								//if (getCardNormalValue(cardLine2[0]) > lastWinCardValue && getCardNormalValue(cardLine2[0]) > lastTiShiCardValue)
								//{
									//bFind = true;
									//for (var n5:int = 0; n5 < cardLine2.length; n5++)
									//{
										//tiShiCards.push(cardLine2[n5]);
									//}
									//break;
								//}
							//}
						//}
						//
						//if (!bFind)
						//{
							////清掉lastTiShiCardValue的记录
							//lastTiShiCardValue = 0;
							//m_FindSwitch = 2;
						//}
					//}
					//
					////找3个的炸弹
					//if (m_FindSwitch == 2)
					//{
						//if (!bFind && threeCards.length > 0)
						//{
							//for (var k5:int = (threeCards.length -1); k5 >= 0; k5 -= 3)
							//{
								//if (getCardNormalValue(threeCards[k5]) <= lastTiShiCardValue)//3个时不区分红十，取普通值
									//continue;
								//
								//bFind = true;
								//tiShiCards.push(threeCards[k5 - 2]);
								//tiShiCards.push(threeCards[k5 - 1]);
								//tiShiCards.push(threeCards[k5]);
								//break;
							//}
						//}	
						//
						//if (!bFind)
						//{
							////清掉lastTiShiCardValue的记录
							//lastTiShiCardValue = 0;
							//m_FindSwitch = 3;
						//}
					//}
					//
					////找4个的炸弹
					//if (m_FindSwitch == 3)
					//{
						//if (!bFind && fourCards.length > 0)
						//{
							//for (var g5:int = (fourCards.length - 1); g5 >= 0; g5 -= 4)
							//{
								//if (getCardNormalValue(fourCards[g5]) <= lastTiShiCardValue)//4个时不区分红十，取普通值
									//continue;
									//
								//bFind = true;
								//tiShiCards.push(fourCards[g5 - 3]);
								//tiShiCards.push(fourCards[g5 - 2]);
								//tiShiCards.push(fourCards[g5 - 1]);
								//tiShiCards.push(fourCards[g5]);
								//break;
							//}
						//}
						//
						//if (!bFind)
						//{
							////清掉lastTiShiCardValue的记录
							//lastTiShiCardValue = 0;
							//m_FindSwitch = 4;
						//}
					//}
					//
					////找双红十
					//if (m_FindSwitch == 4)
					//{
						//if (!bFind && doubleRedTenArray0.length > 0)
						//{
							//bFind = true;
							//tiShiCards.push(doubleRedTenArray0[0]);
							//tiShiCards.push(doubleRedTenArray0[1]);	
						//}
						//
						////清掉lastTiShiCardValue的记录
						//lastTiShiCardValue = 0;
						//m_FindSwitch = 1;
					//}
					//
					//if (bFind)
						//nRet = 1;
				//}
			}
			
			return bFind ? 1 : -1;
		}
	}
}