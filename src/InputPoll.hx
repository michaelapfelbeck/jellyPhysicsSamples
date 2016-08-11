package;

import flash.events.DataEvent;
import openfl.display.Stage;
import openfl.events.KeyboardEvent;
import openfl.events.Event;
import openfl.utils.ByteArray;

/**
 * ...
 * @author Michael Apfelbeck
 */
class InputPoll
{
    private var keyState:ByteArray;
    private var stage:Stage;
    private static var byteCount:Int = 8;
    
    public function new(target:Stage) 
    {
        keyState = new ByteArray();
        for(i in 0...byteCount)
        {
            keyState.writeUnsignedInt( 0 );
        }
        stage = target;
        stage.addEventListener( KeyboardEvent.KEY_DOWN, keyDownListener, false, 0, true );
        stage.addEventListener( KeyboardEvent.KEY_UP, keyUpListener, false, 0, true );
        stage.addEventListener( Event.ACTIVATE, activateListener, false, 0, true );
        stage.addEventListener( Event.DEACTIVATE, deactivateListener, false, 0, true );
    }
    
    private function deactivateListener(event:Event):Void 
    {
        for(i in 0...byteCount)
        {
            keyState[ i ] = 0;
        }
    }
    
    private function activateListener(event:Event):Void 
    {
        for(i in 0...byteCount)
        {
            keyState[ i ] = 0;
        }
    }
    
    private function keyUpListener(event:KeyboardEvent):Void 
    {
        keyState[ event.keyCode >>> 3 ] &= ~(1 << (event.keyCode & 7));
    }
    
    private function keyDownListener(event:KeyboardEvent):Void 
    {
        keyState[ event.keyCode >>> 3 ] |= 1 << (event.keyCode & 7);
    }
    
    public function isDown(key:UInt):Bool
    {
        return ( keyState[ key >>> 3 ] & (1 << (key & 7)) ) != 0;
    }
    
    public function isUp(key:UInt):Bool
    {
        return ( keyState[ key >>> 3 ] & (1 << (key & 7)) ) == 0;
    }
}