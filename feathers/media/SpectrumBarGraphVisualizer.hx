/*
Feathers
Copyright 2012-2015 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.media
{
import feathers.core.FeathersControl;
import feathers.events.MediaPlayerEventType;
import feathers.skins.IStyleProvider;

import flash.media.SoundMixer;
import flash.utils.ByteArray;

import starling.display.Quad;
import starling.display.QuadBatch;
import starling.events.Event;

/**
 * A visualization of the audio spectrum of the runtime's currently playing
 * audio content.
 *
 * @see ../../../help/sound-player.html How to use the Feathers SoundPlayer component
 */
class SpectrumBarGraphVisualizer extends FeathersControl implements IMediaPlayerControl
{
	/**
	 * The default <code>IStyleProvider</code> for all
	 * <code>SpectrumBarGraphVisualizer</code> components.
	 *
	 * @default null
	 * @see feathers.core.FeathersControl#styleProvider
	 */
	public static var globalStyleProvider:IStyleProvider;
	
	/**
	 * @private
	 */
	private static var HELPER_QUAD:Quad = new Quad(1, 1);
	
	/**
	 * @private
	 */
	private static const MAX_BAR_COUNT:Int = 256;

	/**
	 * Constructor
	 */
	public function SpectrumBarGraphVisualizer()
	{
		this.isQuickHitAreaEnabled = true;
	}

	/**
	 * @private
	 */
	override private function get_defaultStyleProvider():IStyleProvider
	{
		return SpectrumBarGraphVisualizer.globalStyleProvider;
	}

	/**
	 * @private
	 */
	private var _bars:QuadBatch;

	/**
	 * @private
	 */
	private var _bytes:ByteArray = new ByteArray();

	/**
	 * @private
	 */
	private var _barValues:Vector.<Float> = new <Float>[];

	/**
	 * @private
	 */
	private var _barCount:Int = 16;

	/**
	 * The number of bars displayed by the visualizer.
	 */
	public function get_barCount():Int
	{
		return this._barCount;
	}

	/**
	 * @private
	 */
	public function set_barCount(value:Int):Int
	{
		if(value > MAX_BAR_COUNT)
		{
			value = MAX_BAR_COUNT;
		}
		else if(value < 1)
		{
			value = 1;
		}
		if(this._barCount == value)
		{
			return;
		}
		this._barCount = value;
		this.invalidate(INVALIDATION_FLAG_STYLES);
	}

	/**
	 * @private
	 */
	private var _gap:Float = 0;

	/**
	 * The gap, in pixels, between the bars.
	 */
	public function get_gap():Float
	{
		return this._gap;
	}

	/**
	 * @private
	 */
	public function set_gap(value:Float):Float
	{
		if(this._gap == value)
		{
			return;
		}
		this._gap = value;
		this.invalidate(INVALIDATION_FLAG_STYLES);
	}

	/**
	 * @private
	 */
	private var _color:UInt = 0x000000;

	/**
	 * The color of the bars.
	 */
	public function get_color():UInt
	{
		return this._color;
	}

	/**
	 * @private
	 */
	public function set_color(value:UInt):UInt
	{
		if(this._color == value)
		{
			return;
		}
		this._color = value;
		this.invalidate(INVALIDATION_FLAG_STYLES);
	}

	/**
	 * @private
	 */
	private var _mediaPlayer:ITimedMediaPlayer;

	/**
	 * @inheritDoc
	 */
	public function get_mediaPlayer():IMediaPlayer
	{
		return this._mediaPlayer;
	}

	/**
	 * @private
	 */
	public function set_mediaPlayer(value:IMediaPlayer):IMediaPlayer
	{
		if(this._mediaPlayer == value)
		{
			return;
		}
		if(this._mediaPlayer)
		{
			this._mediaPlayer.removeEventListener(MediaPlayerEventType.PLAYBACK_STATE_CHANGE, mediaPlayer_playbackStateChange);
		}
		this._mediaPlayer = value as ITimedMediaPlayer;
		if(this._mediaPlayer)
		{
			this.handlePlaybackStateChange();
			this._mediaPlayer.addEventListener(MediaPlayerEventType.PLAYBACK_STATE_CHANGE, mediaPlayer_playbackStateChange);
		}
		this.invalidate(INVALIDATION_FLAG_DATA);
	}

