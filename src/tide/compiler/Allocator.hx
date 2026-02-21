package tide.compiler;

import tide.parser.Expr;
import haxe.ds.Vector;

class Allocator {
	public static var MAX_REGISTERS:Int = 1000;

	public var registers:Vector<Bool>;

	public var curReg:Int = 0;
	public var src:String;

	public var variables:Map<String, {
		reg:Int,
		mutable:Bool
	}>;

	public function new(src:String) {
		this.src = src;
		registers = new Vector(MAX_REGISTERS, false);
	}

	public function allocateRegister(e:Expr):Int {
		if (registers[curReg]) {
			throw CompilerError.compilerError("Register " + curReg + " is already allocated.", e, src);
		}

		registers[curReg] = true;
		return curReg++;
	}

	public function freeRegister(e:Expr, ?reg:Int) {
		var reg:Int = reg ?? --curReg;
		if (!registers[reg])
			throw CompilerError.compilerError("Register " + curReg + " is already free.", e, src);

		registers[reg] = false;
	}

	public function allocateVariable(e:Expr, reg:Int, v:String, mut:Bool):Int {
		if (variables.exists(v)) {
			var v = variables.get(v);
			if (!v.mutable)
				return v.reg = reg;
			else
				throw CompilerError.compilerError('Variable $v is immutable.', e, src);
		}

		var variable = {
			reg: reg,
			mutable: mut
		}

		variables.set(v, variable);

		return variable.reg;
	}
}
