package tide.compiler;

enum abstract Instruction(Int) from Int to Int {
    var LOAD_K;
    var LOAD_ID;

    var TRUE;
    var FALSE;

    var RETURN;

    var SUM;
    var SUBTRACT;
    var MULTIPLY;
    var DIVIDE;
    var MOD;
    var POW;

    var EQ;
    var NEQ;
    var LT;
    var GT;
    var LTE;
    var GTE;

    var AND;
    var OR;
    var NOT;      

    var NULLISH;   

    var RANGE;      
    var RANGE_INC;  

    var SHL;
    var SHR;
}