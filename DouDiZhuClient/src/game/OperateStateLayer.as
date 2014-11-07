package game 
{
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;
	
	/**
	 * 操作的状态：叫地主、不叫地主、抢地主、不抢地主、不要
	 * @author Vampire
	 */
	public class OperateStateLayer extends Sprite 
	{
		public static var sOperateStateLayer:OperateStateLayer = new OperateStateLayer;	//单例模式
		
		private var mStates:Array = [];	//视图座位号
		
		public function OperateStateLayer() 
		{
			super();
			
			if (!sOperateStateLayer)
				sOperateStateLayer = this;
			else
				throw new Error("单例模式，直接使用静态变量sOperateStateLayer");
			
			this.addEventListener(Event.ADDED_TO_STAGE, Init);
		}
		
		//初始化
		private function Init():void
		{
			//自己的状态
			var meTextField:TextField = new TextField(100, 50, "", "黑体", 25, 0x000000, true);
			meTextField.x = int((stage.stageWidth - meTextField.width) / 2);
			meTextField.y = 450;
			addChild(meTextField);
			mStates.push(meTextField);
			
			//右边玩家的状态
			var rightTextField:TextField = new TextField(100, 50, "", "黑体", 25, 0x000000, true);
			rightTextField.x = stage.stageWidth - rightTextField.width - 150;
			rightTextField.y = 250;
			addChild(rightTextField);
			mStates.push(rightTextField);
			
			//左边玩家的状态
			var leftTextField:TextField = new TextField(100, 50, "", "黑体", 25, 0x000000, true);
			leftTextField.x = 150;
			leftTextField.y = 250;
			addChild(leftTextField);
			mStates.push(leftTextField);
		}
		
		//设置状态
		public function SetState(viewSeatID:int, state:String):void
		{
			var textField:TextField = mStates[viewSeatID] as TextField;
			textField.text = state;
		}
	}
}