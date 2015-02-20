package core;

import core.SpriteSheet;

import haxe.Json;
import haxe.ds.StringMap;

import openfl.Assets;
import openfl.display.Graphics;
import openfl.display.Sprite;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.geom.Point;

private class Animation 
{
    public var arFrames:Array<Int>;
    public var fps:Int;
    public var numLoops:Int;
    public var offset:Point;
    public var mirrorX:Bool;
    public var mirrorY:Bool;

    public function new (arFrames:Array<Int>, numLoops:Int, fps:Int, 
            offset:Point, mirrorX:Bool, mirrorY:Bool)
    {
        this.arFrames = arFrames;
        this.numLoops = numLoops;
        this.fps = fps;
        this.offset = offset;
        this.mirrorX = mirrorX;
        this.mirrorY = mirrorY;
    }
}

class AnimatedSprite extends Element 
{
    private var _animationData:StringMap<Animation>;
    private var _currentFrame:Int;
    private var _currentAnimation:Animation;

    private var _currentAnimationName:String;
    public var currentAnimationName(get,null):String;
    public function get_currentAnimationName():String{return _currentAnimationName;};

    private var _nextAnimationName:String;
    private var _timeElapsed:Float;
    private var _framePeriod:Float;
    private var _spriteSheet:SpriteSheet;
    private var _stopped:Bool;
    private var _startAnimation:String;
    private var _over:Bool;
    private var _bmp:Bitmap;
    private var _numLoops:Int;

    public function new(jsonPath:String, spritesheetId:String)
    {
        super();
        _animationData = new StringMap<Animation>();

        var obj:Dynamic = Json.parse(Assets.getText(jsonPath));
        var animationJSON:Dynamic = Reflect.field(obj, spritesheetId);
        _spriteSheet = new SpriteSheet(animationJSON.src, animationJSON.width, 
                animationJSON.height, animationJSON.numFrames);

        var defaultOffset = new Point();
        if(animationJSON.offset != null)
        {
            defaultOffset.x = animationJSON.offset.x;
            defaultOffset.y = animationJSON.offset.y;
        }

        var animations:Array<Dynamic> = animationJSON.animations;
        for(animation in animations)
        {
            addAnimation(animation.name, animation.frames, animation.numLoops, animation.framerate, 
                (animation.offset == null ? defaultOffset : new Point(animation.offset.x, animation.offset.y)),
                (animation.mirrorX == null ? false : animation.mirrorX),
                (animation.mirrorY == null ? false : animation.mirrorY));
        }

        _timeElapsed = 0;
        _stopped = false;
        _over = false;
        _startAnimation = animationJSON.startAnimation;
        setAnimation(_startAnimation);
    }

    public function addAnimation(name:String, frameData:Array<Int>, numLoops:Int, 
            fps:Int, offset:Point, mirrorX:Bool, mirrorY:Bool):Void
    {
        // Test for consecutive frame interval
        if(frameData.length == 2)
        {
            var newFrameData:Array<Int> = new Array<Int>();
            var bottom:Int = frameData[0];
            var top:Int = frameData[1] + 1;

            if(frameData[0] > frameData[1])
            {
                bottom = frameData[1];
                top = frameData[0] + 1;
            }

            for(i in bottom...top) newFrameData.push(i);
            if(frameData[0] > frameData[1]) newFrameData.reverse();

            frameData = newFrameData;
        }
        _animationData.set(name, new Animation(frameData, numLoops, fps, offset, mirrorX, mirrorY));
    }

    public function setAnimation(name:String, stop:Bool = false):Void
    {
        if(name != _currentAnimationName)
        {
            _stopped = stop;
            scaleX = scaleY = 1;
            _currentFrame = 0;
            _nextAnimationName = name;
            _currentAnimation = _animationData.get(name);
            _numLoops = _currentAnimation.numLoops;
            if(_numLoops == -1) _over = true;
            else _over = false;
            _framePeriod = 1 / _currentAnimation.fps;
            _timeElapsed = 0;
            x = _currentAnimation.offset.x;
            y = _currentAnimation.offset.y;
            if(_currentAnimation.mirrorX) scaleX = -1;
            if(_currentAnimation.mirrorY) scaleY = -1;
            updateAsset();
        }
    }

    public function resetAnimation():Void
    {
        setAnimation(_startAnimation, true);
    }

    public function isOver():Bool
    {
        return _over;
    }

    override public function update(dt:Float):Void
    {
        _currentAnimationName = _nextAnimationName;
        if(!_stopped)
        {
            _timeElapsed += dt;
            if (_timeElapsed >= _framePeriod)
            {
                if (_numLoops == -1)
                {
                    _currentFrame = (_currentFrame + 1) % _currentAnimation.arFrames.length; 
                }
                else if (_currentFrame < _currentAnimation.arFrames.length - 1)
                {
                    _currentFrame++;
                }
                else if (_numLoops > 0)
                {
                    _numLoops--;
                    if (_numLoops == 0)
                    {
                        _over = true;
                    }
                    else
                    {
                        _currentFrame = 0;
                    }
                }
                _timeElapsed -= _framePeriod;
                updateAsset();
            }
        }
    }

    override public function draw():Void
    {
        super.draw();
    }

    private function updateAsset():Void
    {
        _bmp = _spriteSheet.getFramedata(_currentAnimation.arFrames[_currentFrame]);
        if (numChildren > 0) removeChildAt(0);
        addChild(_bmp);
    }
}
