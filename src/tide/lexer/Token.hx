package tide.lexer;

enum TokenData {
	// Basic Tokens
	TIdentifier(id:String);
	TInt(i:Int);
	TFloat(f:Float);
    TString(s:String);
	TOp(op:String);

	// Special Characters
	// ()
	TLeftParen;
	TRightParen;

	// {}
	TLeftCurly;
	TRightCurly;

	// []
	TLeftSquare;
	TRightSquare;

	// .
	TDot;

	// ,
	TComma;

	// :
	TColon;

	// ;
	TSemiColon;

	// ?
	TQuestionMark;

	//End Of File
	TEof;
}

typedef Token = {
    start:Int,
    end:Int,
    line:Int,
    data:TokenData
}