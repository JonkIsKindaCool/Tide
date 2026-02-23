package tide.utils;

import tide.std.primitives.TideString;
import tide.std.primitives.TideFloat;
import tide.std.TideValue;
import tide.std.primitives.TideInt;
import tide.vm.Values;
import tide.std.TideInstance;

class ValueUtils {
    public static function valueToInstance(v:Values):TideValue {
        switch (v){
            case VInt(i):
                return new TideInt(i);
            case VFloat(f):
                return new TideFloat(f);
            case VString(s):
                return new TideString(s);
            case VInstance(i):
                return i;
            case _:
                return null;
        }
        return null;
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