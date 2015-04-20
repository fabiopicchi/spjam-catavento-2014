import core.AnimatedSprite;
import openfl.display.Shape;
import openfl.geom.Rectangle;

import core.Element;

class Player extends Element
{
    private var SPEED:Float = 180;
    private var _body:Body;
    private var _facing:Int;
	private var _anim:AnimatedSprite;
	private var FRAME_WIDTH:Int = 72;
    private var FRAME_HEIGHT:Int = 60;
    private var H_SQRT2:Float;

    public function new(x:Float, y:Float)
    {
        super();

        _body = new Body(40, 10);
		_body.position.x = x;
		_body.position.y = y;
		     
		_anim = new AnimatedSprite("assets/animations.json", "bunny");
		_anim.setAnimation("idle-right");
		addElement(_anim);

        H_SQRT2 = Math.sqrt(2)/2;
        _facing = 0;
    }

    public function move (hor:Int, ver:Int)
    {
        if (_anim.isOver())
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
               _anim.setAnimation("walk-" + (_facing == 0 ? "right" :
                           "left"));
            else
               _anim.setAnimation("idle-" + (_facing == 0 ? "right" :
                           "left")); 
        }
    }

    public function water()
    {
        if (_anim.isOver())
        {
            _body.speed.x = 0;
            _body.speed.y = 0;
            _anim.setAnimation("water-" + (_facing == 0 ? "right" : "left"));
        }
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
        
        #if debug
        graphics.clear();
        graphics.beginFill(0xFF0000);
        graphics.drawRect(0, 0, _body.width, _body.height);
        graphics.endFill();

        graphics.lineStyle(1, 0xFF0000);
        graphics.drawRect(_anim.x, _anim.y, _anim.width, _anim.height);
        #end
    }
}
