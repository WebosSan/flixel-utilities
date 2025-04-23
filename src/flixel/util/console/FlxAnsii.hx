package flixel.util.console;

enum abstract FlxAnsii(String) from String to String
{
    #if web
    // Versión optimizada para JavaScript
    var Reset = "\x1b[0m";
    
    // Text attributes
    var Bold = "\x1b[1m";
    var Faint = "\x1b[2m";
    var Italic = "\x1b[3m";
    var Underline = "\x1b[4m";
    var Blink = "\x1b[5m";
    var Reverse = "\x1b[7m";
    var Conceal = "\x1b[8m";
    var Strike = "\x1b[9m";
    
    // Basic 16 colors
    var Black = "\x1b[30m";
    var Red = "\x1b[31m";
    var Green = "\x1b[32m";
    var Yellow = "\x1b[33m";
    var Blue = "\x1b[34m";
    var Magenta = "\x1b[35m";
    var Cyan = "\x1b[36m";
    var White = "\x1b[37m";
    
    var BgBlack = "\x1b[40m";
    var BgRed = "\x1b[41m";
    var BgGreen = "\x1b[42m";
    var BgYellow = "\x1b[43m";
    var BgBlue = "\x1b[44m";
    var BgMagenta = "\x1b[45m";
    var BgCyan = "\x1b[46m";
    var BgWhite = "\x1b[47m";
    
    // Bright colors
    var BrightBlack = "\x1b[90m";
    var BrightRed = "\x1b[91m";
    var BrightGreen = "\x1b[92m";
    var BrightYellow = "\x1b[93m";
    var BrightBlue = "\x1b[94m";
    var BrightMagenta = "\x1b[95m";
    var BrightCyan = "\x1b[96m";
    var BrightWhite = "\x1b[97m";
    
    var BgBrightBlack = "\x1b[100m";
    var BgBrightRed = "\x1b[101m";
    var BgBrightGreen = "\x1b[102m";
    var BgBrightYellow = "\x1b[103m";
    var BgBrightBlue = "\x1b[104m";
    var BgBrightMagenta = "\x1b[105m";
    var BgBrightCyan = "\x1b[106m";
    var BgBrightWhite = "\x1b[107m";
    #else
    // Versión estándar para otras plataformas
    var Reset = "\033[0m";
    
    // Text attributes
    var Bold = "\033[1m";
    var Faint = "\033[2m";
    var Italic = "\033[3m";
    var Underline = "\033[4m";
    var Blink = "\033[5m";
    var Reverse = "\033[7m";
    var Conceal = "\033[8m";
    var Strike = "\033[9m";
    
    // Basic 16 colors
    var Black = "\033[30m";
    var Red = "\033[31m";
    var Green = "\033[32m";
    var Yellow = "\033[33m";
    var Blue = "\033[34m";
    var Magenta = "\033[35m";
    var Cyan = "\033[36m";
    var White = "\033[37m";
    
    var BgBlack = "\033[40m";
    var BgRed = "\033[41m";
    var BgGreen = "\033[42m";
    var BgYellow = "\033[43m";
    var BgBlue = "\033[44m";
    var BgMagenta = "\033[45m";
    var BgCyan = "\033[46m";
    var BgWhite = "\033[47m";
    
    // Bright colors
    var BrightBlack = "\033[90m";
    var BrightRed = "\033[91m";
    var BrightGreen = "\033[92m";
    var BrightYellow = "\033[93m";
    var BrightBlue = "\033[94m";
    var BrightMagenta = "\033[95m";
    var BrightCyan = "\033[96m";
    var BrightWhite = "\033[97m";
    
    var BgBrightBlack = "\033[100m";
    var BgBrightRed = "\033[101m";
    var BgBrightGreen = "\033[102m";
    var BgBrightYellow = "\033[103m";
    var BgBrightBlue = "\033[104m";
    var BgBrightMagenta = "\033[105m";
    var BgBrightCyan = "\033[106m";
    var BgBrightWhite = "\033[107m";
    #end

    @:from
    public static function fromHex(color:Int):FlxAnsii {
        final rgb = color & 0xFFFFFF;
        final r = (rgb >> 16) & 0xFF;
        final g = (rgb >> 8) & 0xFF;
        final b = rgb & 0xFF;
        
        #if web
        return '\x1b[38;2;$r;$g;${b}m';
        #else
        return '\033[38;2;$r;$g;${b}m';
        #end
    }

    public static function bgFromHex(color:Int):FlxAnsii {
        final rgb = color & 0xFFFFFF;
        final r = (rgb >> 16) & 0xFF;
        final g = (rgb >> 8) & 0xFF;
        final b = rgb & 0xFF;
        
        #if web
        return '\x1b[48;2;$r;$g;${b}m';
        #else
        return '\033[48;2;$r;$g;${b}m';
        #end
    }

    @:from
    public static function fromRGB(rgb:Array<Int>):FlxAnsii {
        if (rgb.length != 3) return Reset;
        return fromHex((rgb[0] << 16) | (rgb[1] << 8) | rgb[2]);
    }

    @:from
    public static function bgFromRGB(rgb:Array<Int>):FlxAnsii {
        if (rgb.length != 3) return Reset;
        return bgFromHex((rgb[0] << 16) | (rgb[1] << 8) | rgb[2]);
    }
}