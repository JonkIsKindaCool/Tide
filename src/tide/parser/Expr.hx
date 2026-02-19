package tide.parser;

enum Expr {
    EId(id:String);
    EInt(i:Int);
    EFloat(f:Float);
    EString(s:String);
    
    EBinop(l:Expr, r:Expr, op:String);
    EUnop(op:String, e:Expr, post:Bool);
}