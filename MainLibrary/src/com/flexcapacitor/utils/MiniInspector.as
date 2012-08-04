package com.flexcapacitor.utils {
	
	import flash.debugger.enterDebugger;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	import flash.utils.getQualifiedClassName;
	
	import mx.collections.ArrayCollection;
	import mx.core.FlexGlobals;
	import mx.core.IMXMLObject;
	import mx.core.IVisualElement;
	import mx.core.IVisualElementContainer;
	import mx.core.UIComponent;
	import mx.managers.SystemManager;
	import mx.utils.NameUtil;

	/**
	 * At runtime it will display information about the object you click on in the console. 
	 * It also lets you manually fade in and out a bitmap image.<br/><br/>
	 * 
	 * Click anywhere on the application while pressing the CTRL / COMMAND key and 
	 * information about the object under the mouse (that is also in the component tree excluding the skin) will be written to the console.<br/><br/>
	 * 
	 * Click anywhere on the application while pressing CTRL / CMD + ALT key and 
	 * information about the object under the mouse (that is in the component tree OR in the skin) will be written to the console.<br/><br/>
	 * 
	 * Adding the SHIFT key to the above keyboard shortcuts will cause you to enter the debugger 
	 * during a click handler event to inspect the properties and values of the item you clicked.<br/><br/>
	 * 
	 * The information output to the console includes a way to find the object in Eclipse. <br/>
	 * It will create a search pattern using a regular expression that will locate the document the object is defined in. 
	 * This is used with the Eclipse Search in Files dialog.<br/><br/>
	 * 
	 * To use find in files:<br/>
	 * • Open the Search in Files dialog (CTRL + H)<br/>
	 * • Copy the created pattern from the console and paste it into the search text input<br/>
	 * • select regular expression checkbox <br/>
	 * • select current workspace or project<br/>
	 * • click search.<br/><br/>
	 * 
	 * Note: If it has an ID it will find it quickly. If it doesn't it will narrow it down and in most cases still find it. <br/><br/>
	 * 
	 * Mini Inspector Usage<br/>
	 * Add the class to the declarations tag usually in the root application like so,<br/><br/>
	 * 
	 * &lt;utils:MiniInspector /><br/><br/>
	 * 
	 * To use the image fade in fade out:<br/>
	 * 
	 * • Add an image to your component for example, <br/>
	 * &lt;s:BitmapImage id="image" source="mockup.png" /><br/><br/>
	 * • Set the background image property to the image like so, <br/>
	 *  &lt;utils:MiniInspector backgroundImage="{image}"/><br/><br/>
	 * • Run the application<br/>
	 * • While holding COMMAND / CTRL scroll the mouse wheel up or down. <br/><br/>
	 * 
	 * More information at http://code.google.com/p/flexcapacitor/
	 * */
	public class MiniInspector implements IMXMLObject {
		
		private var _alpha:Number;
		private var _enabled:Boolean = true;
		private var message:String;
		private var _backgroundImage:IVisualElement;
		
		/**
		 * Flag indicating if the url starts with "http"
		 * */
		public var isOnServer:Boolean;
		
		/**
		 * Shows display object information instead of component information
		 * */
		private var showDisplayObjectInformation:Boolean = true;
		
		/**
		 * Show document information
		 * */
		public var showDocument:Boolean = true;
		
		/**
		 * Show parent document information
		 * */
		public var showParentDocument:Boolean = true;
		
		/**
		 * Show regular expression search pattern in console when checking target. 
		 * This is used to find the target in Eclipse.
		 * Copy the value and paste it into the Find or Search window with RegExp option checked.
		 * */
		public var showSearchPattern:Boolean = true;
		
		/**
		 * Shows the path of the target clicked excluding components in the skin.
		 * This shows the path from the component to the root component.
		 * 
		 * For example, if you click a label in a skin the path will start from
		 * the component that owns the button not the button itself.
		 * 
		 * Example:
		 * Button > Group > Application
		 * 
		 * @see showHeirarchy
		 * */
		public var showHeirarchy:Boolean = true;
		
		/**
		 * Show the path from the target up the display list or component display list
		 * in an ascending order. Default is true.
		 * */
		public var showHeirarchyAscending:Boolean = true;
		
		/**
		 * Shows divider markers in the console when checking the target
		 * */
		public var showConsoleDividerMarks:Boolean = true;
		
		/**
		 * Sets the alpha of the background image
		 * @see backgroundImage
		 * */
		public var backgroundImageAlpha:Number;
		
		/**
		 * Amount of alpha to change when scrolling the mouse wheel
		 * 
		 * @see backgroundImage
		 * @see backgroundImageAlpha
		 * */
		public var mouseWheelDelta:int;
		
		/**
		 * When an visual element is set and this option is enabled 
		 * and when the shift key is pressed scrolling up or down on the
		 * mouse wheel will increase or decrease the transparency of the 
		 * background image
		 * 
		 * @see backgroundImage
		 * @see backgroundImageAlpha
		 * */
		public var enableBackgroundCrossFade:Boolean = true;
		
		/**
		 * The amount to add to the mouse wheel delta to fade up or down the 
		 * transparency of the background image. 
		 * For example, if the delta is 4 and the multiplier is 10 then the amount 
		 * to add to the alpha value is .4 since 4/10. 
		 * Default is 20. 
		 * 
		 * @see backgroundImage
		 * @see backgroundImageAlpha
		 * @see mouseWheelDelta
		 * */
		public var multiplier:int = 20;
		
		/**
		 * Reference to the document set automatically when declared in MXML.
		 * If this class isn't declared in MXML then it is not set.
		 * You must set this manually if you want the path of the target to work
		 * when checking the target.
		 * */
		public var document:Object;
		
		/**
		 * ID of the reference to the document set automatically when declared in MXML.
		 * If this isn't declared in MXML then it is not set.
		 * */
		public var documentID:String;
		
		/**
		 * Flags used to set the "dot all" property to on for multiline support in Eclipse.
		 * Default value is "(?s)".
		 * */
		public var regExpSearchFlags:String = "(?s)";
		
		
		public function MiniInspector() {
			var rootDisplay:DisplayObject = SystemManager.getSWFRoot(this);
			
			isOnServer = rootDisplay.loaderInfo.url.indexOf("http")==0 ? true : false;
			
			SystemManager.getSWFRoot(this).addEventListener(MouseEvent.CLICK, handleClick, true, 0, true);
		}
		
		public function initialized(document:Object, id:String):void {
			this.document = document;
			this.documentID = id;
		}
		
		/**
		 * Set this to an image or visual element on the stage. At runtime hold the COMMAND key and 
		 * scroll the mouse wheel up or down to fade the element in or out.
		 * */
		public function get backgroundImage():IVisualElement {
			return _backgroundImage;
		}

		public function set backgroundImage(value:IVisualElement):void {
			_backgroundImage = value;
			
			// this does something
			if (_backgroundImage) {
				SystemManager.getSWFRoot(this).addEventListener(MouseEvent.MOUSE_WHEEL, mouseWheelHandler, true, 0, true);
			}
			else {
				SystemManager.getSWFRoot(this).removeEventListener(MouseEvent.MOUSE_WHEEL, mouseWheelHandler, true);
			}
			
		}
		
		/**
		 * Enables or disables this class
		 * */
		public function get enabled():Boolean {
			return _enabled;
		}

		public function set enabled(value:Boolean):void {
			_enabled = value;
			
			// enabled
			if (value) {
				SystemManager.getSWFRoot(this).addEventListener(MouseEvent.CLICK, handleClick, true, 0, true);
			}
			else {
				SystemManager.getSWFRoot(this).removeEventListener(MouseEvent.CLICK, handleClick, true);
			}
			
		}

		/**
		 * Click handler added to stage
		 * We only check the target if the alt key is down
		 * If the shift key is down also then we enter the debugger
		 * Press step into to bring the debugger to the check target method
		 * In that method you can check details in the target property
		 * */
		protected function handleClick(event:MouseEvent):void {
			
			if (enabled) {
				if (event.ctrlKey) {
					// we are intercepting this event so we can inspect the target
					// stop the event propagation
					event.stopImmediatePropagation();
					checkTarget(event);
				}
			}
		}
		
		/**
		 * Handler to increase or decrease the transparency of a visual element
		 * on a mouse wheel scroll event
		 * */
		protected function mouseWheelHandler(event:MouseEvent):void {
			
			if (enabled && enableBackgroundCrossFade && backgroundImage) {
				if (event.shiftKey || event.ctrlKey) {
					mouseWheelDelta = event.delta;
					_alpha = backgroundImage.alpha;
					
					_alpha = _alpha + mouseWheelDelta/multiplier;
					_alpha = _alpha>1?1:_alpha<0?0:_alpha;
					
					backgroundImage.alpha = _alpha;
					
					// prevent scrolling higher up the line
					event.stopImmediatePropagation();
				}
			}
		}
		
		/**
		 * Gets the current target and traces it to the console
		 * */
		private function checkTarget(event:MouseEvent):void {
			var rootComponent:ComponentItem = document ? getComponentDisplayList(document) : getComponentDisplayList(FlexGlobals.topLevelApplication);
			var componentItem:ComponentItem= getComponentFromDisplayObject(DisplayObject(event.target), rootComponent);
			var target:DisplayObject = event.target as DisplayObject;
			
			
			if (showDisplayObjectInformation) {
				if (event.altKey) {
					message = getComponentDetails(componentItem.accessPath, true);
				}
				else {
					message = getComponentDetails(componentItem, false);
				}
			}
			else {
				// NOT SUPPORTED YET
				//message = getDisplayObjectDetails(event.target);
			}
			
			
			trace(message);
			
			
			// The purpose of this is to check the properties on the target
			if (event.shiftKey) {
				
				// the debugger doesn't take you here until you press step into or step over
				trace("\n// Click your heels three times and step in...");
				
				// the target object contains the item you clicked on
				enterDebugger();
			}
		}
		
		/**
		 * Get's details about the target such as id, type, ancestors and search pattern
		 * */
		private function getComponentDetails(componentItem:ComponentItem, includeSkinComponents:Boolean = false):String {
			var searchPattern:String;
			var message:String = "";
			var document:Object;
			var name:String;
			var out:String;
			var item:Array;
			
			
			message += showConsoleDividerMarks ? "\n~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~":"";
			
			
			// describe component
			if (componentItem.id!=null) {
				message += "\n " + componentItem.id + " is a " + componentItem.name;
			}
			else {
				message += "\n The target is an instance of " + componentItem.name;
			}
			
			
			// get document
			if (showDocument) {
				if (componentItem.documentID!=null) {
					message += "\n It's document " + componentItem.documentID + " is a " + componentItem.documentName;
				}
				else {
					message += "\n It's document is an instance of " + componentItem.documentName;
				}
			}
			
			
			// get parent document
			if (showParentDocument) {
				
				if (componentItem.parentDocumentID!=null) {
					message += "\n It's defined in " + componentItem.parentDocumentID + " which is a " + componentItem.parentDocumentName;
				}
				else {
					message += "\n It's defined in an instance of " + componentItem.parentDocumentName;
				}
			}
			
			
			
			// show heirachy
			if (showHeirarchy) {
				out = getComponentPath(componentItem, showHeirarchyAscending);
				
				message += "\n It's located in "+ out;
			}
			
			
			// show regexp to find in Eclipse
			if (showSearchPattern) {
				searchPattern = getRegExpSearchPattern(DisplayObject(componentItem.instance), componentItem.parentDocumentName, false);
				
				if (componentItem.id) {
					message += "\n Search in files with regexp " + searchPattern;
				}
				else {
					message += "\n Search in files with regexp \"" + searchPattern + "\". Add an ID to it to get a better search pattern";
				}
			}
			
			
			message += showConsoleDividerMarks ? "\n~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~" : "";
			
			
			return message;
		}
		
		/**
		 * Gets the path up the component display list tree 
		  
		 Usage:
		 var string:String = getComponentPath(componentItem); // componentItem.instance is Button
		 
		 trace(string); // application > group > group > button
		 
		 * */
		public function getComponentPath(componentItem:ComponentItem, ascending:Boolean = false, separator:String = " > "):String {
			var items:Array = [];
			var out:String = "";
			
			while (componentItem) {
				items.push(componentItem.name);
				componentItem = componentItem.parent;
			}
			
			out = ascending ? items.join(separator) : items.reverse().join(separator);
			
			return out;
		}
		
		/**
		 * Get qualified class name of the target object
		 * */
		public function getQualifiedClassName(element:Object):String {
			var name:String = flash.utils.getQualifiedClassName(element);
			return name;
		}
		
		/**
		 * Gets the component tree list starting at the given element. 
		 * */
		public function getComponentDisplayList(element:Object, parentItem:ComponentItem = null, depth:int = 0):ComponentItem {
			var item:ComponentItem;
			var childElement:IVisualElement;
			
			
			if (!parentItem) {
				parentItem = new ComponentItem(element);
				parentItem.children = new ArrayCollection();
				return getComponentDisplayList(element, parentItem);
			}
			
			
			if (element is IVisualElementContainer) {
				var visualContainer:IVisualElementContainer = IVisualElementContainer(element);
				var length:int = visualContainer.numElements;
				
				for (var i:int;i<length;i++) {
					childElement = visualContainer.getElementAt(i);
					item = new ComponentItem(childElement);
					item.parent = parentItem;
					
					parentItem.children.addItem(item);
					
					// check for IVisualElement
					if (childElement is IVisualElementContainer && IVisualElementContainer(childElement).numElements>0) {
						item.children = new ArrayCollection();
						getComponentDisplayList(childElement, item, depth + 1);
					}
					
					
				}
			}
			
			return parentItem;
		}
		
		/**
		 * Finds the target component in the component tree
		 * returns ComponentItem where instance is the target
		 * 
		 * Note: the component tree is created by getComponentDisplayList();
		 * parentItem could be the root component tree object
		 * */
		public function getTargetInDisplayList(target:Object, parentItem:ComponentItem, depth:int = 0):ComponentItem {
			var length:int = parentItem.children ? parentItem.children.length : 0;
			var possibleItem:ComponentItem;
			var itemFound:Boolean;
			
			if (target==parentItem.instance) {
				return parentItem;
			}
			
			for (var i:int; i < length; i++) {
				var item:ComponentItem = parentItem.children.getItemAt(i) as ComponentItem;
				
				if (item && item.instance==target) {
					itemFound = true;
					break;
				}
				
				if (item.children) {
					possibleItem = getTargetInDisplayList(target, item, depth + 1);
					
					if (possibleItem) {
						itemFound = true;
						item = possibleItem;
						break;
					}
				}
				
			}
			
			if (itemFound) return item;
			
			return null;
		}
		
		/**
		 * Find the component that contains the display object 
		 * AND is also on the component tree
		 * */
		public function getComponentFromDisplayObject(displayObject:DisplayObject, componentTree:ComponentItem):ComponentItem {
			var componentItem:ComponentItem;
			var displayPath:Array = [];
			var item:ComponentItem;
			
			// find the owner of a visual element that is also on the component tree
			while (displayObject) {
				componentItem = getTargetInDisplayList(displayObject, componentTree);
				
				if (componentItem) {
					if (displayPath.length>0) {
						componentItem.accessPath = displayPath[0];
					}
					else {
						componentItem.accessPath = componentItem;
					}
					return componentItem;
				}
				else {
					
					// accessPath
					item = new ComponentItem(displayObject);
					
					if (displayPath.length>0) {
						displayPath[displayPath.length-1].parent = item;
					}
					
					displayPath.push(item);
					
					
					// if we are here the display object is probably in a skin
					// if so we could create a tree / path until we get to the component item
					// something like displayObjectItem in the third argument
					// it would be accessPath
					if ("owner" in displayObject && displayObject['owner']!=null) {
						displayObject = Object(displayObject).owner as DisplayObjectContainer;
					}
					else {
						displayObject = displayObject.parent;
					}
					
				}
			}
			
			return componentItem;
		}
		
		/**
		 * With the given target it returns a regexp pattern that can be used to find it in the document, project or workspace
		 * If isScript is true it attempts to returns a pattern to find the exact instance in AS3
		 * The MXML pattern will find the instance with that ID. If the instance doesn't have an ID it will create a regexp that will narrow it down.
		 * 
		 * NOTE: Press CTRL + H to open the Search in Files dialog, paste the value in, check regular expression and press Find. 
		 * */
		public function getRegExpSearchPattern(target:DisplayObject, parentDocumentName:String = "", isScript:Boolean = false):String {
			var id:String = getIdentifier(target);
			var className:String = NameUtil.getUnqualifiedClassName(target);
			var applicationName:String;
			var pattern:String;
			var scriptPattern:String;
			
			if (id == null) {
				if (parentDocumentName) {
					applicationName = NameUtil.getUnqualifiedClassName(FlexGlobals.topLevelApplication);
					
					if (applicationName==parentDocumentName) {
						parentDocumentName = getSuperClassName(FlexGlobals.topLevelApplication);
					}
					
					// this finds the document tag then the tag name so something like Group ... :Button
					// the (?! is a positive look ahead. it matches a group after the main expression 
					pattern = regExpSearchFlags + "(?!:" + parentDocumentName + "(.)*:):" + className + " ";
					
				}
				return pattern;
			}
			else {
				pattern = className + "(.*)id\\s?=\\s?[\"|']" + id + "[\"|']";
				scriptPattern = id + ".addEventListener";
			}
			
			
			if (isScript) {
				return scriptPattern;
			}
			
			return pattern;
		}
		
		/**
		 * Gets the ID of the target object
		 * returns null if no ID is specified
		 * */
		public function getIdentifier(element:Object):String {
			var id:String;
			
			if (element && "id" in element) {
				id = element.id;
			}
			return id;
		}
		
		/**
		 * Get super class name of the target object
		 * */
		public function getSuperClassName(element:Object):String {
			var name:String = flash.utils.getQualifiedSuperclassName(element);
			if (name && name.indexOf("::")) {
				name = name.split("::")[name.split("::").length-1]; // i'm sure theres a better way to do this
			}
			
			return name;
		}
	}
}


