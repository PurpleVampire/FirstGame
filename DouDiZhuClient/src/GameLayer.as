package  
{
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;
	
	/**
	 * 总游戏层
	 * @author Vampire
	 */
	public class GameLayer extends Sprite 
	{
		private static var gGameLayer:GameLayer;//单例模式
		
		public function GameLayer() 
		{
			super();
			
			if (!gGameLayer)
				gGameLayer = this;
			else
				throw new Error("单例模式，直接使用静态变量gGameLayer");
			
			this.addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		//初始化
		protected function init(e:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, init);
			
			CreateBox();
		}
		
		public function CreateBox():void
		{
			var box:Sprite = new Sprite;
			addChild(box);
			box.x = 90;
			box.y = 90;
			
			var q:Quad = new Quad(128, 128, 0x009ee1);
			box.addChild(q);
			
			var text:TextField = new TextField(100, 100, "我擦", "楷体", 16, 0xff0000);
			text.border = true;
			box.addChild(text);
		}
	}
}