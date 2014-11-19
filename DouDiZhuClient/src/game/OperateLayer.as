package game 
{
	import help.DanJiLogic;
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
		private var mBuChu:MyButton;	//不出
		private var mTiShi:MyButton;	//提示
		private var mChuPai:MyButton;	//出牌
		
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
			mJiao.x = int((stage.stageWidth - greenNormal.width - yellowNormal.width - 80) / 2);
			mJiao.y = 440;
			addChild(mJiao);
			
			//不叫
			mBuJiao = new MyButton(yellowNormal, "不叫", yellowDown, yellowOver);
			mBuJiao.x = mJiao.x + mJiao.width + 80;
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
			
			//不出
			mBuChu = new MyButton(yellowNormal, "不出", yellowDown, yellowOver);
			mBuChu.x = 380;
			mBuChu.y = stage.stageHeight - 200;
			addChild(mBuChu);
			
			//提示
			mTiShi = new MyButton(greenNormal, "提示", greenDown, greenOver);
			mTiShi.x = 550;
			mTiShi.y = stage.stageHeight - 200;
			addChild(mTiShi);
			
			//出牌
			mChuPai = new MyButton(greenNormal, "出牌", greenDown, greenOver);
			mChuPai.x = 650;
			mChuPai.y = stage.stageHeight - 200;
			addChild(mChuPai);
			
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
			mBuChu.visible = false;
			mTiShi.visible = false;
			mChuPai.visible = false;
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
		
		//设置出牌操作 参数为true时：第一手牌，或者自己的牌最大，自己必须出牌
		public function SetPlayCard(bFirst:Boolean):void
		{
			Reset();
			
			if (bFirst)
			{
				mChuPai.visible = true;
				mChuPai.x = 550;
			}
			else
			{
				mBuChu.visible = true;
				mTiShi.visible = true;
				mChuPai.visible = true;
				mChuPai.x = 650;
			}
		}
		
		//Triggered事件监听
		private function OnTriggered(e:Event):void
		{
			if (e.target is MyButton)
			{
				var tempButton:MyButton = e.target as MyButton;
				if (tempButton == mJiao)
					DanJiLogic.sDanJiLogic.JiaoDiZhu(0, true);
				else if (tempButton == mBuJiao)
					DanJiLogic.sDanJiLogic.JiaoDiZhu(0, false);
				else if (tempButton == mQiang)
					DanJiLogic.sDanJiLogic.QiangDiZhu(0, true);
				else if (tempButton == mBuQiang)
					DanJiLogic.sDanJiLogic.QiangDiZhu(0, false);
				else if (tempButton == mChuPai)
					DanJiLogic.sDanJiLogic.OutCard(0, PokerManagerLayer.sPokerManagerLayer.GetUpPokers());
			}
		}
	}
}