package;

import haxe.Constraints.Function;
import jellyPhysics.*;
import jellyPhysics.math.Vector2;
import openfl.events.*;
import DrawDebugWorld;
import InputPoll;
import jellyPhysics.math.VectorTools;

/**
 * ...
 * @author Michael Apfelbeck
 */
class TestWorld7 extends TestWorldBase 
{
    private var externalSprings:Array<ExternalSpring>;
    
    private static var MATERIAL_GROUND:Int = 0;
    private static var MATERIAL_TYPE_1:Int = 1;
    private static var MATERIAL_TYPE_2:Int = 2;
    private static var MATERIAL_TYPE_3:Int = 3;
    private static var MATERIAL_TYPE_4:Int = 4;
        
    public function new(inputPoll:InputPoll) 
    {
        super(inputPoll);
        Title = "External Spring Test World";
        PromptText = "Test external springs.";
        externalSprings = new Array<ExternalSpring>();
    }
    
    override public function getMaterialMatrix():MaterialMatrix 
    {
        var materialMatrix:MaterialMatrix = new MaterialMatrix(defaultMaterial, 5);

        materialMatrix.SetMaterialPairCollide(MATERIAL_GROUND, MATERIAL_TYPE_1, true);
        materialMatrix.SetMaterialPairCollide(MATERIAL_GROUND, MATERIAL_TYPE_2, true);
        materialMatrix.SetMaterialPairCollide(MATERIAL_GROUND, MATERIAL_TYPE_3, true);
        materialMatrix.SetMaterialPairCollide(MATERIAL_GROUND, MATERIAL_TYPE_4, true);
        materialMatrix.SetMaterialPairCollide(MATERIAL_TYPE_1, MATERIAL_TYPE_2, true);
        materialMatrix.SetMaterialPairCollide(MATERIAL_TYPE_1, MATERIAL_TYPE_3, true);
        materialMatrix.SetMaterialPairCollide(MATERIAL_TYPE_1, MATERIAL_TYPE_4, true);
        materialMatrix.SetMaterialPairCollide(MATERIAL_TYPE_2, MATERIAL_TYPE_3, true);
        materialMatrix.SetMaterialPairCollide(MATERIAL_TYPE_2, MATERIAL_TYPE_4, true);
        materialMatrix.SetMaterialPairCollide(MATERIAL_TYPE_3, MATERIAL_TYPE_4, true);
        
        return materialMatrix;
    }
    
    override public function setupDrawParam(render:DrawDebugWorld):Void 
    {
        super.setupDrawParam(render);
        render.backgroundColor = DrawDebugWorld.COLOR_WHITE;
        render.ColorOfInternalSprings = DrawDebugWorld.COLOR_BLACK;
        render.DrawingPointMasses = false;
        render.DrawingInternalSprings = true;
        render.DrawingAABB = false;
        render.DrawingLabels = false;
        render.SetMaterialDrawOptions(MATERIAL_GROUND, DrawDebugWorld.COLOR_GREY, true);
        render.SetMaterialDrawOptions(MATERIAL_TYPE_1, DrawDebugWorld.COLOR_PURPLE, true);
        render.SetMaterialDrawOptions(MATERIAL_TYPE_2, DrawDebugWorld.COLOR_GREEN, true);
        render.SetMaterialDrawOptions(MATERIAL_TYPE_3, DrawDebugWorld.COLOR_RED, true);
        render.SetMaterialDrawOptions(MATERIAL_TYPE_4, DrawDebugWorld.COLOR_BLUE, true);
    }
    
