import haxe.ds.IntMap;

import openfl.Lib;
import openfl.ui.Keyboard;
import openfl.events.Event;
import openfl.events.KeyboardEvent;
import openfl.display.Sprite;
import openfl.display.StageScaleMode;

import core.State;
import core.SpriteSheet;

class Game extends Sprite 
{
    private var _lastFrame:Int;
    private var _state:State;

    private var _usedKeys:IntMap<Int>;

    private var _keyboardRaw:Int;
    private var _keyboardState:Int;
    private var _keyboardChanged:Int;

    private var LEFT:Int = 1 << 0;
    private var RIGHT:Int = 1 << 1;
    private var UP:Int = 1 << 2;
    private var DOWN:Int = 1 << 3;

    private var ss:SpriteSheet;

    public function new() 
    {
        super();

        _state = new State();
        addChild(_state);

        _keyboardRaw = 0;
        _keyboardState = 0;
        _keyboardChanged = 0;
        _usedKeys = new IntMap<Int>();
        _usedKeys.set(Keyboard.A, LEFT);
        _usedKeys.set(Keyboard.LEFT, LEFT);
        _usedKeys.set(Keyboard.S, DOWN);
        _usedKeys.set(Keyboard.DOWN, DOWN);
        _usedKeys.set(Keyboard.D, RIGHT);
        _usedKeys.set(Keyboard.RIGHT, RIGHT);
        _usedKeys.set(Keyboard.W, UP);
        _usedKeys.set(Keyboard.UP, UP);
        stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
        stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);

        ss = new SpriteSheet("assets/ss_alucard.png", 50, 50);
        ss.loadAnimationsFromJSON("assets/ss_alucard.json");
        ss.setAnimation("idle");
        _state.addElement(ss);

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

    private function justPressed(buttonCode:Int) 
    {
        return (_keyboardChanged & buttonCode == buttonCode &&
                _keyboardState & buttonCode == buttonCode);
    }

    private function justReleased(buttonCode:Int) 
    {
        return (_keyboardChanged & buttonCode == buttonCode &&
                _keyboardState & buttonCode != buttonCode);
    }

    private function pressed(buttonCode:Int) 
    {
        return (_keyboardState & buttonCode == buttonCode);
    }

    public function run(e:Event):Void
    {
        var dt:Float = (Lib.getTimer() - _lastFrame) / 1000;

        _keyboardChanged = (_keyboardRaw ^ _keyboardState);
        _keyboardState = _keyboardRaw;

        _state.update(dt);
        _state.draw();

        _lastFrame = Lib.getTimer();
    }
}
