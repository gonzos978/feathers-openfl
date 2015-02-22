/*
Feathers
Copyright 2012-2014 Joshua Tynjala. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.controls;
import feathers.controls.renderers.DefaultGroupedListHeaderOrFooterRenderer;
import feathers.controls.renderers.DefaultGroupedListItemRenderer;
import feathers.controls.supportClasses.GroupedListDataViewPort;
import feathers.core.IFocusDisplayObject;
import feathers.core.PropertyProxy;
import feathers.data.HierarchicalCollection;
import feathers.events.CollectionEventType;
import feathers.layout.ILayout;
import feathers.layout.VerticalLayout;
import feathers.skins.IStyleProvider;

import openfl.geom.Point;
import openfl.ui.Keyboard;

import starling.events.Event;
import starling.events.KeyboardEvent;

/**
 * Dispatched when the selected item changes.
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
//[Event(name="change",type="starling.events.Event")]

/**
 * Dispatched when an item renderer is added to the list. When the layout is
 * virtualized, item renderers may not exist for every item in the data
 * provider. This event can be used to track which items currently have
 * renderers.
 *
 * <p>The properties of the event object have the following values:</p>
 * <table class="innertable">
 * <tr><th>Property</th><th>Value</th></tr>
 * <tr><td><code>bubbles</code></td><td>false</td></tr>
 * <tr><td><code>currentTarget</code></td><td>The Object that defines the
 *   event listener that handles the event. For example, if you use
 *   <code>myButton.addEventListener()</code> to register an event listener,
 *   myButton is the value of the <code>currentTarget</code>.</td></tr>
 * <tr><td><code>data</code></td><td>The item renderer that was added</td></tr>
 * <tr><td><code>target</code></td><td>The Object that dispatched the event;
 *   it is not always the Object listening for the event. Use the
 *   <code>currentTarget</code> property to always access the Object
 *   listening for the event.</td></tr>
 * </table>
 *
 * @eventType feathers.events.FeathersEventType.RENDERER_ADD
 */
//[Event(name="rendererAdd",type="starling.events.Event")]

/**
 * Dispatched when an item renderer is removed from the list. When the layout is
 * virtualized, item renderers may not exist for every item in the data
 * provider. This event can be used to track which items currently have
 * renderers.
 *
 * <p>The properties of the event object have the following values:</p>
 * <table class="innertable">
 * <tr><th>Property</th><th>Value</th></tr>
 * <tr><td><code>bubbles</code></td><td>false</td></tr>
 * <tr><td><code>currentTarget</code></td><td>The Object that defines the
 *   event listener that handles the event. For example, if you use
 *   <code>myButton.addEventListener()</code> to register an event listener,
 *   myButton is the value of the <code>currentTarget</code>.</td></tr>
 * <tr><td><code>data</code></td><td>The item renderer that was removed</td></tr>
 * <tr><td><code>target</code></td><td>The Object that dispatched the event;
 *   it is not always the Object listening for the event. Use the
 *   <code>currentTarget</code> property to always access the Object
 *   listening for the event.</td></tr>
 * </table>
 *
 * @eventType feathers.events.FeathersEventType.RENDERER_REMOVE
 */
//[Event(name="rendererRemove",type="starling.events.Event")]

[DefaultProperty("dataProvider")]
/**
 * Displays a list of items divided into groups or sections. Takes a
 * hierarchical provider limited to two levels of hierarchy. This component
 * supports scrolling, custom item (and header and footer) renderers, and
 * custom layouts.
 *
 * <p>Layouts may be, and are highly encouraged to be, <em>virtual</em>,
 * meaning that the List is capable of creating a limited number of item
 * renderers to display a subset of the data provider instead of creating a
 * renderer for every single item. This allows for optimal performance with
 * very large data providers.</p>
 *
 * <p>The following example creates a grouped list, gives it a data
 * provider, tells the item renderer how to interpret the data, and listens
 * for when the selection changes:</p>
 *
 * <listing version="3.0">
 * var list:GroupedList = new GroupedList();
 *
 * list.dataProvider = new HierarchicalCollection(
 * [
 *     {
 *     	   header: "Dairy",
 *     	   children:
 *     	   [
 *     	       { text: "Milk", thumbnail: textureAtlas.getTexture( "milk" ) },
 *     	       { text: "Cheese", thumbnail: textureAtlas.getTexture( "cheese" ) },
 *     	   ]
 *     },
 *     {
 *         header: "Bakery",
 *         children:
 *         [
 *             { text: "Bread", thumbnail: textureAtlas.getTexture( "bread" ) },
 *         ]
 *     },
 *     {
 *         header: "Produce",
 *         children:
 *         [
 *             { text: "Bananas", thumbnail: textureAtlas.getTexture( "bananas" ) },
 *             { text: "Lettuce", thumbnail: textureAtlas.getTexture( "lettuce" ) },
 *             { text: "Onion", thumbnail: textureAtlas.getTexture( "onion" ) },
 *         ]
 *     },
 * ]);
 *
 * list.itemRendererFactory = function():IGroupedListItemRenderer
 * {
 *     var renderer:DefaultGroupedListItemRenderer = new DefaultGroupedListItemRenderer();
 *     renderer.labelField = "text";
 *     renderer.iconSourceField = "thumbnail";
 *     return renderer;
 * };
 *
 * list.addEventListener( Event.CHANGE, list_changeHandler );
 *
 * this.addChild( list );</listing>
 *
 * @see http://wiki.starling-framework.org/feathers/grouped-list
 */
class GroupedList extends Scroller implements IFocusDisplayObject
{
	/**
	 * @private
	 */
	private static var HELPER_POINT:Point = new Point();

	/**
	 * The default <code>IStyleProvider</code> for all <code>GroupedList</code>
	 * components.
	 *
	 * @default null
	 * @see feathers.core.FeathersControl#styleProvider
	 */
	public static var globalStyleProvider:IStyleProvider;

	/**
	 * An alternate name to use with GroupedList to allow a theme to give it
	 * an inset style. If a theme does not provide a skin for the inset
	 * grouped list, the theme will automatically fall back to using the
	 * default grouped list skin.
	 *
	 * <p>An alternate name should always be added to a component's
	 * <code>styleNameList</code> before the component is added to the stage for
	 * the first time. If it is added later, it will be ignored.</p>
	 *
	 * <p>In the following example, the inset style is applied to a grouped
	 * list:</p>
	 *
	 * <listing version="3.0">
	 * var list:GroupedList = new GroupedList();
	 * list.styleNameList.add( GroupedList.ALTERNATE_NAME_INSET_GROUPED_LIST );
	 * this.addChild( list );</listing>
	 *
	 * @see feathers.core.FeathersControl#styleNameList
	 */
	inline public static var ALTERNATE_NAME_INSET_GROUPED_LIST:String = "feathers-inset-grouped-list";

	/**
	 * The default name to use with header renderers.
	 *
	 * @see feathers.core.FeathersControl#styleNameList
	 */
	inline public static var DEFAULT_CHILD_NAME_HEADER_RENDERER:String = "feathers-grouped-list-header-renderer";

	/**
	 * An alternate name to use with header renderers to give them an inset
	 * style. This name is usually only referenced inside themes.
	 *
	 * <p>In the following example, the inset style is applied to a grouped
	 * list's header:</p>
	 *
	 * <listing version="3.0">
	 * list.headerRendererName = GroupedList.ALTERNATE_CHILD_NAME_INSET_HEADER_RENDERER;</listing>
	 *
	 * @see feathers.core.FeathersControl#styleNameList
	 */
	inline public static var ALTERNATE_CHILD_NAME_INSET_HEADER_RENDERER:String = "feathers-grouped-list-inset-header-renderer";

	/**
	 * The default name to use with footer renderers.
	 *
	 * @see feathers.core.FeathersControl#styleNameList
	 */
	inline public static var DEFAULT_CHILD_NAME_FOOTER_RENDERER:String = "feathers-grouped-list-footer-renderer";

	/**
	 * An alternate name to use with footer renderers to give them an inset
	 * style. This name is usually only referenced inside themes.
	 *
	 * <p>In the following example, the inset style is applied to a grouped
	 * list's footer:</p>
	 *
	 * <listing version="3.0">
	 * list.footerRendererName = GroupedList.ALTERNATE_CHILD_NAME_INSET_FOOTER_RENDERER;</listing>
	 */
	inline public static var ALTERNATE_CHILD_NAME_INSET_FOOTER_RENDERER:String = "feathers-grouped-list-inset-footer-renderer";

	/**
	 * An alternate name to use with item renderers to give them an inset
	 * style. This name is usually only referenced inside themes.
	 *
	 * <p>In the following example, the inset style is applied to a grouped
	 * list's item renderer:</p>
	 *
	 * <listing version="3.0">
	 * list.itemRendererRendererName = GroupedList.ALTERNATE_CHILD_NAME_INSET_ITEM_RENDERER;</listing>
	 *
	 * @see feathers.core.FeathersControl#styleNameList
	 */
	inline public static var ALTERNATE_CHILD_NAME_INSET_ITEM_RENDERER:String = "feathers-grouped-list-inset-item-renderer";

	/**
	 * An alternate name to use for item renderers to give them an inset
	 * style. Typically meant to be used for the renderer of the first item
	 * in a group. This name is usually only referenced inside themes.
	 *
	 * <p>In the following example, the inset style is applied to a grouped
	 * list's first item renderer:</p>
	 *
	 * <listing version="3.0">
	 * list.firstItemRendererRendererName = GroupedList.ALTERNATE_CHILD_NAME_INSET_FIRST_ITEM_RENDERER;</listing>
	 *
	 * @see feathers.core.FeathersControl#styleNameList
	 */
	inline public static var ALTERNATE_CHILD_NAME_INSET_FIRST_ITEM_RENDERER:String = "feathers-grouped-list-inset-first-item-renderer";