    override public function Update(elapsed: Float) 
    {
        var accumulatorForce:Vector2 = null;
        
        for (i in 0...externalSprings.length)
        {
            var spring:ExternalSpring = externalSprings[i];
            var a:Body = spring.BodyA;
            var pmA = a.PointMasses[spring.pointMassA];
            var b:Body = spring.BodyB;
            var pmB = b.PointMasses[spring.pointMassB];
            
            accumulatorForce = VectorTools.CalculateSpringForce(pmA.Position, pmA.Velocity, pmB.Position, pmB.Velocity, spring.springLen, spring.springK, spring.damping);

            pmA.Force.x += accumulatorForce.x;
            pmA.Force.y += accumulatorForce.y;
            pmB.Force.x -= accumulatorForce.x;
            pmB.Force.y -= accumulatorForce.y;
        }
        super.Update(elapsed);
    }
    
    var externalDamp:Float = 15;
    var externalK:Float = 450;
    public override function addBodiesToWorld():Void
    {                
        var groundBody:Body = new Body(getSquareShape(2), Math.POSITIVE_INFINITY, new Vector2(0, 9), 0, new Vector2(16, 1), false);
        groundBody.IsStatic = true;
        groundBody.Material = MATERIAL_GROUND;
        physicsWorld.AddBody(groundBody);
        
        var mass:Float = 1.0;
        var angle:Float = 0.0;
        var shapeK:Float = 100;
        var shapeDamp:Float = 150;
        var edgeK:Float = 100;
        var edgeDamp:Float = 50;
        var pressureAmount:Float = 10.0;
        
        //lower left
        var body1:PressureBody = new PressureBody(getBigSquareShape(1.5), mass, new Vector2( 0, 3), 0, new Vector2(1, 1), false, shapeK, shapeDamp, edgeK, edgeDamp, pressureAmount);
        body1.Material = MATERIAL_TYPE_1;
        physicsWorld.AddBody(body1);
        
        //upper right
        var body2:PressureBody = new PressureBody(getBigSquareShape(1.5), mass, new Vector2( 0, 0), 0, new Vector2(1, 1), false, shapeK, shapeDamp, edgeK, edgeDamp, pressureAmount);
        body2.Material = MATERIAL_TYPE_2;
        physicsWorld.AddBody(body2);
        
        //lower left
        var body3:PressureBody = new PressureBody(getBigSquareShape(1.5), mass, new Vector2( -4, 4), 0, new Vector2(1, 1), false, shapeK, shapeDamp, edgeK, edgeDamp, pressureAmount);
        body3.Material = MATERIAL_TYPE_3;
        physicsWorld.AddBody(body3);
        
        //upper left
        var body4:PressureBody = new PressureBody(getBigSquareShape(1.5), mass, new Vector2( -3, 0), 0, new Vector2(1, 1), false, shapeK, shapeDamp, edgeK, edgeDamp, pressureAmount);
        body4.Material = MATERIAL_TYPE_4;
        physicsWorld.AddBody(body4);
        
        AttachBlocks(body1, body2, externalSprings);
        AttachBlocks(body4, body2, externalSprings);
    }
    
    private function AttachBlocks(BlockA:Body, BlockB:Body, springs:Array<ExternalSpring>) 
    {
        var numberPMA:Int = BlockA.PointMasses.length;
        var numberPMB:Int = BlockB.PointMasses.length;
        var pmA:PointMass;

        /*if the two block are greater than their size distant then they're
         * diagonal to each other and we don't want to connect them*/
        var blockACenter:Vector2 = BlockA.DerivedPos;
        var blockBCenter:Vector2 = BlockB.DerivedPos;
        
        if (VectorTools.Distance(blockACenter, blockBCenter) > 3.0 + .01)
        {
            return;
        }

        var spring:ExternalSpring;
        for (i in 0...numberPMA)
        {
            pmA = BlockA.PointMasses[i];
            for (j in 0...numberPMB)
            {
                var dist:Vector2 = VectorTools.Subtract(pmA.Position, BlockB.PointMasses[j].Position);
                var absolute:Float = dist.length();

                if (absolute < 0.1)
                {
                    spring = new ExternalSpring(BlockA, BlockB, i, j,
                        0, externalK, externalDamp);

                    springs.push(spring);
                }
            }
        }
    }
}