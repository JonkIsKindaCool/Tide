package tide.vm;

import tide.std.TideInstance;
import tide.std.TideClass;

enum Values {
    VInt(i:Int);
    VFloat(f:Float);
    VString(s:String);

    VHxFunction(v:Array<Values> -> Values);

    VClass(c:TideClass);
    VInstance(i:TideInstance);
}