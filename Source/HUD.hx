package ;
import core.Element;
import flash.display.Graphics;
import openfl.display.Shape;

/**
 * ...
 * @author Helo
 */
class HUD extends Element
{
	private var _maxLevel:Float = 120;
	private var _currentLevel:Float = 0;
	private var _pastLevel:Float = 0;
	private var _cooldown:Float = 0.5;
	private var _timer:Float = 0;
	private var _state:Int = 0;
	
    private var RELOAD_COOLDOWN:Float = 2;

	public function new() 
	{
		super();
		
		var s:Shape = new Shape();
        s.graphics.beginFill(0x00FF00);
        s.graphics.drawRect(0, 0, 120, 20);
        addChild(s);
		
		this.x = 5;
		this.y = 5;
	}
	
	override public function update(dt:Float)
	{
		if (_timer > RELOAD_COOLDOWN)
		{
			_currentLevel = _currentLevel - _cooldown;
			if (_currentLevel < 0)
			{
				_currentLevel = 0;
			}
		}
		
		if (_currentLevel == _pastLevel)
		{
			_timer += dt;
			_state = 0;
		}
		else if (_currentLevel > _pastLevel)
		{
			_timer = 0;
		}
		
		changeColor();
		this.scaleX = _currentLevel / _maxLevel;
		_pastLevel = _currentLevel;
	}
	
	public function increase(value:Float)
	{
		_currentLevel = _currentLevel + value;
		if (_currentLevel >= _maxLevel)
		{
			_currentLevel = _maxLevel;
		}
		
		if (value >= 5)
		{
			_state = 2;
		}
		else
		{
			_state = 1;
		}
	}
	
	private function changeColor()
	{
		if (_state == 1)
		{
			this.graphics.clear();
			var s:Shape = new Shape();
			s.graphics.beginFill(0xFFFF00);
			s.graphics.drawRect(0, 0, 120, 20);
			addChild(s);
		}
		else if (_state == 2)
		{
			this.graphics.clear();
			var s:Shape = new Shape();
			s.graphics.beginFill(0xFF0000);
			s.graphics.drawRect(0, 0, 120, 20);
			addChild(s);
		}
		else
		{
			this.graphics.clear();
			var s:Shape = new Shape();
			s.graphics.beginFill(0x00FF00);
			s.graphics.drawRect(0, 0, 120, 20);
			addChild(s);
		}
	}
	
	public function isFull():Bool
	{
		if (_currentLevel >= _maxLevel)
		{
			return true;
		}
		else
		{
			return false;
		}
	}
}
