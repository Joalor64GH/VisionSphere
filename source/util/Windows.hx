package util;

#if windows
@:buildXml('
    <target id="haxe">
        <lib name="dwmapi.lib" if="windows" />
    </target>
    ')
@:cppFileCode('
    #include <Windows.h>
    #include <cstdio>
    #include <iostream>
    #include <tchar.h>
    #include <dwmapi.h>
    #include <winuser.h>
    ')
#end
@:dox(hide)
class Windows
{
    #if windows
    @:functionCode('
        int darkMode = enable ? 1 : 0;
        HWND window = GetActiveWindow();
        if (S_OK != DwmSetWindowAttribute(window, 19, &darkMode, sizeof(darkMode))) {
            DwmSetWindowAttribute(window, 20, &darkMode, sizeof(darkMode));
        }
    ')
    public static function setDarkMode(enable:Bool) {}

    public static function darkMode(enable:Bool)
    {
        setDarkMode(enable);
        Application.current.window.borderless = true;
        Application.current.window.borderless = false;
    }
    #end
}