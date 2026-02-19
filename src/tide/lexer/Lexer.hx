package tide.lexer;

import tide.lexer.Token.TokenData;

class Lexer {
	public var src:String;

	private var pos:Int;
	private var linePos:Int;
	private var line:Int;

	public function new(src:String) {
		this.src = src;

		pos = 0;
		linePos = 0;
		line = 1;
	}

	public function next():Token {
		if (pos >= src.length)
			return makeToken(linePos, linePos, line, TEof);

		switch (peek()) {
			case " ", "\r", "\t":
				advance();
				return next();
			case "\n":
				advance();
				linePos = 0;
				line++;
				return next();
			case "(":
				advance();
				return makeToken(linePos, linePos, line, TLeftParen);
			case ")":
				advance();
				return makeToken(linePos, linePos, line, TRightParen);
			case "{":
				advance();
				return makeToken(linePos, linePos, line, TLeftCurly);
			case "}":
				advance();
				return makeToken(linePos, linePos, line, TRightCurly);
			case "[":
				advance();
				return makeToken(linePos, linePos, line, TLeftSquare);
			case "]":
				advance();
				return makeToken(linePos, linePos, line, TRightSquare);
			case ".":
				advance();
				var start:Int = linePos;

				if (peek() == ".") {
					advance();
					if (peek() == "=") {
						advance();
						return makeToken(start, linePos, line, TOp("..="));
					}
					return makeToken(start, linePos, line, TOp(".."));
				}

				return makeToken(start, linePos, line, TDot);
			case ":":
				advance();
				return makeToken(linePos, linePos, line, TColon);
			case ";":
				advance();
				return makeToken(linePos, linePos, line, TSemiColon);
			case ",":
				advance();
				return makeToken(linePos, linePos, line, TComma);
			case "+":
				advance();
				var start:Int = linePos;
				if (peek() == "=") {
					advance();
					return makeToken(start, linePos, line, TOp("+="));
				} else if (peek() == "+") {
					advance();
					return makeToken(start, linePos, line, TOp("++"));
				}
				return makeToken(start, linePos, line, TOp("+"));
			case "-":
				advance();
				var start:Int = linePos;
				if (peek() == ">") {
					advance();
					return makeToken(start, linePos, line, TOp("->"));
				} else if (peek() == "=") {
					advance();
					return makeToken(start, linePos, line, TOp("-="));
				} else if (peek() == "-") {
					advance();
					return makeToken(start, linePos, line, TOp("--"));
				}
				return makeToken(start, linePos, line, TOp("-"));
			case "*":
				advance();
				var start:Int = linePos;
				if (peek() == "=") {
					advance();
					return makeToken(start, linePos, line, TOp("*="));
				} else if (peek() == "*") {
					advance();
					if (peek() == "=") {
						advance();
						return makeToken(start, linePos, line, TOp("**="));
					}
					return makeToken(start, linePos, line, TOp("**"));
				}
				return makeToken(start, linePos, line, TOp("*"));
			case "/":
				advance();
				var start:Int = linePos;
				if (peek() == "=") {
					advance();
					return makeToken(start, linePos, line, TOp("/="));
				}
				return makeToken(start, linePos, line, TOp("/"));
			case "=":
				advance();
				var start:Int = linePos;
				if (peek() == "=") {
					advance();
					return makeToken(start, linePos, line, TOp("=="));
				}
				return makeToken(start, linePos, line, TOp("="));
			case "!":
				advance();
				var start:Int = linePos;
				if (peek() == "=") {
					advance();
					return makeToken(start, linePos, line, TOp("!="));
				}
				return makeToken(start, linePos, line, TOp("!"));
			case "|":
				advance();
				var start:Int = linePos;
				if (peek() == "=") {
					advance();
					return makeToken(start, linePos, line, TOp("|="));
				} else if (peek() == "|") {
					advance();
					return makeToken(start, linePos, line, TOp("||"));
				}
				return makeToken(start, linePos, line, TOp("|"));

			case "<":
				advance();
				var start:Int = linePos;
				if (peek() == "=") {
					advance();
					return makeToken(start, linePos, line, TOp("<="));
				} else if (peek() == "<") {
					advance();
					if (peek() == "=") {
						advance();
						return makeToken(start, linePos, line, TOp("<<="));
					}
					return makeToken(start, linePos, line, TOp("<<"));
				}
				return makeToken(start, linePos, line, TOp("<"));
			case ">":
				advance();
				var start:Int = linePos;
				if (peek() == "=") {
					advance();
					return makeToken(start, linePos, line, TOp(">="));
				} else if (peek() == ">") {
					advance();
					if (peek() == "=") {
						advance();
						return makeToken(start, linePos, line, TOp(">>="));
					}
					return makeToken(start, linePos, line, TOp(">>"));
				}
				return makeToken(start, linePos, line, TOp(">"));
			case '?':
				advance();
				var start:Int = linePos;
				if (peek() == "?") {
					advance();
					return makeToken(start, linePos, line, TOp("??"));
				} else if (peek() == ".") {
					advance();
					return makeToken(start, linePos, line, TOp("?."));
				}
				return makeToken(start, linePos, line, TQuestionMark);
			case '"':
				advance();
				var start:Int = linePos;
				var str:String = "";
				while (peek() != '"')
					str += advance();

				advance();

				return makeToken(start, linePos, line, TString(str));
		}

		if (isNum(peek())) {
			var num:String = advance();
			var start:Int = linePos;
			var isFloat:Bool = false;
			var isHex:Bool = false;

			while (true) {
				if (!isHex && !isFloat && (peek() == "x")) {
					num += advance();
					isHex = true;
				}

				if (!isHex && !isFloat && peek() == ".") {
					isFloat = true;
					num += advance();
				}

				if (peek() == "_" && !isFloat && !isHex) {
					advance();
				}

				if (!isHex) {
					if (!isNum(peek()))
						break;
				} else {
					if (!isHexa(peek()))
						break;
				}

				num += advance();
			}

			return makeToken(start, linePos, pos, isFloat ? TFloat(Std.parseFloat(num)) : TInt(Std.parseInt(num)));
		} else if (isAlpha(peek())) {
			var id:String = advance();
			var start:Int = linePos;

			while (isAlpha(peek()))
				id += advance();

			return makeToken(start, linePos, line, TIdentifier(id));
		}

		throw new LexerError(linePos, line, src);
	}

