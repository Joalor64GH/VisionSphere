#if !macro
#if (sys || desktop)
import sys.io.File;
import sys.FileSystem;
#end

import haxe.Json;

import flixel.*;

import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.group.FlxGroup.FlxTypedGroup;

import lime.app.Application;

import base.Menu;
import base.Paths;
import base.Input;
import base.Event;
import util.CoolUtil;
import util.Localization;
import util.SaveData;
import objects.Alphabet;
import objects.AttachedSprite;

import states.*;
import states.substates.*;

using util.CoolUtil;
using StringTools;
#end