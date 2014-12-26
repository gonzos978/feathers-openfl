package feathers.examples.youtube.screens;
import feathers.controls.Button;
import feathers.controls.Label;
import feathers.controls.List;
import feathers.controls.PanelScreen;
import feathers.controls.ScreenNavigatorItem;
import feathers.controls.renderers.DefaultListItemRenderer;
import feathers.controls.renderers.IListItemRenderer;
import feathers.data.ListCollection;
import feathers.events.FeathersEventType;
import feathers.examples.youtube.models.VideoDetails;
import feathers.examples.youtube.models.YouTubeModel;
import feathers.layout.AnchorLayout;
import feathers.layout.AnchorLayoutData;

import flash.events.ErrorEvent;
import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.events.SecurityErrorEvent;
import flash.net.URLLoader;
import flash.net.URLRequest;

import starling.display.DisplayObject;
import starling.events.Event;

[Event(name="complete",type="starling.events.Event")]

[Event(name="showVideoDetails",type="starling.events.Event")]

class ListVideosScreen extends PanelScreen
{
	inline public static var SHOW_VIDEO_DETAILS:String = "showVideoDetails";

	public function ListVideosScreen()
	{
		super();
		this.addEventListener(starling.events.Event.REMOVED_FROM_STAGE, removedFromStageHandler);
	}

	private var _backButton:Button;
	private var _list:List;
	private var _message:Label;

	private var _isTransitioning:Bool = false;

	private var _model:YouTubeModel;

	public function get_model():YouTubeModel
	{
		return this._model;
	}

	public function set_model(value:YouTubeModel):Void
	{
		if(this._model == value)
		{
			return;
		}
		this._model = value;
		this.invalidate(INVALIDATION_FLAG_DATA);
	}

	public var savedVerticalScrollPosition:Float = 0;
	public var savedSelectedIndex:Int = -1;
	public var savedDataProvider:ListCollection;

	private var _loader:URLLoader;
	private var _savedLoaderData:*;

	override private function initialize():Void
	{
		//never forget to call super.initialize()
		super.initialize();

		this.layout = new AnchorLayout();

		this._list = new List();
		this._list.layoutData = new AnchorLayoutData(0, 0, 0, 0);
		this._list.itemRendererFactory = function():IListItemRenderer
		{
			var renderer:DefaultListItemRenderer = new DefaultListItemRenderer();
			renderer.labelField = "title";
			renderer.accessoryLabelField = "author";
			//no accessory and anything interactive, so we can use the quick
			//hit area to improve performance.
			renderer.isQuickHitAreaEnabled = true;
			return renderer;
		}
		//when navigating to video details, we save this information to
		//restore the list when later navigating back to this screen.
		if(this.savedDataProvider)
		{
			this._list.dataProvider = this.savedDataProvider;
			this._list.selectedIndex = this.savedSelectedIndex;
			this._list.verticalScrollPosition = this.savedVerticalScrollPosition;
		}
		this.addChild(this._list);

		this._message = new Label();
		this._message.text = "Loading...";
		this._message.layoutData = new AnchorLayoutData(NaN, NaN, NaN, NaN, 0, 0);
		//hide the loading message if we're using restored results
		this._message.visible = this.savedDataProvider == null;
		this.addChild(this._message);

		this._backButton = new Button();
		this._backButton.styleNameList.add(Button.ALTERNATE_NAME_BACK_BUTTON);
		this._backButton.label = "Back";
		this._backButton.addEventListener(starling.events.Event.TRIGGERED, onBackButton);
		this.headerProperties.leftItems = new <DisplayObject>
		[
			this._backButton
		];

		this.backButtonHandler = onBackButton;

		this._isTransitioning = true;
		this._owner.addEventListener(FeathersEventType.TRANSITION_COMPLETE, owner_transitionCompleteHandler);
	}

	override private function draw():Void
	{
		var dataInvalid:Bool = this.isInvalid(INVALIDATION_FLAG_DATA);

		//only load the list of videos if don't have restored results
		if(!this.savedDataProvider && dataInvalid)
		{
			this._list.dataProvider = null;
			if(this._model && this._model.selectedList)
			{
				this.headerProperties.title = this._model.selectedList.name;
				if(this._loader)
				{
					this.cleanUpLoader();
				}
				if(this._model.cachedLists.hasOwnProperty(this._model.selectedList.url))
				{
					this._message.visible = false;
					this._list.dataProvider = ListCollection(this._model.cachedLists[this._model.selectedList.url]);

					//show the scroll bars so that the user knows they can scroll
					this._list.revealScrollBars();
				}
				else
				{
					this._loader = new URLLoader();
					this._loader.addEventListener(flash.events.Event.COMPLETE, loader_completeHandler);
					this._loader.addEventListener(IOErrorEvent.IO_ERROR, loader_errorHandler);
					this._loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, loader_errorHandler);
					this._loader.load(new URLRequest(this._model.selectedList.url));
				}
			}
		}

