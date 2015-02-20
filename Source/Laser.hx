import openfl.display.Shape;
import openfl.geom.Rectangle;

import core.Element;
import core.AnimatedSprite;

/**
 * ...
 * @author Chambers
 */
class Laser extends Element
{
    public var id:Int;
	private var _arSegments:Array<AnimatedSprite>;
    private var _length:Int;
	private var _body:Body;

    public static var BLUE:String = "blue";
    public static var GREEN:String = "green";
    public static var RED:String = "red";
    
    public function new (x:Float, y:Float, length:Int, direction:Int,
            colour:String, id:Int) 
    {
        super();
		
		this.id = id;
		
		_body = new Body(length, 12);

        this.x = x;
        this.y = y;
        _length = Math.floor((length / 30));
		_body.position.x = x;
		_body.position.y = y;
		
        _arSegments = new Array<AnimatedSprite>();
        _arSegments.push(new AnimatedSprite("assets/animations.json", "laser-start-" + colour));
        for (i in 0...(_length - 2))
            _arSegments.push(new AnimatedSprite("assets/animations.json", "laser-middle-" + colour));
        _arSegments.push(new AnimatedSprite("assets/animations.json", "laser-end-" + colour));

        var i:Int = 0;
        for (seg in _arSegments) 
        {
            seg.setAnimation("on");
            if (direction % 2 == 0)
                seg.x = i * seg.width;
            else
            {
                seg.x = seg.width;
                seg.y = i * seg.width;
                seg.rotation = 90;
            }
            addElement(seg);
            i++;
        }

        switch(direction)
        {
            case 2:
                this.x += width;
                scaleX = -1;
            case 3:
                this.y += height;
                scaleY = -1;
        }
		
    }
	
	public function deactivate():Void {
        visible = false;
	}

    public function activate():Void {
        visible = true;
    }
	
	public function getBody():Body
    {
        return _body;
    }
}
