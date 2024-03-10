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

import frontend.Menu;
import frontend.Event;
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
#end