import openfl.Assets;
import openfl.display.Bitmap;
import openfl.display.Shape;
import openfl.geom.Rectangle;

import core.Element;
import core.AnimatedSprite;

class DizzyStar extends Element
{
    private var _star:Bitmap;
	private var _movementWidth:Int = 30;
	private var _movementHeight:Int = 8;
	private var _position:Float = 0;
	
    public function new(x : Float, y : Float)
    {
        super();
        
		_star = new Bitmap (Assets.getBitmapData ("images/star.png"));
        addChild(_star);
		
        this.x = x;
        this.y = y;
    }

    override public function update (dt:Float)
    {
        _position += dt;
		_star.x = Math.cos(_position * 10)*_movementWidth;
		_star.y = Math.sin(_position * 10)*_movementHeight;
        super.update(dt);
    }
}
