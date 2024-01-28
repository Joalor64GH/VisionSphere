package util;

#if windows
class Windows
{
    public static function setDarkMode(enable:Bool) 
    {
        WindowsBackend.setDarkMode(enable);
        Application.current.window.borderless = true;
        Application.current.window.borderless = false;
    }
}

@:buildXml('
<target id="haxe">
    <lib name="dwmapi.lib" if="windows" />
</target>
')

@:headerCode('#include <dwmapi.h>')

@:dox(hide)
private class WindowsBackend
{
    @:functionCode('
        int darkMode = enable ? 1 : 0;
        HWND window = GetActiveWindow();
        if (S_OK != DwmSetWindowAttribute(window, 19, &darkMode, sizeof(darkMode))) {
            DwmSetWindowAttribute(window, 20, &darkMode, sizeof(darkMode));
        }
    ')
    public static function setDarkMode(enable:Bool) {}
}
#end