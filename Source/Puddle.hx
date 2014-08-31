import openfl.display.Shape;

import core.Element;

class Puddle extends Element
{
    private var _body:Body;
	private var timer:Float;
	private var disappearAnimation:Float;

    public function new()
    {
        super();

        _body = new Body(50, 50);

        var s : Shape = new Shape();
        s.graphics.beginFill(0x000000);
        s.graphics.drawRect(0, 0, 50, 50);
        addChild(s);
		
		timer = 5;
    }

    public function getBody():Body
    {
        return _body;
    }

    override public function update (dt:Float)
    {
        _body.update(dt);
        super.update(dt);
		if (disappearAnimation < 0){
			timer -= dt;
			if (timer < 0) startDisappearing();
		}
		else {
			disappearAnimation --;
		}
    }
	
	public function startDisappearing();
    {
        disappearAnimation = 1;
		//remove()
    }

    override public function draw()
    {
        super.draw();
    }
}