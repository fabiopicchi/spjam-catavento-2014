import haxe.ds.IntMap;

import openfl.Lib;
import openfl.events.Event;
import openfl.events.KeyboardEvent;
import openfl.display.Sprite;
import openfl.display.StageScaleMode;

class Game extends Sprite 
{
    private var _lastFrame:Int;
    private var _state:StageState;

    private var _usedKeys:IntMap<Int>;

    private var _keyboardRaw:Int;

    public function new() 
    {
        super();
        
        _usedKeys = new IntMap<Int>();
        _state = new StageState();
        _state.setInputActions(_usedKeys);

        addChild(_state);

        _keyboardRaw = 0;
        stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
        stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);

        _lastFrame = Lib.getTimer();
        stage.addEventListener(Event.ENTER_FRAME, run);
    }

    private function onKeyDown(e:KeyboardEvent):Void
    {
        if (_usedKeys.exists(e.keyCode))
        {
            _keyboardRaw |= _usedKeys.get(e.keyCode);
        }
    }

    private function onKeyUp(e:KeyboardEvent):Void
    {
        if (_usedKeys.exists(e.keyCode))
        {
            _keyboardRaw &= (~_usedKeys.get(e.keyCode));
        }
    }

    public function run(e:Event):Void
    {
        var dt:Float = (Lib.getTimer() - _lastFrame) / 1000;

        _state.updateInput(_keyboardRaw);
        _state.update(dt);
        _state.draw();

        _lastFrame = Lib.getTimer();
    }
}
