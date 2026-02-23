package tide.std.primitives;

import tide.vm.VM;
import tide.compiler.Program;
import tide.parser.Expr.Type;
import tide.std.TideValue.TideBaseFunction;

class TideCallable extends TideBaseFunction {
	public var program:Program;

	public function new(args:Array<Type>, ret:Type, p:Program) {
		super(args, ret);
		this.program = p;
	}

	override function call(args:Array<TideValue>):TideValue {
		var vm:VM = new VM();
		vm.eval(program);
		return null;
	}
}

class TideHxFunction extends TideBaseFunction {
	public var f:(args:Array<TideValue>) -> TideValue;

	public function new(f:(args:Array<TideValue>) -> TideValue) {
		super(null, null);
        this.f = f;
	}

	override function call(args:Array<TideValue>):TideValue {
		return f(args);
	}
}
