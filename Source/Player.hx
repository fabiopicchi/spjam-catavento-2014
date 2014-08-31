import core.SpriteSheet;
import openfl.display.Shape;
import openfl.geom.Rectangle;

import core.Element;

class Player extends Element
{
    private var SPEED:Float = 180;
    private var _body:Body;
    private var _facing:Int;
	private var _ss:SpriteSheet;
	private var FRAME_WIDTH:Int = 72;
    private var FRAME_HEIGHT:Int = 60;
    private var H_SQRT2:Float

    public function new(x:Float, y:Float)
    {
        super();

        _body = new Body(40, 10);
		_body.position.x = x;
		_body.position.y = y;
		     
		_ss = new SpriteSheet("assets/coelho.png", FRAME_WIDTH, FRAME_HEIGHT) ;
		_ss.loadAnimationsFromJSON("assets/ss_bunny.json");
		_ss.setAnimation("idle-right");
		
		_ss.x = -10;
		_ss.y = -50;
		addElement(_ss);

        H_SQRT2 = Math.sqrt(2)/2;
        _facing = 0;
    }

    public function move (hor:Int, ver:Int)
    {
        if (_ss.isOver())
        {
            _body.speed.x = hor * SPEED;
            _body.speed.y = ver * SPEED;

            if (hor != 0 && ver != 0)
            {
                _body.speed.x *= H_SQRT2;
                _body.speed.y *= H_SQRT2;
            }

            if(_body.speed.x > 0)
                _facing = 0;
            else if(_body.speed.x < 0)
                _facing = 1;

            if (hor != 0 || ver != 0)
               _ss.setAnimation("walk-" + (_facing == 0 ? "right" :
                           "left"));
            else
               _ss.setAnimation("idle-" + (_facing == 0 ? "right" :
                           "left")); 
        }
    }

    public function water()
    {
        _body.speed.x = 0;
        _body.speed.y = 0;
       _ss.setAnimation("water-" + (_facing == 0 ? "right" : "left"));
    }

    public function getFacing():Int
    {
        return _facing;
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
