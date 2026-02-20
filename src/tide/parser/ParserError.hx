package tide.parser;

import haxe.extern.EitherType;
import tide.utils.Printer;
import tide.lexer.Lexer;
import tide.lexer.Token;
import haxe.Exception;

class ParserError extends Exception {
	public static var shouldCrash:Bool = true;

	public function new(msg:String) {
		if (shouldCrash) {
			Sys.println(msg);
			Sys.exit(0);
		}

		super(msg);
	}

	public static function expected(tok:EitherType<String, TokenData>, got:Token, src:String):ParserError {
		var buf:StringBuf = new StringBuf();

		buf.add("==== SYNTAX ERROR ====\n");
		buf.add('Expected token $tok, got\n');
		buf.add(Printer.tokenToString(got));

		buf.add("\n");
		final line:String = src.split("\n")[got.line - 1];
		buf.add('$line\n');
		for (i in 0...got.start - 1)
			buf.add(" ");

		for (i in 0...got.end + 1 - got.start)
			buf.add("^");

		buf.add("\n");

		return new ParserError(buf.toString());
	}

	public static function unexpected(tok:Token, src:String):ParserError {
		var buf:StringBuf = new StringBuf();

		buf.add("==== SYNTAX ERROR ====\n");
		buf.add('Unexpected token\n');
		buf.add(Printer.tokenToString(tok));

		buf.add("\n");
		final line:String = src.split("\n")[tok.line - 1];
		buf.add("\n");
		buf.add('$line\n');
		for (i in 0...tok.start - 1)
			buf.add(" ");

		for (i in 0...tok.end + 1 - tok.start)
			buf.add("^");

		buf.add("\n");

		return new ParserError(buf.toString());
	}
}
