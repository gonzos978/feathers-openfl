/*
Feathers
Copyright 2012-2015 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.controls.text
{
import feathers.controls.Scroller;
import feathers.utils.geom.matrixToRotation;
import feathers.utils.geom.matrixToScaleX;
import feathers.utils.geom.matrixToScaleY;
import feathers.utils.math.roundToNearest;

import flash.events.Event;
import flash.events.FocusEvent;
import flash.geom.Matrix;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.text.TextField;

import starling.core.Starling;
import starling.utils.MatrixUtil;

/**
 * A text editor view port for the <code>TextArea</code> component that uses
 * <code>flash.text.TextField</code>.
 *
 * @see feathers.controls.TextArea
 */
public class TextFieldTextEditorViewPort extends TextFieldTextEditor implements ITextEditorViewPort
{
	/**
	 * @private
	 */
	private static const HELPER_MATRIX:Matrix = new Matrix();

	/**
	 * @private
	 */
	private static const HELPER_POINT:Point = new Point();

	/**
	 * Constructor.
	 */
	public function TextFieldTextEditorViewPort()
	{
		super();
		this.multiline = true;
		this.wordWrap = true;
		this.resetScrollOnFocusOut = false;
	}

	/**
	 * @private
	 */
	private var _ignoreScrolling:Boolean = false;

	/**
	 * @private
	 */
	private var _minVisibleWidth:Number = 0;

	/**
	 * @inheritDoc
	 */
	public function get_minVisibleWidth():Number
	{
		return this._minVisibleWidth;
	}

	/**
	 * @private
	 */
	public function set_minVisibleWidth(value:Number):Number
	{
		if(this._minVisibleWidth == value)
		{
			return;
		}
		if(value != value) //isNaN
		{
			throw new ArgumentError("minVisibleWidth cannot be NaN");
		}
		this._minVisibleWidth = value;
		this.invalidate(INVALIDATION_FLAG_SIZE);
	}

	/**
	 * @private
	 */
	private var _maxVisibleWidth:Number = Number.POSITIVE_INFINITY;

	/**
	 * @inheritDoc
	 */
	public function get_maxVisibleWidth():Number
	{
		return this._maxVisibleWidth;
	}

	/**
	 * @private
	 */
	public function set_maxVisibleWidth(value:Number):Number
	{
		if(this._maxVisibleWidth == value)
		{
			return;
		}
		if(value != value) //isNaN
		{
			throw new ArgumentError("maxVisibleWidth cannot be NaN");
		}
		this._maxVisibleWidth = value;
		this.invalidate(INVALIDATION_FLAG_SIZE);
	}

	/**
	 * @private
	 */
	private var _visibleWidth:Number = NaN;

	/**
	 * @inheritDoc
	 */
	public function get_visibleWidth():Number
	{
		return this._visibleWidth;
	}

	/**
	 * @private
	 */
	public function set_visibleWidth(value:Number):Number
	{
		if(this._visibleWidth == value ||
			(value != value && this._visibleWidth != this._visibleWidth)) //isNaN
		{
			return;
		}
		this._visibleWidth = value;
		this.invalidate(INVALIDATION_FLAG_SIZE);
	}

	/**
	 * @private
	 */
	private var _minVisibleHeight:Number = 0;

	/**
	 * @inheritDoc
	 */
	public function get_minVisibleHeight():Number
	{
		return this._minVisibleHeight;
	}

	/**
	 * @private
	 */
	public function set_minVisibleHeight(value:Number):Number
	{
		if(this._minVisibleHeight == value)
		{
			return;
		}
		if(value != value) //isNaN
		{
			throw new ArgumentError("minVisibleHeight cannot be NaN");
		}
		this._minVisibleHeight = value;
		this.invalidate(INVALIDATION_FLAG_SIZE);
	}

	/**
	 * @private
	 */
	private var _maxVisibleHeight:Number = Number.POSITIVE_INFINITY;

	/**
	 * @inheritDoc
	 */
	public function get_maxVisibleHeight():Number
	{
		return this._maxVisibleHeight;
	}

	/**
	 * @private
	 */
	public function set_maxVisibleHeight(value:Number):Number
	{
		if(this._maxVisibleHeight == value)
		{
			return;
		}
		if(value != value) //isNaN
		{
			throw new ArgumentError("maxVisibleHeight cannot be NaN");
		}
		this._maxVisibleHeight = value;
		this.invalidate(INVALIDATION_FLAG_SIZE);
	}

	/**
	 * @private
	 */
	private var _visibleHeight:Number = NaN;

	/**
	 * @inheritDoc
	 */
	public function get_visibleHeight():Number
	{
		return this._visibleHeight;
	}

