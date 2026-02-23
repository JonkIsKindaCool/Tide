package tide.std.primitives;

class TideNull extends TideInstance {
	public function new() {
        super("Null", []);
    }

    public function toString():String {
        return null;
    }
}
