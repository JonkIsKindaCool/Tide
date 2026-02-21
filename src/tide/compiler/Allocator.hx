package tide.compiler;

import haxe.ds.Vector;

class Allocator {
	public static var MAX_REGISTERS:Int = 1000;

	public var registers:Vector<Bool>;

	private var curReg:Int = 0;

	public function new() {
		registers = new Vector(MAX_REGISTERS, false);
	}

	public function allocateRegister():Int {
		if (registers[curReg]) {
			throw "Register " + curReg + " is already allocated.";
		}

        registers[curReg] = true;
		return curReg++;
	}

	public function freeRegister(?reg:Int) {
		var reg:Int = reg ?? --curReg;
		if (!registers[reg])
			throw "Register " + curReg + " is already free.";

        registers[reg] = false;
	}
}
