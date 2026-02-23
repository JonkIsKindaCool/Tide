package tide.std;

import tide.parser.Expr.Type;

interface TideValue {
	public var name:String;

	public function getVariable(v:String):TideValue;

	public function setVariable(v:String, v:TideValue):TideValue;
}

class TideBaseFunction extends TideInstance {
	public var args:Array<Type>;
	public var ret:Type;

	public function new(args:Array<Type>, ret:Type) {
		super("Callable", []);
		this.args = args;
		this.ret = ret;
	}

	public function call(args:Array<TideValue>):TideValue {
		throw new haxe.exceptions.NotImplementedException();
	}

	override function getVariable(v:String):TideValue {
		return super.getVariable(v);
	}

	override function setVariable(n:String, v:TideValue):TideValue {
		return super.setVariable(n, v);
	}
}
