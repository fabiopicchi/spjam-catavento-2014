import core.SpriteSheet;
import openfl.display.Shape;
import openfl.geom.Rectangle;

import core.Element;

class LevelEnd extends Element
{
    private var _body:Body;

    public function new(x:Float, y:Float)
    {
        super();

        _body = new Body(40, 20);
		_body.position.x = x;
		_body.position.y = y;
		
    }

    public function getBody():Body
    {
        return _body;
    }
}
