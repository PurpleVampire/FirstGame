package myPoker {
	import mylib.Asset;
	import starling.display.Image;
	import starling.textures.Texture;
	
	/**
	 * 扑克类
	 * @author Vampire
	 */
	public class Poker extends Image 
	{
		public var mPokerValue:Number = 0xff;	//扑克的整个值，包括花色和牌面数字
		public var mSuit:int = 0;				//花色 1方片 2梅花 3红桃 4黑桃 5王 6背面
		public var mValue:int = 0;				//牌面数字 1-13 分别表示3、4、5、6、7、8、9、10、J、Q、K、A、2
		
		public function Poker(texture:Texture) 
		{
			super(texture);
		}
		
		//设置扑克 第一个参数为0xff格式的扑克值，第二个参数为扑克名Poker_1_3中的前缀"Poker"
		public function SetPoker(pokerValue:Number, pokerName:String):void
		{
			if (pokerValue == 0)
				throw new Error("扑克值不能为0");
			
			//计算花色和牌面数字
			mPokerValue = pokerValue;
			mSuit = pokerValue & 0x0f;
			mValue = pokerValue >> 4;
			
			//设置扑克牌
			this.texture = Asset.GetPoker().getTexture(pokerName + "_" + mValue + "_" + mSuit);
		}
	}
}