	/**
	 * @private
	 */
	public function set_visibleHeight(value:Number):Number
	{
		if(this._visibleHeight == value ||
			(value != value && this._visibleHeight != this._visibleHeight)) //isNaN
		{
			return;
		}
		this._visibleHeight = value;
		this.invalidate(INVALIDATION_FLAG_SIZE);
	}

	public function get_contentX():Number
	{
		return 0;
	}

	public function get_contentY():Number
	{
		return 0;
	}

	/**
	 * @private
	 */
	private var _scrollStep:int = 0;

	/**
	 * @inheritDoc
	 */
	public function get_horizontalScrollStep():Number
	{
		return this._scrollStep;
	}

	/**
	 * @inheritDoc
	 */
	public function get_verticalScrollStep():Number
	{
		return this._scrollStep;
	}

	/**
	 * @private
	 */
	private var _horizontalScrollPosition:Number = 0;

	/**
	 * @inheritDoc
	 */
	public function get_horizontalScrollPosition():Number
	{
		return this._horizontalScrollPosition;
	}

	/**
	 * @private
	 */
	public function set_horizontalScrollPosition(value:Number):Number
	{
		//this value is basically ignored because the text does not scroll
		//horizontally. instead, it wraps.
		this._horizontalScrollPosition = value;
	}

	/**
	 * @private
	 */
	private var _verticalScrollPosition:Number = 0;

	/**
	 * @inheritDoc
	 */
	public function get_verticalScrollPosition():Number
	{
		return this._verticalScrollPosition;
	}

	/**
	 * @private
	 */
	public function set_verticalScrollPosition(value:Number):Number
	{
		if(this._verticalScrollPosition == value)
		{
			return;
		}
		this._verticalScrollPosition = value;
		this.invalidate(INVALIDATION_FLAG_SCROLL);
		//hack because the superclass doesn't know about the scroll flag
		this.invalidate(INVALIDATION_FLAG_SIZE);
	}

	/**
	 * @private
	 */
	override public function get_baseline():Number
	{
		return super.baseline + this._paddingTop + this._verticalScrollPosition;
	}

	/**
	 * Quickly sets all padding properties to the same value. The
	 * <code>padding</code> getter always returns the value of
	 * <code>paddingTop</code>, but the other padding values may be
	 * different.
	 *
	 * @default 0
	 *
	 * @see #paddingTop
	 * @see #paddingRight
	 * @see #paddingBottom
	 * @see #paddingLeft
	 */
	public function get_padding():Number
	{
		return this._paddingTop;
	}

	/**
	 * @private
	 */
	public function set_padding(value:Number):Number
	{
		this.paddingTop = value;
		this.paddingRight = value;
		this.paddingBottom = value;
		this.paddingLeft = value;
	}

	/**
	 * @private
	 */
	private var _paddingTop:Number = 0;

	/**
	 * The minimum space, in pixels, between the view port's top edge and
	 * the view port's content.
	 *
	 * @default 0
	 */
	public function get_paddingTop():Number
	{
		return this._paddingTop;
	}

	/**
	 * @private
	 */
	public function set_paddingTop(value:Number):Number
	{
		if(this._paddingTop == value)
		{
			return;
		}
		this._paddingTop = value;
		this.invalidate(INVALIDATION_FLAG_STYLES);
	}

	/**
	 * @private
	 */
	private var _paddingRight:Number = 0;

	/**
	 * The minimum space, in pixels, between the view port's right edge and
	 * the view port's content.
	 *
	 * @default 0
	 */
	public function get_paddingRight():Number
	{
		return this._paddingRight;
	}

	/**
	 * @private
	 */
	public function set_paddingRight(value:Number):Number
	{
		if(this._paddingRight == value)
		{
			return;
		}
		this._paddingRight = value;
		this.invalidate(INVALIDATION_FLAG_STYLES);
	}

	/**
	 * @private
	 */
	private var _paddingBottom:Number = 0;

	/**
	 * The minimum space, in pixels, between the view port's bottom edge and
	 * the view port's content.
	 *
	 * @default 0
	 */
	public function get_paddingBottom():Number
	{
		return this._paddingBottom;
	}

	/**
	 * @private
	 */
	public function set_paddingBottom(value:Number):Number
	{
		if(this._paddingBottom == value)
		{
			return;
		}
		this._paddingBottom = value;
		this.invalidate(INVALIDATION_FLAG_STYLES);
	}

	/**
	 * @private
	 */
	private var _paddingLeft:Number = 0;

	/**
	 * The minimum space, in pixels, between the view port's left edge and
	 * the view port's content.
	 *
	 * @default 0
	 */
	public function get_paddingLeft():Number
	{
		return this._paddingLeft;
	}

