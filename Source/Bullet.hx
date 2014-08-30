package ;
import openfl.display.Sprite;
import Math;

/**
 * ...
 * @author helo
 */
class Bullet extends Sprite
{	
	public var dir:Int;
	public var radius:Int = 5;
	public var vel:Int = 20;
	
	public function new(centerX,heroDir):Void
	{
		super();
		
		dir = heroDir;
		
		graphics.beginFill(0xFF0000, 1);
		graphics.drawCircle(0, 0, radius);
		
		this.x = centerX;
		this.y = 460;
	}
	
	public function update()
	{
		this.x = this.x + vel * dir;
	}
}