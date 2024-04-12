#!/bin/sh
# Setup for Mac devices
# Make you've installed Haxe prior to running this file
echo "Installing dependencies"
haxe -cp compileData -D analyzer-optimize -main Libraries --interp
echo "Rebulding extension-webm"
haxelib lime run rebuild extension-webm mac
echo "Done!"