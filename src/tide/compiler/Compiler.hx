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
			case EBool(b):
				instructions.push(b ? TRUE : FALSE);
				instructions.push(reg = allocator.allocateRegister(e));
				shouldFree = true;
			case EReturn(e):
				var i = compileExpr(e, instructions);
				instructions.push(RETURN);
				instructions.push(i.reg);
				if (i.shouldFree)
					allocator.freeRegister(e, i.reg);
			case EId(id):
				instructions.push(LOAD_ID);
				instructions.push(reg = allocator.getVariable(id));
			case EInt(i):
				instructions.push(LOAD_K);
				instructions.push(reg = allocator.allocateRegister(e));
				instructions.push(addConstant(VInt(i)));
				shouldFree = true;
			case EFloat(f):
				instructions.push(LOAD_K);
				instructions.push(reg = allocator.allocateRegister(e));
				instructions.push(addConstant(VFloat(f)));
				shouldFree = true;
			case EString(s):
				instructions.push(LOAD_K);
				instructions.push(reg = allocator.allocateRegister(e));
				instructions.push(addConstant(VString(s)));
				shouldFree = true;
			// En Compiler.hx, dentro de EBinop
			case EBinop(l, r, op):
				var lReg = compileExpr(l, instructions);
				trace("lReg asignado:", lReg.reg);

				allocator.pin(lReg.reg);
				var rReg = compileExpr(r, instructions);
				allocator.unpin(lReg.reg);
				trace("rReg asignado:", rReg.reg); // si sigue siendo 0, el pin no está funcionando

				var lIdx:Int = lReg.reg;
				var rIdx:Int = rReg.reg;

				instructions.push(switch (op) {
					case "+": SUM;
					case "-": SUBTRACT;
					case "*": MULTIPLY;
					case "/": DIVIDE;
					case "%": MOD;
					case "**": POW;
					case "==": EQ;
					case "!=": NEQ;
					case "<": LT;
					case ">": GT;
					case "<=": LTE;
					case ">=": GTE;
					case "&&": AND;
					case "||": OR;
					case "??": NULLISH;
					case "..": RANGE;
					case "..=": RANGE_INC;
					case "<<": SHL;
					case ">>": SHR;
					case _: throw CompilerError.compilerError('Unexpected operator $op.', e, src);
				});
				instructions.push(lIdx);
				instructions.push(rIdx);

				if (rReg.shouldFree)
					allocator.freeRegister(e, rReg.reg);
				if (lReg.shouldFree)
					allocator.freeRegister(e, lReg.reg);

				instructions.push(reg = allocator.allocateRegister(e));
				shouldFree = true;

			case EUnop(op, inner, post):
				var iReg = compileExpr(inner, instructions);

				switch (op) {
					case "!":
						instructions.push(NOT);
						instructions.push(iReg.reg);
						if (iReg.shouldFree)
							allocator.freeRegister(e, iReg.reg);
						instructions.push(reg = allocator.allocateRegister(e));
						shouldFree = true;
					case "...":
						throw CompilerError.compilerError('Spread not yet implemented.', e, src);
					case _:
						throw CompilerError.compilerError('Unexpected unary operator $op.', e, src);
				}
			case EVar(name, type, e, mutable):
				var i = compileExpr(e, instructions);
				allocator.allocateVariable(e, reg = i.reg, name, mutable);
			case EArray(v):
			case EFunction(e, args, type, name):
			case ELambda(e, args):
			case EIf(cond, b, e):
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
