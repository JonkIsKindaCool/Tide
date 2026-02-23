package tide.std;

import tide.vm.Values;

class TideInstance implements TideValue{
	public var name:String;

	public function new(name:String, args:Array<TideInstance>) {
		this.name = name;
	}

	public function getVariable(v:String):TideValue {
		throw 'Instance $name doesn\'t have the variable $v';
	}

	public function setVariable(v:String, v:TideValue):TideValue {
		throw 'Instance $name doesn\'t have the variable $v';
	}
}
