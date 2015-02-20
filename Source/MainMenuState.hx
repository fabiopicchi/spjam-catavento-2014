import haxe.ds.IntMap;

import openfl.Assets;
import openfl.events.Event;
import openfl.ui.Keyboard;
import openfl.display.Bitmap;
import openfl.media.Sound;
import openfl.media.SoundChannel;

import motion.Actuate;

import core.Element;
import core.State;
import core.GameSoundEvent;
import core.SwitchStateEvent;

class MainMenuState extends State {
	
    private var START:Int = 1 << 0;
        
	private var	timer:Int;
	private var timer2:Int;
	private var frames:Array<Bitmap>;

    private var sound:Sound;
    private var channel:SoundChannel;

	public function new ()
	{
		super ();

        timer = 0;
        timer2 = 0;
        frames = [
            new Bitmap (Assets.getBitmapData ("images/titlescreen1.jpg")),
            new Bitmap (Assets.getBitmapData ("images/titlescreen2.jpg")),
            new Bitmap (Assets.getBitmapData ("images/titlescreen3.jpg")),
            new Bitmap (Assets.getBitmapData ("images/titlescreen4.jpg")),
            new Bitmap (Assets.getBitmapData ("images/titlescreen5.jpg")),
            new Bitmap (Assets.getBitmapData ("images/titlescreen6.jpg")),
            new Bitmap (Assets.getBitmapData ("images/titlescreen7.jpg")),
            new Bitmap (Assets.getBitmapData ("images/titlescreen8.jpg"))
        ];
		for(frame in frames){
			addChild (frame);
		}
	}

    override public function onEnter():Void
    {
        dispatchEvent(new GameSoundEvent(GameSoundEvent.BG_MUSIC,
                    "assets/sound/amigo_coelho.ogg"));
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
            dispatchEvent(new SwitchStateEvent(SwitchStateEvent.SWITCH_STATE,
                        new StageState(0)));
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
