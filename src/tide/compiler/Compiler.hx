package tide.compiler;

import tide.parser.Expr;
import tide.vm.Values;

class Compiler {
	public var allocator:Allocator;

	private var instructions:Array<Instruction>;
	private var constants:Array<Values>;

	public function new() {
		allocator = new Allocator();
	}

	public function compile(e:Expr):Program {
		instructions = [];
		constants = [];

        compileExpr(e);

		return {
			instructions: instructions,
			constantPool: constants
		}
	}

	private function compileExpr(e:Expr, ?instructions:Array<Instruction>) {
		instructions ??= this.instructions;

		switch (e.data) {
			case EBlock(exprs):
				for (e in exprs)
					compileExpr(e, instructions);
            case EId(id):
            case EInt(i):
                instructions.push(LOAD_K);
                instructions.push(allocator.allocateRegister());
                instructions.push(addConstant(VInt(i)));
            case EFloat(f):
                instructions.push(LOAD_K);
                instructions.push(allocator.allocateRegister());
                instructions.push(addConstant(VFloat(f)));
            case EString(s):
                instructions.push(addConstant(VString(s)));
            case EArray(v):
            case EBinop(l, r, op):
            case EUnop(op, e, post):
            case EVar(name, type, e, mutable):
            case EFunction(e, args, type, name):
            case ELambda(e, args):
            case EIf(cond, b, e):
            case EReturn(e):
            case ECall(v, args):
            case EAccess(v, i):
            case EField(v, f):
		}
	}

    private function addConstant(v:Values):Int {
        var idx:Int = constants.indexOf(v);

        if (idx == -1){
            idx = constants.length;
            constants.push(v);
        }

        return idx;
    }
}
