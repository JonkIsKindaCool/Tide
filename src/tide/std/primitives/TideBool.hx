package tide.std.primitives;

class TideBool extends TideInstance {
	public var value:Bool;

	public function new(v:Bool) {
		super("Bool", []);
		this.value = v;
	}

	public function toString():String {
		return Std.string(value);
	}
}
