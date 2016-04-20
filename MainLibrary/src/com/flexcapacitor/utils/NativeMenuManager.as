package com.flexcapacitor.utils
{
	import com.flexcapacitor.model.MenuItem;
	
	import flash.display.NativeMenu;
	import flash.display.NativeMenuItem;
	import flash.events.IEventDispatcher;
	import flash.utils.Dictionary;

	/**
	 * This class helps convert menu bar menu items of type MenuItem 
	 * into NativeMenuItems for operating systems like Mac OSX
	 * */
	public class NativeMenuManager
	{
		public function NativeMenuManager()
		{
		}
		
		public var nativeMenuDictionary:Dictionary = new Dictionary(true);
		
		/**
		 * Use this to create NativeMenu and NativeMenuItems from a MenuItem object
		 * */
		public function getNativeMenuItem(menuItem:MenuItem):NativeMenuItem {
			var subItem:NativeMenuItem;
			var items:Array;
			var numberOfItems:int;
			var dispatcher:IEventDispatcher;
			var nativeMenuItem:NativeMenuItem;
			var isSeparator:Boolean;
			
			isSeparator = menuItem.type=="separator" ? true : false;
			
			// seems separator has to be set in constructor
			nativeMenuItem = new NativeMenuItem(menuItem.label, isSeparator);
			
			nativeMenuItem.checked 				= menuItem.checked;
			nativeMenuItem.data 				= menuItem.data;
			nativeMenuItem.enabled 				= menuItem.enabled;
			//nativeMenuItem.isSeparator		= menuItem.isSeparator;
			
			// I need references to the sources for the information below
			// I think they are in the NativeMenuItem and NativeMenu classes
			
			/*
			Set the keyEquivalent with a lowercase letter to assign a shortcut 
			without a Shift-key modifier. Set with an uppercase letter to assign 
			a shortcut with the Shift-key modifier.
			
			By default, a key equivalent modifier 
			(Ctrl on Windows or Linux and Command on Mac OS X) 
			is included as part of the key equivalent. 
			If you want the key equivalent to be a key with no modifier, 
			set the keyEquivalentModifiers property to an empty array.
			*/
			nativeMenuItem.keyEquivalent		= menuItem.keyEquivalent;
			//  private prop on NativeMenuItem - remember event.keyChar is different then event.keyCode
			//nativeMenuItem.keyEquivalentChar	= menuItem.keyEquivalentChar;
			
			// If you do not assign any modifiers, then by default the 
			// Keyboard.CONTROL key is assigned on Windows or Linux and 
			// the Keyboard.COMMAND key is assigned on Mac OS X.
			// If you do not want the key equivalent to include these modifiers, 
			// set this property to an empty array.
			nativeMenuItem.label				= menuItem.label;
			//nativeMenuItem.menu				= menuItem.menu;
			//nativeMenuItem.mnemonicIndex		= menuItem.mnemonicIndex;
			nativeMenuItem.name 				= menuItem.name;
			//nativeMenuItem.keyEquivalentModifiers = menuItem.keyEquivalentModifiers;
			//nativeMenuItem.keyEquivalentModifiers = null; 
			if (menuItem.keyEquivalentModifiers && menuItem.keyEquivalentModifiers.length) {
				nativeMenuItem.keyEquivalentModifiers = menuItem.keyEquivalentModifiers;
			}
			//nativeMenuItem.submenu			= menuItem.submenu;
			//nativeMenuItem.type				= menuItem.isSeparator ? "separator" : menuItem.type;
			//nativeMenuItem.importedMenuItem	= menuItem;
			
			items = menuItem.children ? menuItem.children : [];
			numberOfItems =  items ? items.length : 0;
			
			for (var i:int; i < numberOfItems; i++) {
				//subItem = getNativeMenuItem(items[i] as MenuItem);
				
				//nativeMenuItem.addItem(subItem);
			}
			
			if (nativeMenuItem is IEventDispatcher) {
				dispatcher = nativeMenuItem as IEventDispatcher;
				//addEventListeners(nativeMenuItem, dispatcher)
			}
			
			nativeMenuDictionary[nativeMenuItem] = menuItem;
			
			return nativeMenuItem;
		}
		
		/**
		 * Use this to create NativeMenu and NativeMenuItems
		 * */
		public function getNativeMenu(menuItem:MenuItem):NativeMenu {
			var subItem:NativeMenuItem;
			var items:Array;
			var numberOfItems:int;
			var dispatcher:IEventDispatcher;
			var nativeMenu:NativeMenu;
			
			nativeMenu = new NativeMenu();
			
			//nativeMenu.checked 				= menuItem.checked;
			//nativeMenu.data 				= menuItem.data;
			//nativeMenu.enabled 				= menuItem.enabled;
			//nativeMenu.isSeparator		= menuItem.isSeparator;
			//nativeMenu.keyEquivalent		= menuItem.keyEquivalent;
			//nativeMenu.keyEquivalentChar	= menuItem.keyEquivalentChar; private prop on NativeMenuItem
			//nativeMenu.keyEquivalentModifiers	= menuItem.keyEquivalentModifiers;
			//nativeMenu.label				= menuItem.label;
			//nativeMenu.menu				= menuItem.menu;
			//nativeMenu.mnemonicIndex		= menuItem.mnemonicIndex;
			//nativeMenu.name 				= menuItem.name;
			//nativeMenu.submenu			= menuItem.submenu;
			//nativeMenu.type				= menuItem.isSeparator ? "separator" : menuItem.type;
			//nativeMenu.importedMenuItem	= menuItem;
			
			items = menuItem.children ? menuItem.children : [];
			numberOfItems =  items ? items.length : 0;
			
			for (var i:int; i < numberOfItems; i++) {
				subItem = getNativeMenuItem(items[i] as MenuItem);
				
				//nativeMenu.addItem(subItem);
			}
			
			if (nativeMenu is IEventDispatcher) {
				dispatcher = nativeMenu as IEventDispatcher;
				//addEventListeners(nativeMenu, dispatcher)
			}
			
			
			return nativeMenu;
		}
	}
}