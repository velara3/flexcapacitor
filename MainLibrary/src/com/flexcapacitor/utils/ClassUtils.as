



package com.flexcapacitor.utils {
	
	import com.flexcapacitor.model.AccessorMetaData;
	import com.flexcapacitor.model.StyleMetaData;
	
	import flash.utils.describeType;
	import flash.utils.getQualifiedClassName;
	import flash.utils.getQualifiedSuperclassName;
	
	import mx.utils.ArrayUtil;
	import mx.utils.DescribeTypeCacheRecord;
	import mx.utils.NameUtil;
	import mx.utils.ObjectUtil;
	import mx.utils.XMLUtil;

	/**
	 * Helper class for class utilities
	 * */
	public class ClassUtils {


		public function ClassUtils() {


		}
		
		public static const STYLE:String = "Style";
		public static const EVENT:String = "Event";
		
		/**
		 * Get unqualified class name of the target object
		 * */
		public static function getClassName(element:Object):String {
			var name:String = NameUtil.getUnqualifiedClassName(element);
			return name;
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
		 * Gets the ID of the object or name or if name is not available gets the class name or null. 
		 * 
		 * returns id or name or class name or null if none are found
		 * */
		public static function getIdentifierNameOrClass(element:Object):String {
			
			return getIdentifierOrName(element, true, true);
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
		 * Returns an array the properties for the given object including super class properties. <br/><br/>
		 * 
		 * Properties including accessors and variables are included.<br/><br/>
		 * 
		 * For example, if you give it a Spark Button class it gets all the
		 * properties for it and all the properties on the super classes.<br/><br/>
		 * 
		 * Usage:<br/>
		 <pre>
		 var allProperties:Array = getProperties(myButton);
		 </pre>
		 * 
		 * @param object The object to inspect. Either string, object or class.
		 * @param sort Sorts the properties in the array
		 * */
		public static function getPropertyNames(object:Object, sort:Boolean = true):Array {
			var describedTypeRecord:DescribeTypeCacheRecord = mx.utils.DescribeTypeCache.describeType(object);
			var typeDescription:* = describedTypeRecord.typeDescription;
			var hasFactory:Boolean = typeDescription.factory.length()>0;
			var factory:XMLList = typeDescription.factory;
			var itemsLength:int;
			var itemsList:XMLList;
			var propertyName:String;
			var properties:Array = [];
			
			itemsList = hasFactory ? factory.variable + factory.accessor : typeDescription.variable + typeDescription.accessor;
			itemsLength = itemsList.length();
			
			for (var i:int;i<itemsLength;i++) {
				var item:XML = XML(itemsList[i]);
				propertyName = item.@name;
				properties.push(propertyName);
			}
			
			if (sort) properties.sort();
			
			return properties;
		}
		
		/**
		 * Creates an XMLList of the property items for the given object type including super class properties. <br/><br/>
		 * 
		 * Properties including accessors and variables are included in this list. <br/><br/>
		 * 
		 * We add a few additional attributes to the metadata including the class the property is declared in,
		 * the name of the property. 
		 * 
		 * For example, if you give it a Spark Button class it gets all the
		 * information for it and all the classes that inherit from it. It then
		 * updates all that information with the class it was declared in 
		 * and so on until it gets to Object. <br/><br/>
		 * 
		 * Usage:<br/>
		 <pre>
		 var allProperties:XMLList = getPropertiesMetaData(myButton);
		 var buttonOnlyProperties:XMLList = getPropertiesMetaData(myButton, null, null, getQualifiedClassName(myButton));
		 var buttonOnlyProperties2:XMLList = getPropertiesMetaData(myButton, null, null, "spark.components::Button");
		 </pre>
		 * 
		 * @param object The object to inspect. Either string, object or class.
		 * @param propertyType Either accessor, variable or all. Default is all. 
		 * @param existingItems An existing list of properties
		 * @param stopAt Stops at Object unless you change this value
		 * */
		public static function getPropertiesMetaData(object:Object, propertyType:String = "all", existingItems:XMLList = null, stopAt:String = null):XMLList {
			var describedTypeRecord:DescribeTypeCacheRecord = mx.utils.DescribeTypeCache.describeType(object);
			var typeDescription:* = describedTypeRecord.typeDescription;
			var hasFactory:Boolean = typeDescription.factory.length()>0;
			var factory:* = typeDescription.factory;
			var extendsClass:XMLList = hasFactory ? typeDescription.factory.extendsClass : typeDescription.extendsClass;
			var typeName:String = describedTypeRecord.typeName;
			var extendsLength:int = extendsClass.length();
			// can be on typeDescription.metadata or factory.metadata
			var isRoot:Boolean = object is String ? false : true;
			var className:String = !isRoot ? object as String : getQualifiedClassName(object);
			var itemsLength:int;
			var itemsList:XMLList;
			var existingItemsLength:int = existingItems ? existingItems.length() : 0;
			var metaName:String;
			
			const PROPERTY:String = "property";
			const VARIABLE:String = "variable";
			const ACCESSOR:String = "accessor";
			
			if (propertyType==null) propertyType = "all";
			
			if (propertyType.toLowerCase()=="accessor") {
				propertyType = "accessor";
				itemsList = hasFactory ? factory.accessor : typeDescription.accessor;
			}
			else if (propertyType.toLowerCase()=="variable") {
				propertyType = "variable";
				itemsList = hasFactory ? factory.variable : typeDescription.variable;
			}
			else {
				itemsList = hasFactory ? factory.variable : typeDescription.variable;
				itemsList = hasFactory ? itemsList+factory.accessor : itemsList+typeDescription.accessor;
			}
			
			// make a copy because modifying the xml modifies the cached xml
			itemsList = itemsList.copy();
			itemsLength = itemsList.length();
			
			
			for (var i:int;i<itemsLength;i++) {
				var item:XML = XML(itemsList[i]);
				metaName = item.@name;
				item.@metadataType = item.localName();
				item.@declaredBy = typeName;
				item.setLocalName(PROPERTY);
			
				
				for (var j:int=0;j<existingItemsLength;j++) {
					var existingItem:XML = existingItems[j];
					
					if (metaName==existingItem.@name) {
						
						if (existingItem.@metadataType==VARIABLE) {
							existingItem.@declaredBy = typeName;
						}
						else if (existingItem.@metadataType==ACCESSOR) {
							existingItem.@declaredBy = typeName;
							//existingItem.appendChild(new XML("<overrides type=\""+ className + "\"/>"));
						}
						
						delete itemsList[i];
						itemsLength--;
						i--;
						continue;
					}
				}
			}
			
			if (existingItems==null) {
				existingItems = new XMLList();
			}
			
			// add new items to previous items
			if (itemsLength>0) {
				existingItems = new XMLList(existingItems.toString()+itemsList.toString());
			}
			
			if (isRoot && extendsLength>0) {
				for (i=0;i<extendsLength;i++) {
					var newClass:String = String(extendsClass[i].@type);
					existingItems = getPropertiesMetaData(newClass, propertyType, existingItems, stopAt);
				}
				
				
				var classesToKeep:Array = [typeName];
				
				for (i=0;i<extendsLength;i++) {
					var nextClass:String = String(extendsClass[i].@type);
					classesToKeep.push(nextClass);
				}
				
				// describe type gets all the properties so after we find the class that 
				// declares them we remove the classes are not part of our request
				var classIndex:int = classesToKeep.indexOf(stopAt);
				
				if (classIndex!=-1) {
					var classFound:String = "";
					var removeItems:XMLList;
					var classToRemove:String;
					
					for (i=classIndex+1;i<classesToKeep.length;i++) {
						classToRemove = classesToKeep[i];
						existingItems = existingItems.(@declaredBy!=classToRemove);
					}
				}
				
			}
			
			return existingItems;
		}
		
		/**
		 * Creates an array of the style items for the given object type including inherited styles. <br/><br/>
		 * 
		 * Properties (accessors), variables and methods are not included in this list. See getPropertiesMetaData() <br/><br/>
		 * 
		 * We add a few additional attributes to the metadata including the class the style is declared in,
		 * the name of the style and the type of metadata as style or event. 
		 * 
		 * For example, if you give it a Spark Button class it gets all the
		 * information for it and then gets it's super class ButtonBase and 
		 * adds all that information and so on until it gets to Object. <br/><br/>
		 * 
		 * Usage:<br/>
<pre>
	var allStyles:XMLList = getStyleMetaDataList(myButton);
</pre>
		 * 
		 * @param object The object to inspect. Either string, object or class.
		 * @param existingItems An existing list of styles
		 * @param stopAt Stops at Object unless you change this value
		 * @see #getPropertiesMetaData()
		 * */
		public static function getStylesMetaData(object:Object, existingItems:XMLList = null, stopAt:String = "Object"):XMLList {
			return getMetaData(object, STYLE, existingItems, stopAt);
		}
		
		/**
		 * Creates an array of the event items for the given object type including inherited events. <br/><br/>
		 * 
		 * Properties (accessors), variables and methods are not included in this list. <br/><br/>
		 * 
		 * We add a few additional attributes to the metadata including the class the event is declared in,
		 * the name of the event and the type of metadata as style or event. 
		 * 
		 * For example, if you give it a Spark Button class it gets all the
		 * information for it and then gets it's super class ButtonBase and 
		 * adds all that information and so on until it gets to Object. <br/><br/>
		 * 
		 * Usage:<br/>
<pre>
	var allEvents:XMLList = getEventsMetaDataList(myButton);
</pre>
		 * @param object The object to inspect. Either string, object or class.
		 * @param existingItems An existing list of events
		 * @param stopAt Stops at Object unless you change this value
		 * */
		public static function getEventsMetaData(object:Object, existingItems:XMLList = null, stopAt:String = "Object"):XMLList {
			return getMetaData(object, EVENT, existingItems, stopAt);
		}
		
		/**
		 * Creates an array of the style or event items for the given object type including inherited styles and events. <br/><br/>
		 * 
		 * Properties (accessors), variables and methods are not included in this list. See getPropertiesMetaData() <br/><br/>
		 * 
		 * We add a few additional attributes to the metadata including the class the style or event is declared in,
		 * the name of the style or event and the type of metadata as style or event. 
		 * 
		 * For example, if you give it a Spark Button class it gets all the
		 * information for it and then gets it's super class ButtonBase and 
		 * adds all that information and so on until it gets to Object. <br/><br/>
		 * 
		 * Usage:<br/><pre>
		 * var allStyles:XMLList = getMetaDataList(myButton, "Style");
		 * </pre>
		 * @param object The object to inspect. Either string, object or class.
		 * @param metaType The name of the data in the item name property. Either Style or Event
		 * @param existingItems The list of the data in the item name property
		 * @param stopAt Stops at Object unless you change this value
		 * @see #getPropertiesMetaData()
		 * */
		public static function getMetaData(object:Object, metaType:String, existingItems:XMLList = null, stopAt:String = "Object"):XMLList {
			var describedTypeRecord:DescribeTypeCacheRecord = mx.utils.DescribeTypeCache.describeType(object);
			var typeDescription:* = describedTypeRecord.typeDescription;
			var hasFactory:Boolean = typeDescription.factory.length()>0;
			var factory:* = typeDescription.factory;
			var extendsClass:XMLList = hasFactory ? typeDescription.factory.extendsClass : typeDescription.extendsClass;
			var extendsLength:int = extendsClass.length();
			// can be on typeDescription.metadata or factory.metadata
			var isRoot:Boolean = object is String ? false : true;
			var className:String = describedTypeRecord.typeName;
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
				//itemsList = factory.metadata.(@name==name); property "name" won't work. no matches found
				itemsList = factory.metadata.(@name==metaType);
			}
			else {
				itemsList = typeDescription.metadata.(@name==metaType);
			}
			
			// make a copy because modifying the xml modifies the cached xml
			itemsList = itemsList.copy();
			itemsLength = itemsList.length();
			
			
			for (var i:int;i<itemsLength;i++) {
				var item:XML = XML(itemsList[i]);
				metaName = item.arg[0].@value;
				item.@name = metaName;
				item.@metadataType = metaType;
				item.@declaredBy = className;
				
				for (var j:int=0;j<existingItemsLength;j++) {
					var existingItem:XML = existingItems[j];
					
					if (metaName==existingItem.@name) {
						//existingItem.@declaredBy = className;
						existingItem.appendChild(new XML("<overrides type=\""+ className + "\"/>"));
						delete itemsList[i];
						itemsLength--;
						i--;
						continue;
					}
				}
			}
			
			if (existingItems==null) {
				existingItems = new XMLList();
			}
			
			// add new items to previous items
			if (itemsLength>0) {
				existingItems = new XMLList(existingItems.toString()+itemsList.toString());
			}

			if (isRoot && extendsLength>0) {
				for (i=0;i<extendsLength;i++) {
					var nextClass:String = String(extendsClass[i].@type);
					
					if (nextClass==stopAt) {
						break;
					}
					
					existingItems = getMetaData(nextClass, metaType, existingItems, stopAt);
				}
			}
			
			return existingItems;
		}
		
		/**
		 * Get AccessorMetaData data for the given property. 
		 * */
		public static function getMetaDataOfProperty(target:Object, property:String):AccessorMetaData {
			var describedTypeRecord:mx.utils.DescribeTypeCacheRecord = mx.utils.DescribeTypeCache.describeType(target);
			var accessorMetaData:AccessorMetaData = new AccessorMetaData();
			var matches:XMLList = describedTypeRecord.typeDescription..accessor.(@name==property);
			var matches2:XMLList = describedTypeRecord.typeDescription..variable.(@name==property);
			var node:XML;
			
			if (matches.length()>0) {
				node = matches[0];
			}
			else if (matches2.length()>0) {
				node = matches2[0];
			}
			
			if (node) {
				accessorMetaData.unmarshall(node, target);
				return accessorMetaData;
			}
			
			return null;
		}
		
		/**
		 * Get StyleMetaData data for the given style. 
		 * */
		public static function getMetaDataOfStyle(target:Object, style:String, type:String = null, stopAt:String = null):StyleMetaData {
			var describedTypeRecord:mx.utils.DescribeTypeCacheRecord;
			var styleMetaData:StyleMetaData;
			var extendsClassList:XMLList;
			var typeDescription:XML;
			var matches:XMLList;
			var node:XML;
			var hasFactory:Boolean;
			var factory:Object;
			
			if (type) {
				describedTypeRecord = mx.utils.DescribeTypeCache.describeType(type);
			}
			else {
				describedTypeRecord = mx.utils.DescribeTypeCache.describeType(target);
			}
			
			typeDescription = describedTypeRecord.typeDescription[0];
			factory = typeDescription.factory;
			hasFactory = factory.length()>0;
			
			// sometimes factory exists sometimes it doesn't wtf?
			if (hasFactory) {
				//matches = describedTypeRecord.typeDescription.factory.metadata.(@name=="Style").arg.(@value==style);
				matches = factory.metadata.(@name=="Style").arg.(@value==style);
			}
			else {
				matches = typeDescription.metadata.(@name=="Style").arg.(@value==style);
			}
			
			if (matches && matches.length()==0) {
				
				if (hasFactory) {
					extendsClassList = factory.extendsClass;
				}
				else {
					extendsClassList = typeDescription.extendsClass;
				}
				
				var length:int = extendsClassList.length();
				
				for (var i:int;i<length;i++) {
					type = extendsClassList[i].@type;
					if (type==stopAt) return null;
					if (type=="Class") return null;
					return getMetaDataOfStyle(target, style, type);
				}
				
			}
			
			if (matches.length()>0) {
				node = matches[0].parent();
				node.@declaredBy = typeDescription.typeName;
				styleMetaData = new StyleMetaData();
				styleMetaData.unmarshall(node, target);
				return styleMetaData;
			}
			
			return null;
		}
		
		/**
		 * Gets an array of the styles from an array of names<br/><br/>
		 * 
		 * Usage:<br/>
		 <pre>
		 * // returns ["backgroundAlpha", "fontFamily"]
		 var styles:Array = getStylesFromArray(myButton, ["chicken","potatoe","backgroundAlpha","swisscheese","fontFamily"]);
		 </pre>
		 * 
		 * @param object The object to use. Either string, object or class.
		 * @param possibleStyles An existing list of styles
		 * */
		public static function getStylesFromArray(object:Object, possibleStyles:Object):Array {
			possibleStyles = ArrayUtil.toArray(possibleStyles);
			var styleNames:Array = getStyleNames(object);
			var result:Array = [];
			var style:String;
			
			for (var i:int; i < possibleStyles.length; i++) {
				style = possibleStyles[i];
				
				if (styleNames.indexOf(style)!=-1) {
					if (result.indexOf(style)==-1) {
						result.push(style);
					}
				}
			}
			
			
			return result;
		}
		
		public static var constraints:Array = ["baseline", "left", "top", "right", "bottom", "horizontalCenter", "verticalCenter"];
		
		/**
		 * Gets an array of the properties from an array of names<br/><br/>
		 * 
		 * Usage:<br/>
		 <pre>
		 * // returns ["width", "x"]
		 var styles:Array = getStylesFromArray(myButton, ["chicken","potatoe","width","swisscheese","x"]);
		 </pre>
		 * 
		 * @param object The object to use. Either string, object or class.
		 * @param possibleStyles An list of possible properties
		 * */
		public static function getPropertiesFromArray(object:Object, possibleProperties:Object, removeConstraints:Boolean = true):Array {
			possibleProperties = ArrayUtil.toArray(possibleProperties);
			var propertyNames:Array = getPropertyNames(object);
			var result:Array = [];
			var property:String;
			
			for (var i:int; i < possibleProperties.length; i++) {
				property = possibleProperties[i];
				
				if (propertyNames.indexOf(property)!=-1) {
					if (result.indexOf(property)==-1) {
						
						if (removeConstraints) {
							// remove constraints (they are a facade for the styles)
							if (constraints.indexOf(property)==-1) { 
								result.push(property);
							}
						}
						else {
							result.push(property);
						}
					}
				}
			}
			
			
			return result;
		}
		
		/**
		 * Gets an array of the styles from the object<br/><br/>
		 * 
		 * Usage:<br/>
		 var styles:Array = getStyleNames(myButton);
		 </pre>
		 * 
		 * @param object The object to use. Either string, object or class.
		 * */
		public static function getStyleNames(object:Object):Array {
			var stylesList:XMLList = getStylesMetaData(object);
			var styleNames:Array = XMLUtils.convertXMLListToArray(stylesList.@name);
			
			return styleNames;
		}
	}
}