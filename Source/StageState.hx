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
    private var _map:Tilemap;
    private var _hud:HUD;
	private var _guards = new List <Guard> ();
	//private var _lasers = new List <Laser> ();
	//private var _cameras = new List <Camera> ();

    public function new()
    {
        super();

        _player = new Player();
		
        PLAYER_DETECTION_RADUIS = Math.sqrt(800 * 800 + 600 * 600);

        var obj:Dynamic = Json.parse(Assets.getText("assets/stage.json"));
        var tileset:BitmapData = Assets.getBitmapData("assets/tileset.jpg");    
        var layers:Array<Dynamic> = obj.layers;

        for (layer in layers)
        {
            if (layer.name == "map")
            {
                _map = new Tilemap(layer, tileset, obj.tilewidth, obj.tileheight);
            }
        }

		var g = new Guard (2, [new Point(300,300), new Point(300,380),
                                new Point(380,380)]);
		_guards.add (g);

        _hud = new HUD();
        
        addElement(_map);
		addElement (g);
        addElement(_player);
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
                    if (_map.isPointVisible(g.eye, playerPoint)) 
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

        _map.collideTilemap(_player.getBody());
    }
}
