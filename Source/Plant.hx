import core.AnimatedSprite;
import openfl.display.Shape;
import openfl.geom.Rectangle;

import core.Element;

class Plant extends Element
{
    private var _body:Body;
    private var _anim:AnimatedSprite;
    private var _waterred:Bool;

    public function new(x:Float, y:Float)
    {
        super();
        this.x = x;
        this.y = y;


        _anim = new AnimatedSprite("assets/animations.json", "plant");
        addElement(_anim);

        _body = new Body(60, 60);
        _body.position.x = this.x;
        _body.position.y = this.y;

        _waterred = false;
    }

    public function getBody():Body
    {
        return _body;
    }

    public function water():Void
    {
        if(!_waterred)
        {
            _anim.setAnimation("grow");
            _waterred = true;
        }
    }
    
    override public function draw()
    {
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
