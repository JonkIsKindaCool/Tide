package tide.compiler;

import tide.parser.Parser;
import tide.parser.Expr;
import tide.vm.Values;

class Compiler {
	public var allocator:Allocator;

	private var instructions:Array<Instruction>;
	private var src:String;
	private var constants:Array<Values>;

	public function new() {}

	public function compile(src:String):Program {
		this.src = src;
		allocator = new Allocator(src);
		instructions = [];
		constants = [];
		constantMap = new Map();

		compileExpr(new Parser(src).parse());

		return {
			instructions: instructions,
			constantPool: constants
		}
	}

	private function compileExpr(e:Expr, ?instructions:Array<Instruction>):{reg:Int, shouldFree:Bool} {
		instructions ??= this.instructions;
		var reg:Int = 0;
		var shouldFree:Bool = false;

		switch (e.data) {
			case EBlock(exprs):
				for (e in exprs)
					compileExpr(e, instructions);
			case EId(id):
			case EInt(i):
				instructions.push(LOAD_K);
				instructions.push(reg = allocator.allocateRegister(e));
				instructions.push(addConstant(VInt(i)));
			case EFloat(f):
				instructions.push(LOAD_K);
				instructions.push(reg = allocator.allocateRegister(e));
				instructions.push(addConstant(VFloat(f)));
			case EString(s):
				instructions.push(LOAD_K);
				instructions.push(reg = allocator.allocateRegister(e));
				instructions.push(addConstant(VString(s)));
			case EBinop(l, r, op):
				var lReg = compileExpr(l, instructions);
				var rReg = compileExpr(r, instructions);

				var l:Int = lReg.reg;
				var r:Int = rReg.reg;
				instructions.push(switch (op) {
					case "+":
						SUM;
					case "-":
						SUBTRACT;
					case "*":
						MULTIPLY;
					case "/":
						DIVIDE;
					case _:
						throw CompilerError.compilerError('Unexpected operator $op.', e, src);
				});
				instructions.push(l);
				instructions.push(r);
				if (lReg.shouldFree)
					allocator.freeRegister(e, lReg.reg);

				if (rReg.shouldFree)
					allocator.freeRegister(e, rReg.reg);
				instructions.push(reg = allocator.allocateRegister(e));
			case EUnop(op, e, post):
			case EVar(name, type, e, mutable):
			case EArray(v):
			case EFunction(e, args, type, name):
			case ELambda(e, args):
			case EIf(cond, b, e):
			case EReturn(e):
			case ECall(v, args):
			case EAccess(v, i):
			case EField(v, f):
		}

		return {reg: reg, shouldFree: shouldFree};
	}

	private var constantMap:Map<Values, Int> = new Map();

	private function addConstant(v:Values):Int {
		if (constantMap.exists(v)) {
			return constantMap.get(v);
		}

		var idx:Int = constants.length;
		constants.push(v);
		constantMap.set(v, idx);
		return idx;
	}
}
