package core;

import openfl.events.Event;

class GameSoundEvent extends Event
{
    public var path:String;

    public static var BG_MUSIC:String = "bgmusic";
    public static var SFX:String = "sfx";

    public function new(name:String, path:String)
    {
        super(name, true, false);
        this.path = path;
    }
}
