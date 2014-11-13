package myPoker {
	import flash.geom.Point;
	import help.PokerHelp;
	import mylib.Asset;
	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.Sprite;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.Texture;
	import starling.utils.deg2rad;
	
	/**
	 * 扑克管理类
	 * @author Vampire
	 */
	public class PokerManager extends Sprite 
	{
		private static const UP_HEIGHT:int = -10;		//弹起的高度
		private static const MOVIE_TIME:Number = 0.2;	//动画时间
		
		public static const POSITION_ME:int = 0;		//自己
		public static const POSITION_RIGHT:int = 1;		//右边玩家
		public static const POSITION_LEFT:int = 2;		//左边玩家
		
		private var mPosition:int = 0;		//排列方式
		private var mSpace:int = 0;			//2张牌的间距
		private var mPokerName:String;		//扑克名称
		private var mbMovie:Boolean = true;	//是否需要添加牌时的动画
		
		public function PokerManager() 
		{
			super();
			
			this.addEventListener(TouchEvent.TOUCH, OnPokerManagerTouch);
		}
		
		//设置参数
		public function SetParameter(position:int, space:int, pokerName:String, bMovie:Boolean = true):void
		{
			mPosition = position;
			mSpace = space;
			mPokerName = pokerName;
			mbMovie = bMovie;
		}
		
		//得到弹起的扑克
		public function GetUpPokers():Array
		{
			var pokerValues:Array = [];
			for (var i:int = 0; i < this.numChildren; i++)
			{
				var poker:Poker = this.getChildAt(i) as Poker;
				if(poker.y == UP_HEIGHT)
					pokerValues.push(poker.mPokerValue);
			}
			return pokerValues;
		}
		
		//移除扑克牌
		public function RemovePokers(pokerValues:Array):void
		{
			for (var i:int = 0; i < pokerValues.length; i++)
			{
				for (var j:int = 0; j < this.numChildren; j++)
				{
					var poker:Poker = this.getChildAt(j) as Poker;
					if (poker.mPokerValue == pokerValues[i])
					{
						this.removeChild(poker, true);
						break;
					}
				}
			}
			
			UpdatePosition();
		}
		
		//插入扑克牌（地主需要的3张牌）
		public function InsertPokers(pokerValues:Array):void
		{
			for (var i:int = 0; i < pokerValues.length; i++)
				InsertPoker(pokerValues[i]);
			
			UpdateInsertPosition();
		}
		
		//插入扑克牌
		public function InsertPoker(pokerValue:Number):void
		{
			//添加扑克牌
			var pokerBackTexture:Texture = Asset.GetPoker().getTexture("Poker_0_0");
			var poker:Poker = new Poker(pokerBackTexture);
			poker.SetPoker(pokerValue, mPokerName);
			poker.useHandCursor = true;
			addChild(poker);
			
			//先旋转
			if (mPosition == POSITION_RIGHT)
			{
				poker.pivotX = int(poker.width / 2);
				poker.pivotY = int(poker.height / 2);
				poker.rotation = deg2rad(270);
			}
			else if (mPosition == POSITION_LEFT)
			{
				poker.pivotX = int(poker.width / 2);
				poker.pivotY = int(poker.height / 2);
				poker.rotation = deg2rad(90);
			}
			
			//再排序，确定索引值
			for (var i:int = 0; i < this.numChildren - 2; i++)
			{
				var tempPoker1:Poker = this.getChildAt(i) as Poker;
				var tempPoker2:Poker = this.getChildAt(i + 1) as Poker;
				
				if (i == 0 && pokerValue > tempPoker1.mPokerValue)	//说明刚添加的牌是最大的
					this.setChildIndex(poker, 0);
				else if ((i == this.numChildren - 3) && tempPoker2.mPokerValue > pokerValue)	//说明刚添加的牌是最小的
					continue;
				else if (tempPoker1.mPokerValue > pokerValue && pokerValue > tempPoker2.mPokerValue)
					this.setChildIndex(poker, i+1);
			}
			
			//如果是自己，需要添加动画，其他玩家不需要
			if (mPosition == POSITION_ME)
				poker.y = UP_HEIGHT;
		}
		
		//刷新插入牌时的所有的位置
		public function UpdateInsertPosition():void
		{
			if (this.numChildren == 0)
				return;
			
			//首先计算第一张牌的位置
			var totalWidth:int, totalHeight:int;
			var pokerX:int, pokerY:int;
			var poker:Poker = this.getChildAt(0) as Poker;
			if (mPosition == POSITION_ME)
			{
				totalWidth = (this.numChildren - 1) * mSpace + poker.width;
				pokerX = int((stage.stageWidth - totalWidth) / 2);
				
				for (var i:int = 0; i < this.numChildren; i++)
				{
					var mePoker:Poker = this.getChildAt(i) as Poker;
					mePoker.x = pokerX + i * mSpace;
				}
			}
			else if (mPosition == POSITION_LEFT)
			{
				totalHeight = (this.numChildren - 1) * mSpace + poker.height;
				pokerY = int((stage.stageHeight - totalHeight) / 2);
				
				for (var m:int = 0; m < this.numChildren; m++)
				{
					var leftPoker:Poker = this.getChildAt(m) as Poker;
					leftPoker.y = pokerY + m * mSpace;
				}
			}
			else if (mPosition == POSITION_RIGHT)	//右侧的玩家的牌的布局总是让人蛋疼
			{
				totalHeight = (this.numChildren - 1) * mSpace + poker.height;
				pokerY = int((stage.stageHeight - totalHeight) / 2);
				
				for (var n:int = this.numChildren - 1; n >= 0; n--)
				{
					var rightPoker:Poker = this.getChildAt(n) as Poker;
					rightPoker.y = pokerY + Math.abs(n + 1 - this.numChildren) * mSpace;
				}
			}
			
			//如果是自己，并且有弹起的牌，添加动画，使其落下去
			if (mPosition == POSITION_ME)
			{
				for (var j:int = 0; j < this.numChildren; j++)
				{
					var tempPoker:Poker = this.getChildAt(j) as Poker;
					if (tempPoker.y == UP_HEIGHT)
					{
						var tempPokerTween:Tween = new Tween(tempPoker, MOVIE_TIME, Transitions.LINEAR);
						tempPokerTween.moveTo(tempPoker.x, 0);
						tempPokerTween.onComplete = OnComplete;
						tempPokerTween.onCompleteArgs = [tempPokerTween];
						Starling.juggler.add(tempPokerTween);
					}
				}
			}
		}
		
		//添加扑克牌
		public function AddPokers(pokerValues:Array):void
		{
			for (var i:int = 0; i < pokerValues.length; i++)
				AddPoker(pokerValues[i]);
		}
		
		//添加扑克牌
		public function AddPoker(pokerValue:Number):void
		{
			//添加扑克牌
			var pokerBackTexture:Texture = Asset.GetPoker().getTexture("Poker_0_0");
			var poker:Poker = new Poker(pokerBackTexture);
			poker.SetPoker(pokerValue, mPokerName);
			poker.useHandCursor = true;
			addChild(poker);
			
			//设置位置
			if (mbMovie)	//需要添加动画
			{
				if (mPosition == POSITION_ME)
					poker.x = (this.numChildren == 1) ? int((stage.stageWidth - poker.width) / 2) : (this.getChildAt(this.numChildren - 2) as Poker).x;	//如果是第一张，位置为0，否则新添加的都与自己的前一张位置相同
				else if (mPosition == POSITION_RIGHT)
				{
					poker.pivotX = int(poker.width / 2);
					poker.pivotY = int(poker.height / 2);
					poker.rotation = deg2rad(270);
					poker.y = (this.numChildren == 1) ? int((stage.stageHeight - poker.height) / 2) : (this.getChildAt(this.numChildren - 2) as Poker).y;
				}
				else if (mPosition == POSITION_LEFT)
				{
					poker.pivotX = int(poker.width / 2);
					poker.pivotY = int(poker.height / 2);
					poker.rotation = deg2rad(90);
					poker.y = (this.numChildren == 1) ? int((stage.stageHeight - poker.height) / 2) : (this.getChildAt(this.numChildren - 2) as Poker).y;
				}
				UpdatePosition();
			}
			else		//不需要添加动画
			{
				if (mPosition == POSITION_ME)
					poker.x = (this.numChildren - 1) * mSpace;
				else if (mPosition == POSITION_RIGHT)
				{
					poker.pivotX = int(poker.width / 2);
					poker.pivotY = int(poker.height / 2);
					poker.rotation = deg2rad(270);
					poker.y = 0;	//新添加的一直在0位置，刷新其他的牌
					for (var i:int = 0; i < this.numChildren; i++)
					{
						var tempPoker:Poker = this.getChildAt(i) as Poker;
						tempPoker.y = (this.numChildren - 1 - i) * mSpace;
					}
				}
				else if (mPosition == POSITION_LEFT)
				{
					poker.pivotX = int(poker.width / 2);
					poker.pivotY = int(poker.height / 2);
					poker.rotation = deg2rad(90);
					poker.y = (this.numChildren - 1) * mSpace;
				}
			}
		}
		
		//刷新位置
		private function UpdatePosition():void
		{
			if (this.numChildren == 0)
				return;
			
			//首先计算第一张牌的位置
			var totalWidth:int, totalHeight:int;
			var pokerX:int, pokerY:int;
			var poker:Poker = this.getChildAt(0) as Poker;
			if (mPosition == POSITION_ME)
			{
				totalWidth = (this.numChildren - 1) * mSpace + poker.width;
				pokerX = int((stage.stageWidth - totalWidth) / 2);
				
				for (var i:int = 0; i < this.numChildren; i++)
				{
					var mePoker:Poker = this.getChildAt(i) as Poker;
					var mePokerX:int = pokerX + i * mSpace;
					var mePokerTween:Tween = new Tween(mePoker, MOVIE_TIME, Transitions.LINEAR);
					mePokerTween.moveTo(mePokerX, mePoker.y);
					mePokerTween.onComplete = OnComplete;
					mePokerTween.onCompleteArgs = [mePokerTween];
					Starling.juggler.add(mePokerTween);
				}
			}
			else if (mPosition == POSITION_LEFT)
			{
				totalHeight = (this.numChildren - 1) * mSpace + poker.height;
				pokerY = int((stage.stageHeight - totalHeight) / 2);
				
				for (var m:int = 0; m < this.numChildren; m++)
				{
					var leftPoker:Poker = this.getChildAt(m) as Poker;
					var leftPokerY:int = pokerY + m * mSpace;
					var leftPokerTween:Tween = new Tween(leftPoker, MOVIE_TIME, Transitions.LINEAR);
					leftPokerTween.moveTo(leftPoker.x, leftPokerY);
					leftPokerTween.onComplete = OnComplete;
					leftPokerTween.onCompleteArgs = [leftPokerTween];
					Starling.juggler.add(leftPokerTween);
				}
			}
			else if (mPosition == POSITION_RIGHT)	//右侧的玩家的牌的布局总是让人蛋疼
			{
				totalHeight = (this.numChildren - 1) * mSpace + poker.height;
				pokerY = int((stage.stageHeight - totalHeight) / 2);
				
				for (var n:int = this.numChildren - 1; n >= 0; n--)
				{
					var rightPoker:Poker = this.getChildAt(n) as Poker;
					var rightPokerY:int = pokerY + Math.abs(n + 1 - this.numChildren) * mSpace;
					var rightPokerTween:Tween = new Tween(rightPoker, MOVIE_TIME, Transitions.LINEAR);
					rightPokerTween.moveTo(rightPoker.x, rightPokerY);
					rightPokerTween.onComplete = OnComplete;
					rightPokerTween.onCompleteArgs = [rightPokerTween];
					Starling.juggler.add(rightPokerTween);
				}
			}
		}
		
		//动画结束的处理
		private function OnComplete(tween:Tween):void
		{
			Starling.juggler.remove(tween);
		}
		
		//触摸事件
		private function OnPokerManagerTouch(e:TouchEvent):void
		{
			var touch:Touch = e.getTouch(e.currentTarget as DisplayObject);				//e.currentTarget为添加事件的对象，此处等于this
			
			if (touch && touch.phase == TouchPhase.MOVED)								//鼠标按下并移动
			{
				var point:Point = touch.getLocation(e.currentTarget as DisplayObject);	//获得相对于e.currentTarget的鼠标坐标
				if (this.hitTest(point))												//在e.currentTarget中从顶层开始找包含了point点的displayObject
					(this.hitTest(point) as Poker).color = 0x00ff00;					//该控件只有poker，否则要做判断touch.target is Poker后才能执行
			}
			else if (touch && touch.phase == TouchPhase.ENDED)							//鼠标单击或鼠标按键弹起
			{
				var touchPoker:Poker = touch.target as Poker;							//该控件只有poker，否则要做判断touch.target is Poker后才能执行
				touchPoker.y = (touchPoker.y == 0) ? UP_HEIGHT : 0;
				touchPoker.color = 0xffffff;
				
				//对鼠标按下拖动时影响到的poker进行设置
				for (var i:int = 0; i < this.numChildren; i++)
				{
					var tempPoker:Poker = this.getChildAt(i) as Poker;
					if (tempPoker.color == 0x00ff00)
					{
						tempPoker.color = 0xffffff;
						tempPoker.y = (tempPoker.y == 0) ? UP_HEIGHT : 0;
					}
				}
			}
		}
	}
}