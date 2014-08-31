package;

import haxe.ds.IntMap;
import openfl.events.Event;
import openfl.ui.Keyboard;
import core.Element;
import core.State;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.Sprite;
import openfl.display.Shape;
import motion.easing.Elastic;
import motion.Actuate;
import openfl.Assets;


class MainMenuState extends State {
	
    private var START:Int = 1 << 0;
        
	private var	timer:Int = 0;
	private var timer2:Int = 0;
	
	public var frames = new Array ();
	
	public var bitmap1 = new Bitmap (Assets.getBitmapData ("assets/titlescreen1.jpg"));
	public var bitmap2 = new Bitmap (Assets.getBitmapData ("assets/titlescreen2.jpg"));
	public var bitmap3 = new Bitmap (Assets.getBitmapData ("assets/titlescreen3.jpg"));
	public var bitmap4 = new Bitmap (Assets.getBitmapData ("assets/titlescreen4.jpg"));
	public var bitmap5 = new Bitmap (Assets.getBitmapData ("assets/titlescreen5.jpg"));
	public var bitmap6 = new Bitmap (Assets.getBitmapData ("assets/titlescreen6.jpg"));
	public var bitmap7 = new Bitmap (Assets.getBitmapData ("assets/titlescreen7.jpg"));
	public var bitmap8 = new Bitmap (Assets.getBitmapData ("assets/titlescreen8.jpg"));
	
	public function new ()
	{
		super ();
		
		frames = [bitmap1, bitmap2, bitmap3, bitmap4, bitmap5, bitmap6, bitmap7, bitmap8];
		
		for(frame in frames){
			addChild (frame);
		}
	}

    override public function setInputActions(inputMap:IntMap<Int>)
    {
        inputMap.set(Keyboard.SPACE, START); 
    }
	
	override public function update (dt:Float)
	{
		super.update(dt);
		
		timer++;
		
		if ( timer == 0 )
		{
			visibleOn (0);
		}
		else if ( timer == 5 )
		{
			visibleOn (2);
		}
		else if ( timer == 10 )
		{
			visibleOn (4);
			timer2++;
			timer = 0;
		}
		
		if ( timer2 == 2 )
		{
			visibleOn (1);
		}
		else if ( timer2 == 6 )
		{
			visibleOn (3);
		}
		else if ( timer2 == 10 )
		{
			visibleOn (5);
		}
		else if ( timer2 == 15 )
		{
			visibleOn (7);
			timer2 = 0;
		}

        if (justPressed(START))
        {
            dispatchEvent(new Event("nextLevelEvent", true, false));
        }
		
	}
	
	public function visibleOn (num:Int)
	{
		for(frame in frames){
			frame.visible = false;
		}
		
		frames[num].visible = true;
	}
}
