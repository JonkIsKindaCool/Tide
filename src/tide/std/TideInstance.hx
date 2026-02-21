package tide.std;

import tide.vm.Values;

class TideInstance {
	public var name:String;

	public function new(name:String, args:Array<Values>) {
		this.name = name;
	}

	public function getVariable(v:String):Values {
		throw 'Instance $name doesn\'t have the variable $v';
	}

	public function setVariable(v:String, v:Values):Values {
		throw 'Instance $name doesn\'t have the variable $v';
	}
}
