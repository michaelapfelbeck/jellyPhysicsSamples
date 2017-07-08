package;

import haxe.Timer;
import jellyPhysics.*;
import jellyPhysics.math.*;
import openfl.display.FPS;
import openfl.display.Sprite;
import openfl.events.*;
import openfl.text.*;
import DrawDebugWorld;
import InputPoll;

/**
 * ...
 * @author Michael Apfelbeck
 */
class TestWorldBase extends Sprite
{
    public var drawSurface:Sprite;
    public var physicsWorld:World;
    
    public var mouseActive:Bool = false;
    public var hasGravity:Bool = true;
    public var hasDefaultMouse:Bool = true;
        
    public var mouseLocation:Vector2 = null;
    public var mouseBody:BodyPointMassRef = null;
    public var mouseCurrDistance:Float;
    
    public var defaultMaterial:MaterialPair;
    
    public var Title(get, set):String;
    
    private var input:InputPoll;
    
    private var title:String = "Test World";
    function get_Title():String 
    {
        return title;
    }    
    function set_Title(value:String):String 
    {   
        setTitle(value);
        return title;
    }
    
    private var promptText:String = "";
    public var PromptText(get, set):String;
    function get_PromptText():String 
    {
        return promptText;
    }    
    function set_PromptText(value:String):String 
    {   
        setPromptText(value);
        return promptText;
    }
    
    private var worldRender:DrawDebugWorld;
    private var lastTimeStamp:Float;
    private var titleTextField:TextField;
    private var promptTextField:TextField;
    
    public function new(inputPoll:InputPoll) 
    {
        super();
        
        input = inputPoll;
        if (this.stage != null){
            Init(null);
        }else{
            addEventListener(Event.ADDED_TO_STAGE, Init);
        }
		
    }
    
    private var overscan:Int = 0;
    private var backgroundHeight:Int;
    private var backgroundWidth:Int;
    private function Init(e:Event):Void
    {
        lastTimeStamp = Timer.stamp();
        
        removeEventListener(Event.ADDED_TO_STAGE, Init);
        addEventListener(Event.REMOVED_FROM_STAGE, Close);
        addEventListener(Event.ENTER_FRAME, OnEnterFrame);
        
        if(hasDefaultMouse){
            addEventListener(MouseEvent.MOUSE_DOWN, OnMouseDown);
            addEventListener(MouseEvent.MOUSE_UP, OnMouseUp);
            addEventListener(MouseEvent.MOUSE_OUT, OnMouseUp);
            addEventListener(MouseEvent.MOUSE_MOVE, OnMouseMove);
        }
        
        defaultMaterial = new MaterialPair();
        defaultMaterial.Collide = true;
        defaultMaterial.Friction = 0.3;
        defaultMaterial.Elasticity = 0.8;
        
        addChildAt(createDrawSurface(), 0);
        addChildAt(setTitle(title), 1);
        addChildAt(setPromptText(promptText), 2);
        addChild(new FPS(0, 0, 0x808080));
        
        createWorld();
        addBodiesToWorld();
        
        worldRender = new DrawDebugWorld(drawSurface, physicsWorld);
        setupDrawParam(worldRender);
    }
    
    public function setupDrawParam(render:DrawDebugWorld):Void
    {
        
    }
    
    function setTitle(value:String):TextField
    {
        if (titleTextField == null){
            titleTextField = new TextField();
            titleTextField.mouseEnabled = false;
            titleTextField.autoSize = TextFieldAutoSize.LEFT;
            titleTextField.textColor = 0x000000;
        }
        title = value;
        titleTextField.text = title;
        titleTextField.x = overscan * 2.5;
        return titleTextField;
    }
    
    function setPromptText(value:String):TextField
    {
        if (promptTextField == null){
            promptTextField = new TextField();
            promptTextField.mouseEnabled = false;
            promptTextField.autoSize = TextFieldAutoSize.LEFT;
            promptTextField.textColor = 0xFFFFFF;
        }
        promptText = value;
        promptTextField.text = promptText;
        if(drawSurface != null){
            promptTextField.x = drawSurface.stage.stageWidth - (promptTextField.width + overscan * 1.5);
            promptTextField.y = overscan * 1.5;
        }
        return promptTextField;
    }
    
    private function createDrawSurface():Sprite
    {
        overscan = 20;
        drawSurface = new Sprite();
        drawSurface.x = overscan;
        drawSurface.y = overscan;
        
        drawSurface.cacheAsBitmap = true;
        
        return drawSurface;
    }
    
    private function OnEnterFrame(e:Event)
    {
        var currTimeStamp:Float = Timer.stamp();
        var frameTime = currTimeStamp - lastTimeStamp;
        //trace("frame time: " + frameTime);
        lastTimeStamp = currTimeStamp;
        
        Update(frameTime);
        
        Draw();
    }
    
    public function Update(elapsed:Float):Void
    {
        physicsWorld.Update(elapsed);
    }
    
    private function Draw():Void
    {
        worldRender.Draw();
        if (mouseActive){
            drawSurface.graphics.lineStyle(0, DrawDebugWorld.COLOR_GREEN, 1.0);
            
            var mouseLocal:Vector2 = worldToLocal(mouseLocation);
            drawSurface.graphics.moveTo(mouseLocal.x, mouseLocal.y);
            var body:Body = physicsWorld.GetBody(mouseBody.BodyID);
            var pointMass:PointMass = body.PointMasses[mouseBody.PointMassIndex];
            var location:Vector2 = worldToLocal(pointMass.Position);
            drawSurface.graphics.lineTo(location.x, location.y);
        }
    }
    
