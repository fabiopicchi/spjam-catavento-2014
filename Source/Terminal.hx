import openfl.display.Shape;

import core.Element;

class Terminal extends Element
{
    private var id:Int;
	private var _body:Body;
	private var deactivationTimer:Float;

    public function new(x:Float, y:Float, id:Int)
    {
        super();

        _body = new Body(60, 60);
		_body.x = x;
		_body.y = y;

        var s : Shape = new Shape();
        s.graphics.beginFill(0x000000);
        s.graphics.drawRect(0, 0, 50, 50);
        addChild(s);

    }

    public function getBody():Body
    {
        return _body;
    }

    override public function update (dt:Float)
    {
        if (deactivationTimer > 0) {
			deactivationTimer -= dt;
		}
    }

    override public function draw()
    {
        x = _body.position.x;
        y = _body.position.y;
        super.draw();
    }
	public function deactivate():Void {
		
		dispatchEvent(new CircuitEvent("shootEvent", id, 0) );
		deactivationTimer = 10;
	
	}
	public function isActivated():Bool {
		
		return (deactivationTimer <= 0);
		
	}
}
