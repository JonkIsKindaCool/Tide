package tide.parser;

import tide.parser.Expr.Type;
import tide.parser.Expr.VariableDef;
import tide.lexer.Token;
import tide.parser.Expr.ExprData;
import tide.lexer.Lexer;

class Parser {
	public var lexer:Lexer;

	public function new(src:String) {
		lexer = new Lexer(src);
	}

	public function parse():Expr {
		var block:Array<Expr> = [];

		while (!lexer.maybe(TEof)) {
			block.push(parseDeclaration());
		}

		return makeExpr(0, lexer.src.split("\n").pop().length, 0, lexer.src.split("\n").length - 1, EBlock(block));
	}

	private function parseDeclaration():Expr {
		return parseStatements();
	}

	private function parseStatements():Expr {
		var start:Token = lexer.peekToken();
		switch (start.data) {
			case TIdentifier("fn"):
				lexer.next();
				var name:String = expectIdentifier();
				var type:Type = {
					name: "Any",
					generic: []
				};
				var args:Array<VariableDef> = [];
				expect(TLeftParen);
				while (true) {
					if (lexer.maybe(TRightParen))
						break;

					var name:String = expectIdentifier();
					var type:Type = {
						name: "Any",
						generic: []
					};

					if (lexer.maybe(TColon)) {
						type = parseType();
					}

					args.push({name: name, type: type, mutable: true});

					if (!lexer.maybe(TComma)) {
						expect(TRightParen);
						break;
					}
				}

				if (lexer.maybe(TOp("->"))) {
					type = parseType();
				}

				var body:Expr = parseBlock();

				return makeExpr(start.start, body.end, start.line, body.endLine, EFunction(body, args, type, name));
			case TIdentifier("let"):
				lexer.next();
				var name:String = expectIdentifier();
				var type:Type = {
					name: "Any",
					generic: []
				};
				if (lexer.maybe(TColon)) {
					type = parseType();
				}

				expect(TOp("="));

				var expr:Expr = parseStatements();
				return makeExpr(start.start, expr.end, start.line, expr.endLine, EVar(name, type, expr, false));
			case TIdentifier("mut"):
				lexer.next();
				var name:String = expectIdentifier();
				var last:Token = lexer.peekToken();
				var type:Type = {
					name: "Any",
					generic: []
				};
				if (lexer.maybe(TColon)) {
					type = parseType();
				}
				var expr:Expr = makeExprByToken(last, EId("null"));

				if (lexer.maybe(TOp("="))) {
					expr = parseStatements();
				}

				return makeExpr(start.start, expr.end, start.line, expr.endLine, EVar(name, type, expr, true));
			case TIdentifier("if"):
				lexer.next();
				var cond:Expr = parseExpressions();
				var b:Expr = parseBlock();
				var e:Expr = null;

				switch (lexer.peekToken().data) {
					case TIdentifier("else"):
						lexer.next();
						e = parseBlock();
					case _:
				}

				return makeExpr(start.start, b.end, start.line, b.endLine, EIf(cond, b, e));
			case TIdentifier("return"):
				lexer.next();
				var expr:Expr = parseExpressions();
				return makeExpr(start.start, expr.end, start.line, expr.endLine, EReturn(expr));
			case _:
				return parseExpressions();
		}
	}

	private function parseExpressions() {
		return parseAssign();
	}

	private function parseAssign():Expr {
		var left:Expr = parseOr();
		switch (lexer.peekToken().data) {
			case TOp("="), TOp("+="), TOp("-="), TOp("/="), TOp("*="), TOp("**="):
				var op:String = lexer.next().data.getParameters()[0];
				var right:Expr = parseAssign();
				return makeExpr(left.start, right.end, left.startLine, right.endLine, EBinop(left, right, op));
			case _:
				return left;
		}
	}

	private function parseOr():Expr {
		var left:Expr = parseAnd();
		switch (lexer.peekToken().data) {
			case TOp("||"):
				var op:String = lexer.next().data.getParameters()[0];
				var right:Expr = parseOr();
				return makeExpr(left.start, right.end, left.startLine, right.endLine, EBinop(left, right, op));
			case _:
				return left;
		}
	}

	private function parseAnd():Expr {
		var left:Expr = parseEquality();
		switch (lexer.peekToken().data) {
			case TOp("&&"):
				var op:String = lexer.next().data.getParameters()[0];
				var right:Expr = parseAnd();
				return makeExpr(left.start, right.end, left.startLine, right.endLine, EBinop(left, right, op));
			case _:
				return left;
		}
	}

	private function parseEquality():Expr {
		var left:Expr = parseComparison();
		switch (lexer.peekToken().data) {
			case TOp("!="), TOp("=="):
				var op:String = lexer.next().data.getParameters()[0];
				var right:Expr = parseEquality();
				return makeExpr(left.start, right.end, left.startLine, right.endLine, EBinop(left, right, op));
			case _:
				return left;
		}
	}

	private function parseComparison():Expr {
		var left:Expr = parseAddition();
		switch (lexer.peekToken().data) {
			case TOp("<"), TOp(">"), TOp("<="), TOp(">="):
				var op:String = lexer.next().data.getParameters()[0];
				var right:Expr = parseComparison();
				return makeExpr(left.start, right.end, left.startLine, right.endLine, EBinop(left, right, op));
			case _:
				return left;
		}
	}

