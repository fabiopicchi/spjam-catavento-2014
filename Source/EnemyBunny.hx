package ;
import core.Element;
import openfl.display.Sprite;
import Math;

/**
 * ...
 * @author helo
 */
class EnemyBunny extends Element
{
	public var vel:Int = 3;
	public var spawnSide:Int;
	public var dir:Int = 1;

	public function new(stageWidth,stageHeight) 
	{
		super();
		
		spawnSide = Math.floor(Math.random() * 2);
		
		this.x = stageWidth * (spawnSide);
		this.y = 460;
		
		graphics.beginFill(0xCCCCCC);
		graphics.drawRect(0, 0, 60, 60);
		
		if (spawnSide == 0)
		{
			dir = 1;
		}
		else
		{
			dir = -1;
		}
	}
	
	override public function update(dt:Float)
	{		
		this.x = this.x + vel * dir;
	}	
}