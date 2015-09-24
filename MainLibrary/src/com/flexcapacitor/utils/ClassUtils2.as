



package com.flexcapacitor.utils {
	
	import com.flexcapacitor.events.InspectorEvent;
	import com.flexcapacitor.graphics.LayoutLines;
	import com.flexcapacitor.model.AccessorMetaData;
	import com.flexcapacitor.model.StyleMetaData;
	import com.flexcapacitor.model.VisualElementVO;
	
	import flash.desktop.Clipboard;
	import flash.desktop.ClipboardFormats;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.IEventDispatcher;
	import flash.utils.describeType;
	import flash.utils.getQualifiedClassName;
	import flash.utils.getQualifiedSuperclassName;
	
	import mx.collections.ArrayCollection;
	import mx.collections.XMLListCollection;
	import mx.core.IVisualElement;
	import mx.core.IVisualElementContainer;
	import mx.core.UIComponent;
	import mx.managers.ISystemManager;
	import mx.utils.DescribeTypeCache;
	import mx.utils.DescribeTypeCacheRecord;
	import mx.utils.NameUtil;
	import mx.utils.ObjectUtil;

	/**
	 * Helper class for class utilities
	 * */
	public class ClassUtils2 {


		public function ClassUtils2() {


		}
		
		/**
		 * Get unqualified class name of the target object
		 * @copy NameUtil.getUnqualifiedClassName()
		 * */
		public static function getClassName(element:Object):String {
			var name:String = NameUtil.getUnqualifiedClassName(element);
			return name;
		}
		
		/**
		 * Get the type of the value passed in
		 * */
		public static function getValueType(value:*):String {
			var type:String = getQualifiedClassName(value);
			
			if (type=="int") {
				if (typeof value=="number") {
					type = "Number";
				}
			}
			
			return type;
		}

		/**
		 * Gets the ID of the object or name or if name is not available gets the class name or null. 
		 * 
		 * @param name if id is not available then return name
		 * @param className if id and name are not available get class name
		 * 
		 * returns id or name or class name or null if none are found
		 * */
		public static function getIdentifierOrName(element:Object, name:Boolean = true, className:Boolean = true):String {

			if (element && "id" in element && element.id) {
				return element.id;
			}
			else if (element && name && "name" in element && element.name) {
				return element.name;
			}
			else if (element && className) {
				return getClassName(element);
			}
			
			return null;
		}
		
		/**
		 * Get package of the target object
		 * */
		public static function getPackageName(element:Object):String {
			var name:String = flash.utils.getQualifiedClassName(element);
			if (name && name.indexOf("::")) {
				name = name.split("::")[0];
			}
			
			return name;
		}

		/**
		 * Get super class name of the target object
		 * */
		public static function getSuperClassName(element:Object):String {
			var name:String = flash.utils.getQualifiedSuperclassName(element);
			if (name && name.indexOf("::")) {
				name = name.split("::")[name.split("::").length-1]; // i'm sure theres a better way to do this
			}
			
			return name;
		}

		/**
		 * Get the package of the super class name of the target
		 * */
		public static function getSuperClassPackage(element:Object):String {
			var name:String = flash.utils.getQualifiedSuperclassName(element);
			if (name && name.indexOf("::")) {
				name = name.split("::")[0];
			}
			
			return name;
		}

		/**
		 * Gets the ID of the target object
		 * returns null if no ID is specified or target is not a UIComponent
		 * */
		public static function getIdentifier(element:Object):String {
			var id:String;

			if (element && element.hasOwnProperty("id")) {
				id = element.id;
			}
			return id;
		}

		/**
		 * Get name of target object or null if not available
		 * */
		public static function getName(element:Object):String {
			var name:String;

			if (element.hasOwnProperty("name") && element.name) {
				name = element.name;
			}

			return name;
		}

		/**
		 * Get qualified class name of the target object
		 * */
		public static function getQualifiedClassName(element:Object):String {
			var name:String = flash.utils.getQualifiedClassName(element);
			return name;
		}
		
		/**
		 * Get parent document name
		 * 
		 * @return
		 */
		public static function getClassNameAndPackage(target:Object):Array {
			var className:String;
			var classPath:String;
			
			className = getClassName(target);
			classPath = getPackageName(target);
			
			return [className, classPath];
		}
		
		
		/**
		 *  Returns <code>true</code> if the object reference specified
		 *  is a simple data type. The simple data types include the following:
		 *  <ul>
		 *    <li><code>String</code></li>
		 *    <li><code>Number</code></li>
		 *    <li><code>uint</code></li>
		 *    <li><code>int</code></li>
		 *    <li><code>Boolean</code></li>
		 *    <li><code>Date</code></li>
		 *    <li><code>Array</code></li>
		 *  </ul>
		 *
		 *  @param value Object inspected.
		 *
		 *  @return <code>true</code> if the object specified
		 *  is one of the types above; <code>false</code> otherwise.
		 *  */
		public static function isSimple(value:*):Boolean {
			return ObjectUtil.isSimple(value);
		}
		
		/**
		 * Get metadata from an object by finding members by their type  
		 * */
		public static function getMemberDataByType(object:Object, type:Object):Object {
			if (type==null) return null;
			var className:String = type is String ? String(type) : getQualifiedClassName(type);
			var xml:XML = describeType(object);
			var xmlItem:XMLList = xml.*.(attribute("type")==className);
			return xmlItem;
		}
		
		/**
		 * Get metadata from an object by it's name. Lower case compare doesn't work. 
		 * */
		public static function getMemberDataByName(object:Object, propertyName:String, caseSensitive:Boolean = false):Object {
			if (propertyName==null) return null;
			var xml:XML = describeType(object);
			var xmlItem:XMLList;
			var lowerCaseProperty:String = propertyName.toLowerCase();
			
			if (caseSensitive) {
				xmlItem = xml.*.(attribute("name")==propertyName);
			}
			else {
				xmlItem = xml.*.(attribute("name").toString().toLowerCase()==lowerCaseProperty);
			}
			return xmlItem;
		}
		
		/**
		 * Get unqualified class name of the target object. <br/>
		 * 
		 * If target has the id of myImage and include class name is true then the result is
		 * "Image.myImage". If delimiter is "_" then the result is "Image_myImage". 
		 * If includeClassName is false then the result is, "myImage". 
		 * */
		public static function getClassNameOrID(element:Object, includeClassName:Boolean = false, delimiter:String = "."):String {
			var name:String = NameUtil.getUnqualifiedClassName(element);
			var id:String = element && "id" in element ? element.id : null;
			
			return !id ? name : includeClassName ? name + "." + id : id;
		}
		
		/**
		 * Get unqualified class name of the target object and name or ID. <br/>
		 * 
		 * If target has the id of myImage and include class name is true then the result is
		 * "Image.myImage". If delimiter is "_" then the result is "Image_myImage". 
		 * If includeClassName is false then the result is, "myImage". 
		 * */
		public static function getClassNameAndNameOrID(element:Object, includeClassName:Boolean = false, delimiter:String = "."):String {
			var name:String = getClassName(element);
			var id:String = getIdentifierOrName(element, true);
			
			return !id ? name : includeClassName ? name + "." + id : id;
		}
		
		/**
		 * Get unqualified class name of the document of the target object
		 * returns null if element is not a UIComponent
		 * */
		public static function getDocumentName(element:Object):String {
			var name:String;
			if (element is UIComponent) {
				name = NameUtil.getUnqualifiedClassName(UIComponent(element).document);
			}
			return name;
		}

		/**
		 * Checks if the source object is the same type as the target object. 
		 * */
		public static function isSameClassType(source:Object, target:Object):Boolean {
			if (source==null && target!=null) {
				return false;
			}
			if (target==null && source!=null) {
				return false;
			}
			
			if (flash.utils.getQualifiedClassName(source) == flash.utils.getQualifiedClassName(target)) {
				return true;
			}
			
			return false;
		}

		/**
		 * With the given target it returns a regexp pattern to find the exact instance in MXML
		 * If isScript is true it attempts to returns a pattern to find the exact instance in AS3
		 * The MXML pattern will find the instance with that ID. If the instance doesn't have an ID it no worky.
		 * NOTE: Press CMD+SHIFT+F to and check regular expression in the Find in Files dialog
		 * */
		public static function getRegExpSearchPattern(target:DisplayObject, isScript:Boolean = false):String {
			var id:String = getIdentifierOrName(target);
			var className:String = NameUtil.getUnqualifiedClassName(target);
			var pattern:String;
			var scriptPattern:String;

			if (id == null) {
				pattern = className + "(.*)";
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
		 * Clears outline drawn around target display object
		 * */
		public static function clearSelection(target:Object, systemManager:ISystemManager, remove:Boolean = false):void {
			LayoutLines.getInstance().clear(target, systemManager, remove);
		}
		
		/**
		 * Draws outline around target display object
		 * */
		public static function drawSelection(target:Object, systemManager:ISystemManager):void {
			LayoutLines.getInstance().drawLines(target, systemManager);
		}

		/**
		 * Copy text to clipboard
		 * */
		public static function copyToClipboard(text:String, format:String=ClipboardFormats.TEXT_FORMAT):void {
			Clipboard.generalClipboard.setData(ClipboardFormats.TEXT_FORMAT, text);
		}

		/**
		 * Returns an array of display objects of type VisualElementVO
		 * Optionally returns elements
		 * */
		public static function getElementChildrenArray(displayObject:DisplayObject, getElements:Boolean = false, getSkins:Boolean = true):ArrayCollection {
			var displayObject:DisplayObject = DisplayObject(displayObject);
			var displayObjectContainer:DisplayObjectContainer;

			var visualElementContainer:IVisualElementContainer;
			var visualElement:IVisualElement;

			var visualElementVO:VisualElementVO = new VisualElementVO();

			var children:ArrayCollection = new ArrayCollection();


			// attempt to cast to a specific type and assign in the process
			displayObjectContainer = displayObject as DisplayObjectContainer;
			visualElementContainer = displayObject as IVisualElementContainer;
			visualElement = displayObject as IVisualElement;


			// gather all the display objects on the current display object
			if (displayObjectContainer) {

				for (var bb:int = 0; bb < displayObjectContainer.numChildren; bb++) {
					
						// visualElementVO = createDisplayObjectVO(displayObjectContainer.getChildAt(bb));
					visualElementVO = VisualElementVO.unmarshall(displayObjectContainer.getChildAt(bb));
					children.addItem(visualElementVO);
				}
			}

			if (visualElementContainer && getElements) {

				for (var cc:int = 0; cc < visualElementContainer.numElements; cc++) {
						//visualElementVO = createDisplayObjectVO(displayObjectContainer.getChildAt(cc));
					visualElementVO = VisualElementVO.unmarshall(DisplayObject(visualElementContainer.getElementAt(cc)));
					children.addItem(visualElementVO);
				}
			}

			return children;
		}

		/**
		 * Get ancestors of target 
		 * 
		 * @param target
		 * @param collection
		 * @param ancestors
		 * @return
		 */
		public static function getVisualElementsArray(target:DisplayObject, collection:Array, ancestors:int = 0):Array {
			var vo:VisualElementVO;


			// do the worm up the display list
			while (target && ancestors>-1) {

				// store display element information
				vo = VisualElementVO.unmarshall(target);

				// save reference to display element VO's for tree
				if (!collection) collection = new Array();
				collection.push(vo);

				target = target.parent;
				ancestors--;

			}

			return collection;
		}
		
		/**
		 * Get the parent of the target that is also a UIComponent
		 * 
		 * @return
		 */
		public static function getParentUIComponent(target:DisplayObject):UIComponent {
			var found:Boolean;
			
			// run up the display list
			while (target) {
				target = target.parent;
				
				// check if next parent exists
				if (!target) {
					break;
				}
				
				if (target is UIComponent) {
					found = true;
					break;
				}
				
			}
			
			if (found) return UIComponent(target);
			return null;
		}
		
		/**
		 * Get the name of the target parent that is also a UIComponent
		 * 
		 * @return
		 */
		public static function getParentUIComponentName(target:DisplayObject):String {
			var parent:DisplayObject = getParentUIComponent(target);
			var className:String = getClassName(parent);
			return className;
		}
		
		
		/**
		 * Get parent document name
		 * 
		 * @return null if target is not a UIComponent
		 */
		public static function getParentDocumentName(target:Object):String {
			var className:String;
			if (target is UIComponent) {
				className = getClassName(target.parentDocument);
			}
			return className;
		}
		
		
		/**
		 * Dispatch target change event
		 * 
		 * @return
		 */
		public static function dispatchTargetChangeEvent(target:Object, source:IEventDispatcher):void {
			
			// let other inspectors know there is a new target selected
			var selectionChangeEvent:InspectorEvent = new InspectorEvent(InspectorEvent.CHANGE);
			selectionChangeEvent.targetItem = target;
			
			// store previous targets in a dictionary
			
			if (source) {
				source.dispatchEvent(selectionChangeEvent);
			}			
		}
		
		
		/**
		 * Change target. Use this instead of dispatchTargetChangeEvent()
		 * 
		 * TODO: Add a weak reference to the old target in a static array for history type navigation
		 * 
		 * @return
		 */
		public static function updateTarget(target:Object, source:IEventDispatcher):void {
			// TODO: Add a weak reference to the old target in a static array for history type navigation
			
			// let other inspectors know there is a new target selected
			var selectionChangeEvent:InspectorEvent = new InspectorEvent(InspectorEvent.CHANGE);
			selectionChangeEvent.targetItem = target;
			
			if (source) {
				source.dispatchEvent(selectionChangeEvent);
			}			
		}
		
		/**
		 * Converts an integer to hexidecimal. 
		 * For example, 16117809 returns "#EEEEEE" or something
		 * @return
		 */
		public static function convertIntToHex(item:Object):String {
			var hex:String = Number(item).toString(16);
			return ("00000" + hex.toUpperCase()).substr(-6);
		}
		
		/**
		 * Get describeType data for the given class. 
		 * Can take string, instance or class. 
		 * */
		public static function getDescribeType(object:Object):XML {
			var describedTypeRecord:mx.utils.DescribeTypeCacheRecord = mx.utils.DescribeTypeCache.describeType(object);
			
			return describedTypeRecord.typeDescription;
		}
		
		/**
		 * Get AccessorMetaData data for the given property. 
		 * */
		public static function getMetaDataOfProperty(target:Object, property:String):AccessorMetaData {
			var describedTypeRecord:mx.utils.DescribeTypeCacheRecord = mx.utils.DescribeTypeCache.describeType(target);
			var accessorMetaData:AccessorMetaData = new AccessorMetaData();
			var matches:XMLList = describedTypeRecord.typeDescription.accessor.(@name==property);
			var node:XML;
			
			if (matches.length()>0) {
				node = matches[0];
				accessorMetaData.unmarshall(node, target);
				return accessorMetaData;
			}
			
			return null;
		}
		
		/**
		 * Get StyleMetaData data for the given style. 
		 * */
		public static function getMetaDataOfStyle(target:Object, style:String, superType:String = null):StyleMetaData {
			var describedTypeRecord:mx.utils.DescribeTypeCacheRecord;
			var matches:XMLList;
			var styleMetaData:StyleMetaData;
			var extendsClassList:XMLList;
			var node:XML;
			
			if (superType) {
				describedTypeRecord = mx.utils.DescribeTypeCache.describeType(superType);
			}
			else {
				describedTypeRecord = mx.utils.DescribeTypeCache.describeType(target);
			}
			
			if (superType || target is String) {
				matches = describedTypeRecord.typeDescription.factory.metadata.(@name=="Style").arg.(@value==style);
			}
			else if (target is Object) {
				matches = describedTypeRecord.typeDescription.metadata.(@name=="Style").arg.(@value==style);
			}
			
			if (matches && matches.length()==0) {
				
				if (superType || target is String) {
					extendsClassList = describedTypeRecord.typeDescription.factory.extendsClass;
				}
				else if (target is Object) {
					extendsClassList = describedTypeRecord.typeDescription.extendsClass;
				}
				
				var length:int = extendsClassList.length();
				
				for (var i:int;i<length;i++) {
					var type:String = extendsClassList[i].@type;
					if (type=="Class") return null;
					return getMetaDataOfStyle(target, style, type);
				}
				
			}
			
			if (matches.length()>0) {
				node = matches[0].parent();
				styleMetaData = new StyleMetaData();
				styleMetaData.unmarshall(node, target);
				return styleMetaData;
			}
			
			return null;
		}
		
		/**
		 * Creates an array of metadata items for the given object type including inherited metadata. 
		 * 
		 * For example, if you give it a Spark Button class it gets all the
		 * information for it and then gets it's super class ButtonBase and 
		 * adds all that information and so on until it gets to Object. <br/><br/>
		 * 
		 * Usage:<br/><pre>
		 * var allStyles:XMLList = concatenateMetaDataXMLItems(myButton, "Style", new XMLList());
		 * </pre>
		 * @param metaType The name of the data in the item name property. Either Style or Event
		 * @param existingItems The list of the data in the item name property
		 * */
		public static function concatenateMetaDataXMLItems(object:Object, metaType:String, existingItems:XMLList = null):XMLList {
			var describedTypeRecord:mx.utils.DescribeTypeCacheRecord = mx.utils.DescribeTypeCache.describeType(object);
			var typeDescription:* = describedTypeRecord.typeDescription;
			var hasFactory:Boolean = typeDescription.factory.length()>0;
			var factory:* = typeDescription.factory;
			var extendsClass:XMLList = typeDescription.extendsClass;
			var extendsLength:int = extendsClass.length();
			var list:XMLListCollection = new XMLListCollection(typeDescription.*);
			// can be on typeDescription.metadata or factory.metadata
			var isRoot:Boolean = object is String ? false : true;
			var className:String = !isRoot ? object as String : getQualifiedClassName(object);
			var itemsLength:int;
			var itemsList:XMLList;
			var existingItemsLength:int = existingItems ? existingItems.length() : 0;
			var metaName:String;
			var duplicateItems:Array = [];
			
			if (metaType.toLowerCase()=="style") {
				metaType = "Style"; 
			}
			else if (metaType.toLowerCase()=="event") {
				metaType = "Event"; 
			}
			
			if (hasFactory) {
				//itemsList = factory.metadata.(@name==name); property "name" won't work! no matches found
				itemsList = factory.metadata.(@name==metaType);
			}
			else {
				itemsList = typeDescription.metadata.(@name==metaType);
			}
			
			itemsList = itemsList.copy();
			itemsLength = itemsList.length();
			
			//trace("getting info on class : " + className + " for data on " + nAmEe );
			//trace(" items : " + itemsList);
			
			
			for (var i:int;i<itemsLength;i++) {
				var item:XML = XML(itemsList[i]);
				metaName = item.arg[0].@value;
				item.@name = metaName;
				item.@metadataType = metaType;
				item.@declaredBy = className;
				//item.@className = className.indexOf("::")!=-1 ? className.split("::")[1] : className;
				//continue;
				
				for (var j:int=0;j<existingItemsLength;j++) {
					var existingItem:XML = existingItems[j];
					
					if (metaName==existingItem.@name) {
						delete itemsList[i];
						itemsLength--;
						i--;
						//trace("meta name: " + metaName);
						//trace("Deleting style: " + existingItem.@name);
						continue;
					}
				}
			}
			
			
			if (itemsLength>0) {
				existingItems = new XMLList(existingItems.toString()+itemsList.toString());
			}

			if (isRoot && extendsLength>0) {
				for (i=0;i<extendsLength;i++) {
					var newClass:String = String(extendsClass[i].@type);
					existingItems = concatenateMetaDataXMLItems(newClass, metaType, existingItems);
				}
			}
			
			return existingItems;
		}
		
		
		/**
		 * Sets the property on the target. Supports styles. 
		 * We should probably switch to the set property method 
		 * @return
		 */
		public static function setTargetProperty(target:Object, property:String, value:*, type:String = "String", isPropertyStyle:Object=null):void {
			var newAssignedValue:* = TypeUtils.getTypedValue(value, type);
			TypeUtils.applyProperty(target, property, newAssignedValue, type, isPropertyStyle);
		}
		
			
		/**
		 * @copy spark.components.gridClasses.GridItemEditor#save();
		 */
		public static function setProperty(target:Object, field:String, value:*):Boolean {
			
			var newData:Object = value;
			var property:String = field;
			var data:Object = target;
			var typeInfo:String = "";
			
			for each(var variable:XML in describeType((data).variable)) {
				if (property == variable.@name.toString()) {
					typeInfo = variable.@type.toString();
					break;
				}
			}
			
			if (typeInfo == "String") {
				if (!(newData is String))
					newData = newData.toString();
			}
			else if (typeInfo == "uint") {
				if (!(newData is uint))
					newData = uint(newData);
			}
			else if (typeInfo == "int") {
				if (!(newData is int))
					newData = int(newData);
			}
			else if (typeInfo == "Number") {
				if (!(newData is Number))
					newData = Number(newData);
			}
			else if (typeInfo == "Boolean") {
				if (!(newData is Boolean)) {
					var strNewData:String = newData.toString();
					
					if (strNewData) {
						newData = (strNewData.toLowerCase() == "true") ? true : false;
					}
				}
			}
			
			if (property && data[property] !== newData) {
				data[property] = newData;
			}
			
			return true;
		}
	}
}