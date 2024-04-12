@echo off
color 0a

echo Oh gosh oh gee you've really done it now
pause >nul
cd ..
@echo on
echo Installing dependencies
haxe -cp compileData -D analyzer-optimize -main Libraries --interp
echo Rebuilding extension-webm
haxelib lime run rebuild extension-webm windows
echo Finished!
pause