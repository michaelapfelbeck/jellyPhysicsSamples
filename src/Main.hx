package;

import openfl.display.Graphics;
import openfl.display.Sprite;
import haxe.Constraints.Function;
import openfl.ui.Keyboard;
import openfl.events.*;
import openfl.text.*;

/**
 * ...
 * @author Michael Apfelbeck
 */
class Main extends Sprite 
{
    private var input:InputPoll;
    
    private var currentWorld:TestWorldBase;
    
    private var worlds:Array<Function>;
    
    private static var worldCount:Int = 5;
    private var currIndex:Int = 3;
    
    private var cycleTextField:TextField;
    
	public function new() 
    {
		super();
        
        input = new InputPoll(stage);
        
        if (this.stage != null){
            Init(null);
        }else{
            addEventListener(Event.ADDED_TO_STAGE, Init);
        }
	}
    
    private function Init(e:Event):Void 
    {
        removeEventListener(Event.ADDED_TO_STAGE, Init);
        addEventListener(Event.ENTER_FRAME, OnEnterFrame);
        
        this.stage.quality = "HIGH";
        
        getWorldAndAttach();
        
        cycleTextField = new TextField();
        cycleTextField.text = "PageUp/PageDown to cycle between test screens.";
        cycleTextField.autoSize = TextFieldAutoSize.LEFT;
        cycleTextField.x = stage.width - cycleTextField.width;
		cycleTextField.y = 0;
        stage.addChildAt(cycleTextField, 1);
    }
    
    function getWorldAndAttach() 
    {
        if (currentWorld != null){
            stage.removeChild(currentWorld);
            currentWorld = null;
        }
        currentWorld = getWorld(currIndex);
        stage.addChildAt(currentWorld, 0);
    }
    
    private var wasPageUp:Bool = false;
    private var wasPageDown:Bool = false;
    private function OnEnterFrame(event:Event):Void 
    {
        var newIndex = currIndex;
        if (wasPageUp && input.isDown(Keyboard.PAGE_UP)){
            newIndex = (newIndex + 1) % worldCount;
        }
        if(wasPageDown && input.isDown(Keyboard.PAGE_DOWN)){
            newIndex--;
            if (newIndex < 0){
                newIndex = worldCount - 1;
            }
        }
        
        wasPageUp = input.isUp(Keyboard.PAGE_UP);
        wasPageDown = input.isUp(Keyboard.PAGE_DOWN);
        if (newIndex != currIndex){
            currIndex = newIndex;
            getWorldAndAttach();
        }
    }
    
    private function getWorld(worldNum:Int):TestWorldBase
    {
        var world:TestWorldBase;
        switch(worldNum){
            case 0:
                world = new TestWorld1(input);
            case 1:
                world = new TestWorld2(input);
            case 2:
                world = new TestWorld3(input);
            case 3:
                world = new TestWorld4(input);
            case 4:
                world = new TestWorld5(input);
            default:
                trace("Something went wrong in the demo, unknown world number: " + worldNum);
                world = null;
        }
        return world;
    }
}