	private function parseAddition():Expr {
		var left:Expr = parseMultiplicative();
		switch (lexer.peekToken().data) {
			case TOp("+"), TOp("-"):
				var op:String = lexer.next().data.getParameters()[0];
				var right:Expr = parseAddition();
				return makeExpr(left.start, right.end, left.startLine, right.endLine, EBinop(left, right, op));
			case _:
				return left;
		}
	}

	private function parseMultiplicative():Expr {
		var left:Expr = parseExpo();
		switch (lexer.peekToken().data) {
			case TOp("*"), TOp("/"), TOp("%"):
				var op:String = lexer.next().data.getParameters()[0];
				var right:Expr = parseMultiplicative();
				return makeExpr(left.start, right.end, left.startLine, right.endLine, EBinop(left, right, op));
			case _:
				return left;
		}
	}

	private function parseExpo():Expr {
		var left:Expr = parsePrimitive();
		switch (lexer.peekToken().data) {
			case TOp("**"):
				var op:String = lexer.next().data.getParameters()[0];
				var right:Expr = parseExpo();
				return makeExpr(left.start, right.end, left.startLine, right.endLine, EBinop(left, right, op));
			case _:
				return left;
		}
	}

	private function parsePrimitive():Expr {
		final tok:Token = lexer.next();
		switch (tok.data) {
			case TInt(i):
				return (makeExprByToken(tok, EInt(i)));
			case TFloat(f):
				return (makeExprByToken(tok, EFloat(f)));
			case TString(s):
				return parsePost(makeExprByToken(tok, EString(s)));
			case TIdentifier("true"):
				return makeExprByToken(tok, EBool(true));
			case TIdentifier("false"):
				return makeExprByToken(tok, EBool(false));
			case TIdentifier(id):
				return parsePost(makeExprByToken(tok, EId(id)));
			case TLeftSquare:
				var v:Array<Expr> = [];
				while (true) {
					if (lexer.maybe(TRightSquare))
						break;

					v.push(parseExpressions());

					if (!lexer.maybe(TComma)) {
						expect(TRightSquare);
						break;
					}
				}
				return parsePost(makeExpr(tok.start, tok.end, tok.line, tok.line, EArray(v)));
			case TOp("|"):
				var args:Array<VariableDef> = [];
				while (true) {
					if (lexer.maybe(TOp("|")))
						break;

					var name:String = expectIdentifier();
					var type:Type = {
						name: "Any",
						generic: []
					};

					if (lexer.maybe(TColon)) {
						type = parseType();
					}

					args.push({name: name, type: type});

					if (!lexer.maybe(TComma)) {
						expect(TOp("|"));
						break;
					}
				}
				var body:Expr = parseExpressions();
				return makeExpr(tok.start, body.end, tok.line, body.endLine, ELambda(body, args));
			default:
				throw ParserError.unexpected(tok, lexer.src);
		}
	}

	private function parsePost(e:Expr):Expr {
		var start:Token = lexer.peekToken();
		switch (start.data) {
			case TLeftSquare:
				lexer.next();
				var i:Expr = parseExpressions();
				var end:Token = expect(TRightSquare);

				return parsePost(makeExpr(start.start, end.end, start.line, end.line, EAccess(e, i)));
			case TDot:
				lexer.next();
				var next:Token = lexer.peekToken();
				var f:String = expectIdentifier();
				return parsePost(makeExpr(start.start, next.end, start.line, next.line, EField(e, f)));
			case TLeftParen:
				var end:Token = lexer.next();
				var args:Array<Expr> = [];
				while (true) {
					if (lexer.maybe(TRightParen))
						break;

					args.push(parseExpressions());

					if (!lexer.maybe(TComma)) {
						expect(TRightParen);
						break;
					}
				}

				return parsePost(makeExpr(start.start, end.end, start.line, end.line, ECall(e, args)));
			case _:
				return e;
		}
	}

	private function parseBlock():Expr {
		var tok:Token = lexer.peekToken();
		if (lexer.maybe(TLeftCurly)) {
			var block:Array<Expr> = [];

			while (!lexer.maybe(TEof) && !lexer.maybe(TRightCurly)) {
				block.push(parseStatements());
			}

			return makeExpr(block[0]?.start ?? tok.start, block[block.length - 1]?.end ?? tok.end, block[0]?.startLine ?? tok.line,
				block[block.length - 1]?.endLine ?? tok.line, EBlock(block));
		} else {
			return parseStatements();
		}
	}

	private function parseType():Type {
		var t:Type = {
			name: expectIdentifier(),
			generic: []
		}

		if (lexer.maybe(TOp("<"))) {
			while (true) {
				if (lexer.maybe(TOp(">")))
					break;

				t.generic.push(parseType());

				if (!lexer.maybe(TComma)) {
					expect(TOp(">"));
					break;
				}
			}
		}

		return t;
	}

	private function expect(t:TokenData) {
		var tok:Token = lexer.next();
		if (!tok.data.equals(t))
			throw ParserError.expected(t, tok, lexer.src);

		return tok;
	}

	private function expectIdentifier():String {
		switch (lexer.peekToken().data) {
			case TIdentifier(id):
				lexer.next();
				return id;
			case _:
				throw ParserError.expected("Identifier", lexer.peekToken(), lexer.src);
		}
	}

	private static inline function makeExpr(start:Int, end:Int, startLine:Int, endLine:Int, data:ExprData):Expr {
		return {
			start: start,
			end: end,
			startLine: start,
			endLine: endLine,
			data: data
		}
	}

	private static inline function makeExprByToken(tok:Token, data:ExprData) {
		return makeExpr(tok.start, tok.end, tok.line, tok.line, data);
	}
}
