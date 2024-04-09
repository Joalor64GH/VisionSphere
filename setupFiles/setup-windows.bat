@echo off
color 0a
cd ..
@echo on
echo Installing dependencies
haxe -cp compileData -D analyzer-optimize -main Libraries --interp
echo Rebuilding extension-webm
haxelib lime run rebuild extension-webm windows
echo Finished!
pause