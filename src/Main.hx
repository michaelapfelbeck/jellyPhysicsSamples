package;

import openfl.display.Graphics;
import openfl.display.SimpleButton;
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
    
    private static var worldCount:Int = 6;
    private var currIndex:Int = 4;
        
    private var upButton:SimpleButton;
    private var downButton:SimpleButton;
    
	public function new() 
    {
		super();
        
        input = new InputPoll(stage);
        
        if (this.stage != null){
            Init(null);
        }else{
            addEventListener(Event.ADDED_TO_STAGE, Init);
        }
        
        //testPool();
	}
    
    /*function testPool() 
    {
        var intPool:Pool<Int> = new Pool<Int>(4, intMaker);
        
        var fromPool1 = intPool.get();
        var fromPool2 = intPool.get();
        var fromPool3 = intPool.get();
        
        fromPool2 = 8;
        
        intPool.release(fromPool1);
        intPool.release(fromPool2);
        intPool.release(fromPool3);
    }
    
    function intMaker():Int
    {
        return 7;
    }*/
    
    private function Init(e:Event):Void 
    {
        #if debug
        trace("debug build");
        #else
        trace("release build");
        #end
        
        removeEventListener(Event.ADDED_TO_STAGE, Init);
        addEventListener(Event.ENTER_FRAME, OnEnterFrame);
        
        this.stage.quality = "HIGH";
        
        getWorldAndAttach();
        
        var upButton:SimpleButton = makeButton("Next(PgUp)", 5, 0x9999BB, 0x333333);
        var downButton:SimpleButton = makeButton("Prev(PgDn)", 5, 0x9999BB, 0x333333);
        
        upButton.addEventListener(MouseEvent.CLICK, cycleUp);
        downButton.addEventListener(MouseEvent.CLICK, cycleDown);
        
        addChild(upButton);
        addChild(downButton);
        
        upButton.x = stage.width-(upButton.width+5);
        upButton.y = 2;
        
        downButton.x = stage.width-(downButton.width+upButton.width+15);
        downButton.y = 2;
    }
    
    private function cycleUp(e:Event):Void 
    {
        trace("cycleUp");
        currIndex = (currIndex + 1) % worldCount;
        getWorldAndAttach();
    }
    
    private function cycleDown(e:Event):Void 
    {
        trace("cycleDown");
        currIndex--;
        if (currIndex < 0){
            currIndex = worldCount - 1;
        }
        getWorldAndAttach();
    }
    
    function makeButton(text:String, padding:Int, buttonColor:Int, textColor:Int):SimpleButton{
        var textField:TextField = new TextField();
        textField.text = text;
        textField.autoSize = TextFieldAutoSize.LEFT;
        textField.textColor = textColor;
        textField.x = padding;
        textField.y = padding;
        textField.mouseEnabled = false;
        
        var button:SimpleButton = new SimpleButton();
        var buttonSprite:Sprite = new Sprite();
        buttonSprite.graphics.lineStyle(1, 0x555555);
        buttonSprite.graphics.beginFill(buttonColor,1);
        buttonSprite.graphics.drawRect(0,0,textField.width+padding*2,textField.height+padding*2);
        buttonSprite.graphics.endFill();
        
        buttonSprite.addChild(textField);

        button.overState = button.downState = button.upState = button.hitTestState = buttonSprite;
        
        return button;
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
            case 5:
                world = new TestWorld6(input);
            default:
                trace("Something went wrong in the demo, unknown world number: " + worldNum);
                world = null;
        }
        return world;
    }
}