import flash.display.DisplayObject;
import flash.utils.getQualifiedClassName;

import mx.collections.ArrayCollection;
import mx.utils.NameUtil;

/**
 * Describes the display object
 * */
class ComponentItem {
	
	
	public function ComponentItem(element:Object = null):void {
		
		if (element) {
			instance = element;
			className = getQualifiedClassName(element);
			name = NameUtil.getUnqualifiedClassName(element);
			id = "id" in element && element.id!=null ? element.id : null;

			document = "document" in element ? element.document : null;
			documentClassName = getQualifiedClassName(document);
			documentName = document ? NameUtil.getUnqualifiedClassName(document) : null;
			documentID = document && "id" in document && document.id!=null ? document.id : null;
			
			parentDocument = "parentDocument" in element ? element.parentDocument : null;
			parentDocumentClassName = getQualifiedClassName(parentDocument);
			parentDocumentName = parentDocument ? NameUtil.getUnqualifiedClassName(parentDocument) : null;
			parentDocumentID = parentDocument && "id" in parentDocument && parentDocument.id!=null ? parentDocument.id : null;
		}
	}
	
	/**
	 * ID
	 * */
	public var id:String;
	
	/**
	 * Unqualified class name
	 * */
	public var name:String;
	
	/**
	 * Qualified class name
	 * */
	public var className:String;
	
	/**
	 * Instance of component. Optional. 
	 * Used for display list
	 * */
	public var instance:Object;
	
	/**
	 * Document instance
	 * */
	public var document:Object;
	
	/**
	 * Document name
	 * */
	public var documentName:String;
	
	/**
	 * Document class name
	 * */
	public var documentClassName:String;
	
	/**
	 * Document ID
	 * */
	public var documentID:String;
	
	/**
	 * Parent document instance
	 * */
	public var parentDocument:Object;
	
	/**
	 * Document name
	 * */
	public var parentDocumentName:String;
	
	/**
	 * Document class name
	 * */
	public var parentDocumentClassName:String;
	
	/**
	 * Document ID
	 * */
	public var parentDocumentID:String;
	
	/**
	 * Children. Optional. 
	 * Used for display in heiarchy view such as Tree.
	 * */
	public var children:ArrayCollection;
	
	/**
	 * Parent
	 * */
	public var parent:ComponentItem;
	
	/**
	 * Accessed path from display object event to component.
	 * Used when determining the display object that was clicked
	 * */
	public var accessPath:ComponentItem;
	
}