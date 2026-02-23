package tide.utils;

import eval.luv.Dns.AddrInfoFlag;
import tide.parser.Expr;
import tide.lexer.Lexer;
import tide.lexer.Token;

class Printer {
	public static function printToken(tok:Token) {
		Sys.println(tokenToString(tok));
	}

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

	public static function printExpr(expr:Expr) {
		Sys.println(exprToString(expr));
	}

	public static function exprToString(expr:Expr, ?spaces:Int = 0) {
		function applySpaces(?plus:Int = 0):String {
			var str:String = "";

			for (i in 0...spaces + plus)
				str += " ";

			return str;
		}

		var buf:StringBuf = new StringBuf();
		function add(str:String, ?plus:Int = 0, ?apply:Bool = true) {
			buf.add((apply ? applySpaces(plus) : "") + str);
		}

		add("{\n");
		add('Start Position: ${expr.start}\n', 4);
		add('Start Line: ${expr.startLine}\n', 4);
		add('End Position: ${expr.end}\n', 4);
		add('End Line: ${expr.endLine}\n', 4);
		switch (expr.data) {
			case EId(id):
				add('Identifier: $id\n', 4);
			case EInt(i):
				add('Integer: $i\n', 4);
			case EBool(i):
				add('Bool: $i\n', 4);
			case EFloat(f):
				add('Float: $f\n', 4);
			case EString(s):
				add('String: $s\n', 4);
			case EBinop(l, r, op):
				add('Binop:\n', 4);
				add('Left:\n', 8);
				add(exprToString(l, spaces + 8), false);
				add('Right:\n', 8);
				add(exprToString(r, spaces + 8), false);
				add('Operator: $op\n', 8);
			case EBlock(b):
				add('Block:\n', 4);
				for (e in b)
					add(exprToString(e, spaces + 8), false);

			case EUnop(op, e, post):

			case EFunction(e, args, type, name):
				add('Function:\n', 4);
				add('Arguments: (\n', 8);
				for (arg in args)
					add('${arg.name}:${arg.type}\n', 12);
				add(")\n", 8);
				add('Name: $name\n', 8);
				add('Type: $type\n', 8);
				add('Body:\n', 8);
				add(exprToString(e, spaces + 8), false);
			case ELambda(e, args):
				add('Lambda:\n', 4);
				add('Arguments: (\n', 8);
				for (arg in args)
					add('${arg.name}:${arg.type}\n', 12);
				add(")\n", 8);
				add('Body:\n', 8);
				add(exprToString(e, spaces + 8), false);
			case EVar(name, type, e, mutable):
				add('Variable definition:\n', 4);
				add('Name: $name\n', 8);
				add('Type: $type\n', 8);
				add('Mutable: $mutable\n', 8);
				add('Value:\n', 8);
				add(exprToString(e, spaces + 8), false);
			case EIf(cond, val, e):
				add('If Statement:\n', 4);
				add('Condition:\n', 8);
				add(exprToString(cond, spaces + 8), false);
				add('Body:\n', 8);
				add(exprToString(val, spaces + 8), false);
				if (e != null) {
					add('Else Statement:\n', 8);
					add(exprToString(e, spaces + 8), false);
				}
			case EReturn(e):
				add('Return:\n', 4);
				add(exprToString(e, spaces + 8), false);

			case EField(v, f):
				add('Field:\n', 4);
				add('Target:\n', 8);
				add(exprToString(v, spaces + 8), false);
				add('Field: $f\n', 8);
			case EAccess(v, i):
				add('Access:\n', 4);
				add('Target:\n', 8);
				add(exprToString(v, spaces + 8), false);
				add('Index:\n', 8);
				add(exprToString(i, spaces + 8), false);
			case ECall(v, args):
				add('Function Call:\n', 4);
				add('Target:\n', 8);
				add(exprToString(v, spaces + 8), false);
				if (args.length > 0) {
					add('Arguments:\n', 8);
					for (a in args)
						add(exprToString(a, spaces + 12), false);
				}
			case EArray(v):
				add('Array:\n', 4);
				if (v.length > 0) {
					add('Values:\n', 8);
					for (a in v)
						add(exprToString(a, spaces + 12), false);
				}
		};
		add("}\n");

		return buf.toString();
	}
}
