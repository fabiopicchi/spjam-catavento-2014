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

    private var _player:Player;
    private var _map:Tilemap;
	private var _guards = new List <Guard> ();
	//private var _lasers = new List <Laser> ();
	//private var _cameras = new List <Camera> ();

    public function new()
    {
        super();

        _player = new Player();
		
		var g = new Guard (0, [new Point(40,40), new Point(40,120)]);
		_guards.add (g);
		addElement (g);

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
        
        addElement(_map);
        addElement(_player);
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
		
		var playerPoint = new Point (_player.x, _player.y);
		
		for (g in _guards)
		{
			if (Point.distance(g.eye, playerPoint) < 500) {
				if (_map.isPointVisible(g.eye, playerPoint)) {
					if (true) //checar se está dentro do cone
					{
						g.alert();
						var v:Float;
						if (Point.distance(g.eye, playerPoint) > 500) v = 1;
						else v = 5;
						//hud.increase(v);						
					}
				}
			}	
		}

        super.update(dt);
        _map.collideTilemap(_player.getBody());
    }
}
