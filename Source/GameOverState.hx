package;

import core.Element;
import core.State;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.Sprite;
import openfl.display.Shape;
import openfl.ui.Keyboard;
import motion.easing.Elastic;
import motion.Actuate;
import openfl.Assets;
import haxe.ds.IntMap;

import core.SwitchStateEvent;

class GameOverState extends State {
	
	private var	timer:Int = 0;
	public var bitmap5 = new Bitmap (Assets.getBitmapData ("images/missionfailed4.png"));

    private var START:Int = 1 << 0;

    private var _currentLevel:Int;
	
	public function new (gameScreenshot:BitmapData, currentLevel:Int)
	{
		super ();
        _currentLevel = currentLevel;

        addChild(new Bitmap(gameScreenshot));
		var rect1 : Shape = new Shape();
        rect1.graphics.beginFill(0x000000);
        rect1.graphics.drawRect(0, 197, 800, 200);
        addChild (rect1);
		
		var bitmap0 = new Bitmap (Assets.getBitmapData ("images/missionfailed2.png"));
		bitmap0.x = 76;
		bitmap0.y = 245;
		bitmap0.smoothing = true;
		addChild (bitmap0);
		
		var bitmap6 = new Bitmap (Assets.getBitmapData ("images/missionfailed5.png"));
		bitmap6.x = 0;
		bitmap6.y = 452;
		bitmap6.smoothing = true;
		addChild (bitmap6);
		
		var bitmap1 = new Bitmap (Assets.getBitmapData ("images/missionfailed1.png"));
		bitmap1.x = 0;
		bitmap1.y = 0;
		bitmap1.smoothing = true;
		
		var container1 = new Sprite ();
		container1.addChild (bitmap1);
		container1.x = -800;
		container1.y = 232;
		
		addChild (container1);
		Actuate.tween (container1, 3, { x: 0 } );
		
		var bitmap2 = new Bitmap (Assets.getBitmapData ("images/missionfailed1.png"));
		bitmap2.x = 0;
		bitmap2.y = 0;
		bitmap2.smoothing = true;
		
		var container2 = new Sprite ();
		container2.addChild (bitmap2);
		container2.x = -800;
		container2.y = 206;
		
		addChild (container2);
		Actuate.tween (container2, 4, { x: -35 } );
		
		var bitmap3 = new Bitmap (Assets.getBitmapData ("images/missionfailed3.png"));
		bitmap3.x = 0;
		bitmap3.y = 0;
		bitmap3.smoothing = true;
		
		var container3 = new Sprite ();
		container3.addChild (bitmap3);
		container3.x = 800;
		container3.y = 343;
		
		addChild (container3);
		Actuate.tween (container3, 3, { x: 466 } );
		
		var bitmap4 = new Bitmap (Assets.getBitmapData ("images/missionfailed3.png"));
		bitmap4.x = 0;
		bitmap4.y = 0;
		bitmap4.smoothing = true;
		
		var container4 = new Sprite ();
		container4.addChild (bitmap4);
		container4.x = 800;
		container4.y = 369;
		
		addChild (container4);
		Actuate.tween (container4, 4, { x: 496 } );
	}

    override public function getInputActions():IntMap<Int>
    {
        var inputMap:IntMap<Int> = new IntMap<Int>();
        inputMap.set(Keyboard.SPACE, START); 
        return inputMap;
    }

    override public function update (dt:Float)
    {
        super.update(dt);

        timer++;

        if ( timer == 50 )
        {
            bitmap5.x = 0;
            bitmap5.y = 278;
            bitmap5.smoothing = true;			

            addChild (bitmap5);
        }
        else if( timer == 52)
        {
            bitmap5.visible = false;
        }
        else if( timer == 80)
        {
            bitmap5.visible = true;
        }
        else if( timer == 81)
        {
            bitmap5.visible = false;
        }

        if(justPressed(START))
        {
            dispatchEvent(new SwitchStateEvent(SwitchStateEvent.SWITCH_STATE,
                        new StageState(_currentLevel)));
        }
    }
}
