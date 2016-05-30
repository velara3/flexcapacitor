
package com.flexcapacitor.model {
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.system.ApplicationDomain;
	import flash.system.Capabilities;
	import flash.ui.Keyboard;
	import flash.utils.getDefinitionByName;
	
	import mx.events.MenuEvent;
	
	
	/**
	 *  Dispatched on selection as a result
	 *  of user interaction. 
	 *
	 *  @eventType spark.events.MenuEvent.SELECTED
	 */
	[Event(name="selected", type="flash.events.Event")]
	
	/**
	 *  Dispatched when selection is checked as a result
	 *  of user interaction. 
	 *
	 *  @eventType spark.events.MenuEvent.CHECKED
	 */
	[Event(name="checked", type="flash.events.Event")]
	
	/**
	 *  Dispatched when selection changes as a result
	 *  of user interaction. 
	 *
	 *  @eventType mx.events.MenuEvent.CHANGE
	 */
	[Event(name="change", type="mx.events.MenuEvent")]
	
	/**
	 *  Dispatched when a menu item is selected. 
	 *
	 *  @eventType mx.events.MenuEvent.ITEM_CLICK
	 */
	[Event(name="itemClick", type="mx.events.MenuEvent")]
	
	/**
	 *  Dispatched when a menu or submenu is dismissed.
	 *
	 *  @eventType mx.events.MenuEvent.MENU_HIDE
	 */
	[Event(name="menuHide", type="mx.events.MenuEvent")]
	
	/**
	 *  Dispatched when a menu or submenu opens. 
	 *
	 *  @eventType mx.events.MenuEvent.MENU_SHOW
	 */
	[Event(name="menuShow", type="mx.events.MenuEvent")]
	
	/**
	 *  Dispatched when a user rolls the mouse out of a menu item.
	 *
	 *  @eventType mx.events.MenuEvent.ITEM_ROLL_OUT
	 */
	[Event(name="itemRollOut", type="mx.events.MenuEvent")]
	
	/**
	 *  Dispatched when a user rolls the mouse over a menu item.
	 *
	 *  @eventType mx.events.MenuEvent.ITEM_ROLL_OVER
	 */
	[Event(name="itemRollOver", type="mx.events.MenuEvent")]
	
	[DefaultProperty("children")]
	
	/**
	 * Holds information about the menu item
	 * 
	 * Includes an example of using a keyboard modifier
	 * */
	public class MenuItem extends EventDispatcher {
		
		/**
		 * Constructor
		 * */
		public function MenuItem() {
			if (!initialized) {
				initialize();
			}	
		}
		
		public static var NativeMenuQualifiedName:String = "flash.display.NativeMenu";
		public static var NativeMenuItemQualifiedName:String = "flash.display.NativeMenuItem";
		public static var MenuItemQualifiedName:String = "MenuEvent";
		public static var NativeMenuDefinition:Object;
		public static var NativeMenuItemDefinition:Object;
		public static var isWin:Boolean;
		public static var isMac:Boolean;
		public static var menuEventType:Class;
		
		/**
		 * If true we have already checked if native classes were available.
		 * @see #createInstance()
		 * */
		public static var initialized:Boolean;

		/**
		 * Specifies if it is enabled
		 * */
		[Bindable]
		public var enabled:Boolean = true;

		/**
		 * Specifies if it's a toggle
		 * */
		[Bindable]
		public var toggled:Boolean;

		/**
		 * Specifies if it's checked
		 * From NativeMenuItem
		 * */
		[Bindable]
		public var checked:Boolean;

		/**
		 * Specifies if it's a separator
		 * From NativeMenuItem
		 * */
		public var isSeparator:Boolean;

		/**
		 * Specifies if it's supported
		 * From NativeMenu
		 * */
		public var isSupported:Boolean;
		
		/**
		 * Name of the menu 
		 * */
		public var name:String;
		
		/**
		 * Data used for whatever you need
		 * */
		public var data:Object;
		
		/**
		 * Keyboard key equivalent.
		 * http://help.adobe.com/en_US/flex/using/WSacd9bdd0c5c09f4a-690d4877120e8b878b0-7fea.html#WSacd9bdd0c5c09f4a-690d4877120e8b878b0-7fde
		 * */
		public var keyEquivalent:String;
		
		/**
		 * Keyboard equivalent modifiers. Used in NativeMenuItem 
		 * */
		public var keyEquivalentModifiers:Array;
		
		/**
		 * Function to override default keyboard key combinations for when on different operating systems
		 * */
		public var keyEquivalentModifiersFunction:Function;
		
		/**
		 * Specifies if the control key needs to be pressed when using a key modifier
		 * */
		public var controlKey:Boolean;
		
		/**
		 * Specifies if the shift key needs to be pressed when using a key modifier
		 * */
		public var shiftKey:Boolean;
		
		/**
		 * Specifies if the command key needs to be pressed when using a key modifier
		 * */
		public var commandKey:Boolean;
		
		/**
		 * Specifies if the alt key needs to be pressed when using a key modifier
		 * */
		public var altKey:Boolean;
		
		/**
		 * Specifies if part of a radio like group of menu items
		 * */
		public var group:String;
		
		/**
		 * The parent of this menu item if this menu item is nested. If not it is null
		 * */
		public var parent:Object;
		
		/**
		 * The parent of this menu item if this menu item is nested. If not it is null
		 * From NativeMenuItem
		 * */
		public var menu:Object;
		
		/**
		 * If the menu item was imported from NativeMenuItem then we save a reference here
		 * and add event listeners to it to redispatch to the original event listeners
		 * */
		public var importedMenuItem:Object;
		
		/**
		 * The menu items of this menu item. If not it is null
		 * From NativeMenuItem
		 * */
		public var submenu:Object;
		
		/**
		 * Label displayed in the menu
		 * */
		public var label:String;
		
		/**
		 * Mnemonic index. I think this is the location of the letter in the label that is used as a 
		 * shortcut keyboard handling key.
		 * 
		 * If label is "Save" and you want to use "S" key to trigger 
		 * a click event then set index to 0. If you want to use "a" 
		 * then set the index to "1". 
		 * */
		public var mnemonicIndex:int;
		
		/**
		 * Specifies type of menu item if it's a checkbox, radio button, or separator
		 * Default is null. 
		 * */
		[Inspectable(category="General", enumeration="check,radio,separator")]
		public var type:String = null;
		
		/**
		 * Specifies an icon. Default is null.
		 * */
		public var icon:Object = null;

		private var _children:Array = [];
		
		/**
		 * Nested menu items. Removing requirement to see if we can 
		 * combine different types of menu items so we can 
		 * reuse the default WindowApplication Edit menu with our 
		 * menu items.
		 * 
		 * Using this requires us to use a custom menu bar data descriptor
		 * */
	    //[Inspectable(category="General", arrayType="MenuItem")]
	    public function set children(value:Array):void {
	    	_children = value;
			var numberOfItems:int = value ? value.length : 0;
	    	
			if (value) {
		    	for (var i:int; i < numberOfItems; i++) {
		    		value[i].parent = this;
				}
			}
	    }

		/**
		 * @private
		 * */
		public function get children():Array {
			return _children;
		}
		
		/**
		 * Add a child menu item to this menu
		 * */
		public function addItem(item:MenuItem):void {
			addItemAt(item, children.length);
		}
		
		/**
		 * Add a child menu item at the specified index
		 * To support NativeMenuItem we type as Object
		 * */
		public function addItemAt(item:Object, index:int):void {
			
			if (!children) {
				children = [];
			}
			
			children.splice(index, 0, item);
			
			if (item is MenuItem) {
				item.parent = this;
			}
			else {
				
			}
		}
		
		/**
		 * Get the child menu item at the specified index
		 * To support NativeMenuItem we type as Object
		 * */
		public function getItemAt(index:int):Object {
			return children[index];
		}
		
		/**
		 * Get child menu item by name
		 * To support NativeMenuItem we type as Object
		 * */
		public function getItemByName(name:String):Object {
			var item:Object = null;
			var numberOfItems:int;
	    	
	    	if (this.name == name) {
	    		item = this;
			}
	    	else if (children) {
				numberOfItems = children.length;
				
	    		for (var i:int;i<numberOfItems;i++) {
					item = children[i];
					
					//if ((item = MenuItem(children[i]).getChildByName(name))) {
	    			if ("getItemByName" in item && item.getItemByName(name)) {
	    				break;
					}
				}
	    	}
			
	    	return item;
		}
		
		/**
		 * Get child menu item by index
		 * */
		public function getItemIndex(item:MenuItem):int {
			if (!children) {
				return -1;
			}
			
    		for (var i:int;i<children.length;i++) {
    			if (item == children[i]) {
    				return i;
				}
    		}
    		
    		return -1;		
		}
		
		/**
		 * Remove all child menu items
		 * */
		public function removeAllChildren():void {
			children = [];
		}
		
		/**
		 * Remove child menu item
		 * */
		public function removeChild(item:MenuItem):void {
			var index:int = getItemIndex(item);
			
			if (index >= 0) {
				removeItemAt(index);
			}
		}
		
		/**
		 * Remove child menu item at specified index
		 * */
		public function removeItemAt(index:int):void {
			if (index >= 0 && index < children.length) {
				children.splice(index, 1);
			}
			
			if (children.length == 0) {
				children = [];
			}
		}
		
		/**
		 * Set child menu item index
		 * */
		public function setItemIndex(item:MenuItem, index:int):void {
			var oldIndex:int = getItemIndex(item);
			var newIndex:int;
			
			if (oldIndex >= 0) {
				removeItemAt(oldIndex);
				newIndex = oldIndex < index ? index - 1 : index;
				addItemAt(item, newIndex);
			}
				
		}

		/**
		 * Find child menu items by group
		 * */
	    public function findItemsByGroup(group:String):Array {
	    	var items:Array = [];
			var numberOfItems:int = children ? children.length : 0;
			
	    	if (this.group == group) {
	    		items.push(this);
			}
	    	
	    	for (var i:int; i < numberOfItems; i++) {
	    		items.splice(items.length, 0, MenuItem(children[i]).findItemsByGroup(group));
	    	}
		    
		    return items;
	    }
		
		/**
		 * Use this to import NativeMenu and NativeMenuItems
		 * */
		public static function createInstance(item:Object):MenuItem {
			var menuItem:MenuItem;
			var subItem:MenuItem;
			var items:Array;
			var numberOfItems:int;
			var dispatcher:IEventDispatcher;
			
			if (item is (NativeMenuDefinition as Class)) {
				menuItem = new MenuItem();
				menuItem.name = item.name;
			}
			else if (item is (NativeMenuItemDefinition as Class)) {
				menuItem = new MenuItem();
				menuItem.checked 				= item.checked;
				menuItem.data 					= item.data;
				menuItem.enabled 				= item.enabled;
				menuItem.isSeparator			= item.isSeparator;
				menuItem.keyEquivalent			= item.keyEquivalent;
				//menuItem.keyEquivalentChar		= item.keyEquivalentChar; private prop on NativeMenuItem
				menuItem.keyEquivalentModifiers	= item.keyEquivalentModifiers;
				menuItem.label					= item.label;
				menuItem.menu					= item.menu;
				menuItem.mnemonicIndex			= item.mnemonicIndex;
				menuItem.name 					= item.name;
				menuItem.submenu				= item.submenu;
				menuItem.type					= item.isSeparator ? "separator" : menuItem.type;
				menuItem.importedMenuItem		= item;
				
				items = menuItem.submenu && menuItem.submenu.items ? menuItem.submenu.items : [];
				numberOfItems =  items ? items.length : 0;
				
				for (var i:int; i < numberOfItems; i++) {
					subItem = createInstance(items[i]);
					menuItem.addItem(subItem);
				}
				
				if (item is IEventDispatcher) {
					dispatcher = item as IEventDispatcher;
					addEventListeners(menuItem, dispatcher)
				}
			}
			
			
			return menuItem;
		}
		
		// spark.events.MenuEvent is not in 4.6.0
		public static const CHECKED:String = "checked";
		public static const SELECTED:String = "selected";
		
		public static function addEventListeners(newMenuItem:MenuItem, originalMenu:IEventDispatcher, addAnyway:Boolean = true):void {
			
			if (menuEventType is MenuEvent) {
				
			}
			
			if (addAnyway || originalMenu.hasEventListener(SELECTED)) {
				newMenuItem.addEventListener(SELECTED, function(event:Event):void {
					originalMenu.dispatchEvent(event);
				}, false, 0, true);
			}
			
			if (addAnyway || originalMenu.hasEventListener(CHECKED)) {
				newMenuItem.addEventListener(CHECKED, function(event:Event):void {
					originalMenu.dispatchEvent(event);
				}, false, 0, true);
			}
			
			if (addAnyway || originalMenu.hasEventListener(mx.events.MenuEvent.ITEM_CLICK)) {
				newMenuItem.addEventListener(mx.events.MenuEvent.ITEM_CLICK, function(event:Event):void {
					originalMenu.dispatchEvent(event);
				}, false, 0, true);
			}
			
			if (addAnyway || originalMenu.hasEventListener(mx.events.MenuEvent.CHANGE)) {
				newMenuItem.addEventListener(mx.events.MenuEvent.CHANGE, function(event:Event):void {
					originalMenu.dispatchEvent(event);
				}, false, 0, true);
			}
			
			if (addAnyway || originalMenu.hasEventListener(mx.events.MenuEvent.ITEM_ROLL_OUT)) {
				newMenuItem.addEventListener(mx.events.MenuEvent.ITEM_ROLL_OUT, function(event:Event):void {
					originalMenu.dispatchEvent(event);
				}, false, 0, true);
			}
			
			if (addAnyway || originalMenu.hasEventListener(mx.events.MenuEvent.ITEM_ROLL_OVER)) {
				newMenuItem.addEventListener(mx.events.MenuEvent.ITEM_ROLL_OVER, function(event:Event):void {
					originalMenu.dispatchEvent(event);
				}, false, 0, true);
			}
			
			if (addAnyway || originalMenu.hasEventListener(mx.events.MenuEvent.MENU_HIDE)) {
				newMenuItem.addEventListener(mx.events.MenuEvent.MENU_HIDE, function(event:Event):void {
					originalMenu.dispatchEvent(event);
				}, false, 0, true);
			}
			
			if (addAnyway || originalMenu.hasEventListener(mx.events.MenuEvent.MENU_SHOW)) {
				newMenuItem.addEventListener(mx.events.MenuEvent.MENU_SHOW, function(event:Event):void {
					originalMenu.dispatchEvent(event);
				}, false, 0, true);
			}			
		}
		
		/*
		
		EXAMPLE OF      keyEquivalentModifiers
		
		*/
		
		protected function initialize():void {
			isWin = (Capabilities.os.indexOf("Windows") >= 0);
			isMac = (Capabilities.os.indexOf("Mac OS") >= 0);
			
			
			if (!initialized) {
				if (ApplicationDomain.currentDomain.hasDefinition(NativeMenuQualifiedName)) {
					NativeMenuDefinition = getDefinitionByName(NativeMenuQualifiedName);
				}
				
				if (ApplicationDomain.currentDomain.hasDefinition(NativeMenuItemQualifiedName)) {
					NativeMenuItemDefinition = getDefinitionByName(NativeMenuItemQualifiedName);
				}
				
				if (ApplicationDomain.currentDomain.hasDefinition(NativeMenuItemQualifiedName)) {
					NativeMenuItemDefinition = getDefinitionByName(NativeMenuItemQualifiedName);
				}
				
			}
			
			
			
			initialized = true;
		}
		
		/**
		 * Example modifier function
		 * http://help.adobe.com/en_US/flex/using/WSacd9bdd0c5c09f4a-690d4877120e8b878b0-7fea.html#WSacd9bdd0c5c09f4a-690d4877120e8b878b0-7fde
		 * */
		private function keyEquivalentModifiersExample(item:Object):Array { 
			var result:Array = new Array();
			var menu:Object;
			
			//var keyEquivField:String = menu.keyEquivalentField;
			var keyEquivField:String = menu.keyEquivalentField;
			var altKeyField:String;
			var controlKeyField:String;
			var shiftKeyField:String;
			
			if (item is XML) { 
				altKeyField = "@altKey";
				controlKeyField = "@controlKey";
				shiftKeyField = "@shiftKey";
			}
			else if (item is Object) { 
				altKeyField = "altKey";
				controlKeyField = "controlKey";
				shiftKeyField = "shiftKey";
			}
			
			if (item[keyEquivField] == null || item[keyEquivField].length == 0) { 
				return result;
			}
			
			if (item[altKeyField] != null && item[altKeyField] == true) 
			{
				if (isWin)
				{
					result.push(Keyboard.ALTERNATE); 
				}
			}
			
			if (item[controlKeyField] != null && item[controlKeyField] == true) 
			{
				if (isWin)
				{
					result.push(Keyboard.CONTROL);
				}
				else if (isMac) 
				{
					result.push(Keyboard.COMMAND);
				}
			}
			
			if (item[shiftKeyField] != null && item[shiftKeyField] == true) 
			{
				result.push(Keyboard.SHIFT);
			}
			
			return result;
		}
	}
}