import tide.vm.VM;
import tide.compiler.Program;
import tide.compiler.Compiler;
import tide.parser.Expr;
import tide.parser.Parser;
import tide.utils.Printer;
import tide.lexer.Token;
import tide.lexer.Lexer;
import haxe.Resource;

function main() {
    var resource:String = Resource.getString("test.td");
    var parser:Parser = new Parser(resource);

    var ast:Expr = parser.parse();
    var compiler:Compiler = new Compiler();
    var p:Program = compiler.compile(resource);
    trace(p);

    var vm:VM = new VM();
    vm.eval(p);

    trace(vm.registers);
}