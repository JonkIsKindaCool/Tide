package tide.parser;

enum ExprData {
	EId(id:String);
	EInt(i:Int);
	EFloat(f:Float);
	EString(s:String);
	EArray(v:Array<Expr>);
	EBlock(b:Array<Expr>);

	EBinop(l:Expr, r:Expr, op:String);
	EUnop(op:String, e:Expr, post:Bool);

	EVar(name:String, type:Type, e:Expr, mutable:Bool);
	EFunction(e:Expr, args:Array<VariableDef>, type:Type, ?name:String);
	ELambda(e:Expr, args:Array<VariableDef>);
	EIf(cond:Expr, b:Expr, e:Expr);
	EReturn(e:Expr);

	EField(v:Expr, f:String);
	ECall(v:Expr, args:Array<Expr>);
    EAccess(v:Expr, i:Expr);
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
	type:Type,
	?mutable:Bool
}

typedef Type = {
	name:String,
	generic:Array<Type>
}