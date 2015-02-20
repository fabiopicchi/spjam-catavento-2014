import openfl.display.Shape;
import openfl.geom.Rectangle;

import core.Element;
import core.AnimatedSprite;

class Puddle extends Element
{
    private var _body:Body;
    private var DURATION:Int = 5;
    private var _timer:Float = 0;
    private var _disappearing:Bool = false;

    private var BODY_WIDTH:Int = 30;
    private var BODY_HEIGHT:Int = 30;
	private var FRAME_WIDTH:Int = 60;
    private var FRAME_HEIGHT:Int = 60;
    private var _anim:AnimatedSprite;

    public function new(x : Float, y : Float)
    {
        super();
        
        _anim = new AnimatedSprite("assets/animations.json", "puddle");
        _anim.setAnimation("appear");
        addElement(_anim);

        _body = new Body(BODY_WIDTH, BODY_HEIGHT);
        _body.position.x = x - BODY_WIDTH/2;
        _body.position.y = y - BODY_HEIGHT/2;

        this.x = x;
        this.y = y;

        _timer = DURATION;
    }

    public function getBody():Body
    {
        return _body;
    }

    override public function update (dt:Float)
    {
        if (_timer <= 0)
        {
            if(!_disappearing)
            {
                startDisappearing();
            }
            else if(_anim.isOver())
            {
                visible = false;
            }
        }
        else
        {
            if (_anim.isOver())
            {
                _anim.setAnimation("idle");
                _timer -= dt;
            }
        }
        super.update(dt);
    }
	
	public function startDisappearing()
    {
        _disappearing = true;
        _timer = 0;
        _anim.setAnimation("disappear");
    }
}
