package game 
{
	import starling.display.Sprite;
	import starling.events.Event;
	
	/**
	 * 背景层
	 * @author Vampire
	 */
	public class BackgroundLayer extends Sprite 
	{
		public static var sBackgroundLayer:BackgroundLayer = new BackgroundLayer;	//单例模式
		
		public function BackgroundLayer() 
		{
			super();
			
			if (!sBackgroundLayer)
				sBackgroundLayer = this;
			else
				throw new Error("单例模式，直接使用静态变量sBackgroundLayer");
			
			this.addEventListener(Event.ADDED_TO_STAGE, Init);
		}
		
		//初始化
		private function Init(e:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, Init);
			
			stage.color = 0x0d7dc5;
		}
	}
}