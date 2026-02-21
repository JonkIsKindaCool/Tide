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
    trace(compiler.compile(ast));
}