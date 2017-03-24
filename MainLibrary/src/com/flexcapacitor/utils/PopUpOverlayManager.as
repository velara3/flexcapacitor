package com.flexcapacitor.utils
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	
	import mx.controls.ToolTip;
	import mx.core.FlexGlobals;
	import mx.core.IMXMLObject;
	import mx.managers.SystemManager;
	import mx.managers.SystemManagerGlobals;
	import mx.utils.Platform;
	
	/**
	 * Hides external overlays when a popup such as a tool tip, dropdown or other pop up appears. 
	 * Useful when running in the browser with an HTML element stacked higher than the plugin surface. 
	 * */
	public class PopUpOverlayManager extends EventDispatcher implements IMXMLObject {
		
		public function PopUpOverlayManager(target:IEventDispatcher=null) {
			super(target);
			
			if (_instance) {
				throw new Error("PopUpOverlayManager is a singleton. Use PopUpOverlayManager.getInstance()");
			}
			
			isBrowser = Platform.isBrowser;
			_instance = this;
		}
		
		public var id:String;
		public function initialized(document:Object, id:String):void {
			this.id = id;
		}
		
		public var isBrowser:Boolean;
		private static var systemManager:SystemManager;
		private static var _instance:PopUpOverlayManager;
		private var overlays:Dictionary = new Dictionary(true);
		private var hiddenOverlays:Dictionary = new Dictionary(true);
		
		public static function getInstance():PopUpOverlayManager {
			if (_instance==null) {
				_instance = new PopUpOverlayManager();
			}
			
			return _instance;
		}
		
		/**
		 * Adds an overlay to hide when intersecting pop ups occur
		 * */
		public function addPopUpOverlay(overlay:DisplayObject):void {
			//topLevelApplication = FlexGlobals.topLevelApplication;
			
			if ("systemManager" in overlay && Object(overlay).systemManager) {
				systemManager = Object(overlay).systemManager;
			}
			else {
				systemManager = SystemManagerGlobals.topLevelSystemManagers[0];
			}
			
			if (systemManager) {
				systemManager.addEventListener(Event.ADDED, popupAddedHandler, false, 0, true);
				systemManager.addEventListener(Event.REMOVED, popupRemovedHandler, false, 0, true);
			}
			
			overlays[overlay] = 1;
		}
		
		/**
		 * Remove overlay from being managed
		 * */
		public function removePopUpOverlay(popup:DisplayObject):void {
			
			if ("systemManager" in popup) {
				systemManager = Object(popup).systemManager;
			}
			else {
				systemManager = SystemManagerGlobals.topLevelSystemManagers[0];
			}
			
			if (systemManager) {
				//systemManager.removeEventListener(Event.ADDED, addedHandler, false, 0, true);
				//systemManager.removeEventListener(Event.REMOVED, removedHandler, false, 0, true);
			}
			
			if (overlays[popup]) {
				overlays[popup] = null;
				delete overlays[popup];
			}
		}
		
		/**
		 * Handles when a pop up is added
		 * */
		protected function popupAddedHandler(event:Event):void {
			var displayObject:DisplayObject;
			var isToolTip:Boolean;
			var isCursor:Boolean;
			
			if (isBrowser) {
				displayObject = event.target as DisplayObject;
				isToolTip = displayObject is ToolTip;
				isCursor = displayObject.name == "cursorHolder";
				
				if (isCursor) {
					return;
				}
				
				if (displayObject.parent == systemManager) {
					FlexGlobals.topLevelApplication.callLater(hideOverlappingObjects, [displayObject]);
				}
			}
			
		}
		
		/**
		 * Handles when a pop up is removed
		 * */
		protected function popupRemovedHandler(event:Event):void {
			var removedDisplayObject:DisplayObject = event.target as DisplayObject;
			var popup:DisplayObject;
			
			for (var overlay:Object in hiddenOverlays) {
				
				popup = hiddenOverlays[overlay] as DisplayObject;
				
				if (popup==removedDisplayObject) {
					overlay.visible = true;
					hiddenOverlays[overlay] = null;
					delete hiddenOverlays[overlay];
				}
			}
		}
		
		/**
		 * Checks that a popup is not intersecting with existing overlays
		 * */
		public function hideOverlappingObjects(popup:DisplayObject):void {
			var isOver:Boolean;
			
			for (var overlay:Object in overlays) {
				isOver = intersects(popup, overlay as DisplayObject);
				
				if (isOver) {
					overlay.visible = false;
					hiddenOverlays[overlay] = popup;
				}
			}
			
		}
		
		/**
		 * Hides all overlays. Options to only hide overlays that are visible.
		 * */
		public function hideAllOverlays(onlyVisible:Boolean = true):void {
			var over:Boolean;
			
			for (var overlay:Object in overlays) {
				
				if (overlay.visible==true || !onlyVisible) {
					overlay.visible = false;
					hiddenOverlays[overlay] = 1;
				}
			}
			
		}
		
		/**
		 * Show all overlays. If only hidden is true then shows only already hidden overlays.
		 * */
		public function showAllOverlays(onlyHidden:Boolean = true):void {
			var overlay:Object
			
			if (onlyHidden) {
				for (overlay in hiddenOverlays) {
					
					if (overlay.visible==false) {
						overlay.visible = true;
						delete hiddenOverlays[overlay];
					}
				}
			}
			else {
				for (overlay in overlays) {
					overlay.visible = true;
					//hiddenOverlays[overlay]
				}
			}
			
		}
		
		/**
		 * Returns true if two objects intersect
		 * */
		public function intersects(popup:DisplayObject, overlay:DisplayObject):Boolean {
			var popupRectangle:Rectangle = getRectangleBounds(popup);
			var overlayRectangle:Rectangle = getRectangleBounds(overlay);
			
			if (popupRectangle && overlayRectangle && popupRectangle.intersects(overlayRectangle)) {
				return true;
			}
			
			return false;
		}
		
		/**
		 * Gets the perceptually expected bounds and position of a UIComponent. 
		 * If container is passed in then the position is relative to the container.
		 * 
		 * If the component does not have a parent then it returns null. 
		 * To fix this add it to the stage first and then call this method.  
		 * 
		 * Adapted from mx.managers.layoutClasses.LayoutDebugHelper
		 * */
		public static function getRectangleBounds(item:Object, container:* = null):Rectangle {
			
			if (item && item.parent && "getLayoutBoundsWidth" in item) {
				var w:Number = item.getLayoutBoundsWidth(true);
				var h:Number = item.getLayoutBoundsHeight(true);
				
				var position:Point = new Point();
				position.x = item.getLayoutBoundsX(true);
				position.y = item.getLayoutBoundsY(true);
				position = item.parent.localToGlobal(position);
				
				var rectangle:Rectangle = new Rectangle();
				
				if (container && container is DisplayObjectContainer) {
					var anotherPoint:Point = DisplayObjectContainer(container).globalToLocal(position);
					rectangle.x = anotherPoint.x;
					rectangle.y = anotherPoint.y;
				}
				else {
					rectangle.x = position.x;
					rectangle.y = position.y;
				}
				
				rectangle.width = w;
				rectangle.height = h;
				
				return rectangle;
			}
			
			return null;
		}
		
		/**
		 * Returns number of overlays
		 * */
		public function getNumberOfOverlays(hidden:Boolean = false):int {
			var count:int;
			var object:Object;
			
			if (hidden) {
				for (object in overlays) {
					count++;
				}
				
				return count;
			}
			
			for (object in hidden) {
				count++;
			}
			
			return count;
		}
		
		/**
		 * Returns true if overlays exist
		 * */
		public function hasOverlays(hidden:Boolean = false):Boolean {
			var object:Object;
			
			if (hidden) {
				for (object in hiddenOverlays) {
					return true;
				}
				
				return false;
			}
			
			for (object in overlays) {
				return true;
			}
			
			return false;
		}
		
		/**
		 * Remove all overlays
		 * */
		public function removeAllOverlays():void {
			var object:Object;
			
			for (object in hiddenOverlays) {
				hiddenOverlays[object] = null;
				delete hiddenOverlays[object];
			}
			
			for (object in overlays) {
				overlays[object] = null;
				delete overlays[object];
			}
			
		}
	}
}