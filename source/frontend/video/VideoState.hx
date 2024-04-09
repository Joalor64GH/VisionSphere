package frontend.video;

import flixel.sound.FlxSound;

import openfl.utils.Assets;

using StringTools;

class VideoState extends FlxState
{
	public var leSource:String = "";
	public var callback:Void->Void;
	public var fuckingVolume:Float = 1;
	public var notDone:Bool = true;
	public var vidSound:FlxSound;
	public var useSound:Bool = false;
	public var soundMultiplier:Float = 1;
	public var prevSoundMultiplier:Float = 1;
	public var videoFrames:Int = 0;
	public var defaultText:String = "";
	public var doShit:Bool = false;
	public var autoPause:Bool = false;
	public var musicPaused:Bool = false;

	public function new(source:String, callBack:Void->Void, frameSkipLimit:Int = -1, autopause:Bool = false)
	{
		super();
		
		autoPause = autopause;
		
		leSource = source;
		callback = callBack;
		if (frameSkipLimit != -1 && GlobalVideo.isWebm)
			GlobalVideo.getWebm().webm.SKIP_STEP_LIMIT = frameSkipLimit;
	}
	
	override function create()
	{
		super.create();

		FlxG.autoPause = false;
		doShit = false;
		
		if (GlobalVideo.isWebm)
			videoFrames = Std.parseInt(Assets.getText(leSource.replace(".webm", ".txt")));
		
		fuckingVolume = FlxG.sound.music.volume;
		FlxG.sound.music.volume = 0;
		
		var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		add(bg);

		if (GlobalVideo.isWebm)
		{
			if (Assets.exists(leSource.replace(".webm", ".ogg"), MUSIC) || Assets.exists(leSource.replace(".webm", ".ogg"), SOUND))
			{
				useSound = true;
				vidSound = FlxG.sound.play(leSource.replace(".webm", ".ogg"));
			}
		}

		GlobalVideo.get().source(leSource);
		GlobalVideo.get().clearPause();
		if (GlobalVideo.isWebm)
			GlobalVideo.get().updatePlayer();
		GlobalVideo.get().show();
		if (GlobalVideo.isWebm)
			GlobalVideo.get().restart();
		else
			GlobalVideo.get().play();
		
		vidSound.time = vidSound.length * soundMultiplier;
		doShit = true;
		
		if (autoPause && FlxG.sound.music != null && FlxG.sound.music.playing)
		{
			musicPaused = true;
			FlxG.sound.music.pause();
		}
	}
	
	override function update(elapsed:Float)
	{
		super.update(elapsed);
		
		if (useSound)
		{
			var wasFuckingHit = GlobalVideo.get().webm.wasHitOnce;
			soundMultiplier = GlobalVideo.get().webm.renderedCount / videoFrames;
			
			if (soundMultiplier > 1)
				soundMultiplier = 1;

			if (soundMultiplier < 0)
				soundMultiplier = 0;
			
			if (doShit)
			{
				var compareShit:Float = 50;
				if (vidSound.time >= (vidSound.length * soundMultiplier) + compareShit || vidSound.time <= (vidSound.length * soundMultiplier) - compareShit)
					vidSound.time = vidSound.length * soundMultiplier;
			}

			if (wasFuckingHit)
			{
				if (soundMultiplier == 0)
				{
					if (prevSoundMultiplier != 0)
					{
						vidSound.pause();
						vidSound.time = 0;
					}
				} else {
					if (prevSoundMultiplier == 0)
					{
						vidSound.resume();
						vidSound.time = vidSound.length * soundMultiplier;
					}
				}
				prevSoundMultiplier = soundMultiplier;
			}
		}
		
		if (notDone)
			FlxG.sound.music.volume = 0;
		
		GlobalVideo.get().update(elapsed);

		if (Input.is('r'))
			GlobalVideo.get().restart();
		
		if (Input.is('p'))
		{
			trace("PRESSED PAUSE");
			GlobalVideo.get().togglePause();
			if (GlobalVideo.get().paused)
				GlobalVideo.get().alpha();
			else 
				GlobalVideo.get().unalpha();
		}
		
		if (Input.is('accept') || GlobalVideo.get().ended || GlobalVideo.get().stopped)
		{
			GlobalVideo.get().hide();
			GlobalVideo.get().stop();
		}
		
		if (Input.is('accept') || GlobalVideo.get().ended)
		{
			notDone = false;
			FlxG.sound.music.volume = fuckingVolume;
			if (musicPaused)
			{
				musicPaused = false;
				FlxG.sound.music.resume();
			}
			FlxG.autoPause = true;
			if (callback != null)
				callback();
		}
		
		if (GlobalVideo.get().played || GlobalVideo.get().restarted)
			GlobalVideo.get().show();
		
		GlobalVideo.get().restarted = false;
		GlobalVideo.get().played = false;
		GlobalVideo.get().stopped = false;
		GlobalVideo.get().ended = false;
	}
}