import openfl.display.Shape;

import core.Element;

class Hero extends Element
{
    private var SPEED:Float = 200;
    private var _vx:Float;
	private var dir:Int = 1;
	

    public function new()
    {
        super();
        var s : Shape = new Shape();
        s.graphics.beginFill(0x000000);
        s.graphics.drawRect(0, 0, 60, 120);
        addChild(s);
		
		this.x = 300;
		this.y = 400;
    }

    public function move (hor:Int)
    {
       _vx = hor * SPEED;
	   if (hor != 0)
	   {
			dir = hor;
	   }
    }

    override public function update (dt:Float)
    {
        x += _vx * dt;
    }
	
	public function getCannonPos ()
	{
		return (this.x+30);
	}
	
	public function getDir():Int
	{
		return dir;
	}
}
