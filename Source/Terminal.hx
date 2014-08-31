import openfl.display.Bitmap;
import openfl.geom.Rectangle;
import openfl.Assets;

import core.SpriteSheet;
import core.Element;

class Terminal extends Element
{
    private var _id:Int;
	private var _body:Body;
	private var _deactivationTimer:Float;
    private var _ss:SpriteSheet;
    private var _light:Bitmap;

    public static var BLUE:String = "blue";
    public static var GREEN:String = "green";
    public static var RED:String = "red";
 
    private var FRAME_WIDTH:Int = 60;
    private var FRAME_HEIGHT:Int = 60;

    public function new(x:Float, y:Float, id:Int, direction:Int, colour:String )
    {
        super();
        
        // The spritesheet represents only the upper part of the terminal
        y -= FRAME_HEIGHT;

        _ss = new SpriteSheet("assets/terminal.png", FRAME_WIDTH, FRAME_HEIGHT);
        addElement(_ss);
        _ss.addAnimation("frente-ligado", 
                [new Rectangle(0, 0, FRAME_WIDTH, FRAME_HEIGHT)], 
                false, 1);
        _ss.addAnimation("frente-desligado", 
                [new Rectangle(FRAME_WIDTH, 0, FRAME_WIDTH, FRAME_HEIGHT)], 
                false, 1);
        _ss.addAnimation("lado-ligado", 
                [new Rectangle(2 * FRAME_WIDTH, 0, FRAME_WIDTH, FRAME_HEIGHT)], 
                false, 1);
        _ss.addAnimation("lado-desligado", 
                [new Rectangle(3 * FRAME_WIDTH, 0, FRAME_WIDTH, FRAME_HEIGHT)], 
                false, 1);

        switch(direction)
        {
            case 0:
                _ss.setAnimation("lado-ligado");
            case 1:
                _ss.setAnimation("frente-ligado");
            case 2:
                _ss.setAnimation("lado-ligado");
                scaleX = -1;
                x += width;
        }

        _light = new Bitmap(Assets.getBitmapData("assets/" +
                    (direction % 2 == 0 ? "w42h20_" : "w42h45_") + 
                    colour + "_" + 
                    (direction % 2 == 0 ? "lado" : "frente") +
                    ".png"));
        _light.x = 42;
        _light.y = 40;
        _ss.addChild(_light);

        _body = new Body(60, 60);
		_body.position.x = x;
		_body.position.y = y;
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
            _deactivationTimer = 0;
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
		dispatchEvent(new CircuitEvent(CircuitEvent.OFF, _id));
		_deactivationTimer = 10;
	}

	public function isActivated():Bool 
    {
		return (_deactivationTimer <= 0);
	}
}
