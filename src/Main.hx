import tide.parser.Parser;
import tide.utils.Printer;
import tide.lexer.Token;
import tide.lexer.Lexer;
import haxe.Resource;

function main() {
    var resource:String = Resource.getString("test.td");
    var parser:Parser = new Parser(resource);

    Printer.printExpr(parser.parse());
}