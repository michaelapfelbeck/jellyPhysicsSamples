package;

/**
 * ...
 * @author Michael Apfelbeck
 */
class DebugDrawBodyOption
{
    public var MaterialNum:Int;
    public var Color:Int;
    public var IsSolid:Bool;
    public function new(materialNum:Int, color:Int, isSolid:Bool){
        MaterialNum = materialNum;
        Color = color;
        IsSolid = isSolid;
    }    
}