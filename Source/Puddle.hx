import openfl.geom.Rectangle;

import core.Element;
import core.SpriteSheet;

class Puddle extends Element
{
    private var _body:Body;
    private var DURATION:Int = 5;
    private var _timer:Float = 0;
    private var _disappearing:Bool = false;

    private var FRAME_WIDTH:Int = 60;
    private var FRAME_HEIGHT:Int = 60;
    private var _ss:SpriteSheet;

    public function new(x : Float, y : Float)
    {
        super();
        
        _ss = new SpriteSheet("assets/agua.png", FRAME_WIDTH, FRAME_HEIGHT);
        
        var arFrames = new Array<Rectangle>();
        for (i in 0...4)
        {
            arFrames.push(new Rectangle((3 - i) * FRAME_WIDTH, 0, 
                        FRAME_WIDTH, FRAME_HEIGHT));
        }
        _ss.addAnimation("idle", [new Rectangle(3 * FRAME_WIDTH, 0, FRAME_WIDTH,
                    FRAME_HEIGHT)], false, 1);
        _ss.addAnimation("disappear", arFrames, false, 12);
        _ss.setAnimation("idle");

        addElement(_ss);

        _body = new Body(50, 50);
        _body.position.x = x;
        _body.position.y = y;

        this.x = x;
        this.y = y;

        _timer = DURATION;

        trace(x);
        trace(y);
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
            else if(_ss.isOver())
            {
                _ss.visible = false;
            }
        }
        else
        {
            _timer -= dt;
        }
        super.update(dt);
    }
	
	public function startDisappearing()
    {
        _disappearing = true;
        _ss.setAnimation("disappear");
    }
}
