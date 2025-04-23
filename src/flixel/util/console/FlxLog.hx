package flixel.util.console;

import flixel.util.console.FlxAnsii;
import haxe.PosInfos;

class FlxLog
{
	/**
		Format the output of `trace` before printing it.
	**/
	public static function formatOutput(v:Dynamic, infos:PosInfos):String {
		var str = Std.string(v);
		if (infos == null)
			return str;
		var pstr = infos.fileName + ":" + infos.lineNumber;
		if (infos.customParams != null)
			for (v in infos.customParams)
				str += ", " + Std.string(v);
		return pstr + ": " + str;
	}

	/**
		Outputs `v` in a platform-dependent way.

		The second parameter `infos` is injected by the compiler and contains
		information about the position where the `trace()` call was made.

		This method can be rebound to a custom function:

			var oldTrace = haxe.Log.trace; // store old function
			haxe.Log.trace = function(v, ?infos) {
			  // handle trace
			}
			...
			haxe.Log.trace = oldTrace;

		If it is bound to null, subsequent calls to `trace()` will cause an
		exception.
	**/
	public static dynamic function trace(v:Dynamic, ?infos:PosInfos):Void {
		var str = formatOutput(v, infos);
		#if js
		if (js.Syntax.typeof(untyped console) != "undefined" && (untyped console).log != null)
			(untyped console).log(str);
		#elseif lua
		untyped __define_feature__("use._hx_print", _hx_print(str));
		#elseif sys
		Sys.println(str + FlxAnsii.Reset);
		#else
		throw new haxe.exceptions.NotImplementedException()
		#end
	}
}