package tide.std.primitives;

import tide.std.primitives.TideCallable.TideHxFunction;
import tide.vm.Values;

class TideString extends TideInstance {
	public var value:String;

	public function new(v:String) {
		super("String", []);
		this.value = v;
	}

	override function getVariable(v:String):TideValue {
		switch (v) {
			case "__sum__":
				return new TideHxFunction((args) -> switch (args[0].name) {
					case "String": new TideString(value + cast(args[0], TideString).value);
					case "Int": new TideString(value + cast(args[0], TideInt).value);
					case "Float": new TideString(value + cast(args[0], TideFloat).value);
					case "Bool": new TideString(value + cast(args[0], TideBool).value);
					default: throw 'Unsupported type for String +';
				});

			case "__mul__":
				return new TideHxFunction((args) -> switch (args[0].name) {
					case "Int":
						var n = cast(args[0], TideInt).value;
						if (n < 0)
							throw 'String repetition count must be >= 0';
						var buf = new StringBuf();
						for (_ in 0...n)
							buf.add(value);
						new TideString(buf.toString());
					default: throw 'Unsupported type for String *';
				});

			case "__eq__":
				return new TideHxFunction((args) -> switch (args[0].name) {
					case "String": new TideBool(value == cast(args[0], TideString).value);
					default: new TideBool(false);
				});

			case "__neq__":
				return new TideHxFunction((args) -> switch (args[0].name) {
					case "String": new TideBool(value != cast(args[0], TideString).value);
					default: new TideBool(true);
				});

			case "__lt__":
				return new TideHxFunction((args) -> switch (args[0].name) {
					case "String": new TideBool(value < cast(args[0], TideString).value);
					default: throw 'Unsupported type for String <';
				});

			case "__gt__":
				return new TideHxFunction((args) -> switch (args[0].name) {
					case "String": new TideBool(value > cast(args[0], TideString).value);
					default: throw 'Unsupported type for String >';
				});

			case "__lte__":
				return new TideHxFunction((args) -> switch (args[0].name) {
					case "String": new TideBool(value <= cast(args[0], TideString).value);
					default: throw 'Unsupported type for String <=';
				});

			case "__gte__":
				return new TideHxFunction((args) -> switch (args[0].name) {
					case "String": new TideBool(value >= cast(args[0], TideString).value);
					default: throw 'Unsupported type for String >=';
				});

			case "__not__":
				return new TideHxFunction((_) -> new TideBool(value == ""));

			case "__and__":
				return new TideHxFunction((args) -> switch (args[0].name) {
					case "String": new TideBool(value != "" && cast(args[0], TideString).value != "");
					case "Bool": new TideBool(value != "" && cast(args[0], TideBool).value);
					default: throw 'Unsupported type for String &&';
				});

			case "__or__":
				return new TideHxFunction((args) -> switch (args[0].name) {
					case "String": new TideBool(value != "" || cast(args[0], TideString).value != "");
					case "Bool": new TideBool(value != "" || cast(args[0], TideBool).value);
					default: throw 'Unsupported type for String ||';
				});

			case "__nullish__":
				return new TideHxFunction((_) -> this);

			case "__to_String__":
				return new TideHxFunction((_) -> this);
		}

		return super.getVariable(v);
	}

	public function toString():String {
		return value;
	}
}