	/**
	 * @private
	 */
	override public function dispose():Void
	{
		this.mediaPlayer = null;
		super.dispose();
	}

	/**
	 * @private
	 */
	override private function initialize():Void
	{
		this._bars = new QuadBatch();
		this.addChild(this._bars);
	}

	/**
	 * @private
	 */
	override private function draw():Void
	{
		this.autoSizeIfNeeded();
		this.layoutBarGraph();
		super.draw();
	}

	/**
	 * @private
	 */
	private function autoSizeIfNeeded():Bool
	{
		var needsWidth:Bool = this.explicitWidth != this.explicitWidth; //isNaN
		var needsHeight:Bool = this.explicitHeight != this.explicitHeight; //isNaN
		if(!needsWidth && !needsHeight)
		{
			return false;
		}
		var newWidth:Float = this.explicitWidth;
		if(needsWidth)
		{
			newWidth = this._barCount * (this._gap + 1) - this._gap;
		}
		var newHeight:Float = this.explicitHeight;
		if(needsHeight)
		{
			newHeight = 10;
		}
		return this.setSizeInternal(newWidth, newHeight, false);
	}

	/**
	 * @private
	 */
	private function layoutBarGraph():Void
	{
		this._bars.reset();
		if(!this._mediaPlayer.isPlaying)
		{
			return;
		}
		var barCount:Int = this._barCount;
		var barWidth:Float = ((this.actualWidth + this._gap) / barCount) - this._gap;
		if(barWidth < 0 || this.actualHeight <= 0)
		{
			return;
		}
		
		SoundMixer.computeSpectrum(this._bytes, true, 0);
		
		this._barValues.length = barCount;
		var valuesPerBar:Int = 256 / barCount;
		//read left values
		for(var i:Int = 0; i < barCount; i++)
		{
			//reset to zero first
			this._barValues[i] = 0;
			for(var j:Int = 0; j < valuesPerBar; j++)
			{
				var float:Float = this._bytes.readFloat();
				if(float > 1)
				{
					float = 1;
				}
				this._barValues[i] += float;
			}
		}
		//read right values
		this._bytes.position = 1024;
		for(i = 0; i < barCount; i++)
		{
			for(j = 0; j < valuesPerBar; j++)
			{
				float = this._bytes.readFloat();
				if(float > 1)
				{
					float = 1;
				}
				this._barValues[i] += float;
			}
			//calculate the average
			this._barValues[i] /= (2 * valuesPerBar);
		}
		
		var xPosition:Float = 0;
		var maxHeight:Float = this.actualHeight - 1;
		HELPER_QUAD.color = this._color;
		for(i = 0; i < barCount; i++)
		{
			HELPER_QUAD.x = xPosition;
			HELPER_QUAD.width = barWidth;
			HELPER_QUAD.height = Math.floor(maxHeight * this._barValues[i]);
			HELPER_QUAD.y = maxHeight - HELPER_QUAD.height;
			this._bars.addQuad(HELPER_QUAD);
			xPosition += barWidth + this._gap;
		}
	}

	/**
	 * @private
	 */
	private function handlePlaybackStateChange():Void
	{
		if(this._mediaPlayer.isPlaying)
		{
			this.addEventListener(Event.ENTER_FRAME, peakVisualizer_enterFrameHandler);
		}
		else
		{
			this.removeEventListener(Event.ENTER_FRAME, peakVisualizer_enterFrameHandler);
		}
	}

	/**
	 * @private
	 */
	private function mediaPlayer_playbackStateChange(event:Event):Void
	{
		this.handlePlaybackStateChange();
	}

	/**
	 * @private
	 */
	private function peakVisualizer_enterFrameHandler(event:Event):Void
	{
		this.invalidate(INVALIDATION_FLAG_DATA);
	}
}
}
