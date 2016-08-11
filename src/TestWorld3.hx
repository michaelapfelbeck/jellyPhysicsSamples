package;

import haxe.Constraints.Function;
import jellyPhysics.*;
import lime.math.Vector2;
import openfl.events.*;
import DrawDebugWorld;
import InputPoll;
/**
 * ...
 * @author Michael Apfelbeck
 */
class TestWorld3 extends TestWorldBase
{
    private static var MATERIAL_GROUND:Int = 0;
    private static var MATERIAL_TYPE_1:Int = 1;
    private static var MATERIAL_TYPE_2:Int = 2;
        
    public function new(inputPoll:InputPoll) 
    {
        super(inputPoll);
        Title = "Material Test World";
        PromptText = "Use material collision to prevent red and yellow from colliding.";
    }
    
    override public function getMaterialMatrix():MaterialMatrix 
    {
        var materialMatrix:MaterialMatrix = new MaterialMatrix(defaultMaterial, 3);

        materialMatrix.SetMaterialPairCollide(MATERIAL_GROUND, MATERIAL_TYPE_1, true);
        materialMatrix.SetMaterialPairCollide(MATERIAL_GROUND, MATERIAL_TYPE_2, true);
        materialMatrix.SetMaterialPairCollide(MATERIAL_TYPE_1, MATERIAL_TYPE_2, false);
        
        return materialMatrix;
    }
    
    override public function setupDrawParam(render:DrawDebugWorld):Void 
    {
        super.setupDrawParam(render);
        render.DrawingPointMasses = false;
        render.DrawingAABB = true;
        render.SetMaterialDrawOptions(MATERIAL_GROUND, DrawDebugWorld.COLOR_WHITE, false);
        render.SetMaterialDrawOptions(MATERIAL_TYPE_1, DrawDebugWorld.COLOR_YELLOW, true);
        render.SetMaterialDrawOptions(MATERIAL_TYPE_2, DrawDebugWorld.COLOR_RED, true);
    }
    
    public override function addBodiesToWorld():Void
    {                
        var groundBody:Body = new Body(getSquareShape(2), Math.POSITIVE_INFINITY, new Vector2(0, 9), 0, new Vector2(16, 1), false);
        groundBody.IsStatic = true;
        groundBody.Material = MATERIAL_GROUND;
        physicsWorld.AddBody(groundBody);
        
        var mass:Float = 1.0;
        var angle:Float = 0.0;
        var shapeK:Float = 200;
        var shapeDamp:Float = 100;
        var edgeK:Float = 100;
        var edgeDamp:Float = 50;
        var pressureAmount:Float = 50.0;
             
        var type1PressureBody:PressureBody = new PressureBody(getBigSquareShape(2), mass, new Vector2( -3, 6.25), 0, new Vector2(.5, .5), false, shapeK, shapeDamp, edgeK, edgeDamp, pressureAmount);
        type1PressureBody.Material = MATERIAL_TYPE_1;
        physicsWorld.AddBody(type1PressureBody);
        
        var type1SquareBody1:SpringBody = new SpringBody(getSquareShape(2), mass, new Vector2( -3, 4), 0, new Vector2(1, 1), false, shapeK, shapeDamp, edgeK, edgeDamp);
        type1SquareBody1.Material = MATERIAL_TYPE_1;
        physicsWorld.AddBody(type1SquareBody1); 
        
        var type1SquareBody2:SpringBody = new SpringBody(getSquareShape(2), mass, new Vector2( -2.8, 1), 0, new Vector2(1, 1), false, shapeK, shapeDamp, edgeK, edgeDamp);
        type1SquareBody2.Material = MATERIAL_TYPE_1;
        physicsWorld.AddBody(type1SquareBody2); 
             
        var type2PressureBody:PressureBody = new PressureBody(getBigSquareShape(2), mass, new Vector2( 3, 6.25), 0, new Vector2(.5, .5), false, shapeK, shapeDamp, edgeK, edgeDamp, pressureAmount);
        type2PressureBody.Material = MATERIAL_TYPE_2;
        physicsWorld.AddBody(type2PressureBody);
        
        var type2SquareBody1:SpringBody = new SpringBody(getSquareShape(2), mass, new Vector2( 3, 4), 0, new Vector2(1, 1), false, shapeK, shapeDamp, edgeK, edgeDamp);
        type2SquareBody1.Material = MATERIAL_TYPE_2;
        physicsWorld.AddBody(type2SquareBody1);
        
        var type2SquareBody2:SpringBody = new SpringBody(getSquareShape(2), mass, new Vector2( 2.8, 1), 0, new Vector2(1, 1), false, shapeK, shapeDamp, edgeK, edgeDamp);
        type2SquareBody2.Material = MATERIAL_TYPE_2;
        physicsWorld.AddBody(type2SquareBody2);
    }
}