	/**
	 * @private
	 */
	public function set_paddingLeft(value:Number):Number
	{
		if(this._paddingLeft == value)
		{
			return;
		}
		this._paddingLeft = value;
		this.invalidate(INVALIDATION_FLAG_STYLES);
	}

	/**
	 * @private
	 */
	override private function measure(result:Point = null):Point
	{
		if(!result)
		{
			result = new Point();
		}

		var needsWidth:Boolean = this._visibleWidth != this._visibleWidth; //isNaN

		this.commitStylesAndData(this.measureTextField);

		var gutterDimensionsOffset:Number = 4;
		if(this._useGutter)
		{
			gutterDimensionsOffset = 0;
		}

		var newWidth:Number = this._visibleWidth;
		this.measureTextField.width = newWidth - this._paddingLeft - this._paddingRight + gutterDimensionsOffset;
		if(needsWidth)
		{
			newWidth = this.measureTextField.width + this._paddingLeft + this._paddingRight - gutterDimensionsOffset;
			if(newWidth < this._minVisibleWidth)
			{
				newWidth = this._minVisibleWidth;
			}
			else if(newWidth > this._maxVisibleWidth)
			{
				newWidth = this._maxVisibleWidth;
			}
		}
		var newHeight:Number = this.measureTextField.height + this._paddingTop + this._paddingBottom - gutterDimensionsOffset;
		if(this._useGutter)
		{
			newHeight += 4;
		}
		if(this._visibleHeight === this._visibleHeight) //!isNaN
		{
			if(newHeight < this._visibleHeight)
			{
				newHeight = this._visibleHeight;
			}
		}
		else if(newHeight < this._minVisibleHeight)
		{
			newHeight = this._minVisibleHeight;
		}

		result.x = newWidth;
		result.y = newHeight;

		return result;
	}

	/**
	 * @private
	 */
	override private function getSelectionIndexAtPoint(pointX:Number, pointY:Number):int
	{
		pointY += this._verticalScrollPosition;
		return this.textField.getCharIndexAtPoint(pointX, pointY);
	}

	/**
	 * @private
	 */
	override private function refreshSnapshotParameters():Void
	{
		var textFieldWidth:Number = this._visibleWidth - this._paddingLeft - this._paddingRight;
		if(textFieldWidth != textFieldWidth) //isNaN
		{
			if(this._maxVisibleWidth < Number.POSITIVE_INFINITY)
			{
				textFieldWidth = this._maxVisibleWidth - this._paddingLeft - this._paddingRight;
			}
			else
			{
				textFieldWidth = this._minVisibleWidth - this._paddingLeft - this._paddingRight;
			}
		}
		var textFieldHeight:Number = this._visibleHeight - this._paddingTop - this._paddingBottom;
		if(textFieldHeight != textFieldHeight) //isNaN
		{
			if(this._maxVisibleHeight < Number.POSITIVE_INFINITY)
			{
				textFieldHeight = this._maxVisibleHeight - this._paddingTop - this._paddingBottom;
			}
			else
			{
				textFieldHeight = this._minVisibleHeight - this._paddingTop - this._paddingBottom;
			}
		}

		this._textFieldOffsetX = 0;
		this._textFieldOffsetY = 0;
		this._textFieldSnapshotClipRect.x = 0;
		this._textFieldSnapshotClipRect.y = 0;

		var scaleFactor:Number = Starling.contentScaleFactor;
		var clipWidth:Number = textFieldWidth * scaleFactor;
		if(this._updateSnapshotOnScaleChange)
		{
			this.getTransformationMatrix(this.stage, HELPER_MATRIX);
			clipWidth *= matrixToScaleX(HELPER_MATRIX);
		}
		if(clipWidth < 0)
		{
			clipWidth = 0;
		}
		var clipHeight:Number = textFieldHeight * scaleFactor;
		if(this._updateSnapshotOnScaleChange)
		{
			clipHeight *= matrixToScaleY(HELPER_MATRIX);
		}
		if(clipHeight < 0)
		{
			clipHeight = 0;
		}
		this._textFieldSnapshotClipRect.width = clipWidth;
		this._textFieldSnapshotClipRect.height = clipHeight;
	}

	/**
	 * @private
	 */
	override private function refreshTextFieldSize():Void
	{
		var oldIgnoreScrolling:Boolean = this._ignoreScrolling;
		var gutterDimensionsOffset:Number = 4;
		if(this._useGutter)
		{
			gutterDimensionsOffset = 0;
		}
		this._ignoreScrolling = true;
		this.textField.width = this._visibleWidth - this._paddingLeft - this._paddingRight + gutterDimensionsOffset;
		var textFieldHeight:Number = this._visibleHeight - this._paddingTop - this._paddingBottom + gutterDimensionsOffset;
		if(this.textField.height != textFieldHeight)
		{
			this.textField.height = textFieldHeight;
		}
		var scroller:Scroller = Scroller(this.parent);
		this.textField.scrollV = Math.round(1 + ((this.textField.maxScrollV - 1) * (this._verticalScrollPosition / scroller.maxVerticalScrollPosition)));
		this._ignoreScrolling = oldIgnoreScrolling;
	}

