/*
Feathers
Copyright 2012-2015 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.layout
{
import feathers.core.IValidating;

import flash.errors.IllegalOperationError;
import flash.geom.Point;

import starling.display.DisplayObject;
import starling.events.Event;
import starling.events.EventDispatcher;

/**
 * Dispatched when a property of the layout changes, indicating that a
 * redraw is probably needed.
 *
 * <p>The properties of the event object have the following values:</p>
 * <table class="innertable">
 * <tr><th>Property</th><th>Value</th></tr>
 * <tr><td><code>bubbles</code></td><td>false</td></tr>
 * <tr><td><code>currentTarget</code></td><td>The Object that defines the
 *   event listener that handles the event. For example, if you use
 *   <code>myButton.addEventListener()</code> to register an event listener,
 *   myButton is the value of the <code>currentTarget</code>.</td></tr>
 * <tr><td><code>data</code></td><td>null</td></tr>
 * <tr><td><code>target</code></td><td>The Object that dispatched the event;
 *   it is not always the Object listening for the event. Use the
 *   <code>currentTarget</code> property to always access the Object
 *   listening for the event.</td></tr>
 * </table>
 *
 * @eventType starling.events.Event.CHANGE
 */
[Event(name="change",type="starling.events.Event")]

/**
 * Positions items of different dimensions from left to right in multiple
 * rows. When the width of a row reaches the width of the container, a new
 * row will be started. Constrained to the suggested width, the flow layout
 * will change in height as the number of items increases or decreases.
 *
 * <p><strong>Beta Layout:</strong> This is a new layout, and its APIs
 * may need some changes between now and the next version of Feathers to
 * account for overlooked requirements or other issues. Upgrading to future
 * versions of Feathers may involve manual changes to your code that uses
 * this layout. The
 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>
 * will not go into effect until this component's status is upgraded from
 * beta to stable.</p>
 *
 * @see ../../../help/flow-layout.html How to use FlowLayout with Feathers containers
 */
class FlowLayout extends EventDispatcher implements IVariableVirtualLayout
{
	/**
	 * If the total item height is smaller than the height of the bounds,
	 * the items will be aligned to the top.
	 *
	 * @see #rowVerticalAlign
	 */
	inline public static var VERTICAL_ALIGN_TOP:String = "top";

	/**
	 * If the total item height is smaller than the height of the bounds,
	 * the items will be aligned to the middle.
	 *
	 * @see #rowVerticalAlign
	 */
	inline public static var VERTICAL_ALIGN_MIDDLE:String = "middle";

	/**
	 * If the total item height is smaller than the height of the bounds,
	 * the items will be aligned to the bottom.
	 *
	 * @see #rowVerticalAlign
	 */
	inline public static var VERTICAL_ALIGN_BOTTOM:String = "bottom";

	/**
	 * If the total item width is smaller than the width of the bounds, the
	 * items will be aligned to the left.
	 *
	 * @see #horizontalAlign
	 */
	inline public static var HORIZONTAL_ALIGN_LEFT:String = "left";

	/**
	 * If the total item width is smaller than the width of the bounds, the
	 * items will be aligned to the center.
	 *
	 * @see #horizontalAlign
	 */
	inline public static var HORIZONTAL_ALIGN_CENTER:String = "center";

	/**
	 * If the total item width is smaller than the width of the bounds, the
	 * items will be aligned to the right.
	 *
	 * @see #horizontalAlign
	 */
	inline public static var HORIZONTAL_ALIGN_RIGHT:String = "right";

	/**
	 * Constructor.
	 */
	public function FlowLayout()
	{
	}

	/**
	 * @private
	 */
	private var _rowItems:Vector.<DisplayObject> = new <DisplayObject>[];

	/**
	 * Quickly sets both <code>horizontalGap</code> and <code>verticalGap</code>
	 * to the same value. The <code>gap</code> getter always returns the
	 * value of <code>horizontalGap</code>, but the value of
	 * <code>verticalGap</code> may be different.
	 *
	 * @default 0
	 *
	 * @see #horizontalGap
	 * @see #verticalGap
	 */
	public function get_gap():Float
	{
		return this._horizontalGap;
	}

	/**
	 * @private
	 */
	public function set_gap(value:Float):Float
	{
		this.horizontalGap = value;
		this.verticalGap = value;
	}

	/**
	 * @private
	 */
	private var _horizontalGap:Float = 0;

	/**
	 * The horizontal space, in pixels, between items.
	 *
	 * @default 0
	 */
	public function get_horizontalGap():Float
	{
		return this._horizontalGap;
	}

	/**
	 * @private
	 */
	public function set_horizontalGap(value:Float):Float
	{
		if(this._horizontalGap == value)
		{
			return;
		}
		this._horizontalGap = value;
		this.dispatchEventWith(Event.CHANGE);
	}

