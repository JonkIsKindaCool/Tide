package tide.std.primitives;

import tide.utils.ValueUtils;
import tide.vm.Values;

class TideIntClass extends TideClass {
	public function new() {
		super("Int");
	}

	override function createInstance(args:Array<Values>):TideInstance {
		return super.createInstance(args);
	}
}

class TideIntInstance extends TideInstance {
	public var value:Int;

	public function new(args:Array<Values>) {
		super("Int", args);
        value = ValueUtils.expectInt(args[0]);
	}

	override function getVariable(v:String):Values {
		switch (v) {
			case "value":
				return VInt(value);
			case "__sum__":
				return VHxFunction(args -> {
					var r:Values = args[0];

					switch (r) {
						case VInt(i):
							return VInt(value + i);
						case VInstance(i):
							if (i.name == "Int") return VInt(value + cast (i, TideIntInstance).value);
						case _:
					}
					throw 'Incompatible sum';
				});
		}
		return super.getVariable(v);
	}
}
