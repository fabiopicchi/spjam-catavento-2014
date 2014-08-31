import core.SpriteSheet;
import openfl.display.Shape;
import openfl.geom.Rectangle;

import core.Element;

class Player extends Element
{
    private var SPEED:Float = 180;
    private var _body:Body;
	
	private var _spriteSheet:SpriteSheet;
	private var FRAME_WIDTH:Int = 72;
    private var FRAME_HEIGHT:Int = 60;

    private var H_SQRT2:Float;

    public function new(x:Float, y:Float)
    {
        super();

        _body = new Body(40, 10);
		_body.position.x = x;
		_body.position.y = y;
		     
		_spriteSheet = new SpriteSheet("assets/coelho.png", FRAME_WIDTH, FRAME_HEIGHT) ;
		_spriteSheet.loadAnimationsFromJSON("assets/ss_bunny.json");
		_spriteSheet.setAnimation("idle");
		
		_spriteSheet.x = -10;
		_spriteSheet.y = -50;
		
		addElement(_spriteSheet);

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
