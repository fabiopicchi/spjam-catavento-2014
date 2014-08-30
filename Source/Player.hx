import openfl.display.Shape;

import core.Element;

class Player extends Element
{
    private var SPEED:Float = 600;
    private var _body:Body;

    private var H_SQRT2:Float;

    public function new()
    {
        super();

        _body = new Body(50, 50);

        var s : Shape = new Shape();
        s.graphics.beginFill(0x000000);
        s.graphics.drawRect(0, 0, 50, 50);
        addChild(s);

        H_SQRT2 = Math.sqrt(2)/2;
    }

    public function move (hor:Int, ver:Int)
    {
        _body.speed.x = hor * SPEED;
        _body.speed.y = ver * SPEED;

        if (hor != 0 && ver != 0)
        {
            _body.speed.x *= H_SQRT2;
            _body.speed.y *= H_SQRT2;
        }
    }

    public function getBody():Body
    {
        return _body;
    }

    override public function update (dt:Float)
    {
        _body.update(dt);
        super.update(dt);
    }

    override public function draw()
    {
        x = _body.position.x;
        y = _body.position.y;
        super.draw();
    }
}
