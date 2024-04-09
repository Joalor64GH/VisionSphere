#!/bin/sh
# Setup for Linux devices
# Make you've installed Haxe prior to running this file
haxe -cp compileData -D analyzer-optimize -main Libraries --interp
# Rebuild extension-webm
haxelib lime run rebuild extension-webm linux