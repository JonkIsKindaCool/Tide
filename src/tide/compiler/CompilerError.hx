package tide.compiler;

import tide.parser.Expr;
import haxe.Exception;

class CompilerError extends Exception {
	public static var shouldCrash:Bool = true;

	public function new(msg:String) {
		if (shouldCrash) {
			Sys.println(msg);
			Sys.exit(0);
		}

		super(msg);
	}

	static function underlineExpr(e:Expr, src:String):String {
		var buf:StringBuf = new StringBuf();
		var lines:Array<String> = src.split("\n");

		if (e.startLine == e.endLine) {
			var line = lines[e.startLine - 1];
			buf.add('$line\n');
			for (i in 0...e.start - 1)
				buf.add(" ");
			for (i in 0...e.end + 1 - e.start)
				buf.add("^");
			buf.add("\n");
		} else {
			for (l in e.startLine...e.endLine + 1) {
				var line = lines[l - 1];
				buf.add('$line\n');

				var lineStart = (l == e.startLine) ? e.start - 1 : 0;
				var lineEnd = (l == e.endLine) ? e.end : line.length;

				for (i in 0...lineStart)
					buf.add(" ");
				for (i in lineStart...lineEnd)
					buf.add("^");
				buf.add("\n");
			}
		}

		return buf.toString();
	}

	public static function compilerError(msg:String, e:Expr, src:String):CompilerError {
		var buf:StringBuf = new StringBuf();
		buf.add("==== COMPILER ERROR ====\n");
		buf.add('$msg\n\n');
		buf.add(underlineExpr(e, src));
		return new CompilerError(buf.toString());
	}
	public static function typeError(expected:String, got:String, e:Expr, src:String):CompilerError {
		var buf:StringBuf = new StringBuf();
		buf.add("==== TYPE ERROR ====\n");
		buf.add('Expected type "$expected", got "$got"\n\n');
		buf.add(underlineExpr(e, src));
		return new CompilerError(buf.toString());
	}

	public static function unexpected(e:Expr, src:String):CompilerError {
		var buf:StringBuf = new StringBuf();
		buf.add("==== COMPILER ERROR ====\n");
		buf.add('Unexpected expression\n\n');
		buf.add(underlineExpr(e, src));
		return new CompilerError(buf.toString());
	}
}
