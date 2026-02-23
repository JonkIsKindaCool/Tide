package tide.vm;

import tide.std.primitives.TideNull;
import tide.std.primitives.TideBool;
import tide.std.primitives.TideInt;
import tide.std.TideValue;
import haxe.zip.Reader;
import tide.std.TideInstance;
import tide.utils.ValueUtils;
import tide.compiler.Instruction;
import tide.compiler.Allocator;
import tide.compiler.Program;
import haxe.ds.Vector;

class VM {
	public var registers:Vector<TideValue>;

	private var pc:Int = 0;
	private var instructions:Array<Instruction>;
	private var constantPool:Array<Values>;

	public function new() {}

	public function eval(p:Program):TideValue {
		pc = 0;
		instructions = p.instructions;
		constantPool = p.constantPool;
		registers = new Vector(Allocator.MAX_REGISTERS, null);

		while (pc < instructions.length) {
			try {
				executeInstruction(getInstruction());
			} catch (e:Enders){
				switch (e){
					case RETURN(e):
						return registers[e];
				}
			}
		}

		return new TideNull();
	}

	private function executeInstruction(i:Instruction) {
		switch (i) {
			case LOAD_K:
				registers[getInstruction()] = ValueUtils.valueToInstance(getConstant());
			case LOAD_ID:
			case TRUE:
				registers[getInstruction()] = new TideBool(true);
			case FALSE:
				registers[getInstruction()] = new TideBool(false);
			case RETURN:
				throw Enders.RETURN(getInstruction());
			case SUM:
				binop("__sum__");
			case SUBTRACT:
				binop("__sub__");
			case MULTIPLY:
				binop("__mul__");
			case DIVIDE:
				binop("__div__");
			case MOD:
				binop("__mod__");
			case POW:
				binop("__pow__");

			case EQ:
				binop("__eq__");
			case NEQ:
				binop("__neq__");
			case LT:
				binop("__lt__");
			case GT:
				binop("__gt__");
			case LTE:
				binop("__lte__");
			case GTE:
				binop("__gte__");

			case AND:
				binop("__and__");
			case OR:
				binop("__or__");
			case NOT:
				var src:TideValue = registers[getInstruction()];
				var t:Int = getInstruction();
				registers.set(t, _callFunction_(src.getVariable("__not__"), []));

			case NULLISH:
				binop("__nullish__");

			case RANGE:
				binop("__range__");
			case RANGE_INC:
				binop("__range_inc__");

			case SHL:
				binop("__shl__");
			case SHR:
				binop("__shr__");
		}
	}

	inline function binop(method:String) {
		var l:TideValue = registers[getInstruction()];
		var r:TideValue = registers[getInstruction()];
		var t:Int = getInstruction();
		trace(l, r, t);
		registers.set(t, _callFunction_(l.getVariable(method), [r]));
	}

	private inline function _callFunction_(v:TideValue, args:Array<TideValue>):TideValue {
		if (v.name == "Callable")
			return cast(v, TideBaseFunction).call(args);

		return null;
	}

	private inline function getInstruction()
		return instructions[pc++];

	private inline function getConstant():Values
		return constantPool[getInstruction()];
}

private enum Enders {
	RETURN(e:Int);	
}