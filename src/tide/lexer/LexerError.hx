package tide.lexer;

import haxe.Exception;

class LexerError extends Exception {
	public static var shouldCrash:Bool = true;

	public function new(linePos:Int, line:Int, src:String) {
		var messageBuf:StringBuf = new StringBuf();
		var lines:Array<String> = src.split("\n");
		var line:String = lines[line - 1];

		messageBuf.add("===== Lexer Error =====\n");
		messageBuf.add('Unexpected character ${line.charAt(linePos)} at line $linePos, position $linePos\n');

		messageBuf.add("\n");
		messageBuf.add(line + "\n");

		for (i in 0...linePos)
			messageBuf.add(" ");

		messageBuf.add("^\n");

		if (shouldCrash) {
			Sys.println(messageBuf.toString());
			Sys.exit(0);
		}

		super(messageBuf.toString());
	}
}