	/**
	 * @private
	 */
	override private function commitStylesAndData(textField:TextField):Void
	{
		super.commitStylesAndData(textField);
		if(textField == this.textField)
		{
			this._scrollStep = textField.getLineMetrics(0).height;
		}
	}

	/**
	 * @private
	 */
	override private function transformTextField():Void
	{
		if(!this.textField.visible)
		{
			return;
		}
		var nativeScaleFactor:Number = 1;
		if(Starling.current.supportHighResolutions)
		{
			nativeScaleFactor = Starling.current.nativeStage.contentsScaleFactor;
		}
		var scaleFactor:Number = Starling.contentScaleFactor / nativeScaleFactor;
		HELPER_POINT.x = HELPER_POINT.y = 0;
		this.getTransformationMatrix(this.stage, HELPER_MATRIX);
		MatrixUtil.transformCoords(HELPER_MATRIX, 0, 0, HELPER_POINT);
		var scaleX:Number = matrixToScaleX(HELPER_MATRIX) * scaleFactor;
		var scaleY:Number = matrixToScaleY(HELPER_MATRIX) * scaleFactor;
		var offsetX:Number = Math.round(this._paddingLeft * scaleX);
		var offsetY:Number = Math.round((this._paddingTop + this._verticalScrollPosition) * scaleY);
		var starlingViewPort:Rectangle = Starling.current.viewPort;
		var gutterPositionOffset:Number = 2;
		if(this._useGutter)
		{
			gutterPositionOffset = 0;
		}
		this.textField.x = offsetX + Math.round(starlingViewPort.x + (HELPER_POINT.x * scaleFactor) - gutterPositionOffset * scaleX);
		this.textField.y = offsetY + Math.round(starlingViewPort.y + (HELPER_POINT.y * scaleFactor) - gutterPositionOffset * scaleY);
		this.textField.rotation = matrixToRotation(HELPER_MATRIX) * 180 / Math.PI;
		this.textField.scaleX = scaleX;
		this.textField.scaleY = scaleY;
	}

	/**
	 * @private
	 */
	override private function positionSnapshot():Void
	{
		if(!this.textSnapshot)
		{
			return;
		}
		this.getTransformationMatrix(this.stage, HELPER_MATRIX);
		this.textSnapshot.x = this._paddingLeft + Math.round(HELPER_MATRIX.tx) - HELPER_MATRIX.tx;
		this.textSnapshot.y = this._paddingTop + this._verticalScrollPosition + Math.round(HELPER_MATRIX.ty) - HELPER_MATRIX.ty;
	}

	/**
	 * @private
	 */
	override private function checkIfNewSnapshotIsNeeded():Void
	{
		super.checkIfNewSnapshotIsNeeded();
		this._needsNewTexture ||= this.isInvalid(INVALIDATION_FLAG_SCROLL);
	}

	/**
	 * @private
	 */
	override private function textField_focusInHandler(event:FocusEvent):Void
	{
		this.textField.addEventListener(Event.SCROLL, textField_scrollHandler);
		super.textField_focusInHandler(event);
		this.invalidate(INVALIDATION_FLAG_SIZE);
	}

	/**
	 * @private
	 */
	override private function textField_focusOutHandler(event:FocusEvent):Void
	{
		this.textField.removeEventListener(Event.SCROLL, textField_scrollHandler);
		super.textField_focusOutHandler(event);
		this.invalidate(INVALIDATION_FLAG_SIZE);
	}

	/**
	 * @private
	 */
	private function textField_scrollHandler(event:Event):Void
	{
		//for some reason, the text field's scroll positions don't work
		//properly unless we access the values here. weird.
		var scrollH:Number = this.textField.scrollH;
		var scrollV:Number = this.textField.scrollV;
		if(this._ignoreScrolling)
		{
			return;
		}
		var scroller:Scroller = Scroller(this.parent);
		if(scroller.maxVerticalScrollPosition > 0 && this.textField.maxScrollV > 1)
		{
			var calculatedVerticalScrollPosition:Number = scroller.maxVerticalScrollPosition * (scrollV - 1) / (this.textField.maxScrollV - 1);
			scroller.verticalScrollPosition = roundToNearest(calculatedVerticalScrollPosition, this._scrollStep);
		}
	}

}
}
