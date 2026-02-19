import tide.utils.Printer;
import tide.lexer.Token;
import tide.lexer.Lexer;
import haxe.Resource;

function main() {
    var resource:String = Resource.getString("test.td");
    
    var lex:Lexer = new Lexer(resource);
    while (true){
        var tok:Token = lex.next();
        Printer.printToken(tok);
        if (tok.data.equals(TEof))
            break;
    }
}