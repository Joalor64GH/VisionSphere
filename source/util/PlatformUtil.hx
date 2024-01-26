package util;

class PlatformUtil
{
    public static function getPlatform():String
    {
        #if windows
        return 'windows';
        #elseif linux
        return 'linux';
        #elseif mac
        return 'mac';
        #elseif html5
        return 'browser';
        #elseif android
        return 'android';
        #elseif ios
        return 'ios';
        #elseif switch
        return 'switch';
        #else
        return 'unknown';
        #end
    }
}