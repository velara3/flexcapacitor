package com.flexcapacitor.utils
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.system.ApplicationDomain;
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	import mx.controls.ToolTip;
	import mx.core.FlexGlobals;
	import mx.core.FlexSprite;
	import mx.core.IMXMLObject;
	import mx.core.UIComponent;
	import mx.managers.SystemManager;
	import mx.managers.SystemManagerGlobals;
	import mx.utils.Platform;
	
	import spark.components.PopUpAnchor;
	
	/**
	 * Hides external overlays when a popup such as a tool tip, dropdown or other pop up appears. 
	 * Useful when running in the browser with an HTML element stacked higher than the plugin surface. 
	 * */
	public class PopUpOverlayManager extends EventDispatcher implements IMXMLObject {
		
		public function PopUpOverlayManager(target:IEventDispatcher=null, overlayTypes:Array = null, popUpTypes:Array = null) {
			super(target);
			
			if (_instance) {
				throw new Error("PopUpOverlayManager is a singleton. Use PopUpOverlayManager.getInstance()");
			}
			
			isBrowser = Platform.isBrowser;
			_instance = this;
			
			systemManager = SystemManagerGlobals.topLevelSystemManagers[0];
			
			if (systemManager) {
				systemManager.addEventListener(Event.ADDED, popupAddedHandler, false, 0, true);
				systemManager.addEventListener(Event.REMOVED, popupRemovedHandler, false, 0, true);
			}
			
			if (overlayTypes) {
				addOverlayTypes(overlayTypes);
			}
			
			if (popUpTypes) {
				addPopUpTypes(popUpTypes);
			}
		}
		
		public static function getInstance():PopUpOverlayManager {
			if (_instance==null) {
				_instance = new PopUpOverlayManager();
			}
			
			return _instance;
		}
		
		public var overlayTypes:Array = [];
		public var popUpTypes:Array = [];
		public var isBrowser:Boolean;
		private static var systemManager:SystemManager;
		private static var _instance:PopUpOverlayManager;

		public static function get instance():PopUpOverlayManager {
			if (_instance==null) {
				_instance = new PopUpOverlayManager();
			}
			return _instance;
		}

		private var overlays:Dictionary = new Dictionary(true);
		private var hiddenOverlays:Dictionary = new Dictionary(true);
		
		public var id:String;
		public function initialized(document:Object, id:String):void {
			this.id = id;
		}
		
		public function addPopUpTypes(popUpTypes:Array):void {
			var popUpType:Object;
			if (popUpTypes==null) return;
			
			for (var i:int = 0; i < popUpTypes.length; i++) {
				popUpType = popUpTypes[i];
				addPopUpType(popUpType);
			}
		}
		
		public function addOverlayTypes(overlayTypes:Array):void {
			var overlayType:Object;
			if (overlayTypes==null) return;
			
			for (var i:int = 0; i < overlayTypes.length; i++) {
				overlayType = overlayTypes[i];
				addOverlayType(overlayType);
			}
		}
		
		public function addOverlayType(overlayType:Object):void {
			var hasDefinition:Boolean;
			var qualifiedClassName:String;
			
			if (overlayType is String) {
				hasDefinition = ApplicationDomain.currentDomain.hasDefinition(overlayType as String);
				
				if (hasDefinition) {
					qualifiedClassName = overlayType as String;
				}
			}
			else if (overlayType is Object) {
				qualifiedClassName = getQualifiedClassName(overlayType);
				hasDefinition = true;
			}
			
			if (hasDefinition) {
				if (overlayTypes.indexOf(qualifiedClassName)==-1) {
					overlayTypes.push(qualifiedClassName);
				}
			}
		}
		
		public function addPopUpType(popUpType:Object):void {
			var hasDefinition:Boolean;
			var qualifiedClassName:String;
			
			if (popUpType is String) {
				hasDefinition = ApplicationDomain.currentDomain.hasDefinition(popUpType as String);
				
				if (hasDefinition) {
					qualifiedClassName = popUpType as String;
				}
			}
			else if (popUpType is Object) {
				qualifiedClassName = getQualifiedClassName(popUpType);
				hasDefinition = true;
			}
			
			if (hasDefinition) {
				if (popUpTypes.indexOf(qualifiedClassName)==-1) {
					popUpTypes.push(qualifiedClassName);
				}
			}
			
		}
		
		/**
		 * Adds an overlay to hide when intersecting pop ups occur
		 * */
		public function addOverlay(overlay:DisplayObject):void {
			//topLevelApplication = FlexGlobals.topLevelApplication;
			// trace("11. add popup overlay " + getQualifiedClassName(overlay));
			
			if ("systemManager" in overlay && Object(overlay).systemManager) {
				systemManager = Object(overlay).systemManager;
			}
			
			if (systemManager && !systemManager.hasEventListener(Event.ADDED) && !systemManager.hasEventListener(Event.REMOVED)) {
				systemManager.addEventListener(Event.ADDED, popupAddedHandler, false, 0, true);
				systemManager.addEventListener(Event.REMOVED, popupRemovedHandler, false, 0, true);
			}
			
			if (!hasOverlay(overlay)) {
				overlays[overlay] = true;
			}
		}
		
		/**
		 * Remove overlay from being managed
		 * */
		public function removeOverlay(overlay:DisplayObject):void {
			// trace("9. remove popup " + overlay);
			
			if ("systemManager" in overlay) {
				systemManager = Object(overlay).systemManager;
			}
			
			if (systemManager) {
				//systemManager.removeEventListener(Event.ADDED, addedHandler, false, 0, true);
				//systemManager.removeEventListener(Event.REMOVED, removedHandler, false, 0, true);
			}
			
			if (hasOverlay(overlay)) {
				overlays[overlay] = null;
				delete overlays[overlay];
			}
		}
		
		/**
		 * Handles when a pop up is added
		 * */
		protected function popupAddedHandler(event:Event):void {
			var displayObject:DisplayObject;
			var displayObjectName:String;
			var isToolTip:Boolean;
			var isCursor:Boolean;
			
			// trace("1. popup added");
			
			if (isBrowser) {
				displayObject = event.target as DisplayObject;
				
				if (displayObject) {
					displayObjectName = getQualifiedClassName(displayObject);
					
					// hide all overlays if we have a matching popup type
					if (popUpTypes && popUpTypes.indexOf(displayObjectName)!=-1) {
						// trace("1.3 popup type added");
						FlexGlobals.topLevelApplication.callLater(hideAllOverlays);
						return;
					}
					
					// add overlay automatically if not already hidden
					else if (overlayTypes && overlayTypes.indexOf(displayObjectName)!=-1) {
						// trace("1.5 overlay type added");
						
						if (!hasOverlay(displayObject)) {
							// trace("1.7 overlay type added");
							addOverlay(displayObject);
						}
					}
				}
				
				isToolTip = displayObject is ToolTip;
				isCursor = displayObject.name == "cursorHolder";
				
				if (isCursor) {
					return;
				}
				
				if (displayObject.parent == systemManager) {
					
					// trace("2. popup added call later");
					// trace("2.5. popup is " + displayObjectName);
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
			var areAllAncestorsVisible:Boolean;
			
			// trace("7. popup remove handler");
			
			for (var hiddenOverlay:Object in hiddenOverlays) {
				
				popup = hiddenOverlays[hiddenOverlay] as DisplayObject;
				areAllAncestorsVisible = getAllAncestorsVisible(hiddenOverlay);
				
				if (popup==removedDisplayObject && areAllAncestorsVisible && 
					hiddenOverlay.visible==false && hiddenOverlay.stage!=null) {
					// trace("8. popup remove handler");
					hiddenOverlay.visible = true;
					hiddenOverlays[hiddenOverlay] = null;
					delete hiddenOverlays[hiddenOverlay];
				}
			}
		}
		
		private function getAllAncestorsVisible(overlay:Object):Boolean {
			var parent:Object;
			var isVisible:Boolean;
			
			parent = overlay.parent;
			
			while (parent) {
				isVisible = parent.visible;
				
				if (isVisible==false) {
					return false;
				}
				
				parent = parent.parent;
			}
			
			return isVisible;
		}
		
		/**
		 * Checks that a popup is not intersecting with existing overlays
		 * */
		public function hideOverlappingObjects(popUp:DisplayObject):void {
			var isOver:Boolean;
			var isToolTip:Boolean;
			var ancestorsVisible:Boolean;
			
			// trace("3. popup hide overlap objects");
			
			for (var overlay:Object in overlays) {
				isToolTip = popUp is ToolTip;
				// trace("3.5. popUp is " + popUp);
				
				if (isToolTip) {
					// trace("4. is tool tip");
					isOver = intersects(popUp, overlay as DisplayObject);
					
					if (isOver) {
						
						if (overlay.stage!=null && overlay.visible==true) {
							ancestorsVisible = getAllAncestorsVisible(overlay);
							
							if (ancestorsVisible) {
								// trace("5. is over tool tip");
								overlay.visible = false;
								hiddenOverlays[overlay] = popUp;
							}
						}
					}
				}
				else if (!isToolTip) {
					if (overlay.stage!=null && overlay.visible==true) {
						// trace("6. is not tool tip");
						var numberOfChildren:int = systemManager.rawChildren.numChildren;
						var index:int = systemManager.rawChildren.getChildIndex(popUp);
						
						if ("isPopUp" in popUp && UIComponent(popUp).isPopUp==true) {
							if (UIComponent(popUp).owner is PopUpAnchor && PopUpAnchor(UIComponent(popUp).owner).isModal) {
								overlay.visible = false;
								hiddenOverlays[overlay] = popUp;
							}
							else {
								isOver = intersects(popUp, overlay as DisplayObject);
								
								if (isOver) {
									overlay.visible = false;
									hiddenOverlays[overlay] = popUp;
								}
							}
						}
						
						else if (index>0) {
							var modalWindow:FlexSprite = systemManager.rawChildren.getChildAt(index-1) as FlexSprite;
							
							if (modalWindow) {
								overlay.visible = false;
								hiddenOverlays[overlay] = popUp;
							}
						}
					}
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
		 * Returns true if an overlay is added
		 * */
		public function hasOverlay(overlay:Object, hidden:Boolean = false):Boolean {
			var overlay:Object;
			var result:Object;
			
			if (hidden) {
				result = hiddenOverlays[overlay];
				return result!=null; 
			}

			result = overlays[overlay];
			return result!=null;
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