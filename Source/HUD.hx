package ;
import core.Element;
import flash.display.Graphics;
import openfl.Assets;
import openfl.display.Bitmap;
import openfl.display.Shape;
import openfl.display.Sprite;

/**
 * ...
 * @author Helo
 */
class HUD extends Element
{
	private var _maxLevel:Float = 100;
	private var _currentLevel:Float = 0;
	private var _pastLevel:Float = 0;
	private var _cooldown:Float = 0.5;
	private var _timer:Float = 0;
	private var _state:Int = 0;
	
	var barra = new Shape ();
	
    private var RELOAD_COOLDOWN:Float = 2;

	public function new() 
	{
		super();
		
        barra.graphics.beginFill(0x00FF00);
        barra.graphics.drawRect(0, 0, 195, 15);
        addChild(barra);
		
		barra.x = 52;
		barra.y = 23;
		
		var b:Bitmap = new Bitmap(Assets.getBitmapData ("assets/hud.png"));
		addChild (b);
		
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
		barra.scaleX = _currentLevel / _maxLevel;
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
			barra.graphics.clear();
			barra.graphics.beginFill(0xFFFF00);
			barra.graphics.drawRect(0, 0, 195, 15);
		}
		else if (_state == 2)
		{
			barra.graphics.clear();
			barra.graphics.beginFill(0xFF0000);
			barra.graphics.drawRect(0, 0, 195, 15);
		}
		else
		{
			barra.graphics.clear();
			barra.graphics.beginFill(0x00FF00);
			barra.graphics.drawRect(0, 0, 195, 15);
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
