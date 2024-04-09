package frontend.video;

import flixel.sound.FlxSound;
import frontend.video.*;

using StringTools;

class VideoState extends FlxState
{
	var leSource:String = "";

	var vidSound:FlxSound = null;

	var holdTimer:Int = 0;
	var crashMoment:Int = 0;
	var itsTooLate:Bool = false;
	var skipTxt:FlxText;

	var onComplete:Void->Void;

	public function new(source:String, ?onComplete:Void->Void):Void
	{
		super();
		
		this.leSource = source;
		this.onComplete = onComplete;
	}
	
	override public function create():Void
	{
		super.create();

		if (FlxG.sound.music != null)
			FlxG.sound.music.pause();

		var bg:FlxSprite = new FlxSprite();
		bg.makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		add(bg);

		skipTxt = new FlxText(FlxG.width / 1.5, FlxG.height - 50, FlxG.width, 'Hold any key to skip.', 32);
		skipTxt.setFormat(Paths.font('vcr.ttf'), 32, FlxColor.WHITE, LEFT);

		if (GlobalVideo.isWebm)
		{
			if (Paths.fileExists('videos/$leSource.ogg'))
				vidSound = FlxG.sound.play(Paths.videoSound(leSource), 1, false, null, true);
		}

		var ourVideo:Dynamic = GlobalVideo.get();
		ourVideo.source(Paths.video(leSource));

		if (ourVideo == null)
		{
			end();
			return;
		}

		ourVideo.clearPause();

		if (GlobalVideo.isWebm)
			ourVideo.updatePlayer();

		ourVideo.show();

		if (GlobalVideo.isWebm)
			ourVideo.restart();
		else
			ourVideo.play();

		add(skipTxt);
	}

	override public function update(elapsed:Float):Void
	{
		var ourVideo:Dynamic = GlobalVideo.get();

		if (ourVideo == null)
		{
			end();
			return;
		}

		ourVideo.update(elapsed);

		if (ourVideo.ended || ourVideo.stopped)
		{
			skipTxt.visible = false;

			ourVideo.hide();
			ourVideo.stop();
		}

		if (crashMoment > 0) crashMoment--;

		if (Input.is('any') && crashMoment <= 0 || itsTooLate && Input.is('any'))
		{
			holdTimer++;

			crashMoment = 16;
			itsTooLate = true;
	
			FlxG.sound.music.volume = 0;
			ourVideo.alpha();
	
			if (holdTimer > 100)
			{
				skipTxt.visible = false;
				ourVideo.stop();

				end();
				return;
			}
		}
		else if (!ourVideo.paused)
		{
			ourVideo.unalpha();

			holdTimer = 0;
			itsTooLate = false;
		}
		
		if (ourVideo.ended)
		{
			end();
			return;
		}

		if (ourVideo.played || ourVideo.restarted)
			ourVideo.show();

		ourVideo.restarted = false;
		ourVideo.played = false;

		ourVideo.stopped = false;
		ourVideo.ended = false;

		super.update(elapsed);
	}

	public function end():Void
	{
		if (vidSound != null)
			vidSound.destroy();

		if (onComplete != null)
			onComplete();
	}
}