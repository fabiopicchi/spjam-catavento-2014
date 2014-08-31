import haxe.Json;
import haxe.ds.IntMap;
import openfl.geom.Point;

import openfl.Assets;
import openfl.ui.Keyboard;
import openfl.display.BitmapData;

import core.State;

class StageState extends State
{
    private var LEFT:Int = 1 << 0;
    private var RIGHT:Int = 1 << 1;
    private var UP:Int = 1 << 2;
    private var DOWN:Int = 1 << 3;

    private var PLAYER_DETECTION_RADUIS:Float;

    private var _player:Player;
    private var _hud:HUD;
	private var _guards = new List <Guard> ();

    private var _lowerLayer:Tilemap;
	private var _collideLayer:Tilemap;
	private var _upperLayer:Tilemap;
	private var _shadeLayer:Tilemap;
	
	//private var _lasers = new List <Laser> ();
	//private var _cameras = new List <Camera> ();
	//private var _circuits = new List <Circuit> ();
	//private var _terminals = new List <Terminal> ();

    public function new()
    {
        super();

        _player = new Player();
        _player.getBody().position.x = 200;
        _player.getBody().position.y = 400;
		
        PLAYER_DETECTION_RADUIS = Math.sqrt(800 * 800 + 600 * 600);

        var obj:Dynamic = Json.parse(Assets.getText("assets/level1.json"));
        var tileset:BitmapData = Assets.getBitmapData("assets/tileset.png");
        var layers:Array<Dynamic> = obj.layers;

        for (layer in layers)
        {
            if (layer.name == "lower")
            {
				_lowerLayer = new Tilemap(layer, tileset, obj.tilewidth, obj.tileheight);
            }
			if (layer.name == "collide")
            {
				_collideLayer = new Tilemap(layer, tileset, obj.tilewidth, obj.tileheight);
            }
			if (layer.name == "upper")
            {
				_upperLayer = new Tilemap(layer, tileset, obj.tilewidth, obj.tileheight);
            }
			if (layer.name == "shade")
            {
				_shadeLayer = new Tilemap(layer, tileset, obj.tilewidth, obj.tileheight);
            }
        }

        addElement(_lowerLayer);
		addElement(_collideLayer);

		var g = new Guard (2, [new Point(40,40), new Point(40,120), new Point(120,120)]);
		_guards.add (g);
		addElement (g);

        addElement(_player);
		addElement(_upperLayer);
		addElement(_shadeLayer);

        _hud = new HUD();
        addElement(_hud);
    }

    override public function setInputActions(inputMap:IntMap<Int>)
    {
        inputMap.set(Keyboard.A, LEFT);
        inputMap.set(Keyboard.LEFT, LEFT);
        inputMap.set(Keyboard.S, DOWN);
        inputMap.set(Keyboard.DOWN, DOWN);
        inputMap.set(Keyboard.D, RIGHT);
        inputMap.set(Keyboard.RIGHT, RIGHT);
        inputMap.set(Keyboard.W, UP);
        inputMap.set(Keyboard.UP, UP);
    }

    override public function update (dt:Float)
    {
        var hor:Int = 0;
        var ver:Int = 0;
        if (pressed(UP) && !pressed(DOWN))
        {
            ver = -1;
        }
        else if (pressed(DOWN) && !pressed(UP))
        {
            ver = 1;
        }

        if (pressed(LEFT) && !pressed(RIGHT))
        {
            hor = -1;
        }
        else if(pressed(RIGHT) && !pressed(LEFT))
        {
            hor = 1;
        }

        _player.move(hor, ver);

        super.update(dt);

        _collideLayer.collideTilemap(_player.getBody());

		var playerPoint = new Point (_player.getBody().position.x +
                _player.getBody().width / 2, _player.getBody().position.y +
                _player.getBody().height / 2);
		
		for (g in _guards)
		{
            var playerDistance = Point.distance(g.eye, playerPoint);

            g.graphics.clear();
			if (playerDistance < PLAYER_DETECTION_RADUIS) 
            {
                var angle:Float = Math.atan2(playerPoint.y - g.eye.y, 
                        playerPoint.x - g.eye.x);
                if (angle < 0) angle += 2 * Math.PI;

                if (angle >= g.faceDirection * Math.PI / 2 - Math.PI / 4 &&
                        angle <= g.faceDirection * Math.PI / 2 + Math.PI / 4)
                {
                    if (_collideLayer.isPointVisible(g.eye, playerPoint)) 
                    {
                        g.alert();
                        g.graphics.lineStyle(2, 0xFF0000);
                        g.graphics.moveTo(g.eye.x - g.x, g.eye.y - g.y);
                        g.graphics.lineTo(playerPoint.x - g.x, playerPoint.y -
                                g.y);
                        _hud.increase(2);
                    }
                }
            }
        }
    }
}
