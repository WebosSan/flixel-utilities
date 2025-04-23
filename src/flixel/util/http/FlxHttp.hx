package flixel.util.http;

import flixel.graphics.FlxGraphic;
import haxe.Http;
import haxe.Json;
import haxe.io.Bytes;
import lime.media.AudioBuffer;
import openfl.display.BitmapData;
import openfl.media.Sound;
import openfl.utils.ByteArray;

class FlxHttp {
    /**
     * Loads a FlxGraphic from a URL asynchronously.
     * @param url The URL to load the image from
     * @param errorCallback Optional function to call on error (String->Void)
     */
    public static function getGraphicFromURL(url:String, ?errorCallback:String->Void):FlxGraphic {
        var http = new Http(url);
        var graphic:FlxGraphic = null;
        
        http.onBytes = function(b:Bytes) {
            try {
                var bitmap = BitmapData.fromBytes(b);
                graphic = FlxGraphic.fromBitmapData(bitmap);
            } catch (e:Dynamic) {
                var msg = 'Failed to create graphic from $url: $e';
                if (errorCallback != null) errorCallback(msg);
                else trace(msg);
            }
        };
        
        http.onError = function(msg) {
            var errMsg = 'Failed to load graphic from $url: $msg';
            if (errorCallback != null) errorCallback(errMsg);
            else trace(errMsg);
        };
        
        http.request();
        return graphic;
    }

    /**
     * Loads a Sound from a URL asynchronously.
     * @param url The URL to load the sound from
     * @param errorCallback Optional function to call on error (String->Void)
     */
    public static function getSoundFromURL(url:String, ?errorCallback:String->Void):Sound {
        var http = new Http(url);
        var sound:Sound = null;

        http.onData = s -> trace(s);
        
        http.onBytes = function(b:Bytes) {
            try {
                trace(b);
                sound = Sound.fromAudioBuffer(AudioBuffer.fromBytes(b));
                trace(sound);
            } catch (e:Dynamic) {
                var msg = 'Failed to create sound from $url: $e';
                if (errorCallback != null) errorCallback(msg);
                else trace(msg);
            }
        };
        
        http.onError = function(msg) {
            var errMsg = 'Failed to load sound from $url: $msg';
            if (errorCallback != null) errorCallback(errMsg);
            else trace(errMsg);
        };
        
        http.request();
        return sound;
    }

    /**
     * Loads raw bytes from a URL asynchronously.
     * @param url The URL to load from
     * @param errorCallback Optional function to call on error (String->Void)
     */
    public static function getBytesFromURL(url:String, ?errorCallback:String->Void):Bytes {
        var http = new Http(url);
        var bytes:Bytes = null;

        http.onBytes = b -> bytes = b;
        
        http.onError = function(msg) {
            var errMsg = 'Failed to load bytes from $url: $msg';
            if (errorCallback != null) errorCallback(errMsg);
            else trace(errMsg);
        };
        
        http.request();
        return bytes;
    }

    /**
     * Loads text from a URL asynchronously.
     * @param url The URL to load from
     * @param callback Function to call when loaded (String->Void)
     * @param errorCallback Optional function to call on error (String->Void)
     */
    public static function getTextFromURL(url:String, ?errorCallback:String->Void):String {
        var http = new Http(url);
        var text:String = "";
        
        http.onData = s -> text = s;
        
        http.onError = function(msg) {
            var errMsg = 'Failed to load text from $url: $msg';
            if (errorCallback != null) errorCallback(errMsg);
            else trace(errMsg);
        };
        
        http.request();

        return text;
    }

    /**
     * Loads JSON data from a URL asynchronously.
     * @param url The URL to load from
     * @param errorCallback Optional function to call on error (String->Void)
     */
    public static function getJsonFromURL(url:String, ?errorCallback:String->Void):Dynamic {
        var json:Dynamic = Json.parse(getTextFromURL(url, errorCallback));
        return json;
    }

    /**
     * Checks if a URL exists (HEAD request).
     * @param url The URL to check
     * @param errorCallback Optional function to call on error (String->Void)
     */
    public static function checkURLExists(url:String, ?errorCallback:String->Void):Bool {
        var http = new Http(url);
        var status:Int = 0;
        
        http.onStatus = function(s:Int) {
            status = s;
        };
        
        http.onError = function(msg) {
            if (errorCallback != null) errorCallback(msg);
        };
        
        http.request();

        return status >= 200 && status < 400;
    }
}