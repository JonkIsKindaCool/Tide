package tide.utils;

import tide.std.primitives.TideInt.TideIntInstance;
import tide.vm.Values;
import tide.std.TideInstance;

class ValueUtils {
    public static function valueToInstance(v:Values):TideInstance {
        switch (v){
            case VInt(i):
                return new TideIntInstance([v]);
            case VInstance(i):
                return i;
            case _:
                return null;
        }
    }

    public static function expectInt(v:Values):Int {
        return switch (v){
            case VInt(i):
                return i;
            case _:
                throw 'Expected Int, got ${valueName(v)}';
        }
    }

    public static function valueName(v:Values):String {
        switch (v){
            case VInt(i):
                return "Int";
            case VFloat(f):
                return "Float";
            case VString(s):
                return "String";
            case VHxFunction(v):
                return "Callable";
            case VClass(c):
                return c.name;
            case VInstance(i):
                return i.name; 
        }
    }
}