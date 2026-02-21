package tide.compiler;

import tide.vm.Values;
import tide.compiler.Instruction;

typedef Program = {
    instructions:Array<Instruction>,
    constantPool:Array<Values>
} 