package mylib
{
	import flash.geom.Rectangle;
	import starling.display.Button;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.Texture;
	
	/**
	 * 扩展Starling引擎的Button按钮
	 * @author Vampire
	 */
	public class MyButton extends Button 
	{
		private static const MAX_DRAG_DIST:Number = 50;
		
        private static const UP:String = "up";
        private static const DOWN:String = "down";
        private static const OVER:String = "over";
        
        private var mState:String = UP;
        
		private var mUpState:Texture;
        private var mOverState:Texture;
        
		public function MyButton(upState:Texture, text:String = "", downState:Texture = null, overState:Texture = null)
		{
			super(upState, text, downState);
			mUpState = upState;
			mOverState = overState;
            addEventListener(TouchEvent.TOUCH, onTouch);
		}
		
		private function onTouch(e:TouchEvent):void
        {
            var touch:Touch = e.getTouch(this);
            if(!touch)
            {
                mState = UP;
                upState = mUpState;
                return;
            }
            if(enabled && mState != OVER && touch.phase == TouchPhase.HOVER)   
            {
                mState = OVER;
                if(mOverState)
                    upState = mOverState;
            }
            else if(touch.phase == TouchPhase.BEGAN && mState != DOWN)
			{
                mState = DOWN;
            }
            else if (touch.phase == TouchPhase.ENDED && mState == DOWN)
            {
                mState = UP;
            }
            else if (touch.phase == TouchPhase.MOVED && mState == DOWN)
            {
                var buttonRect:Rectangle = getBounds(stage);
                if (touch.globalX < buttonRect.x - MAX_DRAG_DIST ||
                    touch.globalY < buttonRect.y - MAX_DRAG_DIST ||
                    touch.globalX > buttonRect.x + buttonRect.width + MAX_DRAG_DIST ||
                    touch.globalY > buttonRect.y + buttonRect.height + MAX_DRAG_DIST)
                {
                    mState = UP;
					upState = mUpState;
                }
            }
        }
	}
}