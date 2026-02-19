package tide.utils;

import tide.lexer.Lexer;
import tide.lexer.Token;

class Printer {
    public static function printToken(tok:Token) {
        Sys.println(Lexer.tokenToString(tok));
    }
}