    private function Close(e:Event):Void
    {
        removeEventListener(Event.REMOVED_FROM_STAGE, Close);
        removeEventListener(Event.ENTER_FRAME, Update);
    }
        
    private function PhysicsAccumulator(elapsed:Float){
        if(hasGravity){
            var gravity:Vector2 = new Vector2(0, 9.8);
            gravity.y *= 0.5;

            for(i in 0...physicsWorld.NumberBodies)
            {
                var body:Body = physicsWorld.GetBody(i);
                if (!body.IsStatic){
                    body.AddGlobalForce(body.DerivedPos, gravity);
                }
            }
        }
        
        if (hasDefaultMouse && mouseActive){
            var body:Body = physicsWorld.GetBody(mouseBody.BodyID);
            var pointMass:PointMass = body.PointMasses[mouseBody.PointMassIndex];
            var force:Vector2 = VectorTools.CalculateSpringForce(mouseLocation, 
                                new Vector2(0, 0), pointMass.Position, pointMass.Velocity, mouseBody.Distance, 250, 50);
            pointMass.Force.x -= force.x;
            pointMass.Force.y -= force.y;
        }
    }
    
    private function OnMouseMove(e:MouseEvent):Void 
    {
        if(mouseActive){
            mouseLocation = localToWorld(new Vector2(e.localX, e.localY));
        }        
    }
    
    private function OnMouseDown(e:MouseEvent):Void 
    {
        if (!hasDefaultMouse){
            return;
        }
        mouseLocation = localToWorld(new Vector2(e.localX, e.localY));
        mouseBody = physicsWorld.GetClosestPointMass(mouseLocation, true);
        if(mouseBody != null){
            mouseActive = true;
        }
    }
    
    private function OnMouseUp(e:MouseEvent):Void 
    {
        mouseActive = false;
    }
    
    public function getSquareShape(size:Float):ClosedShape{
        var squareShape:ClosedShape = new ClosedShape();
        squareShape.Begin();
        squareShape.AddVertex(new Vector2(0, 0));
        squareShape.AddVertex(new Vector2(size, 0));
        squareShape.AddVertex(new Vector2(size, size));
        squareShape.AddVertex(new Vector2(0, size));
        squareShape.Finish(true);
        return squareShape;
    }
    
    public function getBigSquareShape(size:Float):ClosedShape{
        var bigSquareShape:ClosedShape = new ClosedShape();
        bigSquareShape.Begin();
        bigSquareShape.AddVertex(new Vector2(0, -size*2));
        bigSquareShape.AddVertex(new Vector2(size, -size*2));
        bigSquareShape.AddVertex(new Vector2(size*2, -size*2));
        bigSquareShape.AddVertex(new Vector2(size*2, -size));
        bigSquareShape.AddVertex(new Vector2(size*2, 0));
        bigSquareShape.AddVertex(new Vector2(size, 0));
        bigSquareShape.AddVertex(new Vector2(0, 0));
        bigSquareShape.AddVertex(new Vector2(0, -size));
        bigSquareShape.Finish(true);
        return bigSquareShape;
    }
    
    public function getPolygonShape(radius:Float, ?count:Int):ClosedShape{
        if (null == count){
            count = 12;
        }
        
        var polygonShape:ClosedShape = new ClosedShape();
        polygonShape.Begin();
        for (i in 0...count){
            var point:Vector2 = new Vector2();
            point.x =  Math.cos(2 * (Math.PI / count) * i) * radius;
            point.y = Math.sin(2 * (Math.PI / count) * i) * radius;
            polygonShape.AddVertex(point);
        }
        
        polygonShape.Finish(true);
        return polygonShape;
    }
    
    //convert local coordinate on this sprite to world coordinate in the physics world
    public function localToWorld(local:Vector2):Vector2{
        var world:Vector2 = new Vector2(
                                    (local.x - worldRender.offset.x) / worldRender.scale.x,
                                    (local.y - worldRender.offset.y) / worldRender.scale.y);
        return world;
    }
    
    //convert physics world coordinate to local coordinate on this sprite
    public function worldToLocal(world:Vector2):Vector2{
        var local:Vector2 = new Vector2(
                                    (world.x * worldRender.scale.x)+worldRender.offset.x,
                                    (world.y * worldRender.scale.y) + worldRender.offset.y );
        return local;
    }
    
    private function createWorld()
    {
        var matrix:MaterialMatrix = getMaterialMatrix();
        
        var bounds:AABB = new AABB(new Vector2( -20, -20), new Vector2( 20, 20));
        
        var penetrationThreshhold:Float = 10.0;
        
        physicsWorld = new World(matrix.Count, matrix, matrix.DefaultMaterial, penetrationThreshhold, bounds);
        physicsWorld.externalAccumulator = PhysicsAccumulator;
    }
    
    public function getMaterialMatrix():MaterialMatrix{
        var materialCount : Int = 1;
        var materialMatrix:MaterialMatrix = new MaterialMatrix(defaultMaterial, materialCount);
        
        return materialMatrix;
    }
    
    public function addBodiesToWorld():Void
    {
    }    
}