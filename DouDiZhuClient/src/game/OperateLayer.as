package game 
{
	import mylib.Asset;
	import mylib.MyButton;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.textures.Texture;
	
	/**
	 * 操作层
	 * @author Vampire
	 */
	public class OperateLayer extends Sprite 
	{
		public static var sOperateLayer:OperateLayer = new OperateLayer;	//单例模式
		
		private var mJiao:MyButton;		//叫地主
		private var mBuJiao:MyButton;	//不叫
		private var mQiang:MyButton;	//抢地主
		private var mBuQiang:MyButton;	//不抢
		
		public function OperateLayer() 
		{
			super();
			
			if (!sOperateLayer)
				sOperateLayer = this;
			else
				throw new Error("单例模式，直接使用静态变量sOperateLayer");
			
			this.addEventListener(Event.ADDED_TO_STAGE, Init);
		}
		
		//初始化
		private function Init():void
		{
			var greenNormal:Texture = Asset.GetPoker().getTexture("Button_Start_0");
			var greenOver:Texture = Asset.GetPoker().getTexture("Button_Start_1");
			var greenDown:Texture = Asset.GetPoker().getTexture("Button_Start_2");
			
			var yellowNormal:Texture = Asset.GetPoker().getTexture("Button_Return_0");
			var yellowOver:Texture = Asset.GetPoker().getTexture("Button_Return_1");
			var yellowDown:Texture = Asset.GetPoker().getTexture("Button_Return_2");
			
			//叫地主
			mJiao = new MyButton(greenNormal, "叫地主", greenDown, greenOver);
			mJiao.x = int((stage.stageWidth - greenNormal.width - yellowNormal.width - 50) / 2);
			mJiao.y = 450;
			addChild(mJiao);
			
			//不叫
			mBuJiao = new MyButton(yellowNormal, "不叫", yellowDown, yellowOver);
			mBuJiao.x = mJiao.x + mJiao.width + 50;
			mBuJiao.y = mJiao.y;
			addChild(mBuJiao);
			
			//抢地主
			mQiang = new MyButton(greenNormal, "抢地主", greenDown, greenOver);
			mQiang.x = mJiao.x;
			mQiang.y = mJiao.y;
			addChild(mQiang);
			
			//不抢
			mBuQiang = new MyButton(yellowNormal, "不抢", yellowDown, yellowOver);
			mBuQiang.x = mBuJiao.x;
			mBuQiang.y = mBuJiao.y;
			addChild(mBuQiang);
			
			//监听Triggered事件
			this.addEventListener(Event.TRIGGERED, OnTriggered);
			
			Reset();
		}
		
		//重置
		public function Reset():void
		{
			mJiao.visible = false;
			mBuJiao.visible = false;
			mQiang.visible = false;
			mBuQiang.visible = false;
		}
		
		//设置叫地主
		public function SetJiao():void
		{
			Reset();
			mJiao.visible = true;
			mBuJiao.visible = true;
		}
		
		//设置抢地主
		public function SetQiang():void
		{
			Reset();
			mQiang.visible = true;
			mBuQiang.visible = true;
		}
		
		//Triggered事件监听
		private function OnTriggered(e:Event):void
		{
			if (e.target is MyButton)
			{
				var tempButton:MyButton = e.target as MyButton;
				if (tempButton == mJiao)
					DouDiZhu.sDouDiZhu.JiaoDiZhu(0, true);
				else if (tempButton == mBuJiao)
					DouDiZhu.sDouDiZhu.JiaoDiZhu(0, false);
				else if (tempButton == mQiang)
					DouDiZhu.sDouDiZhu.QiangDiZhu(0, true);
				else if (tempButton == mBuQiang)
					DouDiZhu.sDouDiZhu.QiangDiZhu(0, false);
			}
		}
	}
}