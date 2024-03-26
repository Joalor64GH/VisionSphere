package frontend;

import openfl.display.Sprite;
import openfl.events.AsyncErrorEvent;
import openfl.events.MouseEvent;
import openfl.events.NetStatusEvent;
import openfl.media.Video;
import openfl.net.NetConnection;
import openfl.net.NetStream;

/**
 * A video player class.
 * Modified by me for custom callbacks and video files.
 * @author ninjamuffin99
 * @see https://github.com/FunkinCrew/Funkin/
 */

class VideoState extends FlxState
{
    var file:String;
    var callback:Void->Void;

	var video:Video;
	var netStream:NetStream;
    
	private var overlay:Sprite;

    public function new(file:String, callback:Void->Void)
    {
        super();

        this.file = file;
        this.callback = callback;
    }

	override function create()
	{
		super.create();

		video = new Video();
		FlxG.addChildBelowMouse(video);

		var netConnection = new NetConnection();
		netConnection.connect(null);

		netStream = new NetStream(netConnection);
		netStream.client = {onMetaData: client_onMetaData};
		netStream.addEventListener(AsyncErrorEvent.ASYNC_ERROR, netStream_onAsyncError);
		netConnection.addEventListener(NetStatusEvent.NET_STATUS, netConnection_onNetStatus);
		netStream.play(Paths.file('videos/' + file + '.mp4'));

		overlay = new Sprite();
		overlay.graphics.beginFill(0, 0.5);
		overlay.graphics.drawRect(0, 0, 1280, 720);
		overlay.addEventListener(MouseEvent.MOUSE_DOWN, overlay_onMouseDown);
		overlay.buttonMode = true;
	}

	override function update(elapsed:Float)
	{
		if (Input.is('accept'))
        {
            netStream.dispose();
		    FlxG.removeChild(video);
            if (callback != null)
                callback();
        }

		super.update(elapsed);
	}

	private function client_onMetaData(metaData:Dynamic)
	{
		video.attachNetStream(netStream);

		video.width = video.videoWidth;
		video.height = video.videoHeight;
	}

	private function netStream_onAsyncError(event:AsyncErrorEvent):Void
	{
		trace("Error loading video");
	}

	private function netConnection_onNetStatus(event:NetStatusEvent):Void
	{
		if (event.info.code == 'NetStream.Play.Complete')
        {
            netStream.dispose();
		    FlxG.removeChild(video);
            if (callback != null)
                callback();
        }

		trace(event.toString());
	}

	private function overlay_onMouseDown(event:MouseEvent):Void
	{
		netStream.soundTransform.volume = 0.2;
		netStream.soundTransform.pan = -1;

		FlxG.stage.removeChild(overlay);
	}
}