package;


import flash.display.Sprite;
import flash.events.Event;
import flash.media.Sound;
import flash.media.SoundChannel;
import flash.media.SoundTransform;
import motion.Actuate;
import motion.easing.Quad;
import openfl.Assets;


class Bgm extends Sprite {
		
	private var channel:SoundChannel;
	private var playing:Bool;
	private var position:Float;
	private var sound:Sound;
	
	
	public function new (path:String) {
		
		super ();
		
		Actuate.defaultEase = Quad.easeOut;
		
		sound = Assets.getSound (path);
		
		position = 0;
		
		play ();
		
	}
	
	
	private function pause (fadeOut:Float = 1.2):Void {
		
		if (playing) {
			
			playing = false;
			
			Actuate.transform (channel, fadeOut).sound (0, 0).onComplete (function () {
				
				position = channel.position;
				channel.removeEventListener (Event.SOUND_COMPLETE, channel_onSoundComplete);
				channel.stop ();
				channel = null;
				
			});
			
		}
		
	}
	
	
	private function play (fadeIn:Float = 3):Void {
		
		playing = true;
		
		if (fadeIn <= 0) {
			
			channel = sound.play (position);
			
		} else {
			
			channel = sound.play (position, 0, new SoundTransform (0, 0));
			Actuate.transform (channel, fadeIn).sound (1, 0);
			
		}
		
		channel.addEventListener (Event.SOUND_COMPLETE, channel_onSoundComplete);
		
	}
	
	
	
	
	// Event Handlers
	
	
	
	
	private function channel_onSoundComplete (event:Event):Void {
		
		pause ();
		position = 0;
		
	}	
	
}