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
		
		//得到所给的牌中数量为number的所有牌
		public function getCardsWithNumber(pokerValues:Array, number:int):Array
		{
			var num1:Array = [];
			var num2:Array = [];
			var num3:Array = [];
			var num4:Array = [];
			
			//先进行牌值排序
			SortByValue(pokerValues);
			
			//将对应数量的牌放入对应的数组
			var shuliang:int = 1;
			for (var m:int = 0; m < pokerValues.length;)
			{
				var paizhi1:int = pokerValues[m] >> 4;
				var paizhi2:int = pokerValues[m + shuliang] >> 4;
				if (paizhi1 != paizhi2)
				{
					switch(shuliang)
					{
						case 1:
							num1.push(pokerValues[m]);
							break;
						case 2:
							num2.push(pokerValues[m]);
							num2.push(pokerValues[m+1]);
							break;
						case 3:
							num3.push(pokerValues[m]);
							num3.push(pokerValues[m+1]);
							num3.push(pokerValues[m+2]);
							break;
						case 4:
							num4.push(pokerValues[m]);
							num4.push(pokerValues[m+1]);
							num4.push(pokerValues[m+2]);
							num4.push(pokerValues[m+3]);
							break;
					}
					m += shuliang;
					shuliang = 1;	
				}
				else 
				{
					shuliang++;
				}
			}
			
			switch(number)
			{
				case 1:
					return num1;
				case 2:
					return num2;
				case 3:
					return num3;
				case 4:
					return num4;
			}
			
			return null;
		}
		
		//是否是3带1
		public function Is3Dai1(pokerValues:Array):Boolean
		{
			var pokers3:Array = [];
			pokers3 = getCardsWithNumber(pokerValues, 3);
			
			return (pokers3.length == 0) ? false :true;
		}
		
		//是否是3带2
		public function Is3Dai2(pokerValues:Array):Boolean
		{
			var pokers3:Array = [];
			pokers3 = getCardsWithNumber(pokerValues, 3);
			
			var pokers2:Array = [];
			pokers2 = getCardsWithNumber(pokerValues, 2);
			
			return (pokers3.length == 0 || pokers2.length == 0) ? false : true;
		}
		
		//是否是4带1
		public function Is4Dai1(pokerValues:Array):Boolean
		{
			var pokers4:Array = [];
			pokers4 = getCardsWithNumber(pokerValues, 4);
			
			return (pokers4.length == 0) ? false : true;
		}
		
		//是否是4带一对
		public function Is4Dai2(pokerValues:Array):Boolean
		{
			var pokers4:Array = [];
			pokers4 = getCardsWithNumber(pokerValues, 4);
			
			var pokers2:Array = [];
			pokers2 = getCardsWithNumber(pokerValues, 2);
			
			return (pokers4.length == 0 || pokers2.length == 0) ? false : true;
		}
		
		//是否是4带2张单
		public function Is4DaiTwoSingle(pokerValues:Array):Boolean
		{
			var pokers4:Array = [];
			pokers4 = getCardsWithNumber(pokerValues, 4);
			
			var pokers1:Array = [];
			pokers1 = getCardsWithNumber(pokerValues, 1);
			
			return (pokers4.length == 0 || pokers1.length != 2) ? false : true;
		}
		
		//是否是飞机带翅膀（2张单）
		public function IsPlane1(pokerValues:Array):Boolean
		{
			var pokers3:Array = [];
			pokers3 = getCardsWithNumber(pokerValues, 3);
			
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
			pokers3 = getCardsWithNumber(pokerValues, 3);
			
			var pokers2:Array = [];
			pokers2 = getCardsWithNumber(pokerValues, 2);
			
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
		
		//提示出牌
		public function TiShiOutCard(handCards:Array, handCardCount:int, lastWinCards:Array, lastWinCardCount:int, tiShiCards:Array, tiShiCardCount:int):int
		{
			var nRet:int = -1;
			
			//var lastWinCardType:int = getCardType(lastWinCards);		//上一个玩家出的牌的类型
			//var lastWinCardValue:int = getCardValue(lastWinCards[0]);	//上一个玩家出的牌的最大牌的牌值 替换 var lastWinCardValue:int = lastWinCard[0] >> 4;		
			//
			//var tiShiCardType:int = 0;
			//var tiShiCardValue:int = 0;
			//if (tiShiCardCount)
			//{
				//tiShiCardType = getCardType(tiShiCards);		//当前弹起的牌的类型
				//tiShiCardValue = getCardNormalValue(tiShiCards[0]);//当前弹起的牌的普通值//当前弹起的牌的最大牌的牌值 替换 tiShiCardValue =  tiShiCard[0] >> 4;	
			//}
			//
			//var lastTiShiCard:int = tiShiCards[0];		//上一次提示的牌的最大牌
			//var lastTiShiCardValue:int = tiShiCardValue;//上一次提示的牌的最大牌的牌值
			//
			////查找符合条件的牌
			//{
				////清空提示出牌的数组
				//for (var i:int = 0; i < tiShiCards.length; )
				//{
					//tiShiCards.splice(0, 1);
				//}
				//
				//var oneCardArray0:Array = new Array();				//1张牌的数组
				//oneCardArray0 = getCardsWithNumber(handCards, 1);
					//
				//var twoCardArray0:Array = new Array();				//2张牌的数组
				//twoCardArray0 = getCardsWithNumber(handCards, 2);
					//
				//var threeCardArray0:Array = new Array();			//3张牌的数组
				//threeCardArray0 = getCardsWithNumber(handCards, 3);
					//
				//var fourCardArray0:Array = new Array();				//4张牌的数组
				//fourCardArray0 = getCardsWithNumber(handCards, 4);
						//
				//var doubleRedTenArray0:Array = new Array();			//双红十
				//doubleRedTenArray0 = GetDoubleRed10(handCards);
					//
				//var bFind:Boolean = false;
					//
				//if (lastWinCardType == CARD_ONE)//单牌
				//{
					//if (tiShiCardType == CARD_ERROR || tiShiCardType == CARD_RED10 || (m_FindSwitch == 1 && tiShiCardCount > 1))
					//{
						//lastTiShiCardValue = 0;
						//tiShiCardCount = 0;
					//}
					//
					////首先找单牌
					//if (m_FindSwitch == 1)
					//{
						//if (oneCardArray0.length > 0)
						//{
							//for (var m0:int = (oneCardArray0.length - 1); m0 >= 0; m0--)
							//{
								////红十单独处理
								//if (oneCardArray0[m0] == 0x81 || oneCardArray0[m0] == 0x83)
									//break;
								//
								//if ((getCardValue(oneCardArray0[m0]) > lastWinCardValue) && (getCardValue(oneCardArray0[m0]) > lastTiShiCardValue))
								//{
									//bFind = true;
									//tiShiCardCount = 1;
									//tiShiCards.push(oneCardArray0[m0]);
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
					////找对子
					//if (m_FindSwitch == 2)
					//{
						//if (!bFind && twoCardArray0.length > 0)
						//{
							//var temp0:int = 0;
							//for (var n0:int = (twoCardArray0.length -1); n0 >= 0; n0--)
							//{
								////红十单独处理
								//if (twoCardArray0[n0] == 0x81 || twoCardArray0[n0] == 0x83)
									//break;
								//
								//if (temp0 == getCardValue(twoCardArray0[n0]))
									//continue;
								//else
									//temp0 = getCardValue(twoCardArray0[n0]);
								//
								//if ((getCardValue(twoCardArray0[n0]) > lastWinCardValue) && (getCardValue(twoCardArray0[n0]) > lastTiShiCardValue))
								//{
									//bFind = true;
									//tiShiCardCount = 1;
									//tiShiCards.push(twoCardArray0[n0]);
									//break;
								//}
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
					////找3张
					//if (m_FindSwitch == 3)
					//{
						//if (!bFind && threeCardArray0.length > 0)
						//{
							//var temp1:int = 0;
							//for (var i0:int = (threeCardArray0.length - 1); i0 >= 0; i0--)
							//{
								////红十单独处理
								//if (threeCardArray0[i0] == 0x81 || threeCardArray0[i0] == 0x83)
									//break;
								//
								//if (temp1 == getCardValue(threeCardArray0[i0]))
									//continue;
								//else
									//temp1 = getCardValue(threeCardArray0[i0]);
								//
								//if ((getCardValue(threeCardArray0[i0]) > lastWinCardValue) && (getCardValue(threeCardArray0[i0]) > lastTiShiCardValue))
								//{
									//bFind = true;
									//tiShiCardCount = 1;
									//tiShiCards.push(threeCardArray0[i0]);
									//break;
								//}
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
					////找4张
					//if (m_FindSwitch == 4)
					//{
						//if (!bFind && fourCardArray0.length > 0)
						//{
							//var temp2:int = 0;
							//for (var j0:int = (fourCardArray0.length - 1); j0 >= 0; j0--)
							//{
								////红十单独处理
								//if (fourCardArray0[j0] == 0x81 || fourCardArray0[j0] == 0x83)
									//break;
								//
								//if (temp2 == getCardValue(fourCardArray0[j0]))
									//continue;
								//else
									//temp2 == getCardValue(fourCardArray0[j0]);
								//
								//if ((getCardValue(fourCardArray0[j0]) > lastWinCardValue) && (getCardValue(fourCardArray0[j0]) > lastTiShiCardValue))
								//{
									//bFind = true;
									//tiShiCardCount = 1;
									//tiShiCards.push(fourCardArray0[j0]);
									//break;
								//}
							//}
						//}
						//
						//if (!bFind)
						//{
							////清掉lastTiShiCardValue的记录
							//lastTiShiCardValue = 0;
							//m_FindSwitch = 5;
						//}
					//}
					//
					////单独处理的红十
					//if (m_FindSwitch == 5)
					//{
						//if (!bFind)
						//{
							//for (var index:int = 0; index < handCards.length; index++)
							//{
								//if (handCards[index] == 0x81 || handCards[index] == 0x83)//是红十
								//{
									//if (lastTiShiCard == 0x81 || lastTiShiCard == 0x83)//上一个提示的牌也是红十
										//break;
										//
									//bFind = true;
									//tiShiCards.push(handCards[index]);
									//break;
								//}
							//}
						//}
						//
						//if (!bFind)
						//{
							////清掉lastTiShiCardValue的记录
							//lastTiShiCardValue = 0;
							//m_FindSwitch = 6;
						//}
					//}
					//
					////找3个的炸弹
					//if (m_FindSwitch == 6)
					//{
						//if (!bFind && threeCardArray0.length > 0)
						//{
							//for (var k0:int = (threeCardArray0.length -1); k0 >= 0; k0 -= 3)
							//{
								//if (getCardNormalValue(threeCardArray0[k0]) <= lastTiShiCardValue)//3个时不区分红十，取普通值
									//continue;
								//
								//bFind = true;
								//tiShiCards.push(threeCardArray0[k0 - 2]);
								//tiShiCards.push(threeCardArray0[k0 - 1]);
								//tiShiCards.push(threeCardArray0[k0]);
								//break;
							//}
						//}	
						//
						//if (!bFind)
						//{
							////清掉lastTiShiCardValue的记录
							//lastTiShiCardValue = 0;
							//m_FindSwitch = 7;
						//}
					//}
					//
					////找4个的炸弹
					//if (m_FindSwitch == 7)
					//{
						//if (!bFind && fourCardArray0.length > 0)
						//{
							//for (var g0:int = (fourCardArray0.length - 1); g0 >= 0; g0 -= 4)
							//{
								//if (getCardNormalValue(fourCardArray0[g0]) <= lastTiShiCardValue)//4个时不区分红十，取普通值
									//continue;
									//
								//bFind = true;
								//tiShiCards.push(fourCardArray0[g0 - 3]);
								//tiShiCards.push(fourCardArray0[g0 - 2]);
								//tiShiCards.push(fourCardArray0[g0 - 1]);
								//tiShiCards.push(fourCardArray0[g0]);
								//break;
							//}
						//}
						//
						//if (!bFind)
						//{
							////清掉lastTiShiCardValue的记录
							//lastTiShiCardValue = 0;
							//m_FindSwitch = 8;
						//}
					//}
					//
					////找双红十
					//if (m_FindSwitch == 8)
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
				//else if (lastWinCardType == CARD_TWO)//对子
				//{
					//if (tiShiCardType == CARD_ERROR || tiShiCardType == CARD_RED10 || (m_FindSwitch == 1 && tiShiCardCount > 2))
					//{
						//lastTiShiCardValue = 0;
						//tiShiCardCount = 0;
					//}
					//
					////首先找对子
					//if (m_FindSwitch == 1)
					//{
						//if (twoCardArray0.length > 0)
						//{
							//for (var m1:int = (twoCardArray0.length - 1); m1 >= 0; m1 -= 2)
							//{
								//if ((getCardValue(twoCardArray0[m1]) > lastWinCardValue) && (getCardValue(twoCardArray0[m1]) > lastTiShiCardValue))
								//{
									//bFind = true;
									//tiShiCards.push(twoCardArray0[m1 - 1]);
									//tiShiCards.push(twoCardArray0[m1]);
									//break;
								//}
							//}
							//
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
					////找3张
					//if (m_FindSwitch == 2)
					//{
						//if (!bFind && threeCardArray0.length > 0)
						//{
							//for (var n1:int = (threeCardArray0.length -1); n1 >= 0; n1 -= 3)
							//{
								//if ((getCardNormalValue(threeCardArray0[n1]) > lastWinCardValue) && (getCardNormalValue(threeCardArray0[n1]) > lastTiShiCardValue))
								//{
									//bFind = true;
									//tiShiCards.push(threeCardArray0[n1 - 2]);
									//tiShiCards.push(threeCardArray0[n1 - 1]);
									//break;
								//}
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
					////找4张
					//if (m_FindSwitch == 3)
					//{
						//if (!bFind && fourCardArray0.length > 0)
						//{
							//for (var i1:int = (fourCardArray0.length - 1); i1 >= 0; i1 -= 4)
							//{
								//if ((getCardNormalValue(fourCardArray0[i1]) > lastWinCardValue) && (getCardNormalValue(fourCardArray0[i1]) > lastTiShiCardValue))
								//{
									//bFind = true;
									//tiShiCards.push(fourCardArray0[i1 - 3]);
									//tiShiCards.push(fourCardArray0[i1 - 2]);
									//break;
								//}
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
					////找3个的炸弹
					//if (m_FindSwitch == 4)
					//{
						//if (!bFind && threeCardArray0.length > 0)
						//{
							//for (var k1:int = (threeCardArray0.length -1); k1 >= 0; k1 -= 3)
							//{
								//if (getCardNormalValue(threeCardArray0[k1]) <= lastTiShiCardValue)//3个时不区分红十，取普通值
									//continue;
								//
								//bFind = true;
								//tiShiCards.push(threeCardArray0[k1 - 2]);
								//tiShiCards.push(threeCardArray0[k1 - 1]);
								//tiShiCards.push(threeCardArray0[k1]);
								//break;
							//}
						//}	
						//
						//if (!bFind)
						//{
							////清掉lastTiShiCardValue的记录
							//lastTiShiCardValue = 0;
							//m_FindSwitch = 5;
						//}
					//}
					//
					////找4个的炸弹
					//if (m_FindSwitch == 5)
					//{
						//if (!bFind && fourCardArray0.length > 0)
						//{
							//for (var g1:int = (fourCardArray0.length - 1); g1 >= 0; g1 -= 4)
							//{
								//if (getCardNormalValue(fourCardArray0[g1]) <= lastTiShiCardValue)//4个时不区分红十，取普通值
									//continue;
									//
								//bFind = true;
								//tiShiCards.push(fourCardArray0[g1 - 3]);
								//tiShiCards.push(fourCardArray0[g1 - 2]);
								//tiShiCards.push(fourCardArray0[g1 - 1]);
								//tiShiCards.push(fourCardArray0[g1]);
								//break;
							//}
						//}
						//
						//if (!bFind)
						//{
							////清掉lastTiShiCardValue的记录
							//lastTiShiCardValue = 0;
							//m_FindSwitch = 6;
						//}
					//}
					//
					////找双红十
					//if (m_FindSwitch == 6)
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
						//if (!bFind && threeCardArray0.length > 0)
						//{
							//for (var k2:int = (threeCardArray0.length -1); k2 >= 0; k2 -= 3)
							//{
								//if (getCardNormalValue(threeCardArray0[k2]) <= lastTiShiCardValue)//3个时不区分红十，取普通值
									//continue;
								//
								//bFind = true;
								//tiShiCards.push(threeCardArray0[k2 - 2]);
								//tiShiCards.push(threeCardArray0[k2 - 1]);
								//tiShiCards.push(threeCardArray0[k2]);
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
						//if (!bFind && fourCardArray0.length > 0)
						//{
							//for (var g2:int = (fourCardArray0.length - 1); g2 >= 0; g2 -= 4)
							//{
								//if (getCardNormalValue(fourCardArray0[g2]) <= lastTiShiCardValue)//4个时不区分红十，取普通值
									//continue;
									//
								//bFind = true;
								//tiShiCards.push(fourCardArray0[g2 - 3]);
								//tiShiCards.push(fourCardArray0[g2 - 2]);
								//tiShiCards.push(fourCardArray0[g2 - 1]);
								//tiShiCards.push(fourCardArray0[g2]);
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
						//if (!bFind && fourCardArray0.length > 0)
						//{
							//for (var g3:int = (fourCardArray0.length - 1); g3 >= 0; g3 -= 4)
							//{
								//if (getCardNormalValue(fourCardArray0[g3]) <= lastTiShiCardValue)//4个时不区分红十，取普通值
									//continue;
									//
								//bFind = true;
								//tiShiCards.push(fourCardArray0[g3 - 3]);
								//tiShiCards.push(fourCardArray0[g3 - 2]);
								//tiShiCards.push(fourCardArray0[g3 - 1]);
								//tiShiCards.push(fourCardArray0[g3]);
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
						//if (!bFind && threeCardArray0.length > 0)
						//{
							//for (var k4:int = (threeCardArray0.length -1); k4 >= 0; k4 -= 3)
							//{
								//if (getCardNormalValue(threeCardArray0[k4]) <= lastTiShiCardValue)//3个时不区分红十，取普通值
									//continue;
								//
								//bFind = true;
								//tiShiCards.push(threeCardArray0[k4 - 2]);
								//tiShiCards.push(threeCardArray0[k4 - 1]);
								//tiShiCards.push(threeCardArray0[k4]);
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
						//if (!bFind && fourCardArray0.length > 0)
						//{
							//for (var g4:int = (fourCardArray0.length - 1); g4 >= 0; g4 -= 4)
							//{
								//if (getCardNormalValue(fourCardArray0[g4]) <= lastTiShiCardValue)//4个时不区分红十，取普通值
									//continue;
									//
								//bFind = true;
								//tiShiCards.push(fourCardArray0[g4 - 3]);
								//tiShiCards.push(fourCardArray0[g4 - 2]);
								//tiShiCards.push(fourCardArray0[g4 - 1]);
								//tiShiCards.push(fourCardArray0[g4]);
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
						//if (!bFind && threeCardArray0.length > 0)
						//{
							//for (var k5:int = (threeCardArray0.length -1); k5 >= 0; k5 -= 3)
							//{
								//if (getCardNormalValue(threeCardArray0[k5]) <= lastTiShiCardValue)//3个时不区分红十，取普通值
									//continue;
								//
								//bFind = true;
								//tiShiCards.push(threeCardArray0[k5 - 2]);
								//tiShiCards.push(threeCardArray0[k5 - 1]);
								//tiShiCards.push(threeCardArray0[k5]);
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
						//if (!bFind && fourCardArray0.length > 0)
						//{
							//for (var g5:int = (fourCardArray0.length - 1); g5 >= 0; g5 -= 4)
							//{
								//if (getCardNormalValue(fourCardArray0[g5]) <= lastTiShiCardValue)//4个时不区分红十，取普通值
									//continue;
									//
								//bFind = true;
								//tiShiCards.push(fourCardArray0[g5 - 3]);
								//tiShiCards.push(fourCardArray0[g5 - 2]);
								//tiShiCards.push(fourCardArray0[g5 - 1]);
								//tiShiCards.push(fourCardArray0[g5]);
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
			//}
			
			return nRet;
		}
	}
}