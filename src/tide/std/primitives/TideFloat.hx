package tide.std.primitives;

import tide.std.primitives.TideCallable.TideHxFunction;
import tide.utils.ValueUtils;
import tide.vm.Values;

class TideFloat extends TideInstance {
	public var value:Float;

	public function new(f:Float) {
		super("Float", []);
		value = f;
	}

	override function getVariable(v:String):TideValue {
		switch (v) {
			case "__sum__":
				return new TideHxFunction((args) -> switch (args[0].name) {
					case "Float": new TideFloat(value + cast(args[0], TideFloat).value);
					case "Int": new TideFloat(value + cast(args[0], TideInt).value);
					default: throw 'Unsupported type for +';
				});

			case "__sub__":
				return new TideHxFunction((args) -> switch (args[0].name) {
					case "Float": new TideFloat(value - cast(args[0], TideFloat).value);
					case "Int": new TideFloat(value - cast(args[0], TideInt).value);
					default: throw 'Unsupported type for -';
				});

			case "__mul__":
				return new TideHxFunction((args) -> switch (args[0].name) {
					case "Float": new TideFloat(value * cast(args[0], TideFloat).value);
					case "Int": new TideFloat(value * cast(args[0], TideInt).value);
					default: throw 'Unsupported type for *';
				});

			case "__div__":
				return new TideHxFunction((args) -> switch (args[0].name) {
					case "Float":
						var rhs = cast(args[0], TideFloat).value;
						if (rhs == 0.0)
							throw 'Division by zero';
						new TideFloat(value / rhs);
					case "Int":
						var rhs:Float = cast(args[0], TideInt).value;
						if (rhs == 0.0)
							throw 'Division by zero';
						new TideFloat(value / rhs);
					default: throw 'Unsupported type for /';
				});

			case "__mod__":
				return new TideHxFunction((args) -> switch (args[0].name) {
					case "Float":
						var rhs = cast(args[0], TideFloat).value;
						if (rhs == 0.0)
							throw 'Modulo by zero';
						new TideFloat(value % rhs);
					case "Int":
						var rhs:Float = cast(args[0], TideInt).value;
						if (rhs == 0.0)
							throw 'Modulo by zero';
						new TideFloat(value % rhs);
					default: throw 'Unsupported type for %';
				});

			case "__pow__":
				return new TideHxFunction((args) -> switch (args[0].name) {
					case "Float": new TideFloat(Math.pow(value, cast(args[0], TideFloat).value));
					case "Int": new TideFloat(Math.pow(value, cast(args[0], TideInt).value));
					default: throw 'Unsupported type for **';
				});

			case "__eq__":
				return new TideHxFunction((args) -> switch (args[0].name) {
					case "Float": new TideBool(value == cast(args[0], TideFloat).value);
					case "Int": new TideBool(value == cast(args[0], TideInt).value);
					default: new TideBool(false);
				});

			case "__neq__":
				return new TideHxFunction((args) -> switch (args[0].name) {
					case "Float": new TideBool(value != cast(args[0], TideFloat).value);
					case "Int": new TideBool(value != cast(args[0], TideInt).value);
					default: new TideBool(true);
				});

			case "__lt__":
				return new TideHxFunction((args) -> switch (args[0].name) {
					case "Float": new TideBool(value < cast(args[0], TideFloat).value);
					case "Int": new TideBool(value < cast(args[0], TideInt).value);
					default: throw 'Unsupported type for <';
				});

			case "__gt__":
				return new TideHxFunction((args) -> switch (args[0].name) {
					case "Float": new TideBool(value > cast(args[0], TideFloat).value);
					case "Int": new TideBool(value > cast(args[0], TideInt).value);
					default: throw 'Unsupported type for >';
				});

			case "__lte__":
				return new TideHxFunction((args) -> switch (args[0].name) {
					case "Float": new TideBool(value <= cast(args[0], TideFloat).value);
					case "Int": new TideBool(value <= cast(args[0], TideInt).value);
					default: throw 'Unsupported type for <=';
				});

			case "__gte__":
				return new TideHxFunction((args) -> switch (args[0].name) {
					case "Float": new TideBool(value >= cast(args[0], TideFloat).value);
					case "Int": new TideBool(value >= cast(args[0], TideInt).value);
					default: throw 'Unsupported type for >=';
				});

			case "__and__":
				return new TideHxFunction((args) -> switch (args[0].name) {
					case "Float": new TideBool(value != 0.0 && cast(args[0], TideFloat).value != 0.0);
					case "Bool": new TideBool(value != 0.0 && cast(args[0], TideBool).value);
					default: throw 'Unsupported type for &&';
				});

			case "__or__":
				return new TideHxFunction((args) -> switch (args[0].name) {
					case "Float": new TideBool(value != 0.0 || cast(args[0], TideFloat).value != 0.0);
					case "Bool": new TideBool(value != 0.0 || cast(args[0], TideBool).value);
					default: throw 'Unsupported type for ||';
				});

			case "__not__":
				return new TideHxFunction((_) -> new TideBool(value == 0.0));

			case "__nullish__":
				return new TideHxFunction((_) -> this);

			case "__shl__":
				return new TideHxFunction((args) -> switch (args[0].name) {
					case "Int": new TideInt(Std.int(value) << cast(args[0], TideInt).value);
					default: throw 'Unsupported type for <<';
				});

			case "__shr__":
				return new TideHxFunction((args) -> switch (args[0].name) {
					case "Int": new TideInt(Std.int(value) >> cast(args[0], TideInt).value);
					default: throw 'Unsupported type for >>';
				});

			case "__to_Int__":
				return new TideHxFunction((_) -> new TideInt(Std.int(value)));

			case "__to_Bool__":
				return new TideHxFunction((_) -> new TideBool(value != 0.0));

			case "__to_String__":
				return new TideHxFunction((_) -> new TideString(Std.string(value)));
		}

		return super.getVariable(v);
	}

	public function toString():String {
		return Std.string(value);
	}
}