	private inline function makeToken(startPos:Int, endPos:Int, line:Int, data:TokenData):Token
		return {
			start: startPos,
			end: endPos,
			line: line,
			data: data
		}

	private inline function isNum(c:String):Bool
		return c >= "0" && c <= "9";

	private inline function isHexa(c:String):Bool
		return c >= "0" && c <= "9" || c >= "a" && c <= "f" || c >= "A" && c <= "F";

	private inline function isAlpha(c:String):Bool
		return c >= "a" && c <= "z" || c >= "A" && c <= "Z" || c == "_";

	private inline function advance():String {
		linePos++;
		return src.charAt(pos++);
	}

	private inline function peek(?offset:Int = 0):String
		return src.charAt(pos + offset);

	public static function tokenToString(tok:Token, ?spaces:Int = 0):String {
		var buf:StringBuf = new StringBuf();

		function applySpaces(?plus:Int = 0):String {
			var str:String = "";

			for (i in 0...spaces + plus)
				str += " ";

			return str;
		}

		function add(str:String, ?plus:Int = 0) {
			buf.add(applySpaces(plus) + str);
		}

		add("{\n");
		add('Start Pos: ${tok.start}\n', 4);
		add('End Pos: ${tok.end}\n', 4);
		add('Line: ${tok.line}\n', 4);
		add('Data: ${tokenDataToString(tok.data)}\n', 4);
		add("}");

		return buf.toString();
	}

	public static function tokenDataToString(tok:TokenData):String {
		switch (tok) {
			case TIdentifier(id):
				return 'Identifier($id)';
			case TInt(i):
				return 'Integer($i)';
			case TFloat(f):
				return 'Float($f)';
			case TString(s):
				return 'String($s)';
			case TOp(op):
				return 'Operator($op)';
			case TLeftParen:
				return '(';
			case TRightParen:
				return ')';
			case TLeftCurly:
				return '{';
			case TRightCurly:
				return '}';
			case TColon:
				return ':';
			case TDot:
				return '.';
			case TSemiColon:
				return ';';
			case TEof:
				return '<eof>';
			case TLeftSquare:
				return '[';
			case TRightSquare:
				return ']';
			case TQuestionMark:
				return '?';
			case TComma:
				return ',';
		}
	}
}