	/**
	 * An alternate name to use for item renderers to give them an inset
	 * style. Typically meant to be used for the renderer of the last item
	 * in a group. This name is usually only referenced inside themes.
	 *
	 * <p>In the following example, the inset style is applied to a grouped
	 * list's last item renderer:</p>
	 *
	 * <listing version="3.0">
	 * list.lastItemRendererRendererName = GroupedList.ALTERNATE_CHILD_NAME_INSET_LAST_ITEM_RENDERER;</listing>
	 *
	 * @see feathers.core.FeathersControl#styleNameList
	 */
	inline public static var ALTERNATE_CHILD_NAME_INSET_LAST_ITEM_RENDERER:String = "feathers-grouped-list-inset-last-item-renderer";

	/**
	 * An alternate name to use for item renderers to give them an inset
	 * style. Typically meant to be used for the renderer of an item in a
	 * group that has no other items. This name is usually only referenced
	 * inside themes.
	 *
	 * <p>In the following example, the inset style is applied to a grouped
	 * list's single item renderer:</p>
	 *
	 * <listing version="3.0">
	 * list.singleItemRendererName = GroupedList.ALTERNATE_CHILD_NAME_INSET_SINGLE_ITEM_RENDERER;</listing>
	 *
	 * @see feathers.core.FeathersControl#styleNameList
	 */
	inline public static var ALTERNATE_CHILD_NAME_INSET_SINGLE_ITEM_RENDERER:String = "feathers-grouped-list-inset-single-item-renderer";

	/**
	 * @copy feathers.controls.Scroller#SCROLL_POLICY_AUTO
	 *
	 * @see feathers.controls.Scroller#horizontalScrollPolicy
	 * @see feathers.controls.Scroller#verticalScrollPolicy
	 */
	inline public static var SCROLL_POLICY_AUTO:String = "auto";

	/**
	 * @copy feathers.controls.Scroller#SCROLL_POLICY_ON
	 *
	 * @see feathers.controls.Scroller#horizontalScrollPolicy
	 * @see feathers.controls.Scroller#verticalScrollPolicy
	 */
	inline public static var SCROLL_POLICY_ON:String = "on";

	/**
	 * @copy feathers.controls.Scroller#SCROLL_POLICY_OFF
	 *
	 * @see feathers.controls.Scroller#horizontalScrollPolicy
	 * @see feathers.controls.Scroller#verticalScrollPolicy
	 */
	inline public static var SCROLL_POLICY_OFF:String = "off";

	/**
	 * @copy feathers.controls.Scroller#SCROLL_BAR_DISPLAY_MODE_FLOAT
	 *
	 * @see feathers.controls.Scroller#scrollBarDisplayMode
	 */
	inline public static var SCROLL_BAR_DISPLAY_MODE_FLOAT:String = "float";

	/**
	 * @copy feathers.controls.Scroller#SCROLL_BAR_DISPLAY_MODE_FIXED
	 *
	 * @see feathers.controls.Scroller#scrollBarDisplayMode
	 */
	inline public static var SCROLL_BAR_DISPLAY_MODE_FIXED:String = "fixed";

	/**
	 * @copy feathers.controls.Scroller#SCROLL_BAR_DISPLAY_MODE_NONE
	 *
	 * @see feathers.controls.Scroller#scrollBarDisplayMode
	 */
	inline public static var SCROLL_BAR_DISPLAY_MODE_NONE:String = "none";

	/**
	 * The vertical scroll bar will be positioned on the right.
	 *
	 * @see feathers.controls.Scroller#verticalScrollBarPosition
	 */
	inline public static var VERTICAL_SCROLL_BAR_POSITION_RIGHT:String = "right";

	/**
	 * The vertical scroll bar will be positioned on the left.
	 *
	 * @see feathers.controls.Scroller#verticalScrollBarPosition
	 */
	inline public static var VERTICAL_SCROLL_BAR_POSITION_LEFT:String = "left";

	/**
	 * @copy feathers.controls.Scroller#INTERACTION_MODE_TOUCH
	 *
	 * @see feathers.controls.Scroller#interactionMode
	 */
	inline public static var INTERACTION_MODE_TOUCH:String = "touch";

	/**
	 * @copy feathers.controls.Scroller#INTERACTION_MODE_MOUSE
	 *
	 * @see feathers.controls.Scroller#interactionMode
	 */
	inline public static var INTERACTION_MODE_MOUSE:String = "mouse";

	/**
	 * @copy feathers.controls.Scroller#INTERACTION_MODE_TOUCH_AND_SCROLL_BARS
	 *
	 * @see feathers.controls.Scroller#interactionMode
	 */
	inline public static var INTERACTION_MODE_TOUCH_AND_SCROLL_BARS:String = "touchAndScrollBars";

	/**
	 * @copy feathers.controls.Scroller#DECELERATION_RATE_NORMAL
	 *
	 * @see feathers.controls.Scroller#decelerationRate
	 */
	inline public static var DECELERATION_RATE_NORMAL:Float = 0.998;

	/**
	 * @copy feathers.controls.Scroller#DECELERATION_RATE_FAST
	 *
	 * @see feathers.controls.Scroller#decelerationRate
	 */
	inline public static var DECELERATION_RATE_FAST:Float = 0.99;

	/**
	 * Constructor.
	 */
	public function GroupedList()
	{
		super();
	}

	/**
	 * @private
	 * The guts of the List's functionality. Handles layout and selection.
	 */
	private var dataViewPort:GroupedListDataViewPort;

	/**
	 * @private
	 */
	override private function get_defaultStyleProvider():IStyleProvider
	{
		return GroupedList.globalStyleProvider;
	}

	/**
	 * @private
	 */
	override public var isFocusEnabled(get, set):Bool;
public function get_isFocusEnabled():Bool
	{
		return this._isSelectable && this._isEnabled && this._isFocusEnabled;
	}

	/**
	 * @private
	 */
	private var _layout:ILayout;

	/**
	 * The layout algorithm used to position and, optionally, size the
	 * list's items.
	 *
	 * <p>By default, if no layout is provided by the time that the list
	 * initializes, a vertical layout with options targeted at touch screens
	 * is created.</p>
	 *
	 * <p>The following example tells the list to use a horizontal layout:</p>
	 *
	 * <listing version="3.0">
	 * var layout:HorizontalLayout = new HorizontalLayout();
	 * layout.gap = 20;
	 * layout.padding = 20;
	 * list.layout = layout;</listing>
	 */
	public var layout(get, set):ILayout;
	public function get_layout():ILayout
	{
		return this._layout;
	}

