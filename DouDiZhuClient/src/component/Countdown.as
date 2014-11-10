package component 
{
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import mylib.Asset;
	import mylib.MyNumber;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.textures.Texture;
	
	/**
	 * 倒计时
	 * @author Vampire
	 */
	public class Countdown extends Sprite 
	{
		private var mNumber:MyNumber;	//数字类
		private var mTime:int;			//时间数字
		private var mTimer:Timer;		//定时器
		
		public function Countdown() 
		{
			super();
			
			this.addEventListener(Event.ADDED_TO_STAGE, Init);
		}
		
		//初始化
		private function Init(e:Event):void
		{
			//背景
			var bgTexture:Texture = Asset.GetPoker().getTexture("Countdown_Bg");
			var bg:Image = new Image(bgTexture);
			addChild(bg);
			
			//数字
			mNumber = new MyNumber;
			mNumber.SetParameter("Countdown_Number_", 5);
			mNumber.x = 8;
			mNumber.y = 8;
			addChild(mNumber);
			mNumber.SetNumberWithParameter2(0, 2);
			
			mTimer = new Timer(1000);
			mTimer.addEventListener(TimerEvent.TIMER, OnTimer);
		}
		
		//设置时间
		public function SetTime(time:int):void
		{
			mTime = time;
			mNumber.SetNumberWithParameter2(time, 2);
			mTimer.reset();
			mTimer.start();
		}
		
		//游戏时间
		private function OnTimer(e:TimerEvent):void
		{
			if(mTime == 0)
			{
				mTimer.stop();
				mTime = 0;
				return;
			}
			
			mTime--;
			mNumber.SetNumberWithParameter2(mTime, 2);
		}
	}
}