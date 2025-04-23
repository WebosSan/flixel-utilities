package flixel.script;

import hscript.Expr.ModuleDecl;
import hscript.Expr;
import hscript.Printer;
import openfl.Assets;
import rulescript.parsers.HxParser;
import rulescript.scriptedClass.RuleScriptedClass;
import rulescript.scriptedClass.RuleScriptedClassUtil;
import sys.FileSystem;

using StringTools;

class FlxScriptedClass
{
	public static var extension:String = ".hx";

    private static var parser:HxParser = new HxParser();

	public static function registerClass(name:String):Dynamic
	{
		var cl = RuleScriptedClassUtil.getClass(name);
		if (cl != null)
			return cl;

		// Parse type path.
		var path:Array<String> = name.split('.');

		var pack:Array<String> = [];

		while (path[0].charAt(0) == path[0].charAt(0).toLowerCase())
			pack.push(path.shift());

		var moduleName:String = null;

		if (path.length > 1)
			moduleName = path.shift();

		// Replace type path dots to slash.
		var filePath = '${(pack.length >= 1 ? pack.join('.') + '.' + (moduleName ?? path[0]) : path[0]).replace('.', '/')}.hx';

		// Check file.
		if (!FileSystem.exists(filePath))
			return null;

		var typeName = path[0];

		// Parse code.
		var parser = new HxParser();
		parser.allowAll();
		parser.mode = MODULE;

		var module:Array<ModuleDecl> = parser.parseModule(Assets.getText(filePath));

		// Remove other types, include packages, imports and etc.
		var newModule:Array<ModuleDecl> = [];

		var extend:String = null;

		var classImpl:ClassDecl = null;

		for (decl in module)
		{
			switch (decl)
			{
				case DPackage(_), DUsing(_), DImport(_):
					newModule.push(decl);
				case DClass(c):
					if (c.name == typeName)
					{
						newModule.push(decl);

						classImpl = c;

						if (c.extend != null)
						{
							extend = new Printer().typeToString(c.extend);
						}
					}
				default:
			}
		}

		var obj:Null<ScriptedClass> = null;

		if (classImpl != null)
		{
			obj = new ScriptedClass({
				name: moduleName ?? path[0],
				path: pack.join('.'),
				decl: newModule
			}, classImpl?.name);

			RuleScriptedClassUtil.registerRuleScriptedClass(obj.toString(), obj);
		}

		return obj;
	}

    public static function getClass(name:String) {
        return RuleScriptedClassUtil.getClass(name);
    }

	public static function extractClassInfo(filePath:String):Array<{className:String, extension:String}>
	{
		var content = Assets.getText(filePath);
		var classInfo = [];

		// Expresión regular para encontrar clases y sus extensiones
		var classPattern = ~/class\s+([A-Za-z0-9_]+)(?:\s+extends\s+([A-Za-z0-9_]+))?/g;

		while (classPattern.match(content))
		{
			var className = classPattern.matched(1);
			var extension = classPattern.matched(2);

			classInfo.push({
				className: className,
				extension: extension != null ? extension : ""
			});

			content = classPattern.matchedRight();
		}

		return classInfo;
	}
}