		//never forget to call super.draw()!
		super.draw();
	}

	private function cleanUpLoader():Void
	{
		if(!this._loader)
		{
			return;
		}
		this._loader.removeEventListener(flash.events.Event.COMPLETE, loader_completeHandler);
		this._loader.removeEventListener(IOErrorEvent.IO_ERROR, loader_errorHandler);
		this._loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, loader_errorHandler);
		this._loader = null;
	}

	private function parseFeed(feed:XML):Void
	{
		this._message.visible = false;

		var atom:Namespace = feed.namespace();
		var media:Namespace = feed.namespace("media");

		var items:Array<VideoDetails> = new Array();
		var entries:XMLList = feed.atom::entry;
		var entryCount:Int = entries.length();
		for(var i:Int = 0; i < entryCount; i++)
		{
			var entry:XML = entries[i];
			var item:VideoDetails = new VideoDetails();
			item.title = entry.atom::title[0].toString();
			item.author = entry.atom::author[0].atom::name[0].toString();
			item.url = entry.media::group[0].media::player[0].@url.toString();
			item.description = entry.media::group[0].media::description[0].toString();
			items.push(item);
		}
		var collection:ListCollection = new ListCollection(items);
		this._model.cachedLists[this._model.selectedList.url] = collection;
		this._list.dataProvider = collection;

		//show the scroll bars so that the user knows they can scroll
		this._list.revealScrollBars();
	}

	private function onBackButton(event:starling.events.Event = null):Void
	{
		var screenItem:ScreenNavigatorItem = this._owner.getScreen(this.screenID);
		if(screenItem.properties)
		{
			//if we're going backwards, we should clear the restored results
			//because next time we come back, we may be asked to display
			//completely different data
			delete screenItem.properties.savedVerticalScrollPosition;
			delete screenItem.properties.savedSelectedIndex;
			delete screenItem.properties.savedDataProvider;
		}

		this.dispatchEventWith(starling.events.Event.COMPLETE);
	}

	private function list_changeHandler(event:starling.events.Event):Void
	{
		if(this._list.selectedIndex < 0)
		{
			return;
		}

		var screenItem:ScreenNavigatorItem = this._owner.getScreen(this.screenID);
		if(!screenItem.properties)
		{
			screenItem.properties = {};
		}
		//we're going to save the position of the list so that when the user
		//navigates back to this screen, they won't need to scroll back to
		//the same position manually
		screenItem.properties.savedVerticalScrollPosition = this._list.verticalScrollPosition;
		//we'll also save the selected index to temporarily highlight
		//the previously selected item when transitioning back
		screenItem.properties.savedSelectedIndex = this._list.selectedIndex;
		//and we'll save the data provider so that we don't need to reload
		//data when we return to this screen. we can restore it.
		screenItem.properties.savedDataProvider = this._list.dataProvider;

		this.dispatchEventWith(SHOW_VIDEO_DETAILS, false, VideoDetails(this._list.selectedItem));
	}

	private function removedFromStageHandler(event:starling.events.Event):Void
	{
		this.cleanUpLoader();
	}

	private function loader_completeHandler(event:flash.events.Event):Void
	{
		var loaderData:* = this._loader.data;
		this.cleanUpLoader();
		if(this._isTransitioning)
		{
			//if this screen is still transitioning in, the we'll save the
			//feed until later to ensure that the animation isn't affected.
			this._savedLoaderData = loaderData;
			return;
		}
		this.parseFeed(new XML(loaderData));
	}

	private function loader_errorHandler(event:ErrorEvent):Void
	{
		this.cleanUpLoader();
		this._message.text = "Unable to load data. Please try again later.";
		this._message.visible = true;
		this.invalidate(INVALIDATION_FLAG_STYLES);
		trace(event.toString());
	}

	private function owner_transitionCompleteHandler(event:starling.events.Event):Void
	{
		this.owner.removeEventListener(FeathersEventType.TRANSITION_COMPLETE, owner_transitionCompleteHandler);

		this._isTransitioning = false;

		if(this._savedLoaderData)
		{
			this.parseFeed(new XML(this._savedLoaderData));
			this._savedLoaderData = null;
		}

		this._list.selectedIndex = -1;
		this._list.addEventListener(starling.events.Event.CHANGE, list_changeHandler);
		this._list.revealScrollBars();
	}
}
