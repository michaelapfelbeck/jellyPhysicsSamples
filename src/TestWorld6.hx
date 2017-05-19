package;

import haxe.Constraints.Function;
import jellyPhysics.*;
import jellyPhysics.math.Vector2;
import openfl.events.*;
import DrawDebugWorld;
import InputPoll;
/**
 * ...
 * @author Michael Apfelbeck
 */
class TestWorld6 extends TestWorldBase 
{
    private static var MATERIAL_GROUND:Int = 0;
    private static var MATERIAL_TYPE_1:Int = 1;
    private static var MATERIAL_TYPE_2:Int = 2;
    private static var MATERIAL_TYPE_3:Int = 3;
        
    public function new(inputPoll:InputPoll) 
    {
        super(inputPoll);
        Title = "Edge Collision Test World";
        PromptText = "Test collisions between vertexes and lines.";
    }
    
    override public function getMaterialMatrix():MaterialMatrix 
    {
        var materialMatrix:MaterialMatrix = new MaterialMatrix(defaultMaterial, 4);

        materialMatrix.SetMaterialPairCollide(MATERIAL_GROUND, MATERIAL_TYPE_1, true);
        materialMatrix.SetMaterialPairCollide(MATERIAL_GROUND, MATERIAL_TYPE_2, true);
        materialMatrix.SetMaterialPairCollide(MATERIAL_GROUND, MATERIAL_TYPE_3, true);
        materialMatrix.SetMaterialPairCollide(MATERIAL_TYPE_1, MATERIAL_TYPE_2, true);
        materialMatrix.SetMaterialPairCollide(MATERIAL_TYPE_1, MATERIAL_TYPE_3, true);
        materialMatrix.SetMaterialPairCollide(MATERIAL_TYPE_2, MATERIAL_TYPE_3, true);
        
        return materialMatrix;
    }
    
    override public function setupDrawParam(render:DrawDebugWorld):Void 
    {
        super.setupDrawParam(render);
        render.DrawingPointMasses = true;
        render.DrawingAABB = false;
        render.SetMaterialDrawOptions(MATERIAL_GROUND, DrawDebugWorld.COLOR_GREY, true);
        render.SetMaterialDrawOptions(MATERIAL_TYPE_1, DrawDebugWorld.COLOR_PURPLE, true);
        render.SetMaterialDrawOptions(MATERIAL_TYPE_2, DrawDebugWorld.COLOR_GREEN, true);
        render.SetMaterialDrawOptions(MATERIAL_TYPE_3, DrawDebugWorld.COLOR_RED, true);
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
        var shapeDamp:Float = 150;
        var edgeK:Float = 100;
        var edgeDamp:Float = 50;
        var pressureAmount:Float = 50.0;
        
        var body1:SpringBody = new SpringBody(getBigSquareShape(1.5), mass, new Vector2( 0, 4), 0, new Vector2(1, 1), false, shapeK, shapeDamp, edgeK, edgeDamp);
        body1.Material = MATERIAL_TYPE_1;
        physicsWorld.AddBody(body1);
        
        var body2:SpringBody = new SpringBody(getBigSquareShape(1.5), mass, new Vector2( 0, -0.5), Math.PI/4, new Vector2(1, 1), false, shapeK, shapeDamp, edgeK, edgeDamp);
        body2.Material = MATERIAL_TYPE_2;
        physicsWorld.AddBody(body2);
        
        var body3:SpringBody = new SpringBody(getBigSquareShape(1.5), mass, new Vector2( -3, 1.5), Math.PI/6, new Vector2(1, 1), false, shapeK, shapeDamp, edgeK, edgeDamp);
        body3.Material = MATERIAL_TYPE_3;
        physicsWorld.AddBody(body3);
    }
}