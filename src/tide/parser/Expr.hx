package tide.parser;

enum ExprData {
    EId(id:String);
    EInt(i:Int);
    EFloat(f:Float);
    EString(s:String);
    EBlock(b:Array<Expr>);
    
    EBinop(l:Expr, r:Expr, op:String);
    EUnop(op:String, e:Expr, post:Bool);

    EVar(name:String, type:String, e:Expr, mutable:Bool);
    EMultVar(vars:Array<VariableDef>, values:Array<Expr>);
    EFunction(e:Expr, args:Array<VariableDef>, type:String, ?name:String);
    ELambda(e:Expr, args: Array<VariableDef>);
    EIf(cond:Expr, b:Expr, e:Expr);
    EReturn(e:Expr);
}

typedef Expr = {
    data:ExprData,
    start:Int,
    end:Int,
    startLine:Int,
    endLine:Int
}

typedef VariableDef = {
    name:String,
    type:String,
    ?mutable:Bool
}