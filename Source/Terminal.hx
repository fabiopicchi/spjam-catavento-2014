import openfl.display.Bitmap;
import openfl.geom.Rectangle;
import openfl.Assets;

import core.AnimatedSprite;
import core.Element;

class Terminal extends Element
{
    public var id:Int;
    private var _body:Body;
    private var _direction:Int;
    private var _deactivationTimer:Float;
	private var _deactivationTime:Float;
    private var _anim:AnimatedSprite;
    private var _light:Bitmap;

    public static var BLUE:String = "blue";
    public static var GREEN:String = "green";
    public static var RED:String = "red";

    private var FRAME_WIDTH:Int = 60;
    private var FRAME_HEIGHT:Int = 120;

    public function new(x:Float, y:Float, id:Int, direction:Int, deactivationTime:Float, colour:String)
    {
        super();

        _body = new Body(60, 60);
        _body.position.x = x;
        _body.position.y = y;

        this.id = id;
		_deactivationTime = deactivationTime;
        _direction = direction;
	
        _anim = new AnimatedSprite("assets/animations.json", "terminal");
        _anim.setAnimation("on-" + animationDirection);

        _light = new Bitmap(Assets.getBitmapData("images/" +
            (direction % 2 == 0 ? "w42h20_" : "w42h45_") + colour + "_" + 
            (direction % 2 == 0 ? "lado" : "frente") + ".png"));
        _light.x = 42;
        _light.y = 40;
        _anim.addChild(_light);

        addElement(_anim);
    }

    public function getBody():Body
    {
        return _body;
    }

    override public function update (dt:Float)
    {
        if (_deactivationTimer > 0) 
        {
            _deactivationTimer -= dt;
        }
        else 
        {
            if (!_light.visible)
            {
                _deactivationTimer = 0;
                _light.visible = true;
                _anim.setAnimation("on-" + animationDirection);
                dispatchEvent(new CircuitEvent(CircuitEvent.REACTIVATE, id));
            }
        }
    }

    override public function draw()
    {
        x = _body.position.x;
        y = _body.position.y;
        super.draw();
    }

    public function deactivate():Void 
    {
        _anim.setAnimation("off-" + animationDirection);
        _light.visible = false;
        _deactivationTimer = _deactivationTime;
    }

    public function isActivated():Bool 
    {
        return (_deactivationTimer <= 0);
    }

    private var animationDirection(get,null):String;
    private function get_animationDirection():String
    {
        switch(_direction)
        {
            case 0:
                return "right";
            case 1:
                return "down";
            case 2:
                return "left";
            default:
                trace("INVALID DIRECTION");
                return "none";
        }
    }
}
