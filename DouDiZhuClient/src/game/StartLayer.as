package game 
{
	import mylib.Asset;
	import mylib.MyButton;
	import starling.core.Starling;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.textures.Texture;
	
	/**
	 * 开始层
	 * @author Vampire
	 */
	public class StartLayer extends Sprite 
	{
		public static var sStartLayer:StartLayer = new StartLayer;	//单例模式
		
		private var mStartButton:MyButton;	//开始按钮
		private var mReturnButton:MyButton;	//返回按钮
		
		public function StartLayer() 
		{
			super();
			
			if (!sStartLayer)
				sStartLayer = this;
			else
				throw new Error("单例模式，直接使用静态变量sStartLayer");
			
			this.addEventListener(Event.ADDED_TO_STAGE, Init);
		}
		
		//初始化
		private function Init(e:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, Init);
			
			//开始按钮
			var startNormal:Texture = Asset.GetPoker().getTexture("Button_Start_0");
			var startOver:Texture = Asset.GetPoker().getTexture("Button_Start_1");
			var startDown:Texture = Asset.GetPoker().getTexture("Button_Start_2");
			mStartButton = new MyButton(startNormal, "开始", startDown, startOver);
			addChild(mStartButton);
			
			//返回按钮
			var returnNormal:Texture = Asset.GetPoker().getTexture("Button_Return_0");
			var returnOver:Texture = Asset.GetPoker().getTexture("Button_Return_1");
			var returnDown:Texture = Asset.GetPoker().getTexture("Button_Return_2");
			mReturnButton = new MyButton(returnNormal, "返回", returnDown, returnOver);
			mReturnButton.x = mStartButton.x + mStartButton.width + 50;
			addChild(mReturnButton);
			
			//监听Triggered事件
			this.addEventListener(Event.TRIGGERED, OnTriggered);
		}
		
		//Triggered事件监听
		private function OnTriggered(e:Event):void
		{
			if (e.target is MyButton)
			{
				var tempButton:MyButton = e.target as MyButton;
				if (tempButton == mStartButton)
					Start();
				else if (tempButton == mReturnButton)
					Return();
			}
		}
		
		//开始游戏
		private function Start():void
		{
			DouDiZhu.sDouDiZhu.removeChild(this);
			DouDiZhu.sDouDiZhu.GameStart();
		}
		
		//返回
		private function Return():void
		{
		}
	}
}