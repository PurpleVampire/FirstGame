package mylib 
{
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.textures.Texture;
	
	/**
	 * 数字类
	 * @author Vampire
	 */
	public class MyNumber extends Sprite 
	{
		//符号层和数字层
		private var mSymbolLayer:Sprite;
		private var mNumberLayer:Sprite;
		
		private var mNumber:int;			//数值
		private var mSpace:int;				//数字之间的间隔
		private var mNumberName:String;		//数值名称
		
		public function MyNumber() 
		{
			super();
			
			this.addEventListener(Event.ADDED_TO_STAGE, Init);
		}
		
		//初始化
		private function Init(e:Event):void
		{
			mSymbolLayer = new Sprite;
			addChild(mSymbolLayer);
			mNumberLayer = new Sprite;
			addChild(mNumberLayer);
		}
		
		//设置参数（使用该类时要先设置参数，否则不会有数字显示）
		public function SetParameter(numberName:String, space:int = 0):void
		{
			mNumberName = numberName;
			mSpace = space;
		}
		
		//设置数字（数字是几位就显示几位，是99显示99，是9显示9，而不显示09）
		public function SetNumberWithParameter1(number:int):void
		{
			mNumber = number;
			var str:String = number.toString();
			
			SetNumber(str);
		}
		
		//设置数字和位数（比如一直显示2位，则倒计时到10以下时显示为09、08...）
		public function SetNumberWithParameter2(number:int, count:int):void
		{
			mNumber = number;
			
			//如果位数不足，在前面添加0
			var str:String = number.toString();
			var chaZhi:int = count - str.length;
			for (var i:int = 0; i < chaZhi; i++)
				str = "0" + str;
			
			SetNumber(str);
		}
		
		//添加数字
		public function SetNumber(str:String):void
		{
			//先清空所有的子对象
			mNumberLayer.removeChildren();
			
			//获得数字的位数
			var length:int = str.length;
			
			for (var i:int = 0; i < length; i++)
			{
				var index:String = str.charAt(i);
				var texture:Texture = Asset.GetPoker().getTexture(mNumberName + index);
				var image:Image = new Image(texture);
				mNumberLayer.addChild(image);
				
				var numberCount:int = mNumberLayer.numChildren;
				image.x = (numberCount == 1) ? 0 : mNumberLayer.getChildAt(mNumberLayer.numChildren - 2).x + mNumberLayer.getChildAt(mNumberLayer.numChildren - 2).width + mSpace;
			}
		}
	}
}