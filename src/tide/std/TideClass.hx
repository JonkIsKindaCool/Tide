package tide.std;

import tide.vm.Values;

class TideClass implements TideValue {
	public var name:String;

	public function new(name:String) {
		this.name = name;
	}

	public function createInstance(args:Array<TideValue>):TideValue {
		throw 'Class $name doens\'t have a constructor';
	}

	public function getVariable(v:String):TideInstance {
		throw 'Class $name doesn\'t have the variable $v';
	}

	public function setVariable(v:String, v:TideValue):TideValue {
		throw 'Class $name doesn\'t have the variable $v';
	}
}
