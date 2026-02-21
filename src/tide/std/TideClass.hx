package tide.std;

import tide.vm.Values;

class TideClass {
    public var name:String;
	public function new(name:String) {
        this.name = name;
    }

	public function createInstance(args:Array<Values>):TideInstance {
        throw 'Class $name doens\'t have a constructor';
    }
}
