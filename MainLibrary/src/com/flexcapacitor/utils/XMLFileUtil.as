




package com.flexcapacitor.utils {
	
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.filesystem.File;
	
	/**
	 * Saves settings to an XML file
	 * */
	public class XMLFileUtil extends EventDispatcher {
		
		
		private static var _self:XMLFileUtil;
		
		
		public static function get self():XMLFileUtil {
			
			if (_self == null) {
				_self = new XMLFileUtil(new SINGLEDOUBLE());
				_self.createFile(_self.name);
			}
			
			return _self;
		}
		
		/**
		 * XML item used when creating a new item.
		 * */
		public var defaultXMLItem:XML;
		
		/**
		 * Reference to the XML contents
		 * */
		public var contents:XML;
		
		/**
		 * Reference to the XML file
		 * */
		public var file:File;
		
		/**
		 * Name and path of the file. Should be stored in the same location
		 * */
		public var name:String = "ProjectSettings";
		
		/**
		 * Saves the property immediately
		 * */
		public var saveOnChange:Boolean = true;
		
		/**
		 * Location of default settings file. Do not overwrite. Use as a template.
		 * */
		private var defaultSettingsPath:String;
		
		
		public function XMLFileUtil(s:SINGLEDOUBLE) {
			
		}
		
		/**
		 * Checks if the file exists 
		 * Does not automatically create a file.
		 * */
		public function fileExists(name:String):Boolean {
			var fileCheck:File = new File(name);
			
			if (name && fileCheck && fileCheck.exists && !fileCheck.isDirectory) {
				return true;
			}
			return false;
		}
		
		/**
		 * Creates the file. Sets the content property to the file XML data. 
		 * Sets the name property to the path
		 * */
		public function createFile(path:String):File {
			file = new File(path);
			
			if (path && file && file.exists && !file.isDirectory) {
				contents = new XML(file.data);
			}
			else {
				// get default file
				file = new File(defaultSettingsPath);
			}
			
			name = path;
			return file;
		}
		
		/**
		 * Opens the file. Same as create file
		 * */
		public function openFile(path:String):void {
			createFile(path);
		}
		
		/**
		 * Sets the key to the file
		 * */
		public function setItemValue(name:String, value:Object, createNonExistantItems:Boolean = false):void {
			var key:XML = contents..items.(name==name);
			
			if (key) {
				key.content = value;
			}
			else if (createNonExistantItems) {
				addItem(name, value);
			}
			
			if (saveOnChange) {
				save();
			}
		}
		
		/**
		 * Creates an item and adds it to the contents
		 * */
		public function addItem(name:String, value:Object, overwrite:Boolean = false):void {
			var itemExists:XML = contents..items.(name==name);
			var newItem:XML;
			
			if (itemExists && overwrite) {
				itemExists.content = value;
			}
			else {
				newItem = createItem(name, value);
				contents.items.appendChild(newItem);
			}
		}
		
		/**
		 * Create a new XML item. The default item is embedded in the class itemClass;
		 * */
		public function createItem(name:String, value:Object):XML {
			if (defaultXMLItem) {
				return new XML(defaultXMLItem);
			}
			return new XML();
		}
		
		/**
		 * Takes a target and a list of properties. Then saves the value of those properties in 
		 * the shared object using the same names as the keys
		 * 
		 * For example, we have PersonVO, and it has properties name, address and phone
		 * Pass in the instance and the name of the properties and it will save the properties
		 * name, address and phone as keys and the values as values
		 * */
		public function setValuesOfItemsFromTarget(target:Object, propertyNames:Array, createNonExistantItems:Boolean = false):void {
			var saveOnChangeValue:Boolean = saveOnChange;
			
			// prevent saving until after all items have been set
			saveOnChange = false;
			
			// loop through each property on the target and set the item and value
			for (var i:int; i<propertyNames.length;i++) {
				//trace("setting " + propertyNames[i] + " to " + target[propertyNames[i]]);
				setItemValue(propertyNames[i], target[propertyNames[i]], createNonExistantItems);
			}
			
			// restore save on change setting
			saveOnChange = saveOnChangeValue;
			
			if (saveOnChange) {
				save();
			}
		}
		
		/**
		 * Save the contents XML to file
		 * */
		public function save():void {
			file.save(contents.toXMLString());
		}
		
		/**
		 * Gets the value of the XML item by name
		 * */
		public function getItemValue(name:String):XML {
			var key:XML = contents..items.(name==name);
			
			if (key) {
				return key.content;
			}
			
			return null;
		}
		
		/**
		 * Get all XML items
		 * */
		public function getAllItems():Array {
			return contents..items;
		}
		
		/**
		 * Remove all the items in the XML file
		 * */
		public function removeAllItems():void {
			var items:XMLList = contents..items;
			
			for (var i:int = items.length(); i>0;i--) {
				delete items[i];
			}
			
			if (saveOnChange) {
				save();
			}
		}
		
		/**
		 * Gets the size of the XML file
		 * */
		public function getDiskUsage():int {
			
			if (file && file.size) {
				return file.size;
			}
			
			return 0;
		}
		
		/**
		 * Gets the space available for the XML file
		 * */
		public function getDiskSpaceAvailable():int {
			
			if (file && file.size) {
				return file.spaceAvailable;
			}
			
			return 0;
		}
	}
}

class SINGLEDOUBLE{}