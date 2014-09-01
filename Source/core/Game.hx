package core;

import haxe.ds.IntMap;

import openfl.Assets;
import openfl.Lib;
import openfl.events.Event;
import openfl.events.KeyboardEvent;
import openfl.display.Sprite;
import openfl.display.StageScaleMode;
import openfl.media.Sound;
import openfl.media.SoundChannel;
import openfl.media.SoundTransform;

import core.State;

class Game extends Sprite 
{
    private var _lastFrame:Int;
    private var _state:State;
    private var _usedKeys:IntMap<Int>;
    private var _keyboardRaw:Int;
    private var _musicVolume:SoundTransform;
    private var _sfxVolume:SoundTransform;
    private var _bgMusic:Sound;
    private var _bgMusicChannel:SoundChannel;
    private var _sfxChannelList:List<SoundChannel>;

    public function new() 
    {
        super();

        stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
        stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);

        _lastFrame = Lib.getTimer();
        stage.addEventListener(Event.ENTER_FRAME, run);

        _musicVolume = new SoundTransform(1, 0);
        _sfxVolume = new SoundTransform(1, 0);
        _sfxChannelList = new List<SoundChannel>();
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

    private function onSwitchState(e:SwitchStateEvent):Void
    {
        switchState(e.state);
    }

    private function onChangeBGMusic(e:GameSoundEvent):Void
    {
        function loop(e:Event):Void
        {
            _bgMusicChannel.removeEventListener(Event.SOUND_COMPLETE, loop);
            _bgMusicChannel = _bgMusic.play();
            _bgMusicChannel.soundTransform = _musicVolume;
            _bgMusicChannel.addEventListener(Event.SOUND_COMPLETE, loop);
        }

        if (_bgMusicChannel != null)
        {
            _bgMusicChannel.removeEventListener(Event.SOUND_COMPLETE, loop);
            _bgMusicChannel.stop();
        }

        _bgMusic = Assets.getSound(e.path);
        _bgMusicChannel = _bgMusic.play();
        _bgMusicChannel.soundTransform = _musicVolume;
        _bgMusicChannel.addEventListener(Event.SOUND_COMPLETE, loop);
    }

    private function onAddSfx(e:GameSoundEvent):Void
    {
        var s:Sound = Assets.getSound(e.path);
        var c:SoundChannel = s.play();
        c.soundTransform = _sfxVolume;
        _sfxChannelList.add(c);

        function end(e:Event):Void
        {
            _sfxChannelList.remove(c);
            c.removeEventListener(Event.SOUND_COMPLETE, end);
        }
        c.addEventListener(Event.SOUND_COMPLETE, end);
    }

    private function onAdjustBGMusic(e:GameVolumeEvent):Void
    {
        _musicVolume.volume = e.volume;
        _bgMusicChannel.soundTransform = _musicVolume;
    }

    private function onAdjustSfx(e:GameVolumeEvent):Void
    {
        _sfxVolume.volume = e.volume;
        for (sfx in _sfxChannelList)
        {
            sfx.soundTransform = _sfxVolume;
        }
    }

    private function run(e:Event):Void
    {
        var dt:Float = (Lib.getTimer() - _lastFrame) / 1000;

        _state.updateInput(_keyboardRaw);
        _state.update(dt);
        _state.draw();

        _lastFrame = Lib.getTimer();
    }

    private function switchState(s:State)
    {
        if (_state != null) 
        {
            removeChild(_state);
            _state.removeEventListener(SwitchStateEvent.SWITCH_STATE,
                    onSwitchState);
            _state.removeEventListener(GameSoundEvent.BG_MUSIC,
                    onChangeBGMusic);
            _state.removeEventListener(GameSoundEvent.SFX,
                    onAddSfx);
            _state.removeEventListener(GameVolumeEvent.BG_MUSIC,
                    onAdjustBGMusic);
            _state.removeEventListener(GameVolumeEvent.SFX,
                    onAdjustSfx);
            _state.onLeave();
        }

        _keyboardRaw = 0;

        _state = s;
        _state.addEventListener(SwitchStateEvent.SWITCH_STATE,
                onSwitchState);
        _state.addEventListener(GameSoundEvent.BG_MUSIC,
                onChangeBGMusic);
        _state.addEventListener(GameSoundEvent.SFX,
                onAddSfx);
        _state.addEventListener(GameVolumeEvent.BG_MUSIC,
                onAdjustBGMusic);
        _state.addEventListener(GameVolumeEvent.SFX,
                onAdjustSfx);
        _usedKeys = _state.getInputActions();
        addChild(_state);
        _state.onEnter();
    }
}
