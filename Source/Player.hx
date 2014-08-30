import openfl.display.Shape;

import core.Element;

class Player extends Element
{
    private var SPEED:Float = 100;

    private var _vx:Float;
    private var _vy:Float;
    private var H_SQRT2:Float;

    public function new()
    {
        super();
        var s : Shape = new Shape();
        s.graphics.beginFill(0x000000);
        s.graphics.drawRect(0, 0, 50, 50);
        addChild(s);

        H_SQRT2 = Math.sqrt(2)/2;
    }

    public function move (hor:Int, ver:Int)
    {
        if (hor != 0 && ver != 0)
        {
            _vx = hor * SPEED * H_SQRT2;
            _vy = ver * SPEED * H_SQRT2;
        }
        else
        {
            _vx = hor * SPEED;
            _vy = ver * SPEED;
        }
    }

    override public function update (dt:Float)
    {
        x += _vx * dt;
        y += _vy * dt;
    }
}
