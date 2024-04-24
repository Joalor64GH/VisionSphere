#if !macro
// Default Imports
#if (sys || desktop)
import sys.io.File;
import sys.FileSystem;
#end

import haxe.Json;

import openfl.Lib;
import openfl.Assets;

import flixel.*;
import flixel.util.*;

import flixel.math.FlxMath;
import flixel.text.FlxText;

import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.input.gamepad.FlxGamepad;

import lime.app.Application;

// Game Imports
import frontend.Menu;

import frontend.objects.Alphabet;
import frontend.objects.AttachedSprite;
import frontend.objects.AbsoluteSprite;

import backend.Paths;
import backend.CoolUtil;
import backend.Localization;

import backend.data.Input;
import backend.data.SaveData;

import states.*;
import states.substates.*;

using backend.CoolUtil;
using StringTools;
using Globals;

#if !debug
@:noDebug
#end
#end