	/**
	 * @private
	 */
	private var _verticalGap:Float = 0;

	/**
	 * The vertical space, in pixels, between items.
	 *
	 * @default 0
	 */
	public function get_verticalGap():Float
	{
		return this._verticalGap;
	}

	/**
	 * @private
	 */
	public function set_verticalGap(value:Float):Float
	{
		if(this._verticalGap == value)
		{
			return;
		}
		this._verticalGap = value;
		this.dispatchEventWith(Event.CHANGE);
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
	public function get_padding():Float
	{
		return this._paddingTop;
	}

	/**
	 * @private
	 */
	public function set_padding(value:Float):Float
	{
		this.paddingTop = value;
		this.paddingRight = value;
		this.paddingBottom = value;
		this.paddingLeft = value;
	}

	/**
	 * @private
	 */
	private var _paddingTop:Float = 0;

	/**
	 * The space, in pixels, above of items.
	 *
	 * @default 0
	 */
	public function get_paddingTop():Float
	{
		return this._paddingTop;
	}

	/**
	 * @private
	 */
	public function set_paddingTop(value:Float):Float
	{
		if(this._paddingTop == value)
		{
			return;
		}
		this._paddingTop = value;
		this.dispatchEventWith(Event.CHANGE);
	}

	/**
	 * @private
	 */
	private var _paddingRight:Float = 0;

	/**
	 * The space, in pixels, to the right of the items.
	 *
	 * @default 0
	 */
	public function get_paddingRight():Float
	{
		return this._paddingRight;
	}

	/**
	 * @private
	 */
	public function set_paddingRight(value:Float):Float
	{
		if(this._paddingRight == value)
		{
			return;
		}
		this._paddingRight = value;
		this.dispatchEventWith(Event.CHANGE);
	}

	/**
	 * @private
	 */
	private var _paddingBottom:Float = 0;

	/**
	 * The space, in pixels, below the items.
	 *
	 * @default 0
	 */
	public function get_paddingBottom():Float
	{
		return this._paddingBottom;
	}

	/**
	 * @private
	 */
	public function set_paddingBottom(value:Float):Float
	{
		if(this._paddingBottom == value)
		{
			return;
		}
		this._paddingBottom = value;
		this.dispatchEventWith(Event.CHANGE);
	}

	/**
	 * @private
	 */
	private var _paddingLeft:Float = 0;

	/**
	 * The space, in pixels, to the left of the items.
	 *
	 * @default 0
	 */
	public function get_paddingLeft():Float
	{
		return this._paddingLeft;
	}

	/**
	 * @private
	 */
	public function set_paddingLeft(value:Float):Float
	{
		if(this._paddingLeft == value)
		{
			return;
		}
		this._paddingLeft = value;
		this.dispatchEventWith(Event.CHANGE);
	}

	/**
	 * @private
	 */
	private var _horizontalAlign:String = HORIZONTAL_ALIGN_LEFT;

	[Inspectable(type="String",enumeration="left,center,right")]
	/**
	 * If the total row width is less than the bounds, the items in the row
	 * can be aligned horizontally.
	 *
	 * @default FlowLayout.HORIZONTAL_ALIGN_LEFT
	 *
	 * @see #HORIZONTAL_ALIGN_LEFT
	 * @see #HORIZONTAL_ALIGN_CENTER
	 * @see #HORIZONTAL_ALIGN_RIGHT
	 * @see #verticalAlign
	 * @see #rowVerticalAlign
	 */
	public function get_horizontalAlign():String
	{
		return this._horizontalAlign;
	}

	/**
	 * @private
	 */
	public function set_horizontalAlign(value:String):String
	{
		if(this._horizontalAlign == value)
		{
			return;
		}
		this._horizontalAlign = value;
		this.dispatchEventWith(Event.CHANGE);
	}

	/**
	 * @private
	 */
	private var _verticalAlign:String = VERTICAL_ALIGN_TOP;

	[Inspectable(type="String",enumeration="top,middle,bottom")]
	/**
	 * If the total height of the content is less than the bounds, the
	 * content may be aligned vertically.
	 *
	 * @default FlowLayout.VERTICAL_ALIGN_TOP
	 *
	 * @see #VERTICAL_ALIGN_TOP
	 * @see #VERTICAL_ALIGN_MIDDLE
	 * @see #VERTICAL_ALIGN_BOTTOM
	 * @see #horizontalAlign
	 * @see #rowVerticalAlign
	 */
	public function get_verticalAlign():String
	{
		return this._verticalAlign;
	}

	/**
	 * @private
	 */
	public function set_verticalAlign(value:String):String
	{
		if(this._verticalAlign == value)
		{
			return;
		}
		this._verticalAlign = value;
		this.dispatchEventWith(Event.CHANGE);
	}

	/**
	 * @private
	 */
	private var _rowVerticalAlign:String = VERTICAL_ALIGN_TOP;

	[Inspectable(type="String",enumeration="top,middle,bottom")]
	/**
	 * If the height of an item is less than the height of a row, it can be
	 * aligned vertically.
	 *
	 * @default FlowLayout.VERTICAL_ALIGN_TOP
	 *
	 * @see #VERTICAL_ALIGN_TOP
	 * @see #VERTICAL_ALIGN_MIDDLE
	 * @see #VERTICAL_ALIGN_BOTTOM
	 * @see #horizontalAlign
	 * @see #verticalAlign
	 */
	public function get_rowVerticalAlign():String
	{
		return this._rowVerticalAlign;
	}

	/**
	 * @private
	 */
	public function set_rowVerticalAlign(value:String):String
	{
		if(this._rowVerticalAlign == value)
		{
			return;
		}
		this._rowVerticalAlign = value;
		this.dispatchEventWith(Event.CHANGE);
	}

	/**
	 * @private
	 */
	private var _useVirtualLayout:Bool = true;

	/**
	 * @inheritDoc
	 *
	 * @default true
	 */
	public function get_useVirtualLayout():Bool
	{
		return this._useVirtualLayout;
	}

	/**
	 * @private
	 */
	public function set_useVirtualLayout(value:Bool):Bool
	{
		if(this._useVirtualLayout == value)
		{
			return;
		}
		this._useVirtualLayout = value;
		this.dispatchEventWith(Event.CHANGE);
	}

	/**
	 * @private
	 */
	private var _typicalItem:DisplayObject;

	/**
	 * @inheritDoc
	 */
	public function get_typicalItem():DisplayObject
	{
		return this._typicalItem;
	}

	/**
	 * @private
	 */
	public function set_typicalItem(value:DisplayObject):DisplayObject
	{
		if(this._typicalItem == value)
		{
			return;
		}
		this._typicalItem = value;
		this.dispatchEventWith(Event.CHANGE);
	}

	/**
	 * @private
	 */
	private var _hasVariableItemDimensions:Bool = true;

	/**
	 * When the layout is virtualized, and this value is true, the items may
	 * have variable width and height values. If false, the items will all
	 * share the same dimensions with the typical item.
	 *
	 * @default true
	 */
	public function get_hasVariableItemDimensions():Bool
	{
		return this._hasVariableItemDimensions;
	}

	/**
	 * @private
	 */
	public function set_hasVariableItemDimensions(value:Bool):Bool
	{
		if(this._hasVariableItemDimensions == value)
		{
			return;
		}
		this._hasVariableItemDimensions = value;
		this.dispatchEventWith(Event.CHANGE);
	}

	/**
	 * @inheritDoc
	 */
	public function get_requiresLayoutOnScroll():Bool
	{
		return this._useVirtualLayout;
	}

	/**
	 * @private
	 */
	private var _widthCache:Array = [];

	/**
	 * @private
	 */
	private var _heightCache:Array = [];

	/**
	 * @inheritDoc
	 */
	public function layout(items:Vector.<DisplayObject>, viewPortBounds:ViewPortBounds = null, result:LayoutBoundsResult = null):LayoutBoundsResult
	{
		//this function is very long because it may be called every frame,
		//in some situations. testing revealed that splitting this function
		//into separate, smaller functions affected performance.
		//since the SWC compiler cannot inline functions, we can't use that
		//feature either.

		//since viewPortBounds can be null, we may need to provide some defaults
		var boundsX:Float = viewPortBounds ? viewPortBounds.x : 0;
		var boundsY:Float = viewPortBounds ? viewPortBounds.y : 0;
		var minWidth:Float = viewPortBounds ? viewPortBounds.minWidth : 0;
		var minHeight:Float = viewPortBounds ? viewPortBounds.minHeight : 0;
		var maxWidth:Float = viewPortBounds ? viewPortBounds.maxWidth : Float.POSITIVE_INFINITY;
		var maxHeight:Float = viewPortBounds ? viewPortBounds.maxHeight : Float.POSITIVE_INFINITY;
		var explicitWidth:Float = viewPortBounds ? viewPortBounds.explicitWidth : NaN;
		var explicitHeight:Float = viewPortBounds ? viewPortBounds.explicitHeight : NaN;
		
		//let's figure out if we can show multiple rows
		var supportsMultipleRows:Bool = true;
		var availableRowWidth:Float = explicitWidth;
		if(availableRowWidth != availableRowWidth) //isNaN
		{
			availableRowWidth = maxWidth;
			if(availableRowWidth === Float.POSITIVE_INFINITY)
			{
				supportsMultipleRows = false;
			}
		}

		if(this._useVirtualLayout)
		{
			//if the layout is virtualized, we'll need the dimensions of the
			//typical item so that we have fallback values when an item is null
			if(this._typicalItem is IValidating)
			{
				IValidating(this._typicalItem).validate();
			}
			var calculatedTypicalItemWidth:Float = this._typicalItem ? this._typicalItem.width : 0;
			var calculatedTypicalItemHeight:Float = this._typicalItem ? this._typicalItem.height : 0;
		}

		var i:Int = 0;
		var itemCount:Int = items.length;
		var positionY:Float = boundsY + this._paddingTop;
		var maxItemHeight:Float = 0;
		var horizontalGap:Float = this._horizontalGap;
		var verticalGap:Float = this._verticalGap;
		do
		{
			if(i > 0)
			{
				positionY += maxItemHeight + verticalGap;
			}
			//this section prepares some variables needed for the following loop
			maxItemHeight = this._useVirtualLayout ? calculatedTypicalItemHeight : 0;
			var positionX:Float = boundsX + this._paddingLeft;
			//we save the items in this row to align them later.
			this._rowItems.length = 0;
			var rowItemCount:Int = 0;

			//this first loop sets the x position of items, and it calculates
			//the total width of all items
			for(; i < itemCount; i++)
			{
				var item:DisplayObject = items[i];

				if(this._useVirtualLayout && this._hasVariableItemDimensions)
				{
					var cachedWidth:Float = this._widthCache[i];
					var cachedHeight:Float = this._heightCache[i];
				}
				if(this._useVirtualLayout && !item)
				{
					//the item is null, and the layout is virtualized, so we
					//need to estimate the width of the item.
					
					if(this._hasVariableItemDimensions)
					{
						if(cachedWidth != cachedWidth)
						{
							var itemWidth:Float = calculatedTypicalItemWidth;
						}
						else
						{
							itemWidth = cachedWidth;
						}
						if(cachedHeight != cachedHeight)
						{
							var itemHeight:Float = calculatedTypicalItemHeight;
						}
						else
						{
							itemHeight = cachedHeight;
						}
					}
					else
					{
						itemWidth = calculatedTypicalItemWidth;
						itemHeight = calculatedTypicalItemHeight;
					}
				}
				else
				{
					//we get here if the item isn't null. it is never null if
					//the layout isn't virtualized.
					if(item is ILayoutDisplayObject && !ILayoutDisplayObject(item).includeInLayout)
					{
						continue;
					}
					if(item is IValidating)
					{
						IValidating(item).validate();
					}
					itemWidth = item.width;
					itemHeight = item.height;
					if(this._useVirtualLayout)
					{
						if(this._hasVariableItemDimensions)
						{
							if(itemWidth != cachedWidth)
							{
								//update the cache if needed. this will notify
								//the container that the virtualized layout has
								//changed, and it the view port may need to be
								//re-measured.
								this._widthCache[i] = itemWidth;
								this.dispatchEventWith(Event.CHANGE);
							}
							if(itemHeight != cachedHeight)
							{
								this._heightCache[i] = itemHeight;
								this.dispatchEventWith(Event.CHANGE);
							}
						}
						else
						{
							if(calculatedTypicalItemWidth >= 0)
							{
								item.width = itemWidth = calculatedTypicalItemWidth;
							}
							if(calculatedTypicalItemHeight >= 0)
							{
								item.height = itemHeight = calculatedTypicalItemHeight;
							}
						}
					}
				}
				if(supportsMultipleRows && rowItemCount > 0 && (positionX + itemWidth) > (availableRowWidth - this._paddingRight))
				{
					//we've reached the end of the row, so go to next
					break;
				}
				if(item)
				{
					this._rowItems[this._rowItems.length] = item;
					item.x = item.pivotX + positionX;
				}
				positionX += itemWidth + horizontalGap;
				//we compare with > instead of Math.max() because the rest
				//arguments on Math.max() cause extra garbage collection and
				//hurt performance
				if(itemHeight > maxItemHeight)
				{
					//we need to know the maximum height of the items in the
					//case where the height of the view port needs to be
					//calculated by the layout.
					maxItemHeight = itemHeight;
				}
				rowItemCount++;
			}

			//this is the total width of all items in the row
			var totalRowWidth:Float = positionX - horizontalGap + this._paddingRight - boundsX;
			rowItemCount = this._rowItems.length;

			if(supportsMultipleRows)
			{
				//in this section, we handle horizontal alignment.
				var horizontalAlignOffsetX:Float = 0;
				if(this._horizontalAlign == HORIZONTAL_ALIGN_RIGHT)
				{
					horizontalAlignOffsetX = availableRowWidth - totalRowWidth;
				}
				else if(this._horizontalAlign == HORIZONTAL_ALIGN_CENTER)
				{
					horizontalAlignOffsetX = Math.round((availableRowWidth - totalRowWidth) / 2);
				}
				if(horizontalAlignOffsetX != 0)
				{
					for(var j:Int = 0; j < rowItemCount; j++)
					{
						item = this._rowItems[j];
						if(item is ILayoutDisplayObject && !ILayoutDisplayObject(item).includeInLayout)
						{
							continue;
						}
						item.x += horizontalAlignOffsetX;
					}
				}
			}

			for(j = 0; j < rowItemCount; j++)
			{
				item = this._rowItems[j];
				var layoutItem:ILayoutDisplayObject = item as ILayoutDisplayObject;
				if(layoutItem && !layoutItem.includeInLayout)
				{
					continue;
				}
				//handle all other vertical alignment values. the y position
				//of all items is set here.
				switch(this._rowVerticalAlign)
				{
					case VERTICAL_ALIGN_BOTTOM:
					{
						item.y = item.pivotY + positionY + maxItemHeight - item.height;
						break;
					}
					case VERTICAL_ALIGN_MIDDLE:
					{
						//round to the nearest pixel when dividing by 2 to
						//align in the middle
						item.y = item.pivotY + positionY + Math.round((maxItemHeight - item.height) / 2);
						break;
					}
					default: //top
					{
						item.y = item.pivotY + positionY;
					}
				}
			}
		}
		while(i < itemCount)
		//we don't want to keep a reference to any of the items, so clear
		//this cache
		this._rowItems.length = 0;

		var totalHeight:Float = positionY + maxItemHeight + this._paddingBottom;
		//the available height is the height of the viewport. if the explicit
		//height is NaN, we need to calculate the viewport height ourselves
		//based on the total height of all items.
		var availableHeight:Float = explicitHeight;
		if(availableHeight != availableHeight) //isNaN
		{
			availableHeight = totalHeight;
			if(availableHeight < minHeight)
			{
				availableHeight = minHeight;
			}
			else if(availableHeight > maxHeight)
			{
				availableHeight = maxHeight;
			}
		}
		
		if(totalHeight < availableHeight &&
			this._verticalAlign != VERTICAL_ALIGN_TOP)
		{
			var verticalAlignOffset:Float = availableHeight - totalHeight;
			if(this._verticalAlign === VERTICAL_ALIGN_MIDDLE)
			{
				verticalAlignOffset /= 2;
			}
			for(i = 0; i < itemCount; i++)
			{
				item = items[i];
				if(!item || (item is ILayoutDisplayObject && !ILayoutDisplayObject(item).includeInLayout))
				{
					continue;
				}
				item.y += verticalAlignOffset;
			}
		}

		//finally, we want to calculate the result so that the container
		//can use it to adjust its viewport and determine the minimum and
		//maximum scroll positions (if needed)
		if(!result)
		{
			result = new LayoutBoundsResult();
		}
		result.contentX = 0;
		result.contentWidth = availableRowWidth;
		result.contentY = 0;
		result.contentHeight = totalHeight;
		result.viewPortWidth = availableRowWidth;
		result.viewPortHeight = availableHeight;
		return result;
	}

	/**
	 * @inheritDoc
	 */
	public function measureViewPort(itemCount:Int, viewPortBounds:ViewPortBounds = null, result:Point = null):Point
	{
		if(!result)
		{
			result = new Point();
		}
		if(!this._useVirtualLayout)
		{
			throw new IllegalOperationError("measureViewPort() may be called only if useVirtualLayout is true.")
		}
		//this function is very long because it may be called every frame,
		//in some situations. testing revealed that splitting this function
		//into separate, smaller functions affected performance.
		//since the SWC compiler cannot inline functions, we can't use that
		//feature either.

		//since viewPortBounds can be null, we may need to provide some defaults
		var boundsX:Float = viewPortBounds ? viewPortBounds.x : 0;
		var boundsY:Float = viewPortBounds ? viewPortBounds.y : 0;
		var minWidth:Float = viewPortBounds ? viewPortBounds.minWidth : 0;
		var minHeight:Float = viewPortBounds ? viewPortBounds.minHeight : 0;
		var maxWidth:Float = viewPortBounds ? viewPortBounds.maxWidth : Float.POSITIVE_INFINITY;
		var maxHeight:Float = viewPortBounds ? viewPortBounds.maxHeight : Float.POSITIVE_INFINITY;
		var explicitWidth:Float = viewPortBounds ? viewPortBounds.explicitWidth : NaN;
		var explicitHeight:Float = viewPortBounds ? viewPortBounds.explicitHeight : NaN;

		//let's figure out if we can show multiple rows
		var supportsMultipleRows:Bool = true;
		var availableRowWidth:Float = explicitWidth;
		if(availableRowWidth != availableRowWidth) //isNaN
		{
			availableRowWidth = maxWidth;
			if(availableRowWidth === Float.POSITIVE_INFINITY)
			{
				supportsMultipleRows = false;
			}
		}
		
		if(this._typicalItem is IValidating)
		{
			IValidating(this._typicalItem).validate();
		}
		var calculatedTypicalItemWidth:Float = this._typicalItem ? this._typicalItem.width : 0;
		var calculatedTypicalItemHeight:Float = this._typicalItem ? this._typicalItem.height : 0;

		var i:Int = 0;
		var positionY:Float = boundsY + this._paddingTop;
		var maxItemHeight:Float = 0;
		var horizontalGap:Float = this._horizontalGap;
		var verticalGap:Float = this._verticalGap;
		do
		{
			if(i > 0)
			{
				positionY += maxItemHeight + verticalGap;
			}
			//this section prepares some variables needed for the following loop
			maxItemHeight = this._useVirtualLayout ? calculatedTypicalItemHeight : 0;
			var positionX:Float = boundsX + this._paddingLeft;
			var rowItemCount:Int = 0;

			//this first loop sets the x position of items, and it calculates
			//the total width of all items
			for(; i < itemCount; i++)
			{
				if(this._hasVariableItemDimensions)
				{
					var cachedWidth:Float = this._widthCache[i];
					var cachedHeight:Float = this._heightCache[i];
					if(cachedWidth != cachedWidth)
					{
						var itemWidth:Float = calculatedTypicalItemWidth;
					}
					else
					{
						itemWidth = cachedWidth;
					}
					if(cachedHeight != cachedHeight)
					{
						var itemHeight:Float = calculatedTypicalItemHeight;
					}
					else
					{
						itemHeight = cachedHeight;
					}
				}
				else
				{
					itemWidth = calculatedTypicalItemWidth;
					itemHeight = calculatedTypicalItemHeight;
				}
				if(supportsMultipleRows && rowItemCount > 0 && (positionX + itemWidth) > (availableRowWidth - this._paddingRight))
				{
					//we've reached the end of the row, so go to next
					break;
				}
				positionX += itemWidth + horizontalGap;
				//we compare with > instead of Math.max() because the rest
				//arguments on Math.max() cause extra garbage collection and
				//hurt performance
				if(itemHeight > maxItemHeight)
				{
					//we need to know the maximum height of the items in the
					//case where the height of the view port needs to be
					//calculated by the layout.
					maxItemHeight = itemHeight;
				}
				rowItemCount++;
			}
		}
		while(i < itemCount)
		
		var totalHeight:Float = positionY + maxItemHeight + this._paddingBottom;
		//the available height is the height of the viewport. if the explicit
		//height is NaN, we need to calculate the viewport height ourselves
		//based on the total height of all items.
		var availableHeight:Float = explicitHeight;
		if(availableHeight != availableHeight) //isNaN
		{
			availableHeight = totalHeight;
			if(availableHeight < minHeight)
			{
				availableHeight = minHeight;
			}
			else if(availableHeight > maxHeight)
			{
				availableHeight = maxHeight;
			}
		}

		result.x = availableRowWidth;
		result.y = availableHeight;
		return result;
	}

	/**
	 * @inheritDoc
	 */
	public function getNearestScrollPositionForIndex(index:Int, scrollX:Float, scrollY:Float, items:Vector.<DisplayObject>,
		x:Float, y:Float, width:Float, height:Float, result:Point = null):Point
	{
		result = this.calculateMaxScrollYAndRowHeightOfIndex(index, items, x, y, width, height, result);
		var maxScrollY:Float = result.x;
		var rowHeight:Float = result.y;
		
		result.x = 0;
		
		var bottomPosition:Float = maxScrollY - (height - rowHeight);
		if(scrollY >= bottomPosition && scrollY <= maxScrollY)
		{
			//keep the current scroll position because the item is already
			//fully visible
			result.y = scrollY;
		}
		else
		{
			var topDifference:Float = Math.abs(maxScrollY - scrollY);
			var bottomDifference:Float = Math.abs(bottomPosition - scrollY);
			if(bottomDifference < topDifference)
			{
				result.y = bottomPosition;
			}
			else
			{
				result.y = maxScrollY;
			}
		}

		return result;
	}

	/**
	 * @inheritDoc
	 */
	public function getScrollPositionForIndex(index:Int, items:Vector.<DisplayObject>, x:Float, y:Float, width:Float, height:Float, result:Point = null):Point
	{
		result = this.calculateMaxScrollYAndRowHeightOfIndex(index, items, x, y, width, height, result);
		var maxScrollY:Float = result.x;
		var rowHeight:Float = result.y;

		if(this._useVirtualLayout)
		{
			if(this._hasVariableItemDimensions)
			{
				var itemHeight:Float = this._heightCache[index];
				if(itemHeight != itemHeight) //isNaN
				{
					itemHeight = this._typicalItem.height;
				}
			}
			else
			{
				itemHeight = this._typicalItem.height;
			}
		}
		else
		{
			itemHeight = items[index].height;
		}

		if(!result)
		{
			result = new Point();
		}
		result.x = 0;
		result.y = maxScrollY - Math.round((height - itemHeight) / 2);

		return result;
	}

	/**
	 * @inheritDoc
	 */
	public function resetVariableVirtualCache():Void
	{
		this._widthCache.length = 0;
		this._heightCache.length = 0;
	}

	/**
	 * @inheritDoc
	 */
	public function resetVariableVirtualCacheAtIndex(index:Int, item:DisplayObject = null):Void
	{
		delete this._widthCache[index];
		delete this._heightCache[index];
		if(item)
		{
			this._widthCache[index] = item.width;
			this._heightCache[index] = item.height;
			this.dispatchEventWith(Event.CHANGE);
		}
	}

	/**
	 * @inheritDoc
	 */
	public function addToVariableVirtualCacheAtIndex(index:Int, item:DisplayObject = null):Void
	{
		var widthValue:* = item ? item.width: undefined;
		this._widthCache.splice(index, 0, widthValue);
		
		var heightValue:* = item ? item.height : undefined;
		this._heightCache.splice(index, 0, heightValue);
	}

	/**
	 * @inheritDoc
	 */
	public function removeFromVariableVirtualCacheAtIndex(index:Int):Void
	{
		this._widthCache.splice(index, 1);
		this._heightCache.splice(index, 1);
	}

	/**
	 * @inheritDoc
	 */
	public function getVisibleIndicesAtScrollPosition(scrollX:Float, scrollY:Float, width:Float, height:Float, itemCount:Int, result:Vector.<Int> = null):Vector.<Int>
	{
		if(result)
		{
			result.length = 0;
		}
		else
		{
			result = new <Int>[];
		}
		if(!this._useVirtualLayout)
		{
			throw new IllegalOperationError("getVisibleIndicesAtScrollPosition() may be called only if useVirtualLayout is true.")
		}

		if(this._typicalItem is IValidating)
		{
			IValidating(this._typicalItem).validate();
		}
		var calculatedTypicalItemWidth:Float = this._typicalItem ? this._typicalItem.width : 0;
		var calculatedTypicalItemHeight:Float = this._typicalItem ? this._typicalItem.height : 0;

		var resultLastIndex:Int = 0;

		var i:Int = 0;
		var positionY:Float = this._paddingTop;
		var maxItemHeight:Float = 0;
		var horizontalGap:Float = this._horizontalGap;
		var verticalGap:Float = this._verticalGap;
		var maxPositionY:Float = scrollY + height;
		do
		{
			if(i > 0)
			{
				positionY += maxItemHeight + verticalGap;
				if(positionY >= maxPositionY)
				{
					//the following rows will not be visible, so we can stop
					break;
				}
			}
			//this section prepares some variables needed for the following loop
			maxItemHeight = calculatedTypicalItemHeight;
			var positionX:Float = this._paddingLeft;
			var rowItemCount:Int = 0;

			//this first loop sets the x position of items, and it calculates
			//the total width of all items
			for(; i < itemCount; i++)
			{
				if(this._hasVariableItemDimensions)
				{
					var cachedWidth:Float = this._widthCache[i];
					var cachedHeight:Float = this._heightCache[i];
				}
				if(this._hasVariableItemDimensions)
				{
					if(cachedWidth != cachedWidth)
					{
						var itemWidth:Float = calculatedTypicalItemWidth;
					}
					else
					{
						itemWidth = cachedWidth;
					}
					if(cachedHeight != cachedHeight)
					{
						var itemHeight:Float = calculatedTypicalItemHeight;
					}
					else
					{
						itemHeight = cachedHeight;
					}
				}
				else
				{
					itemWidth = calculatedTypicalItemWidth;
					itemHeight = calculatedTypicalItemHeight;
				}
				if(rowItemCount > 0 && (positionX + itemWidth) > (width - this._paddingRight))
				{
					//we've reached the end of the row, so go to next
					break;
				}
				if((positionY + itemHeight) > scrollY)
				{
					result[resultLastIndex] = i;
					resultLastIndex++;
				}
				positionX += itemWidth + horizontalGap;
				//we compare with > instead of Math.max() because the rest
				//arguments on Math.max() cause extra garbage collection and
				//hurt performance
				if(itemHeight > maxItemHeight)
				{
					//we need to know the maximum height of the items in the
					//case where the height of the view port needs to be
					//calculated by the layout.
					maxItemHeight = itemHeight;
				}
				rowItemCount++;
			}
		}
		while(i < itemCount)
		return result;
	}

	/**
	 * @private
	 */
	private function calculateMaxScrollYAndRowHeightOfIndex(index:Int, items:Vector.<DisplayObject>,
		x:Float, y:Float, width:Float, height:Float, result:Point = null):Point
	{
		if(!result)
		{
			result = new Point();
		}
		if(this._useVirtualLayout)
		{
			//if the layout is virtualized, we'll need the dimensions of the
			//typical item so that we have fallback values when an item is null
			if(this._typicalItem is IValidating)
			{
				IValidating(this._typicalItem).validate();
			}
			var calculatedTypicalItemWidth:Float = this._typicalItem ? this._typicalItem.width : 0;
			var calculatedTypicalItemHeight:Float = this._typicalItem ? this._typicalItem.height : 0;
		}

		var horizontalGap:Float = this._horizontalGap;
		var verticalGap:Float = this._verticalGap;
		var maxItemHeight:Float = 0;
		var positionY:Float = y + this._paddingTop;
		var i:Int = 0;
		var itemCount:Int = items.length;
		var isLastRow:Bool = false;
		do
		{
			if(isLastRow)
			{
				break;
			}
			if(i > 0)
			{
				positionY += maxItemHeight + verticalGap;
			}
			//this section prepares some variables needed for the following loop
			maxItemHeight = this._useVirtualLayout ? calculatedTypicalItemHeight : 0;
			var positionX:Float = x + this._paddingLeft;
			var rowItemCount:Int = 0;
			for(; i < itemCount; i++)
			{
				var item:DisplayObject = items[i];

				if(this._useVirtualLayout && this._hasVariableItemDimensions)
				{
					var cachedWidth:Float = this._widthCache[i];
					var cachedHeight:Float = this._heightCache[i];
				}
				if(this._useVirtualLayout && !item)
				{
					//the item is null, and the layout is virtualized, so we
					//need to estimate the width of the item.

					if(this._hasVariableItemDimensions)
					{
						if(cachedWidth != cachedWidth) //isNaN
						{
							var itemWidth:Float = calculatedTypicalItemWidth;
						}
						else
						{
							itemWidth = cachedWidth;
						}
						if(cachedHeight != cachedHeight) //isNaN
						{
							var itemHeight:Float = calculatedTypicalItemHeight;
						}
						else
						{
							itemHeight = cachedHeight;
						}
					}
					else
					{
						itemWidth = calculatedTypicalItemWidth;
						itemHeight = calculatedTypicalItemHeight;
					}
				}
				else
				{
					//we get here if the item isn't null. it is never null if
					//the layout isn't virtualized.
					if(item is ILayoutDisplayObject && !ILayoutDisplayObject(item).includeInLayout)
					{
						continue;
					}
					if(item is IValidating)
					{
						IValidating(item).validate();
					}
					itemWidth = item.width;
					itemHeight = item.height;
					if(this._useVirtualLayout && this._hasVariableItemDimensions)
					{
						if(this._hasVariableItemDimensions)
						{
							if(itemWidth != cachedWidth)
							{
								this._widthCache[i] = itemWidth;
								this.dispatchEventWith(Event.CHANGE);
							}
							if(itemHeight != cachedHeight)
							{
								this._heightCache[i] = itemHeight;
								this.dispatchEventWith(Event.CHANGE);
							}
						}
						else
						{
							if(calculatedTypicalItemWidth >= 0)
							{
								itemWidth = calculatedTypicalItemWidth;
							}
							if(calculatedTypicalItemHeight >= 0)
							{
								itemHeight = calculatedTypicalItemHeight;
							}
						}
					}
				}
				if(rowItemCount > 0 && (positionX + itemWidth) > (width - this._paddingRight))
				{
					//we've reached the end of the row, so go to next
					break;
				}
				//we don't check this at the beginning of the loop because
				//it may break to start a new row and then redo this item
				if(i === index)
				{
					isLastRow = true;
				}
				//we compare with > instead of Math.max() because the rest
				//arguments on Math.max() cause extra garbage collection and
				//hurt performance
				if(itemHeight > maxItemHeight)
				{
					//we need to know the maximum height of the items in the
					//case where the height of the view port needs to be
					//calculated by the layout.
					maxItemHeight = itemHeight;
				}
				positionX += itemWidth + horizontalGap;
				rowItemCount++;
			}
		}
		while(i < itemCount)
		result.setTo(positionY, maxItemHeight);
		return result;
	}
}
}
