package util;

class VersionUtil
{
    public var release(default, null):Int;
    public var major(default, null):Int;
    public var minor(default, null):Int;
    public var patch(default, null):String;

    public function new(release:Int, major:Int, minor:Int, ?patch:String)
    {
        this.release = release;
        this.major = major;
        this.minor = minor;
        this.patch = patch;
    }

    public var version(get, never):String;
    function get_version():String return '$release.$major.$minor$patch';
}