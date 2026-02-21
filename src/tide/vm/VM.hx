package tide.vm;

import haxe.zip.Reader;
import tide.std.TideInstance;
import tide.utils.ValueUtils;
import tide.compiler.Instruction;
import tide.compiler.Allocator;
import tide.compiler.Program;
import haxe.ds.Vector;

class VM {
    public var registers:Vector<Values>;
    private var pc:Int = 0;
    private var instructions:Array<Instruction>;
    private var constantPool:Array<Values>;

    public function new() {
        
    }

    public function eval(p:Program) {
        pc = 0;
        instructions = p.instructions;
        constantPool = p.constantPool;
        registers = new Vector(Allocator.MAX_REGISTERS, null);

        while (pc < instructions.length){
            executeInstruction(getInstruction());
        }
    }

    private function executeInstruction(i:Instruction) {
        switch (i){
            case LOAD_K:
                registers[getInstruction()] = Values.VInstance(ValueUtils.valueToInstance(getConstant()));
            case SUM:
                var l:Int = getInstruction();
                var r:Int = getInstruction();
                var t:Int = getInstruction();
                registers[t] = _callFunction_(ValueUtils.valueToInstance(registers[l]).getVariable("__sum__"), [registers[r]]);
            case SUBTRACT:
            case DIVIDE:
            case MULTIPLY:
        }
    }
    
    private inline function _callFunction_(v:Values, args:Array<Values>):Values {
        switch (v){
            case VHxFunction(v):
                return v(args);
            case _:
                throw 'Expected Callable, got ${ValueUtils.valueName(v)}';
        }
    }

    private inline function getInstruction()
        return instructions[pc++];

    private inline function getConstant():Values 
        return constantPool[getInstruction()];
}