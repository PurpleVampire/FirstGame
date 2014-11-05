package mylib
{	
	import flash.display.Bitmap;
	import flash.utils.Dictionary;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	/**
	 * 资源管理器
	 * 该类包含了通过Embed方法添加的纹理、字体、声音、其他文件等
	 * @author Vampire
	 */
	public class Asset 
	{
		//扑克
		[Embed(source="../../textures/Poker.png")]
		public static const PokerTexture:Class;
		[Embed(source="../../textures/Poker.xml", mimeType="application/octet-stream")]
		public static const PokerXml:Class;
		
		//扑克纹理
		private static var sPokerTexture:TextureAtlas;
		
		//纹理缓存
		private static var sTextures:Dictionary = new Dictionary;
		
		public function Asset() 
		{
		}
		
		//扑克纹理
		public static function GetPoker():TextureAtlas
		{
			if (sPokerTexture == null)
			{
				var texture:Texture = GetTexture("PokerTexture");
				var xml:XML = XML(new PokerXml);
				sPokerTexture = new TextureAtlas(texture, xml);
			}
			
			return sPokerTexture;
		}
		
		//name:纹理的静态类名，如PokerTexture类
		public static function GetTexture(name:String):Texture
		{
			if (Asset[name] != undefined)
			{
				if (sTextures[name] == undefined)
				{
					var bitmap:Bitmap = new Asset[name] as Bitmap;
					sTextures[name] = Texture.fromBitmap(bitmap);
				}
				return sTextures[name];
			}
			else throw new Error("没有名称为" + name + "的资源");
		}
	}
}