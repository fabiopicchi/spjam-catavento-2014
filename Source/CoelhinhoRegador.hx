import openfl.events.Event;

import core.Game;

class CoelhinhoRegador extends Game
{
    public function new()
    {
        super();
        switchState(new MainMenuState());
    }
}
