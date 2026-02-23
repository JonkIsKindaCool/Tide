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
		variables = new Map();
		registers = new Vector(MAX_REGISTERS, false);
	}

	private var pinned:Array<Int> = [];

	public function pin(reg:Int) {
		pinned.push(reg);
	}

	public function unpin(reg:Int) {
		pinned.remove(reg);
	}

	public function allocateRegister(e:Expr):Int {
		var r:Int = 0;
		while (registers[r] || pinned.contains(r))
			r++;

		trace("allocando registro:", r, "pinned:", pinned);

		registers[r] = true;
		curReg = r + 1;
		return r;
	}

	public function freeRegister(e:Expr, ?reg:Int) {
		var reg:Int = reg ?? --curReg;
		if (!registers[reg])
			throw CompilerError.compilerError("Register " + reg + " is already free.", e, src);

		registers[reg] = false;
		curReg = reg;
	}

	public function allocateVariable(e:Expr, reg:Int, v:String, mut:Bool):Int {
		if (variables.exists(v)) {
			var v = variables.get(v);
			if (v.mutable)
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

	public function getVariable(n:String) {
		return variables.get(n).reg;
	}
}
