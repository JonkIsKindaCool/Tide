package tide.compiler;

enum abstract Instruction(Int) from Int to Int {
    var LOAD_K;
    var SUM;
    var SUBTRACT;
    var MULTIPLY;
    var DIVIDE;
}