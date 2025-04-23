package flixel.script;

import haxe.Rest;
import openfl.Assets;
import rulescript.BytecodeInterp;
import rulescript.parsers.HxParser;

class FlxScript {
    public var interp:BytecodeInterp;
    public var parser:HxParser;

    public var superInstance(default, set):Dynamic;

    
    function set_superInstance(value:Dynamic):Dynamic {
        interp.superInstance = value;
        return superInstance = value;
    }

    public function new() {
        parser = new HxParser();
        parser.allowAll();
        parser.mode = HxParserMode.DEFAULT;
        interp = new BytecodeInterp();
    }

    public function hasVariable(name:String):Bool {
        return interp.variables.exists(name);
    }

    public function setVariable(name:String, value:Dynamic) {
        interp.variables.set(name, value);
    }

    public function getVariable(name:String):Dynamic {
        if (hasVariable(name)) return interp.variables.get(name);
        trace("Script " + interp.scriptName + " doesnt has " + name);
        return null;
    }

    public function call(name:String, ?args:Array<Dynamic>) {
        var func = getVariable(name);
        if (Reflect.isFunction(func)) {
            if (args != null) {
                return Reflect.callMethod(null, func, args);
            } else {
                return func();
            }
        }
        return null;
    }

    public function evaluateString(str:String, ?scriptName:String = "HScript"):Dynamic {
        interp.scriptName = scriptName;
        return interp.execute(parser.parse(str));
    }

    public function evaluateFile(file:String):Dynamic {
        interp.scriptName = file;
        return interp.execute(parser.parse(Assets.getText(file)));
    }
}