	/**
	 * @private
	 */
	public function set_layout(value:ILayout):ILayout
	{
		if(this._layout == value)
		{
			return;
		}
		this._layout = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_LAYOUT);
	}

	/**
	 * @private
	 */
	private var _dataProvider:HierarchicalCollection;

	/**
	 * The collection of data displayed by the list. Changing this property
	 * to a new value is considered a drastic change to the list's data, so
	 * the horizontal and vertical scroll positions will be reset, and the
	 * list's selection will be cleared.
	 *
	 * <p>The following example passes in a data provider and tells the item
	 * renderer how to interpret the data:</p>
	 *
	 * <listing version="3.0">
	 * list.dataProvider = new HierarchicalCollection(
	 * [
	 *     {
	 *     	   header: "Dairy",
	 *     	   children:
	 *     	   [
	 *     	       { text: "Milk", thumbnail: textureAtlas.getTexture( "milk" ) },
	 *     	       { text: "Cheese", thumbnail: textureAtlas.getTexture( "cheese" ) },
	 *     	   ]
	 *     },
	 *     {
	 *         header: "Bakery",
	 *         children:
	 *         [
	 *             { text: "Bread", thumbnail: textureAtlas.getTexture( "bread" ) },
	 *         ]
	 *     },
	 *     {
	 *         header: "Produce",
	 *         children:
	 *         [
	 *             { text: "Bananas", thumbnail: textureAtlas.getTexture( "bananas" ) },
	 *             { text: "Lettuce", thumbnail: textureAtlas.getTexture( "lettuce" ) },
	 *             { text: "Onion", thumbnail: textureAtlas.getTexture( "onion" ) },
	 *         ]
	 *     },
	 * ]);
	 *
	 * list.itemRendererFactory = function():IGroupedListItemRenderer
	 * {
	 *     var renderer:DefaultGroupedListItemRenderer = new DefaultGroupedListItemRenderer();
	 *     renderer.labelField = "text";
	 *     renderer.iconSourceField = "thumbnail";
	 *     return renderer;
	 * };</listing>
	 *
	 * <p>By default, a <code>HierarchicalCollection</code> accepts an
	 * <code>Array</code> containing objects for each group. By default, the
	 * <code>header</code> and <code>footer</code> fields in each group will
	 * contain data to pass to the header and footer renderers of the
	 * grouped list. The <code>children</code> field of each group should be
	 * be an <code>Array</code> of data where each item is passed to an item
	 * renderer.</p>
	 *
	 * <p>A custom <em>data descriptor</em> may be passed to the
	 * <code>HierarchicalCollection</code> to tell it to parse the data
	 * source differently than the default behavior described above. For
	 * instance, you might want to use <code>Vector</code> instead of
	 * <code>Array</code> or structure the data differently. Custom data
	 * descriptors may be implemented with the
	 * <code>IHierarchicalCollectionDataDescriptor</code> interface.</p>
	 *
	 * <p><em>Warning:</em> A grouped list's data provider cannot contain
	 * duplicate items. To display the same item in multiple item renderers,
	 * you must create separate objects with the same properties. This
	 * limitation exists because it significantly improves performance.</p>
	 *
	 * <p><em>Warning:</em> If the data provider contains display objects,
	 * concrete textures, or anything that needs to be disposed, those
	 * objects will not be automatically disposed when the grouped list is
	 * disposed. Similar to how <code>starling.display.Image</code> cannot
	 * automatically dispose its texture because the texture may be used
	 * by other display objects, a list cannot dispose its data provider
	 * because the data provider may be used by other lists. See the
	 * <code>dispose()</code> function on <code>HierarchicalCollection</code>
	 * to see how the data provider can be disposed properly.</p>
	 *
	 * @default null
	 *
	 * @see feathers.data.HierarchicalCollection
	 * @see feathers.data.IHierarchicalCollectionDataDescriptor
	 */
	public var dataProvider(get, set):HierarchicalCollection;
	public function get_dataProvider():HierarchicalCollection
	{
		return this._dataProvider;
	}

	/**
	 * @private
	 */
	public function set_dataProvider(value:HierarchicalCollection):HierarchicalCollection
	{
		if(this._dataProvider == value)
		{
			return;
		}
		if(this._dataProvider)
		{
			this._dataProvider.removeEventListener(CollectionEventType.RESET, dataProvider_resetHandler);
			this._dataProvider.removeEventListener(Event.CHANGE, dataProvider_changeHandler);
		}
		this._dataProvider = value;
		if(this._dataProvider)
		{
			this._dataProvider.addEventListener(CollectionEventType.RESET, dataProvider_resetHandler);
			this._dataProvider.addEventListener(Event.CHANGE, dataProvider_changeHandler);
		}

		//reset the scroll position because this is a drastic change and
		//the data is probably completely different
		this.horizontalScrollPosition = 0;
		this.verticalScrollPosition = 0;

		//clear the selection for the same reason
		this.setSelectedLocation(-1, -1);

		this.invalidate(FeathersControl.INVALIDATION_FLAG_DATA);
	}

	/**
	 * @private
	 */
	private var _isSelectable:Bool = true;

	/**
	 * Determines if an item in the list may be selected.
	 *
	 * <p>The following example disables selection:</p>
	 *
	 * <listing version="3.0">
 	 * list.isSelectable = false;</listing>
	 *
	 * @default true
	 */
	public var isSelectable(get, set):Bool;
	public function get_isSelectable():Bool
	{
		return this._isSelectable;
	}

	/**
	 * @private
	 */
	public function set_isSelectable(value:Bool):Bool
	{
		if(this._isSelectable == value)
		{
			return;
		}
		this._isSelectable = value;
		if(!this._isSelectable)
		{
			this.setSelectedLocation(-1, -1);
		}
		this.invalidate(FeathersControl.INVALIDATION_FLAG_SELECTED);
	}

	/**
	 * @private
	 */
	private var _selectedGroupIndex:Int = -1;

	/**
	 * The group index of the currently selected item. Returns <code>-1</code>
	 * if no item is selected.
	 *
	 * <p>Because the selection consists of both a group index and an item
	 * index, this property does not have a setter. To change the selection,
	 * call <code>setSelectedLocation()</code> instead.</p>
	 *
	 * <p>The following example listens for when selection changes and
	 * requests the selected group index and selected item index:</p>
	 *
	 * <listing version="3.0">
	 * function list_changeHandler( event:Event ):Void
	 * {
	 *     var list:List = GroupedList(event.currentTarget);
	 *     var groupIndex:Int = list.selectedGroupIndex;
	 *     var itemIndex:Int = list.selectedItemIndex;
	 *
	 * }
	 * list.addEventListener( Event.CHANGE, list_changeHandler );</listing>
	 *
	 * @default -1
	 *
	 * @see #selectedItemIndex
	 * @see #setSelectedLocation()
	 */
	public var selectedGroupIndex(get, set):Int;
	public function get_selectedGroupIndex():Int
	{
		return this._selectedGroupIndex;
	}

	/**
	 * @private
	 */
	private var _selectedItemIndex:Int = -1;

	/**
	 * The item index of the currently selected item. Returns <code>-1</code>
	 * if no item is selected.
	 *
	 * <p>Because the selection consists of both a group index and an item
	 * index, this property does not have a setter. To change the selection,
	 * call <code>setSelectedLocation()</code> instead.</p>
	 *
	 * <p>The following example listens for when selection changes and
	 * requests the selected group index and selected item index:</p>
	 *
	 * <listing version="3.0">
	 * function list_changeHandler( event:Event ):Void
	 * {
	 *     var list:GroupedList = GroupedList( event.currentTarget );
	 *     var groupIndex:Int = list.selectedGroupIndex;
	 *     var itemIndex:Int = list.selectedItemIndex;
	 *
	 * }
	 * list.addEventListener( Event.CHANGE, list_changeHandler );</listing>
	 *
	 * @default -1
	 *
	 * @see #selectedGroupIndex
	 * @see #setSelectedLocation()
	 */
	public var selectedItemIndex(get, set):Int;
	public function get_selectedItemIndex():Int
	{
		return this._selectedItemIndex;
	}

	/**
	 * The currently selected item. Returns <code>null</code> if no item is
	 * selected.
	 *
	 * <p>The following example listens for when selection changes and
	 * requests the selected item:</p>
	 *
	 * <listing version="3.0">
	 * function list_changeHandler( event:Event ):Void
	 * {
	 *     var list:GroupedList = GroupedList( event.currentTarget );
	 *     var item:Dynamic = list.selectedItem;
	 *
	 * }
	 * list.addEventListener( Event.CHANGE, list_changeHandler );</listing>
	 *
	 * @default null
	 */
	public var selectedItem(get, set):Dynamic;
	public function get_selectedItem():Dynamic
	{
		if(!this._dataProvider || this._selectedGroupIndex < 0 || this._selectedItemIndex < 0)
		{
			return null;
		}
		return this._dataProvider.getItemAt(this._selectedGroupIndex, this._selectedItemIndex);
	}

	/**
	 * @private
	 */
	public function set_selectedItem(value:Dynamic):Dynamic
	{
		if(!this._dataProvider)
		{
			this.setSelectedLocation(-1, -1);
			return;
		}
		var result:Array<Int> = this._dataProvider.getItemLocation(value);
		if(result.length == 2)
		{
			this.setSelectedLocation(result[0], result[1]);
		}
		else
		{
			this.setSelectedLocation(-1, -1);
		}
	}

	/**
	 * @private
	 */
	private var _itemRendererType:Class<Dynamic> = DefaultGroupedListItemRenderer;

	/**
	 * The class used to instantiate item renderers. Must implement the
	 * <code>IGroupedListItemRenderer</code> interface.
	 *
	 * <p>To customize properties on the item renderer, use
	 * <code>itemRendererFactory</code> instead.</p>
	 *
	 * <p>The following example changes the item renderer type:</p>
	 *
	 * <listing version="3.0">
	 * list.itemRendererType = CustomItemRendererClass;</listing>
	 *
	 * <p>The first item and last item in a group may optionally use
	 * different item renderer types, if desired. Use the
	 * <code>firstItemRendererType</code> and <code>lastItemRendererType</code>,
	 * respectively. Additionally, if a group contains only one item, it may
	 * also have a different type. Use the <code>singleItemRendererType</code>.
	 * Finally, factories for each of these types may also be customized.</p>
	 *
	 * @default feathers.controls.renderers.DefaultGroupedListItemRenderer
	 *
	 * @see feathers.controls.renderers.IGroupedListItemRenderer
	 * @see #itemRendererFactory
	 * @see #firstItemRendererType
	 * @see #lastItemRendererType
	 * @see #singleItemRendererType
	 */
	public var itemRendererType(get, set):Class;
	public function get_itemRendererType():Class
	{
		return this._itemRendererType;
	}

	/**
	 * @private
	 */
	public function set_itemRendererType(value:Class<Dynamic>):Class<Dynamic>
	{
		if(this._itemRendererType == value)
		{
			return;
		}

		this._itemRendererType = value;
		this.invalidate(INVALIDATION_FLAG_STYLES);
	}

	/**
	 * @private
	 */
	private var _itemRendererFactory:Dynamic;

	/**
	 * A function called that is expected to return a new item renderer. Has
	 * a higher priority than <code>itemRendererType</code>. Typically, you
	 * would use an <code>itemRendererFactory</code> instead of an
	 * <code>itemRendererType</code> if you wanted to initialize some
	 * properties on each separate item renderer, such as skins.
	 *
	 * <p>The function is expected to have the following signature:</p>
	 *
	 * <pre>function():IGroupedListItemRenderer</pre>
	 *
	 * <p>The following example provides a factory for the item renderer:</p>
	 *
	 * <listing version="3.0">
	 * list.itemRendererFactory = function():IGroupedListItemRenderer
	 * {
	 *     var renderer:CustomItemRendererClass = new CustomItemRendererClass();
	 *     renderer.backgroundSkin = new Quad( 10, 10, 0xff0000 );
	 *     return renderer;
	 * };</listing>
	 *
	 * <p>The first item and last item in a group may optionally use
	 * different item renderer factories, if desired. Use the
	 * <code>firstItemRendererFactory</code> and <code>lastItemRendererFactory</code>,
	 * respectively. Additionally, if a group contains only one item, it may
	 * also have a different factory. Use the <code>singleItemRendererFactory</code>.</p>
	 *
	 * @default null
	 *
	 * @see feathers.controls.renderers.IGroupedListItemRenderer
	 * @see #itemRendererType
	 * @see #firstItemRendererFactory
	 * @see #lastItemRendererFactory
	 * @see #singleItemRendererFactory
	 */
	public var itemRendererFactory(get, set):Dynamic;
	public function get_itemRendererFactory():Dynamic
	{
		return this._itemRendererFactory;
	}

	/**
	 * @private
	 */
	public function set_itemRendererFactory(value:Dynamic):Dynamic
	{
		if(this._itemRendererFactory == value)
		{
			return;
		}

		this._itemRendererFactory = value;
		this.invalidate(INVALIDATION_FLAG_STYLES);
	}

	/**
	 * @private
	 */
	private var _typicalItem:Dynamic = null;

	/**
	 * Used to auto-size the list when a virtualized layout is used. If the
	 * list's width or height is unknown, the list will try to automatically
	 * pick an ideal size. This item is used to create a sample item
	 * renderer to measure item renderers that are virtual and not visible
	 * in the viewport.
	 *
	 * <p>The following example provides a typical item:</p>
	 *
	 * <listing version="3.0">
	 * list.typicalItem = { text: "A typical item", thumbnail: texture };
	 * list.itemRendererProperties.labelField = "text";
	 * list.itemRendererProperties.iconSourceField = "thumbnail";</listing>
	 *
	 * @default null
	 */
	public var typicalItem(get, set):Dynamic;
	public function get_typicalItem():Dynamic
	{
		return this._typicalItem;
	}

	/**
	 * @private
	 */
	public function set_typicalItem(value:Dynamic):Dynamic
	{
		if(this._typicalItem == value)
		{
			return;
		}
		this._typicalItem = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_DATA);
	}

	/**
	 * @private
	 */
	private var _itemRendererName:String;

	/**
	 * A name to add to all item renderers in this list. Typically used by a
	 * theme to provide different skins to different lists.
	 *
	 * <p>The following example sets the item renderer name:</p>
	 *
	 * <listing version="3.0">
	 * list.itemRendererName = "my-custom-item-renderer";</listing>
	 *
	 * <p>In your theme, you can target this sub-component name to provide
	 * different skins than the default style:</p>
	 *
	 * <listing version="3.0">
	 * getStyleProviderForClass( DefaultGroupedListItemRenderer ).setFunctionForStyleName( "my-custom-item-renderer", setCustomItemRendererStyles );</listing>
	 *
	 * @default null
	 *
	 * @see feathers.core.FeathersControl#styleNameList
	 * @see #firstItemRendererName
	 * @see #lastItemRendererName
	 * @see #singleItemRendererName
	 */
	public var itemRendererName(get, set):String;
	public function get_itemRendererName():String
	{
		return this._itemRendererName;
	}

	/**
	 * @private
	 */
	public function set_itemRendererName(value:String):String
	{
		if(this._itemRendererName == value)
		{
			return;
		}
		this._itemRendererName = value;
		this.invalidate(INVALIDATION_FLAG_STYLES);
	}

	/**
	 * @private
	 */
	private var _itemRendererProperties:PropertyProxy;

	/**
	 * A set of key/value pairs to be passed down to all of the list's item
	 * renderers. These values are shared by each item renderer, so values
	 * that cannot be shared (such as display objects that need to be added
	 * to the display list) should be passed to the item renderers using the
	 * <code>itemRendererFactory</code> or with a theme. The item renderers
	 * are instances of <code>IGroupedListItemRenderer</code>. The available
	 * properties depend on which <code>IGroupedListItemRenderer</code>
	 * implementation is returned by <code>itemRendererFactory</code>.
	 *
	 * <p>The following example customizes some item renderer properties
	 * (this example assumes that the item renderer's label text renderer
	 * is a <code>BitmapFontTextRenderer</code>):</p>
	 *
	 * <listing version="3.0">
	 * list.itemRendererProperties.&#64;defaultLabelProperties.textFormat = new BitmapFontTextFormat( bitmapFont );
	 * list.itemRendererProperties.padding = 20;</listing>
	 *
	 * <p>If the subcomponent has its own subcomponents, their properties
	 * can be set too, using attribute <code>&#64;</code> notation. For example,
	 * to set the skin on the thumb which is in a <code>SimpleScrollBar</code>,
	 * which is in a <code>List</code>, you can use the following syntax:</p>
	 * <pre>list.verticalScrollBarProperties.&#64;thumbProperties.defaultSkin = new Image(texture);</pre>
	 *
	 * <p>Setting properties in a <code>itemRendererFactory</code> function instead
	 * of using <code>itemRendererProperties</code> will result in better
	 * performance.</p>
	 *
	 * @default null
	 *
	 * @see #itemRendererFactory
	 * @see feathers.controls.renderers.IGroupedListItemRenderer
	 * @see feathers.controls.renderers.DefaultGroupedListItemRenderer
	 */
	public var itemRendererProperties(get, set):Dynamic;
	public function get_itemRendererProperties():Dynamic
	{
		if(!this._itemRendererProperties)
		{
			this._itemRendererProperties = new PropertyProxy(childProperties_onChange);
		}
		return this._itemRendererProperties;
	}

	/**
	 * @private
	 */
	public function set_itemRendererProperties(value:Dynamic):Dynamic
	{
		if(this._itemRendererProperties == value)
		{
			return;
		}
		if(!value)
		{
			value = new PropertyProxy();
		}
		if(!(value is PropertyProxy))
		{
			var newValue:PropertyProxy = new PropertyProxy();
			for(var propertyName:String in value)
			{
				newValue[propertyName] = value[propertyName];
			}
			value = newValue;
		}
		if(this._itemRendererProperties)
		{
			this._itemRendererProperties.removeOnChangeCallback(childProperties_onChange);
		}
		this._itemRendererProperties = PropertyProxy(value);
		if(this._itemRendererProperties)
		{
			this._itemRendererProperties.addOnChangeCallback(childProperties_onChange);
		}
		this.invalidate(INVALIDATION_FLAG_STYLES);
	}

	/**
	 * @private
	 */
	private var _firstItemRendererType:Class<Dynamic>;

	/**
	 * The class used to instantiate the item renderer for the first item in
	 * a group. Must implement the <code>IGroupedListItemRenderer</code>
	 * interface.
	 *
	 * <p>The following example changes the first item renderer type:</p>
	 *
	 * <listing version="3.0">
	 * list.firstItemRendererType = CustomItemRendererClass;</listing>
	 *
	 * @default null
	 *
	 * @see feathers.controls.renderer.IGroupedListItemRenderer
	 * @see #itemRendererType
	 * @see #lastItemRendererType
	 * @see #singleItemRendererType
	 */
	public var firstItemRendererType(get, set):Class;
	public function get_firstItemRendererType():Class
	{
		return this._firstItemRendererType;
	}

	/**
	 * @private
	 */
	public function set_firstItemRendererType(value:Class<Dynamic>):Class<Dynamic>
	{
		if(this._firstItemRendererType == value)
		{
			return;
		}

		this._firstItemRendererType = value;
		this.invalidate(INVALIDATION_FLAG_STYLES);
	}

	/**
	 * @private
	 */
	private var _firstItemRendererFactory:Dynamic;

	/**
	 * A function called that is expected to return a new item renderer for
	 * the first item in a group. Has a higher priority than
	 * <code>firstItemRendererType</code>. Typically, you would use an
	 * <code>firstItemRendererFactory</code> instead of an
	 * <code>firstItemRendererType</code> if you wanted to initialize some
	 * properties on each separate item renderer, such as skins.
	 *
	 * <p>The function is expected to have the following signature:</p>
	 *
	 * <pre>function():IGroupedListItemRenderer</pre>
	 *
	 * <p>The following example provides a factory for the item renderer
	 * used for the first item in a group:</p>
	 *
	 * <listing version="3.0">
	 * list.firstItemRendererFactory = function():IGroupedListItemRenderer
	 * {
	 *     var renderer:CustomItemRendererClass = new CustomItemRendererClass();
	 *     renderer.backgroundSkin = new Quad( 10, 10, 0xff0000 );
	 *     return renderer;
	 * };</listing>
	 *
	 * @default null
	 *
	 * @see feathers.controls.renderers.IGroupedListItemRenderer
	 * @see #firstItemRendererType
	 * @see #itemRendererFactory
	 * @see #lastItemRendererFactory
	 * @see #singleItemRendererFactory
	 */
	public var firstItemRendererFactory(get, set):Dynamic;
	public function get_firstItemRendererFactory():Dynamic
	{
		return this._firstItemRendererFactory;
	}

	/**
	 * @private
	 */
	public function set_firstItemRendererFactory(value:Dynamic):Dynamic
	{
		if(this._firstItemRendererFactory == value)
		{
			return;
		}

		this._firstItemRendererFactory = value;
		this.invalidate(INVALIDATION_FLAG_STYLES);
	}

	/**
	 * @private
	 */
	private var _firstItemRendererName:String;

	/**
	 * A name to add to all item renderers in this list that are the first
	 * item in a group. Typically used by a theme to provide different skins
	 * to different lists, and to differentiate first items from regular
	 * items if they are created with the same class. If this value is null
	 * the regular <code>itemRendererName</code> will be used instead.
	 *
	 * <p>The following example provides an name for the first item renderer
	 * in a group:</p>
	 *
	 * <listing version="3.0">
	 * list.firstItemRendererName = "my-custom-first-item-renderer";</listing>
	 *
	 * <p>In your theme, you can target this sub-component name to provide
	 * different skins than the default style:</p>
	 *
	 * <listing version="3.0">
	 * getStyleProviderForClass( DefaultGroupedListItemRenderer ).setFunctionForStyleName( "my-custom-first-item-renderer", setCustomFirstItemRendererStyles );</listing>
	 *
	 * @default null
	 *
	 * @see feathers.core.FeathersControl#styleNameList
	 * @see #itemRendererName
	 * @see #lastItemRendererName
	 * @see #singleItemRendererName
	 */
	public var firstItemRendererName(get, set):String;
	public function get_firstItemRendererName():String
	{
		return this._firstItemRendererName;
	}

	/**
	 * @private
	 */
	public function set_firstItemRendererName(value:String):String
	{
		if(this._firstItemRendererName == value)
		{
			return;
		}
		this._firstItemRendererName = value;
		this.invalidate(INVALIDATION_FLAG_STYLES);
	}

	/**
	 * @private
	 */
	private var _lastItemRendererType:Class<Dynamic>;

	/**
	 * The class used to instantiate the item renderer for the last item in
	 * a group. Must implement the <code>IGroupedListItemRenderer</code>
	 * interface.
	 *
	 * <p>The following example changes the last item renderer type:</p>
	 *
	 * <listing version="3.0">
	 * list.lastItemRendererType = CustomItemRendererClass;</listing>
	 *
	 * @default null
	 *
	 * @see feathers.controls.renderer.IGroupedListItemRenderer
	 * @see #lastItemRendererFactory
	 * @see #itemRendererType
	 * @see #firstItemRendererType
	 * @see #singleItemRendererType
	 */
	public var lastItemRendererType(get, set):Class;
	public function get_lastItemRendererType():Class
	{
		return this._lastItemRendererType;
	}

	/**
	 * @private
	 */
	public function set_lastItemRendererType(value:Class<Dynamic>):Class<Dynamic>
	{
		if(this._lastItemRendererType == value)
		{
			return;
		}

		this._lastItemRendererType = value;
		this.invalidate(INVALIDATION_FLAG_STYLES);
	}

	/**
	 * @private
	 */
	private var _lastItemRendererFactory:Dynamic;

	/**
	 * A function called that is expected to return a new item renderer for
	 * the last item in a group. Has a higher priority than
	 * <code>lastItemRendererType</code>. Typically, you would use an
	 * <code>lastItemRendererFactory</code> instead of an
	 * <code>lastItemRendererType</code> if you wanted to initialize some
	 * properties on each separate item renderer, such as skins.
	 *
	 * <p>The function is expected to have the following signature:</p>
	 *
	 * <pre>function():IGroupedListItemRenderer</pre>
	 *
	 * <p>The following example provides a factory for the item renderer
	 * used for the last item in a group:</p>
	 *
	 * <listing version="3.0">
	 * list.firstItemRendererFactory = function():IGroupedListItemRenderer
	 * {
	 *     var renderer:CustomItemRendererClass = new CustomItemRendererClass();
	 *     renderer.backgroundSkin = new Quad( 10, 10, 0xff0000 );
	 *     return renderer;
	 * };</listing>
	 *
	 * @default null
	 *
	 * @see feathers.controls.renderers.IGroupedListItemRenderer
	 * @see #lastItemRendererType
	 * @see #itemRendererFactory
	 * @see #firstItemRendererFactory
	 * @see #singleItemRendererFactory
	 */
	public var lastItemRendererFactory(get, set):Dynamic;
	public function get_lastItemRendererFactory():Dynamic
	{
		return this._lastItemRendererFactory;
	}

	/**
	 * @private
	 */
	public function set_lastItemRendererFactory(value:Dynamic):Dynamic
	{
		if(this._lastItemRendererFactory == value)
		{
			return;
		}

		this._lastItemRendererFactory = value;
		this.invalidate(INVALIDATION_FLAG_STYLES);
	}

	/**
	 * @private
	 */
	private var _lastItemRendererName:String;

	/**
	 * A name to add to all item renderers in this list that are the last
	 * item in a group. Typically used by a theme to provide different skins
	 * to different lists, and to differentiate last items from regular
	 * items if they are created with the same class. If this value is null
	 * the regular <code>itemRendererName</code> will be used instead.
	 *
	 * <p>The following example provides an name for the last item renderer
	 * in a group:</p>
	 *
	 * <listing version="3.0">
	 * list.lastItemRendererName = "my-custom-last-item-renderer";</listing>
	 *
	 * <p>In your theme, you can target this sub-component name to provide
	 * different skins than the default style:</p>
	 *
	 * <listing version="3.0">
	 * getStyleProviderForClass( DefaultGroupedListItemRenderer ).setFunctionForStyleName( "my-custom-last-item-renderer", setCustomLastItemRendererStyles );</listing>
	 *
	 * @default null
	 *
	 * @see feathers.core.FeathersControl#styleNameList
	 * @see #itemRendererName
	 * @see #firstItemRendererName
	 * @see #singleItemRendererName
	 */
	public var lastItemRendererName(get, set):String;
	public function get_lastItemRendererName():String
	{
		return this._lastItemRendererName;
	}

	/**
	 * @private
	 */
	public function set_lastItemRendererName(value:String):String
	{
		if(this._lastItemRendererName == value)
		{
			return;
		}
		this._lastItemRendererName = value;
		this.invalidate(INVALIDATION_FLAG_STYLES);
	}

	/**
	 * @private
	 */
	private var _singleItemRendererType:Class<Dynamic>;

	/**
	 * The class used to instantiate the item renderer for an item in a
	 * group with no other items. Must implement the
	 * <code>IGroupedListItemRenderer</code> interface.
	 *
	 * <p>The following example changes the single item renderer type:</p>
	 *
	 * <listing version="3.0">
	 * list.singleItemRendererType = CustomItemRendererClass;</listing>
	 *
	 * @default null
	 *
	 * @see feathers.controls.renderer.IGroupedListItemRenderer
	 * @see #singleItemRendererFactory
	 * @see #itemRendererType
	 * @see #firstItemRendererType
	 * @see #lastItemRendererType
	 */
	public var singleItemRendererType(get, set):Class;
	public function get_singleItemRendererType():Class
	{
		return this._singleItemRendererType;
	}

	/**
	 * @private
	 */
	public function set_singleItemRendererType(value:Class<Dynamic>):Class<Dynamic>
	{
		if(this._singleItemRendererType == value)
		{
			return;
		}

		this._singleItemRendererType = value;
		this.invalidate(INVALIDATION_FLAG_STYLES);
	}

	/**
	 * @private
	 */
	private var _singleItemRendererFactory:Dynamic;

	/**
	 * A function called that is expected to return a new item renderer for
	 * an item in a group with no other items. Has a higher priority than
	 * <code>singleItemRendererType</code>. Typically, you would use an
	 * <code>singleItemRendererFactory</code> instead of an
	 * <code>singleItemRendererType</code> if you wanted to initialize some
	 * properties on each separate item renderer, such as skins.
	 *
	 * <p>The function is expected to have the following signature:</p>
	 *
	 * <pre>function():IGroupedListItemRenderer</pre>
	 *
	 * <p>The following example provides a factory for the item renderer
	 * used for when only one item appears in a group:</p>
	 *
	 * <listing version="3.0">
	 * list.firstItemRendererFactory = function():IGroupedListItemRenderer
	 * {
	 *     var renderer:CustomItemRendererClass = new CustomItemRendererClass();
	 *     renderer.backgroundSkin = new Quad( 10, 10, 0xff0000 );
	 *     return renderer;
	 * };</listing>
	 *
	 * @default null
	 *
	 * @see feathers.controls.renderers.IGroupedListItemRenderer
	 * @see #singleItemRendererType
	 * @see #itemRendererFactory
	 * @see #firstItemRendererFactory
	 * @see #lastItemRendererFactory
	 */
	public var singleItemRendererFactory(get, set):Dynamic;
	public function get_singleItemRendererFactory():Dynamic
	{
		return this._singleItemRendererFactory;
	}

	/**
	 * @private
	 */
	public function set_singleItemRendererFactory(value:Dynamic):Dynamic
	{
		if(this._singleItemRendererFactory == value)
		{
			return;
		}

		this._singleItemRendererFactory = value;
		this.invalidate(INVALIDATION_FLAG_STYLES);
	}

	/**
	 * @private
	 */
	private var _singleItemRendererName:String;

	/**
	 * A name to add to all item renderers in this list that are an item in
	 * a group with no other items. Typically used by a theme to provide
	 * different skins to different lists, and to differentiate single items
	 * from other items if they are created with the same class. If this
	 * value is null the regular <code>itemRendererName</code> will be used
	 * instead.
	 *
	 * <p>The following example provides an name for a single item renderer
	 * in a group:</p>
	 *
	 * <listing version="3.0">
	 * list.singleItemRendererName = "my-custom-single-item-renderer";</listing>
	 *
	 * <p>In your theme, you can target this sub-component name to provide
	 * different skins than the default style:</p>
	 *
	 * <listing version="3.0">
	 * getStyleProviderForClass( DefaultGroupedListItemRenderer ).setFunctionForStyleName( "my-custom-single-item-renderer", setCustomSingleItemRendererStyles );</listing>
	 *
	 * @default null
	 *
	 * @see feathers.core.FeathersControl#styleNameList
	 * @see #itemRendererName
	 * @see #firstItemRendererName
	 * @see #lastItemRendererName
	 */
	public var singleItemRendererName(get, set):String;
	public function get_singleItemRendererName():String
	{
		return this._singleItemRendererName;
	}

	/**
	 * @private
	 */
	public function set_singleItemRendererName(value:String):String
	{
		if(this._singleItemRendererName == value)
		{
			return;
		}
		this._singleItemRendererName = value;
		this.invalidate(INVALIDATION_FLAG_STYLES);
	}

	/**
	 * @private
	 */
	private var _headerRendererType:Class<Dynamic> = DefaultGroupedListHeaderOrFooterRenderer;

	/**
	 * The class used to instantiate header renderers. Must implement the
	 * <code>IGroupedListHeaderOrFooterRenderer</code> interface.
	 *
	 * <p>The following example changes the header renderer type:</p>
	 *
	 * <listing version="3.0">
	 * list.headerRendererType = CustomHeaderRendererClass;</listing>
	 *
	 * @default feathers.controls.renderers.DefaultGroupedListHeaderOrFooterRenderer
	 *
	 * @see feathers.controls.renderers.IGroupedListHeaderOrFooterRenderer
	 * @see #headerRendererFactory
	 */
	public var headerRendererType(get, set):Class;
	public function get_headerRendererType():Class
	{
		return this._headerRendererType;
	}

	/**
	 * @private
	 */
	public function set_headerRendererType(value:Class<Dynamic>):Class<Dynamic>
	{
		if(this._headerRendererType == value)
		{
			return;
		}

		this._headerRendererType = value;
		this.invalidate(INVALIDATION_FLAG_STYLES);
	}

	/**
	 * @private
	 */
	private var _headerRendererFactory:Dynamic;

	/**
	 * A function called that is expected to return a new header renderer.
	 * Has a higher priority than <code>headerRendererType</code>.
	 * Typically, you would use an <code>headerRendererFactory</code>
	 * instead of a <code>headerRendererType</code> if you wanted to
	 * initialize some properties on each separate header renderer, such as
	 * skins.
	 *
	 * <p>The function is expected to have the following signature:</p>
	 *
	 * <pre>function():IGroupedListHeaderOrFooterRenderer</pre>
	 *
	 * <p>The following example provides a factory for the header renderer:</p>
	 *
	 * <listing version="3.0">
	 * list.itemRendererFactory = function():IGroupedListHeaderOrFooterRenderer
	 * {
	 *     var renderer:CustomHeaderRendererClass = new CustomHeaderRendererClass();
	 *     renderer.backgroundSkin = new Quad( 10, 10, 0xff0000 );
	 *     return renderer;
	 * };</listing>
	 *
	 * @default null
	 *
	 * @see feathers.controls.renderers.IGroupedListHeaderOrFooterRenderer
	 * @see #headerRendererType
	 */
	public var headerRendererFactory(get, set):Dynamic;
	public function get_headerRendererFactory():Dynamic
	{
		return this._headerRendererFactory;
	}

	/**
	 * @private
	 */
	public function set_headerRendererFactory(value:Dynamic):Dynamic
	{
		if(this._headerRendererFactory == value)
		{
			return;
		}

		this._headerRendererFactory = value;
		this.invalidate(INVALIDATION_FLAG_STYLES);
	}

	/**
	 * @private
	 */
	private var _headerRendererName:String = DEFAULT_CHILD_NAME_HEADER_RENDERER;

	/**
	 * A name to add to all header renderers in this grouped list. Typically
	 * used by a theme to provide different skins to different lists.
	 *
	 * <p>The following example sets the header renderer name:</p>
	 *
	 * <listing version="3.0">
	 * list.headerRendererName = "my-custom-header-renderer";</listing>
	 *
	 * <p>In your theme, you can target this sub-component name to provide
	 * different skins than the default style:</p>
	 *
	 * <listing version="3.0">
	 * getStyleProviderForClass( DefaultGroupedListHeaderOrFooterRenderer ).setFunctionForStyleName( "my-custom-header-renderer", setCustomHeaderRendererStyles );</listing>
	 *
	 * @default null
	 *
	 * @see feathers.core.FeathersControl#styleNameList
	 */
	public var headerRendererName(get, set):String;
	public function get_headerRendererName():String
	{
		return this._headerRendererName;
	}

	/**
	 * @private
	 */
	public function set_headerRendererName(value:String):String
	{
		if(this._headerRendererName == value)
		{
			return;
		}
		this._headerRendererName = value;
		this.invalidate(INVALIDATION_FLAG_STYLES);
	}

	/**
	 * @private
	 */
	private var _headerRendererProperties:PropertyProxy;

	/**
	 * A set of key/value pairs to be passed down to all of the grouped
	 * list's header renderers. These values are shared by each header
	 * renderer, so values that cannot be shared (such as display objects
	 * that need to be added to the display list) should be passed to the
	 * header renderers using the <code>headerRendererFactory</code> or in a
	 * theme. The header renderers are instances of
	 * <code>IGroupedListHeaderOrFooterRenderer</code>. The available
	 * properties depend on which <code>IGroupedListItemRenderer</code>
	 * implementation is returned by <code>headerRendererFactory</code>.
	 *
	 * <p>The following example customizes some header renderer properties:</p>
	 *
	 * <listing version="3.0">
	 * list.headerRendererProperties.&#64;contentLabelProperties.textFormat = new BitmapFontTextFormat( bitmapFont );
	 * list.headerRendererProperties.padding = 20;</listing>
	 *
	 * <p>If the subcomponent has its own subcomponents, their properties
	 * can be set too, using attribute <code>&#64;</code> notation. For example,
	 * to set the skin on the thumb which is in a <code>SimpleScrollBar</code>,
	 * which is in a <code>List</code>, you can use the following syntax:</p>
	 * <pre>list.verticalScrollBarProperties.&#64;thumbProperties.defaultSkin = new Image(texture);</pre>
	 *
	 * <p>Setting properties in a <code>headerRendererFactory</code> function instead
	 * of using <code>headerRendererProperties</code> will result in better
	 * performance.</p>
	 *
	 * @default null
	 *
	 * @see #headerRendererFactory
	 * @see feathers.controls.renderers.IGroupedListHeaderOrFooterRenderer
	 * @see feathers.controls.renderers.DefaultGroupedListHeaderOrFooterRenderer
	 */
	public var headerRendererProperties(get, set):Dynamic;
	public function get_headerRendererProperties():Dynamic
	{
		if(!this._headerRendererProperties)
		{
			this._headerRendererProperties = new PropertyProxy(childProperties_onChange);
		}
		return this._headerRendererProperties;
	}

	/**
	 * @private
	 */
	public function set_headerRendererProperties(value:Dynamic):Dynamic
	{
		if(this._headerRendererProperties == value)
		{
			return;
		}
		if(!value)
		{
			value = new PropertyProxy();
		}
		if(!(value is PropertyProxy))
		{
			var newValue:PropertyProxy = new PropertyProxy();
			for(var propertyName:String in value)
			{
				newValue[propertyName] = value[propertyName];
			}
			value = newValue;
		}
		if(this._headerRendererProperties)
		{
			this._headerRendererProperties.removeOnChangeCallback(childProperties_onChange);
		}
		this._headerRendererProperties = PropertyProxy(value);
		if(this._headerRendererProperties)
		{
			this._headerRendererProperties.addOnChangeCallback(childProperties_onChange);
		}
		this.invalidate(INVALIDATION_FLAG_STYLES);
	}

	/**
	 * @private
	 */
	private var _footerRendererType:Class<Dynamic> = DefaultGroupedListHeaderOrFooterRenderer;

	/**
	 * The class used to instantiate footer renderers. Must implement the
	 * <code>IGroupedListHeaderOrFooterRenderer</code> interface.
	 *
	 * <p>The following example changes the footer renderer type:</p>
	 *
	 * <listing version="3.0">
	 * list.footerRendererType = CustomFooterRendererClass;</listing>
	 *
	 * @default feathers.controls.renderers.DefaultGroupedListHeaderOrFooterRenderer
	 *
	 * @see feathers.controls.renderers.IGroupedListHeaderOrFooterRenderer
	 * @see #footerRendererFactory
	 */
	public var footerRendererType(get, set):Class;
	public function get_footerRendererType():Class
	{
		return this._footerRendererType;
	}

	/**
	 * @private
	 */
	public function set_footerRendererType(value:Class<Dynamic>):Class<Dynamic>
	{
		if(this._footerRendererType == value)
		{
			return;
		}

		this._footerRendererType = value;
		this.invalidate(INVALIDATION_FLAG_STYLES);
	}

	/**
	 * @private
	 */
	private var _footerRendererFactory:Dynamic;

	/**
	 * A function called that is expected to return a new footer renderer.
	 * Has a higher priority than <code>footerRendererType</code>.
	 * Typically, you would use an <code>footerRendererFactory</code>
	 * instead of a <code>footerRendererType</code> if you wanted to
	 * initialize some properties on each separate footer renderer, such as
	 * skins.
	 *
	 * <p>The function is expected to have the following signature:</p>
	 *
	 * <pre>function():IGroupedListHeaderOrFooterRenderer</pre>
	 *
	 * <p>The following example provides a factory for the footer renderer:</p>
	 *
	 * <listing version="3.0">
	 * list.itemRendererFactory = function():IGroupedListHeaderOrFooterRenderer
	 * {
	 *     var renderer:CustomFooterRendererClass = new CustomFooterRendererClass();
	 *     renderer.backgroundSkin = new Quad( 10, 10, 0xff0000 );
	 *     return renderer;
	 * };</listing>
	 *
	 * @default null
	 *
	 * @see feathers.controls.renderers.IGroupedListHeaderOrFooterRenderer
	 * @see #footerRendererType
	 */
	public var footerRendererFactory(get, set):Dynamic;
	public function get_footerRendererFactory():Dynamic
	{
		return this._footerRendererFactory;
	}

	/**
	 * @private
	 */
	public function set_footerRendererFactory(value:Dynamic):Dynamic
	{
		if(this._footerRendererFactory == value)
		{
			return;
		}

		this._footerRendererFactory = value;
		this.invalidate(INVALIDATION_FLAG_STYLES);
	}

	/**
	 * @private
	 */
	private var _footerRendererName:String = DEFAULT_CHILD_NAME_FOOTER_RENDERER;

	/**
	 * A name to add to all footer renderers in this grouped list. Typically
	 * used by a theme to provide different skins to different lists.
	 *
	 * <p>The following example sets the footer renderer name:</p>
	 *
	 * <listing version="3.0">
	 * list.footerRendererName = "my-custom-footer-renderer";</listing>
	 *
	 * <p>In your theme, you can target this sub-component name to provide
	 * different skins than the default style:</p>
	 *
	 * <listing version="3.0">
	 * getStyleProviderForClass( DefaultGroupedListHeaderOrFooterRenderer ).setFunctionForStyleName( "my-custom-footer-renderer", setCustomFooterRendererStyles );</listing>
	 *
	 * @default null
	 *
	 * @see feathers.core.FeathersControl#styleNameList
	 */
	public var footerRendererName(get, set):String;
	public function get_footerRendererName():String
	{
		return this._footerRendererName;
	}

	/**
	 * @private
	 */
	public function set_footerRendererName(value:String):String
	{
		if(this._footerRendererName == value)
		{
			return;
		}
		this._footerRendererName = value;
		this.invalidate(INVALIDATION_FLAG_STYLES);
	}

	/**
	 * @private
	 */
	private var _footerRendererProperties:PropertyProxy;

	/**
	 * A set of key/value pairs to be passed down to all of the grouped
	 * list's footer renderers. These values are shared by each footer
	 * renderer, so values that cannot be shared (such as display objects
	 * that need to be added to the display list) should be passed to the
	 * footer renderers using a <code>footerRendererFactory</code> or with
	 * a theme. The header renderers are instances of
	 * <code>IGroupedListHeaderOrFooterRenderer</code>. The available
	 * properties depend on which <code>IGroupedListItemRenderer</code>
	 * implementation is returned by <code>headerRendererFactory</code>.
	 *
	 * <p>The following example customizes some header renderer properties:</p>
	 *
	 * <listing version="3.0">
	 * list.footerRendererProperties.&#64;contentLabelProperties.textFormat = new BitmapFontTextFormat( bitmapFont );
	 * list.footerRendererProperties.padding = 20;</listing>
	 *
	 * <p>If the subcomponent has its own subcomponents, their properties
	 * can be set too, using attribute <code>&#64;</code> notation. For example,
	 * to set the skin on the thumb which is in a <code>SimpleScrollBar</code>,
	 * which is in a <code>List</code>, you can use the following syntax:</p>
	 * <pre>list.verticalScrollBarProperties.&#64;thumbProperties.defaultSkin = new Image(texture);</pre>
	 *
	 * <p>Setting properties in a <code>footerRendererFactory</code> function instead
	 * of using <code>footerRendererProperties</code> will result in better
	 * performance.</p>
	 *
	 * @default null
	 *
	 * @see #footerRendererFactory
	 * @see feathers.controls.renderers.IGroupedListHeaderOrFooterRenderer
	 * @see feathers.controls.renderers.DefaultGroupedListHeaderOrFooterRenderer
	 */
	public var footerRendererProperties(get, set):Dynamic;
	public function get_footerRendererProperties():Dynamic
	{
		if(!this._footerRendererProperties)
		{
			this._footerRendererProperties = new PropertyProxy(childProperties_onChange);
		}
		return this._footerRendererProperties;
	}

	/**
	 * @private
	 */
	public function set_footerRendererProperties(value:Dynamic):Dynamic
	{
		if(this._footerRendererProperties == value)
		{
			return;
		}
		if(!value)
		{
			value = new PropertyProxy();
		}
		if(!(value is PropertyProxy))
		{
			var newValue:PropertyProxy = new PropertyProxy();
			for(var propertyName:String in value)
			{
				newValue[propertyName] = value[propertyName];
			}
			value = newValue;
		}
		if(this._footerRendererProperties)
		{
			this._footerRendererProperties.removeOnChangeCallback(childProperties_onChange);
		}
		this._footerRendererProperties = PropertyProxy(value);
		if(this._footerRendererProperties)
		{
			this._footerRendererProperties.addOnChangeCallback(childProperties_onChange);
		}
		this.invalidate(INVALIDATION_FLAG_STYLES);
	}

	/**
	 * @private
	 */
	private var _headerField:String = "header";

	/**
	 * The field in a group that contains the data for a header. If the
	 * group does not have this field, and a <code>headerFunction</code> is
	 * not defined, then no header will be displayed for the group. In other
	 * words, a header is optional, and a group may not have one.
	 *
	 * <p>All of the header fields and functions, ordered by priority:</p>
	 * <ol>
	 *     <li><code>headerFunction</code></li>
	 *     <li><code>headerField</code></li>
	 * </ol>
	 *
	 * <p>The following example sets the header field:</p>
	 *
	 * <listing version="3.0">
	 * list.headerField = "alphabet";</listing>
	 *
	 * @default "header"
	 *
	 * @see #headerFunction
	 */
	public var headerField(get, set):String;
	public function get_headerField():String
	{
		return this._headerField;
	}

	/**
	 * @private
	 */
	public function set_headerField(value:String):String
	{
		if(this._headerField == value)
		{
			return;
		}
		this._headerField = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_DATA);
	}

	/**
	 * @private
	 */
	private var _headerFunction:Dynamic;

	/**
	 * A function used to generate header data for a specific group. If this
	 * function is not null, then the <code>headerField</code> will be
	 * ignored.
	 *
	 * <p>The function is expected to have the following signature:</p>
	 * <pre>function( item:Dynamic ):Dynamic</pre>
	 *
	 * <p>All of the header fields and functions, ordered by priority:</p>
	 * <ol>
	 *     <li><code>headerFunction</code></li>
	 *     <li><code>headerField</code></li>
	 * </ol>
	 *
	 * <p>The following example sets the header function:</p>
	 *
	 * <listing version="3.0">
	 * list.headerFunction = function( group:Dynamic ):Dynamic
	 * {
	 *    return group.header;
	 * };</listing>
	 *
	 * @default null
	 *
	 * @see #headerField
	 */
	public var headerFunction(get, set):Dynamic;
	public function get_headerFunction():Dynamic
	{
		return this._headerFunction;
	}

	/**
	 * @private
	 */
	public function set_headerFunction(value:Dynamic):Dynamic
	{
		if(this._headerFunction == value)
		{
			return;
		}
		this._headerFunction = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_DATA);
	}

	/**
	 * @private
	 */
	private var _footerField:String = "footer";

	/**
	 * The field in a group that contains the data for a footer. If the
	 * group does not have this field, and a <code>footerFunction</code> is
	 * not defined, then no footer will be displayed for the group. In other
	 * words, a footer is optional, and a group may not have one.
	 *
	 * <p>All of the footer fields and functions, ordered by priority:</p>
	 * <ol>
	 *     <li><code>footerFunction</code></li>
	 *     <li><code>footerField</code></li>
	 * </ol>
	 *
	 * <p>The following example sets the footer field:</p>
	 *
	 * <listing version="3.0">
	 * list.footerField = "controls";</listing>
	 *
	 * @default "footer"
	 *
	 * @see #footerFunction
	 */
	public var footerField(get, set):String;
	public function get_footerField():String
	{
		return this._footerField;
	}

	/**
	 * @private
	 */
	public function set_footerField(value:String):String
	{
		if(this._footerField == value)
		{
			return;
		}
		this._footerField = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_DATA);
	}

	/**
	 * @private
	 */
	private var _footerFunction:Dynamic;

	/**
	 * A function used to generate footer data for a specific group. If this
	 * function is not null, then the <code>footerField</code> will be
	 * ignored.
	 *
	 * <p>The function is expected to have the following signature:</p>
	 * <pre>function( item:Dynamic ):Dynamic</pre>
	 *
	 * <p>All of the footer fields and functions, ordered by priority:</p>
	 * <ol>
	 *     <li><code>footerFunction</code></li>
	 *     <li><code>footerField</code></li>
	 * </ol>
	 *
	 * <p>The following example sets the footer function:</p>
	 *
	 * <listing version="3.0">
	 * list.footerFunction = function( group:Dynamic ):Dynamic
	 * {
	 *    return group.footer;
	 * };</listing>
	 *
	 * @default null
	 *
	 * @see #footerField
	 */
	public var footerFunction(get, set):Dynamic;
	public function get_footerFunction():Dynamic
	{
		return this._footerFunction;
	}

	/**
	 * @private
	 */
	public function set_footerFunction(value:Dynamic):Dynamic
	{
		if(this._footerFunction == value)
		{
			return;
		}
		this._footerFunction = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_DATA);
	}

	/**
	 * The pending group index to scroll to after validating. A value of
	 * <code>-1</code> means that the scroller won't scroll to a group after
	 * validating.
	 */
	private var pendingGroupIndex:Int = -1;

	/**
	 * The pending item index to scroll to after validating. A value of
	 * <code>-1</code> means that the scroller won't scroll to an item after
	 * validating.
	 */
	private var pendingItemIndex:Int = -1;

	/**
	 * @private
	 */
	override public function dispose():Void
	{
		//clearing selection now so that the data provider setter won't
		//cause a selection change that triggers events.
		this._selectedGroupIndex = -1;
		this._selectedItemIndex = -1;
		this.dataProvider = null;
		super.dispose();
	}

	/**
	 * @private
	 */
	override public function scrollToPosition(horizontalScrollPosition:Float, verticalScrollPosition:Float, animationDuration:Float = Math.NaN):Void
	{
		this.pendingItemIndex = -1;
		super.scrollToPosition(horizontalScrollPosition, verticalScrollPosition, animationDuration);
	}

	/**
	 * @private
	 */
	override public function scrollToPageIndex(horizontalPageIndex:Int, verticalPageIndex:Int, animationDuration:Float = Math.NaN):Void
	{
		this.pendingGroupIndex = -1;
		this.pendingItemIndex = -1;
		super.scrollToPageIndex(horizontalPageIndex, verticalPageIndex, animationDuration);
	}

	/**
	 * After the next validation, scrolls the list so that the specified
	 * item is visible. If <code>animationDuration</code> is greater than
	 * zero, the scroll will animate. The duration is in seconds.
	 *
	 * <p>In the following example, the list is scrolled to display the
	 * third item in the second group:</p>
	 *
	 * <listing version="3.0">
	 * list.scrollToDisplayIndex( 1, 2 );</listing>
	 */
	public function scrollToDisplayIndex(groupIndex:Int, itemIndex:Int, animationDuration:Float = 0):Void
	{
		this.pendingHorizontalPageIndex = -1;
		this.pendingVerticalPageIndex = -1;
		this.pendingHorizontalScrollPosition = Math.NaN;
		this.pendingVerticalScrollPosition = Math.NaN;
		if(this.pendingGroupIndex == groupIndex &&
			this.pendingItemIndex == itemIndex &&
			this.pendingScrollDuration == animationDuration)
		{
			return;
		}
		this.pendingGroupIndex = groupIndex;
		this.pendingItemIndex = itemIndex;
		this.pendingScrollDuration = animationDuration;
		this.invalidate(INVALIDATION_FLAG_PENDING_SCROLL);
	}

	/**
	 * Sets the selected group and item index.
	 *
	 * <p>In the following example, the third item in the second group
	 * is selected:</p>
	 *
	 * <listing version="3.0">
	 * list.setSelectedLocation( 1, 2 );</listing>
	 *
	 * <p>In the following example, the selection is cleared:</p>
	 *
	 * <listing version="3.0">
	 * list.setSelectedLocation( -1, -1 );</listing>
	 *
	 * @see #selectedGroupIndex
	 * @see #selectedItemIndex
	 * @see #selectedItem
	 */
	public function setSelectedLocation(groupIndex:Int, itemIndex:Int):Void
	{
		if(this._selectedGroupIndex == groupIndex && this._selectedItemIndex == itemIndex)
		{
			return;
		}
		if((groupIndex < 0 && itemIndex >= 0) || (groupIndex >= 0 && itemIndex < 0))
		{
			throw new ArgumentError("To deselect items, group index and item index must both be < 0.");
		}
		this._selectedGroupIndex = groupIndex;
		this._selectedItemIndex = itemIndex;

		this.invalidate(FeathersControl.INVALIDATION_FLAG_SELECTED);
		this.dispatchEventWith(Event.CHANGE);
	}

	/**
	 * Extracts header data from a group object.
	 */
	public function groupToHeaderData(group:Dynamic):Dynamic
	{
		if(this._headerFunction != null)
		{
			return this._headerFunction(group);
		}
		else if(this._headerField != null && group && group.hasOwnProperty(this._headerField))
		{
			return group[this._headerField];
		}

		return null;
	}

	/**
	 * Extracts footer data from a group object.
	 */
	public function groupToFooterData(group:Dynamic):Dynamic
	{
		if(this._footerFunction != null)
		{
			return this._footerFunction(group);
		}
		else if(this._footerField != null && group && group.hasOwnProperty(this._footerField))
		{
			return group[this._footerField];
		}

		return null;
	}

	/**
	 * @private
	 */
	override private function initialize():Void
	{
		var hasLayout:Bool = this._layout != null;

		super.initialize();

		if(!this.dataViewPort)
		{
			this.viewPort = this.dataViewPort = new GroupedListDataViewPort();
			this.dataViewPort.owner = this;
			this.dataViewPort.addEventListener(Event.CHANGE, dataViewPort_changeHandler);
			this.viewPort = this.dataViewPort;
		}

		if(!hasLayout)
		{
			if(this._hasElasticEdges &&
				this._verticalScrollPolicy == SCROLL_POLICY_AUTO &&
				this._scrollBarDisplayMode != SCROLL_BAR_DISPLAY_MODE_FIXED)
			{
				//so that the elastic edges work even when the max scroll
				//position is 0, similar to iOS.
				this.verticalScrollPolicy = SCROLL_POLICY_ON;
			}

			var layout:VerticalLayout = new VerticalLayout();
			layout.useVirtualLayout = true;
			layout.paddingTop = layout.paddingRight = layout.paddingBottom =
				layout.paddingLeft = 0;
			layout.gap = 0;
			layout.horizontalAlign = VerticalLayout.HORIZONTAL_ALIGN_JUSTIFY;
			layout.verticalAlign = VerticalLayout.VERTICAL_ALIGN_TOP;
			this._layout = layout;
		}
	}

	/**
	 * @private
	 */
	override private function draw():Void
	{
		this.refreshDataViewPortProperties();
		super.draw();
		this.refreshFocusIndicator();
	}

	/**
	 * @private
	 */
	private function refreshDataViewPortProperties():Void
	{
		this.dataViewPort.isSelectable = this._isSelectable;
		this.dataViewPort.setSelectedLocation(this._selectedGroupIndex, this._selectedItemIndex);
		this.dataViewPort.dataProvider = this._dataProvider;
		this.dataViewPort.typicalItem = this._typicalItem;

		this.dataViewPort.itemRendererType = this._itemRendererType;
		this.dataViewPort.itemRendererFactory = this._itemRendererFactory;
		this.dataViewPort.itemRendererProperties = this._itemRendererProperties;
		this.dataViewPort.itemRendererName = this._itemRendererName;

		this.dataViewPort.firstItemRendererType = this._firstItemRendererType;
		this.dataViewPort.firstItemRendererFactory = this._firstItemRendererFactory;
		this.dataViewPort.firstItemRendererName = this._firstItemRendererName;

		this.dataViewPort.lastItemRendererType = this._lastItemRendererType;
		this.dataViewPort.lastItemRendererFactory = this._lastItemRendererFactory;
		this.dataViewPort.lastItemRendererName = this._lastItemRendererName;

		this.dataViewPort.singleItemRendererType = this._singleItemRendererType;
		this.dataViewPort.singleItemRendererFactory = this._singleItemRendererFactory;
		this.dataViewPort.singleItemRendererName = this._singleItemRendererName;

		this.dataViewPort.headerRendererType = this._headerRendererType;
		this.dataViewPort.headerRendererFactory = this._headerRendererFactory;
		this.dataViewPort.headerRendererProperties = this._headerRendererProperties;
		this.dataViewPort.headerRendererName = this._headerRendererName;

		this.dataViewPort.footerRendererType = this._footerRendererType;
		this.dataViewPort.footerRendererFactory = this._footerRendererFactory;
		this.dataViewPort.footerRendererProperties = this._footerRendererProperties;
		this.dataViewPort.footerRendererName = this._footerRendererName;

		this.dataViewPort.layout = this._layout;
	}

	/**
	 * @private
	 */
	override private function handlePendingScroll():Void
	{
		if(this.pendingGroupIndex >= 0 && this.pendingItemIndex >= 0)
		{
			var item:Dynamic = this._dataProvider.getItemAt(this.pendingGroupIndex, this.pendingItemIndex);
			if(item is Object)
			{
				this.dataViewPort.getScrollPositionForIndex(this.pendingGroupIndex, this.pendingItemIndex, HELPER_POINT);
				this.pendingGroupIndex = -1;
				this.pendingItemIndex = -1;

				var targetHorizontalScrollPosition:Float = HELPER_POINT.x;
				if(targetHorizontalScrollPosition < this._minHorizontalScrollPosition)
				{
					targetHorizontalScrollPosition = this._minHorizontalScrollPosition;
				}
				else if(targetHorizontalScrollPosition > this._maxHorizontalScrollPosition)
				{
					targetHorizontalScrollPosition = this._maxHorizontalScrollPosition;
				}
				var targetVerticalScrollPosition:Float = HELPER_POINT.y;
				if(targetVerticalScrollPosition < this._minVerticalScrollPosition)
				{
					targetVerticalScrollPosition = this._minVerticalScrollPosition;
				}
				else if(targetVerticalScrollPosition > this._maxVerticalScrollPosition)
				{
					targetVerticalScrollPosition = this._maxVerticalScrollPosition;
				}
				this.throwTo(targetHorizontalScrollPosition, targetVerticalScrollPosition, this.pendingScrollDuration);
			}
		}
		super.handlePendingScroll();
	}

	/**
	 * @private
	 */
	override private function focusInHandler(event:Event):Void
	{
		super.focusInHandler(event);
		this.stage.addEventListener(KeyboardEvent.KEY_DOWN, stage_keyDownHandler);
	}

	/**
	 * @private
	 */
	override private function focusOutHandler(event:Event):Void
	{
		super.focusOutHandler(event);
		this.stage.removeEventListener(KeyboardEvent.KEY_DOWN, stage_keyDownHandler);
	}

	/**
	 * @private
	 */
	private function stage_keyDownHandler(event:KeyboardEvent):Void
	{
		if(!this._dataProvider)
		{
			return;
		}
		if(event.keyCode == Keyboard.HOME)
		{
			if(this._dataProvider.getLength() > 0 && this._dataProvider.getLength(0) > 0)
			{
				this.setSelectedLocation(0, 0);
			}
		}
		if(event.keyCode == Keyboard.END)
		{
			var groupIndex:Int = this._dataProvider.getLength();
			var itemIndex:Int = -1;
			do
			{
				groupIndex--;
				if(groupIndex >= 0)
				{
					itemIndex = this._dataProvider.getLength(groupIndex) - 1;
				}
			}
			while(groupIndex > 0 && itemIndex < 0)
			if(groupIndex >= 0 && itemIndex >= 0)
			{
				this.setSelectedLocation(groupIndex, itemIndex);
			}
		}
		else if(event.keyCode == Keyboard.UP)
		{
			groupIndex = this._selectedGroupIndex;
			itemIndex = this._selectedItemIndex - 1;
			if(itemIndex < 0)
			{
				do
				{
					groupIndex--;
					if(groupIndex >= 0)
					{
						itemIndex = this._dataProvider.getLength(groupIndex) - 1;
					}
				}
				while(groupIndex > 0 && itemIndex < 0)
			}
			if(groupIndex >= 0 && itemIndex >= 0)
			{
				this.setSelectedLocation(groupIndex, itemIndex);
			}
		}
		else if(event.keyCode == Keyboard.DOWN)
		{
			groupIndex = this._selectedGroupIndex;
			if(groupIndex < 0)
			{
				itemIndex = -1;
			}
			else
			{
				itemIndex = this._selectedItemIndex + 1;
			}
			if(groupIndex < 0 || itemIndex >= this._dataProvider.getLength(groupIndex))
			{
				itemIndex = -1;
				groupIndex++;
				var groupCount:Int = this._dataProvider.getLength();
				while(groupIndex < groupCount && itemIndex < 0)
				{
					if(this._dataProvider.getLength(groupIndex) > 0)
					{
						itemIndex = 0;
					}
					else
					{
						groupIndex++;
					}
				}
			}
			if(groupIndex >= 0 && itemIndex >= 0)
			{
				this.setSelectedLocation(groupIndex, itemIndex);
			}
		}
	}

	/**
	 * @private
	 */
	private function dataProvider_changeHandler(event:Event):Void
	{
		this.invalidate(FeathersControl.INVALIDATION_FLAG_DATA);
	}

	/**
	 * @private
	 */
	private function dataProvider_resetHandler(event:Event):Void
	{
		this.horizontalScrollPosition = 0;
		this.verticalScrollPosition = 0;
	}

	/**
	 * @private
	 */
	private function dataViewPort_changeHandler(event:Event):Void
	{
		this.setSelectedLocation(this.dataViewPort.selectedGroupIndex, this.dataViewPort.selectedItemIndex);
	}
}
