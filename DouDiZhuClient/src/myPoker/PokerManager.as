package myPoker {
	import flash.geom.Point;
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
		public static const POSITION_ME:int = 0;	//自己
		public static const POSITION_RIGHT:int = 1;	//右边玩家
		public static const POSITION_LEFT:int = 2;	//左边玩家
		
		private var mPosition:int = 0;	//排列方式
		private var mSpace:int = 0;		//2张牌的间距
		private var mPokerName:String;	//扑克名称
		
		public function PokerManager() 
		{
			super();
			
			this.addEventListener(TouchEvent.TOUCH, OnPokerManagerTouch);
		}
		
		//设置参数
		public function SetParameter(position:int, space:int, pokerName:String):void
		{
			mPosition = position;
			mSpace = space;
			mPokerName = pokerName;
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
			var pokerBackTexture:Texture = Asset.GetPoker().getTexture("Poker_6_0");
			var poker:Poker = new Poker(pokerBackTexture);
			poker.SetPoker(pokerValue, mPokerName);
			poker.useHandCursor = true;
			addChild(poker);
			
			//设置位置
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
		
		//刷新位置
		private function UpdatePosition():void
		{
			if (this.numChildren == 0)
				return;
			
			//首先计算第一张牌的位置
			var poker:Poker = this.getChildAt(0) as Poker;
			if (mPosition == POSITION_ME)
			{
				var totalWidth:int = (this.numChildren - 1) * mSpace + poker.width;
				var pokerX:int = int((stage.stageWidth - totalWidth) / 2);
				
				for (var i:int = 0; i < this.numChildren; i++)
				{
					var mePoker:Poker = this.getChildAt(i) as Poker;
					var mePokerX:int = pokerX + i * mSpace;
					var mePokerTween:Tween = new Tween(mePoker, 0.2, Transitions.LINEAR);
					mePokerTween.moveTo(mePokerX, mePoker.y);
					mePokerTween.onComplete = OnComplete;
					mePokerTween.onCompleteArgs = [mePokerTween];
					Starling.juggler.add(mePokerTween);
				}
			}
			else if (mPosition == POSITION_RIGHT || mPosition == POSITION_LEFT)
			{
				var totalHeight:int = (this.numChildren - 1) * mSpace + poker.height;
				var pokerY:int = int((stage.stageHeight - totalHeight) / 2);
				
				for (var m:int = 0; m < this.numChildren; m++)
				{
					var rightPoker:Poker = this.getChildAt(m) as Poker;
					var rightPokerY:int = pokerY + m * mSpace;
					var rightPokerTween:Tween = new Tween(rightPoker, 0.2, Transitions.LINEAR);
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
				touchPoker.y = (touchPoker.y == 0) ? -10 : 0;
				touchPoker.color = 0xffffff;
				
				//对鼠标按下拖动时影响到的poker进行设置
				for (var i:int = 0; i < this.numChildren; i++)
				{
					var tempPoker:Poker = this.getChildAt(i) as Poker;
					if (tempPoker.color == 0x00ff00)
					{
						tempPoker.color = 0xffffff;
						tempPoker.y = (tempPoker.y == 0) ? -10 : 0;
					}
				}
			}
		}
	}
}