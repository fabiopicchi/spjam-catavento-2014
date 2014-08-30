import haxe.ds.IntMap;
import openfl.display.Sprite;

import openfl.ui.Keyboard;

import core.State;

class EndState extends State
{
    private var LEFT:Int = 1 << 0;
    private var RIGHT:Int = 1 << 1;
    private var SHOOT:Int = 1 << 2;

    private var _player:Hero;
	
	var heroDir:Int;
	var timerShoot:Int;
	var timerSpawn:Int = 100;
	
	var bullets = new List ();
	var enemies = new List ();

    public function new()
    {
        super();

        _player = new Hero();
        addElement(_player);
    }

    override public function setInputActions(inputMap:IntMap<Int>)
    {
        inputMap.set(Keyboard.A, LEFT);
        inputMap.set(Keyboard.LEFT, LEFT);
        inputMap.set(Keyboard.D, RIGHT);
        inputMap.set(Keyboard.RIGHT, RIGHT);
        inputMap.set(Keyboard.SPACE, SHOOT);
    }

    override public function update (dt:Float)
    {
        var hor:Int = 0;

        if (pressed(LEFT) && !pressed(RIGHT))
        {
            hor = -1;
        }
        else if(pressed(RIGHT) && !pressed(LEFT))
        {
            hor = 1;
        }

		if (pressed(SHOOT))
        {
			//create bullets
			if (timerShoot == 10)
			{
				var b:Bullet;
				addChild(b = new Bullet(_player.getCannonPos(),_player.getDir()));
				bullets.add(b);
				timerShoot = 0;
			}
			else
			{
				timerShoot++;
			}
		}
		else
		{
			timerShoot = 10;
		}
		
        _player.move(hor);
		
		//move bullets
		for (thing in bullets)
		{
			thing.update();
		}
		
		//create enemies
		if (timerSpawn == 100)
		{
			var e:EnemyBunny;
			addElement(e = new EnemyBunny(stage.stageWidth,stage.stageHeight));
			enemies.add(e);
			timerSpawn = 0;
		}
		else
		{
			timerSpawn++;
		}

		//test collision
		for (enemy in enemies)
		{
			for (bullet in bullets)
			{
				if (enemy.hitTestPoint(bullet.x, bullet.y))
				{
					enemy.visible = false;
				}
			}
		}
		
		
        super.update(dt);
    }
}
