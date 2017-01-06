



package com.flexcapacitor.utils {
	
	import com.flexcapacitor.model.AccessorMetaData;
	import com.flexcapacitor.model.MetaData;
	import com.flexcapacitor.model.MetaDataMetaData;
	import com.flexcapacitor.model.StyleMetaData;
	import com.flexcapacitor.utils.supportClasses.ObjectDefinition;
	
	import flash.events.IEventDispatcher;
	import flash.sampler.getMemberNames;
	import flash.system.ApplicationDomain;
	import flash.utils.Dictionary;
	import flash.utils.describeType;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	import flash.utils.getQualifiedSuperclassName;
	
	import mx.core.IFlexModuleFactory;
	import mx.core.UIComponent;
	import mx.styles.IStyleClient;
	import mx.styles.IStyleManager2;
	import mx.styles.StyleManager;
	import mx.utils.ArrayUtil;
	import mx.utils.DescribeTypeCache;
	import mx.utils.DescribeTypeCacheRecord;
	import mx.utils.NameUtil;
	import mx.utils.ObjectUtil;

	/**
	 * Helper class for class utilities.
	 * 
	 * TODO: 
	 * We could cache the value of many of these calls including getPropertyNames, getPropertyMetaData, etc.
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
		 * Get unqualified class name of the target object. <br/>
		 * 
		 * If target has the id of myImage and include class name is true then the result is
		 * "Image.myImage". If delimiter is "_" then the result is "Image_myImage". 
		 * If includeClassName is false then the result is, "myImage". 
		 * */
		public static function getClassNameOrID(element:Object, includeClassName:Boolean = false, delimiter:String = "."):String {
			var name:String = NameUtil.getUnqualifiedClassName(element);
			var id:String = element && "id" in element ? element.id : null;
			
			return !id ? name : includeClassName ? name + delimiter + id : id;
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
		public static function getSuperClassName(element:Object, fullyQualified:Boolean = false):String {
			var name:String = flash.utils.getQualifiedSuperclassName(element);
			if (name && name.indexOf("::") && !fullyQualified) {
				name = name.split("::")[name.split("::").length-1]; // i'm sure theres a better way to do this
			}
			
			return name;
		}
		
		/**
		 * Get fully qualified name of super class of the target object
		 * */
		public static function getSuperClass(element:Object):String {
			var name:String = flash.utils.getQualifiedSuperclassName(element);
			
			return name;
		}
		
		/**
		 * Get fully qualified super class of the target object
		 * */
		public static function getSuperClassDefinition(element:Object, domain:ApplicationDomain = null):Object {
			var name:String = flash.utils.getQualifiedSuperclassName(element);
			var definition:Object;
			
			if (domain==null) {
				domain = ApplicationDomain.currentDomain;
			}
			
			if (domain.hasDefinition(name)) {
				definition = domain.getDefinition(name);
				return definition;
			}
			
			return null;
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
		 * Get the class name and package. 
		 * 
		 * @returns an Array with className at index 0 and the package name as index 1 
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
		 * Get metadata from an object by finding members by their type.
		 * It loops through all the properties on the object and if 
		 * it is of the type you passed in then it returns the metadata on it.
<pre>
var object:XMLList = ClassUtils.getMemberDataByType(myButton, mx.styles.CSSStyleDeclaration);

trace(object);

// finds the "myButton.styleDeclaration" since it is of type CSSStyleDeclaration

&lt;accessor name="styleDeclaration" access="readwrite" type="mx.styles::CSSStyleDeclaration" declaredBy="mx.core::UIComponent">
  &lt;metadata name="Inspectable">
    &lt;arg key="environment" value="none"/>
  &lt;/metadata>
&lt;/accessor>
</pre>
		 * */
		public static function getMemberDataByType(object:Object, type:Object):Object {
			if (type==null) return null;
			var className:String = type is String ? String(type) : getQualifiedClassName(type);
			var xml:XML = describeType(object);
			var xmlItem:XMLList = xml.*.(attribute("type")==className);
			return xmlItem;
		}
		
		/**
		 * Get metadata from an object by it's name.
		 * 
<pre>
var object:XMLList = ClassUtils.getMemberDataByName(myButton, "width");
trace(object);

// finds metadata for "myButton.width" 

&lt;accessor name="width" access="readwrite" type="String" declaredBy="mx.core::UIComponent">
&lt;/accessor>
</pre>
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
<pre>
var sameType:Boolean = isSameClassType(myButton, yourButton);
trace(sameType); // true

var sameType:Boolean = isSameClassType(myButton, myCheckbox);
trace(sameType); // false

</pre>
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
<pre>
var name:String = getIdentifierOrName(myButton);
trace(name); // Button

myButton.name = "Button100"
var name:String = getIdentifierOrName(myButton);
trace(name); // "Button100"
 
myButton.id = "myButton";
var name:String = getIdentifierOrName(myButton);
trace(name); // "mySuperButton" 

</pre>
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
		 * Get DescribeTypeCacheRecord.typeDescription for the given class. 
		 * Can take string, instance or class.
		 * 
		 * If class can't be found returns null 
		 * */
		public static function getDescribeType(object:Object):XML {
			var describedTypeRecord:mx.utils.DescribeTypeCacheRecord = mx.utils.DescribeTypeCache.describeType(object);
			
			if (describedTypeRecord) {
				return describedTypeRecord.typeDescription;
			}
			
			return null
		}
		
		public static var membersNamesCache:Dictionary = new Dictionary(true);
		public static var eventNamesCache:Dictionary = new Dictionary(true);
		public static var propertyNamesCache:Dictionary = new Dictionary(true);
		public static var styleNamesCache:Dictionary = new Dictionary(true);
		public static var methodNamesCache:Dictionary = new Dictionary(true);
		
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
 var allProperties:Array = getObjectPropertyNames(myButton);
 </pre>
		 * 
		 * @param object The object to inspect. Either string, object or class.
		 * @param sort Sorts the properties in the array
		 * @param ignoreCache Ignores the cache in case we've added properties on a dynamic object
		 * 
		 * @see #getStyleNames()
		 * @see #getEventNames()
		 * @see #getPropertiesMetaData()
		 * */
		public static function getPropertyNames(object:Object, sort:Boolean = true, ignoreCache:Boolean = false):Array {
			var describedTypeRecord:DescribeTypeCacheRecord;
			var typeDescription:*;
			var hasFactory:Boolean;
			var factory:XMLList;
			var numberOfItems:int;
			var itemsList:XMLList;
			var propertyName:String;
			var properties:Array = [];
			var typeName:String;
			var isDynamic:Boolean;
			
			
			typeName = object is String ? String(object) : getQualifiedClassName(object);
			
			// check cache first
			if (propertyNamesCache[typeName] && !ignoreCache) {
				// create a copy so it's not modified elsewhere
				return (propertyNamesCache[typeName] as Array).slice();
			}
			
			describedTypeRecord = DescribeTypeCache.describeType(object);
			typeDescription = describedTypeRecord.typeDescription;
			hasFactory = typeDescription.factory.length()>0;
			factory = typeDescription.factory;
			isDynamic = typeDescription.@isDynamic=="true";
			
			itemsList = hasFactory ? factory.variable + factory.accessor : typeDescription.variable + typeDescription.accessor;
			// create a copy so it's not modified elsewhere
			itemsList = itemsList.copy();
			numberOfItems = itemsList.length();
			
			
			for (var i:int;i<numberOfItems;i++) {
				var item:XML = XML(itemsList[i]);
				propertyName = item.@name;
				properties.push(propertyName);
			}
			
			// get dynamic properties
			if (typeName=="Object" && isDynamic) {
				for (propertyName in object) {
					properties.push(propertyName);
				}
			}
			
			if (sort) properties.sort();
			
			// save results in a cache for next time
			if (typeName && typeName!="Object") {
				propertyNamesCache[typeName] = properties.slice();
			}
			
			return properties;
		}
		
		/**
		 * Returns an array the events for the given object including super class events. 
		 * Setting includeInherited to false is not yet implemented.<br/><br/>
		 * 
		 * For example, if you give it a Spark Button class it gets all the
		 * events for it and all the events on the super classes.<br/><br/>
		 * 
		 * Usage:<br/>
 <pre>
 var allEvents:Array = getEventNames(myButton);
 </pre>
		 * 
		 * @param object The object to inspect. Either string, object or class.
		 * @param sort Sorts the events in order in the array.
		 * @param includeInherited Gets inherited. Default is true. False is not implemented
		 * 
		 * @see #getPropertyNames()
		 * @see #getStyleNames()
		 * @see #getMethodNames()
		 * @see #getMemberNames()
		 * */
		public static function getEventNames(object:Object, sort:Boolean = true, stopAt:String = "Object", existingItems:Array = null, isRoot:Boolean = true, ignoreCache:Boolean = false):Array {
			var describedTypeRecord:DescribeTypeCacheRecord;
			var typeDescription:*;
			var hasFactory:Boolean;
			var extendsClass:XMLList;
			var numberOfExtendedClasses:int;
			var factory:XMLList;
			var isRoot:Boolean;
			var numberOfItems:int;
			var itemsList:XMLList;
			var eventName:String;
			var metaType:String = "Event";
			var nextClass:String;
			var item:XML;
			var typeName:String;
			var isDynamic:Boolean;
			
			
			typeName = object is String ? String(object) : getQualifiedClassName(object);
			
			// check cache first
			if (eventNamesCache[typeName] && !ignoreCache) {
				// create a copy so it's not modified elsewhere
				return (eventNamesCache[typeName] as Array).slice();
			}
			
			describedTypeRecord = mx.utils.DescribeTypeCache.describeType(object);
			typeDescription = describedTypeRecord.typeDescription;
			hasFactory = typeDescription.factory.length()>0;
			extendsClass = hasFactory ? typeDescription.factory.extendsClass : typeDescription.extendsClass;
			numberOfExtendedClasses = extendsClass.length();
			factory = typeDescription.factory;
			isDynamic = typeDescription.@isDynamic=="true";
			
			itemsList = hasFactory ? factory.metadata.(@name==metaType): typeDescription.metadata.(@name==metaType);
			itemsList = itemsList.copy();
			numberOfItems = itemsList.length();
			
			if (existingItems==null) {
				existingItems = [];
			}
			
			for (var i:int;i<numberOfItems;i++) {
				item = XML(itemsList[i]);
				eventName = item.arg[0].@value;
				existingItems.push(eventName);
			}
			
			// add events from super classes
			if (isRoot && numberOfExtendedClasses>0) {
				for (i=0;i<numberOfExtendedClasses;i++) {
					nextClass = String(extendsClass[i].@type);
					
					if (nextClass==stopAt) {
						break;
					}
					
					existingItems = getEventNames(nextClass, sort, stopAt, existingItems, false);
				}
			}
			
			
			if (sort) existingItems.sort();
			
			// save results in a cache for next time
			if (isRoot && typeName && typeName!="Object") {
				eventNamesCache[typeName] = existingItems.slice();
			}
			
			return existingItems;
		}
		
		/**
		 * Returns an array the styles for the given object including super class styles. 
		 * Setting includeInherited to false is not yet implemented.<br/><br/>
		 * 
		 * For example, if you give it a Spark Button class it gets all the
		 * styles for it and all the styles on the super classes.<br/><br/>
		 * 
		 * Usage:<br/>
 <pre>
 var allEvents:Array = getStyleNames(myButton);
 </pre>
		 * 
		 * @param object The object to inspect. Either string, object or class.
		 * @param sort Sorts the styles in order in the array.
		 * @param includeInherited Gets inherited. Default is true. False is not implemented
		 * 
		 * @see #getPropertyNames()
		 * @see #getEventNames()
		 * @see #getMethodNames()
		 * */
		public static function getStyleNames(object:Object, sort:Boolean = true, stopAt:String = "Object", existingItems:Array = null, isRoot:Boolean = true, ignoreCache:Boolean = false):Array {
			var describedTypeRecord:DescribeTypeCacheRecord;
			var typeDescription:*;
			var hasFactory:Boolean;
			var extendsClass:XMLList;
			var numberOfExtendedClasses:int;
			var factory:XMLList;
			var numberOfItems:int;
			var itemsList:XMLList;
			var styleName:String;
			var metaType:String = "Style";
			var nextClass:String;
			var item:XML;
			var typeName:String;
			
			typeName = object is String ? String(object) : getQualifiedClassName(object);
			
			// check cache first
			if (styleNamesCache[typeName] && !ignoreCache) {
				// create a copy so it's not modified elsewhere
				return (styleNamesCache[typeName] as Array).slice();
			}
			
			describedTypeRecord = mx.utils.DescribeTypeCache.describeType(object);
			typeDescription = describedTypeRecord.typeDescription;
			hasFactory = typeDescription.factory.length()>0;
			extendsClass = hasFactory ? typeDescription.factory.extendsClass : typeDescription.extendsClass;
			numberOfExtendedClasses = extendsClass.length();
			factory = typeDescription.factory;
			
			itemsList = hasFactory ? factory.metadata.(@name==metaType): typeDescription.metadata.(@name==metaType);
			itemsList = itemsList.copy();
			numberOfItems = itemsList.length();
			
			if (existingItems==null) {
				existingItems = [];
			}
			
			for (var i:int;i<numberOfItems;i++) {
				item = XML(itemsList[i]);
				styleName = item.arg[0].@value;
				existingItems.push(styleName);
			}
			
			// add events from super classes
			if (isRoot && numberOfExtendedClasses>0) {
				for (i=0;i<numberOfExtendedClasses;i++) {
					nextClass = String(extendsClass[i].@type);
					
					if (nextClass==stopAt) {
						break;
					}
					
					existingItems = getStyleNames(nextClass, sort, stopAt, existingItems, false);
				}
			}
			
			
			if (sort) existingItems.sort();
			
			// save results in a cache for next time
			if (isRoot && typeName && typeName!="Object") {
				styleNamesCache[typeName] = existingItems.slice();
			}
			
			return existingItems;
		}
		
		/**
		 * Returns an array the super classes for the given object.<br/><br/>
		 * 
		 * For example, if you give it a Spark Button class it gets all the
		 * classes it extends and so on until object.<br/><br/>
		 * 
		 * Usage:<br/>
<pre>
var superClasses:Array = getInheritedClasses(MyButton);
trace(superClasses); // Button, ButtonBase, UIComponent, Object
</pre>
		 * 
		 * @param object The object to inspect. Either string, object or class.
		 * @param stopAt Stops at object with the given class name or Object if not defined
		 * 
		 * */
		public static function getInheritedClasses(object:Object, stopAt:String = "Object", ignoreCache:Boolean = false):Array {
			var describedTypeRecord:DescribeTypeCacheRecord;
			var typeDescription:*;
			var hasFactory:Boolean;
			var extendsClass:XMLList;
			var numberOfExtendedClasses:int;
			var factory:XMLList;
			var styleName:String;
			var nextClass:String;
			var classNames:Array;
			
			describedTypeRecord = mx.utils.DescribeTypeCache.describeType(object);
			typeDescription = describedTypeRecord.typeDescription;
			hasFactory = typeDescription.factory.length()>0;
			extendsClass = hasFactory ? typeDescription.factory.extendsClass : typeDescription.extendsClass;
			numberOfExtendedClasses = extendsClass.length();
			
			classNames = [];
			
			// add events from super classes
			for (var i:int=0;i<numberOfExtendedClasses;i++) {
				nextClass = String(extendsClass[i].@type);
				
				if (nextClass==stopAt) {
					break;
				}
				
				classNames.push(nextClass);
			}
			
			return classNames;
		}
		
		/**
		 * Returns an array the methods for the given object including super class methods. 
		 * Setting includeInherited to false is not yet implemented.<br/><br/>
		 * 
		 * For example, if you give it a Spark Button class it gets all the
		 * methods for it and all the methods on the super classes.<br/><br/>
		 * 
		 * Usage:<br/>
<pre>
var allMethods:Array = getMethodNames(myButton);
</pre>
		 * 
		 * @param object The object to inspect. Either string, object or class.
		 * @param sort Sorts the methods in order in the array.
		 * @param includeInherited Gets inherited. Default is true. False is not implemented
		 * 
		 * @see #getEventNames()
		 * @see #getPropertyNames()
		 * @see #getStylesNames()
		 * */
		public static function getMethodNames(object:Object, sort:Boolean = true, includeInherited:Boolean = true, ignoreCache:Boolean = false):Array {
			var describedTypeRecord:DescribeTypeCacheRecord;
			var typeDescription:*;
			var hasFactory:Boolean;
			var factory:XMLList;
			var numberOfItems:int;
			var itemsList:XMLList;
			var methodName:String;
			var methods:Array = [];
			var typeName:String;
			
			typeName = object is String ? String(object) : getQualifiedClassName(object);
			
			// check cache first
			if (methodNamesCache[typeName] && !ignoreCache) {
				// create a copy so it's not modified elsewhere
				return (methodNamesCache[typeName] as Array).slice();
			}
			
			describedTypeRecord = mx.utils.DescribeTypeCache.describeType(object);
			typeDescription = describedTypeRecord.typeDescription;
			hasFactory = typeDescription.factory.length()>0;
			factory = typeDescription.factory;
			
			itemsList = hasFactory ? factory.method : typeDescription.method;
			numberOfItems = itemsList.length();
			
			for (var i:int;i<numberOfItems;i++) {
				var item:XML = XML(itemsList[i]);
				methodName = item.@name;
				methods.push(methodName);
			}
			
			if (describedTypeRecord.typeName=="Object" && numberOfItems==0) {
				for (methodName in object) {
					methods.push(methodName);
				}
			}
			
			if (sort) methods.sort();
			
			// save results in a cache for next time
			if (typeName && typeName!="Object") {
				methodNamesCache[typeName] = methods.slice();
			}
			
			return methods;
		}
		
		/**
		 * Returns true if the object has the property specified. <br/><br/>
		 * 
		 * If useFlashAPI is true then uses Flash internal methods
<pre> 
"property" in object and object.hasOwnProperty(propertyName);
</pre>
		 * <br/>
		 * 
		 * Otherwise it uses describeType. It includes accessors and variables and checks 
		 * super classes.<br/><br/>
		 * 
		 * For example:<br/>
<pre>
var hasProperty:Boolean = ClassUtils.hasProperty(myButton, "label"); // true
var hasProperty:Boolean = ClassUtils.hasProperty(myButton, "spagetti"); // false
var hasProperty:Boolean = ClassUtils.hasProperty(myButton, "width"); // true
</pre>
		 * 
		 * @param object The object to check property for
		 * @param propertyName Name of property to check for
		 * @param useFlashAPI Uses Flash internal methods
		 * 
		 * @see #hasStyle()
		 * */
		public static function hasProperty(object:Object, propertyName:String, useFlashAPI:Boolean = false):Boolean {
			if (object==null || object=="" || propertyName==null || propertyName=="") return false;

			var properties:Array;
			var found:Boolean;
			
			if (useFlashAPI) {
				found = propertyName in object;
				
				if (!found) {
					found = object.hasOwnProperty(propertyName);
				}
				
				return found;
			}
			
			properties = getPropertyNames(object);
			
			if (properties.indexOf(propertyName)!=-1) {
				return true;
			}
			
			return false;
		}
		
		/**
		 * Returns true if the object has the event specified. <br/><br/>
		 * 
		 * For example:<br/>
<pre>
	var hasEvent:Boolean = ClassUtils.hasEvent(myButton, "click"); // true
	var hasEvent:Boolean = ClassUtils.hasEvent(myButton, "spagetti"); // false
	var hasEvent:Boolean = ClassUtils.hasEvent(myButton, "width"); // false
</pre>
		 * 
		 * @param object The object to check event for
		 * @param propertyName Name of event to check for
		 * @param useFlashAPI Uses Flash internal methods
		 * 
		 * @see #hasStyle()
		 * */
		public static function hasEvent(object:Object, eventName:String, includeInheritedEvents:Boolean = false):Boolean {
			var events:Array;
			var found:Boolean;
			
			if (object==null || object=="" || eventName==null || eventName=="") return false;
			
			events = getEventNames(object);
			
			if (events.indexOf(eventName)!=-1) {
				return true;
			}
			
			return false;
		}
		
		/**
		 * Returns true if the object has the method specified. <br/><br/>
		 * 
		 * If useFlashAPI is true then uses Flash internal methods
<pre> 
	"method" in object and object.hasOwnProperty(methodName);
</pre>
		 * <br/>
		 * 
		 * Otherwise it uses describeType.<br/><br/>
		 * 
		 * For example:<br/>
<pre>
	var hasMethod:Boolean = ClassUtils.hasMethod(myButton, "styleChanged"); // true
	var hasMethod:Boolean = ClassUtils.hasMethod(myButton, "spagetti"); // false
	var hasMethod:Boolean = ClassUtils.hasMethod(myButton, "width"); // false
</pre>
		 * 
		 * @param object The object to check method for
		 * @param propertyName Name of method to check for
		 * @param useFlashAPI Uses Flash internal methods
		 * 
		 * @see #hasStyle()
		 * */
		public static function hasMethod(object:Object, methodName:String, useFlashAPI:Boolean = false):Boolean {
			var methods:Array;
			var found:Boolean;
			
			if (object==null || object=="" || methodName==null || methodName=="") return false;
			
			if (useFlashAPI) {
				
				if (methodName && object is IEventDispatcher) {
					found = "method" in object || object.hasOwnProperty(methodName);
					if (!(found is Function)) {
						found = false;
					}
				}
				
				return found;
			}
			
			methods = getMethodNames(object);
			
			if (methods.indexOf(methodName)!=-1) {
				return true;
			}
			
			return false;
		}
		
		/**
		 * Returns true if the object has the style specified. <br/><br/>
		 * 
		 * If checkFlexObjects is true then we check inherited and noninherited objects
		 * to see if they have the style listed. Not sure if this is correct.
 <pre> 
 var hasStyle:Boolean = style in styleClient.inheritingStyles || styleName in styleClient.nonInheritingStyles;
 </pre>
		 * <br/>
		 * 
		 * Otherwise it uses describeType. We check not only the object but the super classes.<br/><br/>
		 * 
		 * For example:<br/>
 <pre>
 var hasStyle:Boolean = ClassUtils.hasStyle(myButton, "color"); // true
 var hasStyle:Boolean = ClassUtils.hasStyle(myButton, "spagetti"); // false
 </pre>
		 * 
		 * @param object The object to check style exists on
		 * @param styleName Name of style to check for
		 * @param checkFlexObjects Checks the inheriting and nonInheriting properties of style client
		 * 
		 * @see #isStyleDefined()
		 * */
		public static function hasStyle(object:Object, styleName:String, checkFlexObjects:Boolean = false):Boolean {
			var isClass:Boolean = object is Class;
			var isStyleClient:Boolean = object is IStyleClient;
			var styleClient:IStyleClient = object ? object as IStyleClient : null;
			var found:Boolean;
			var styles:Array;
			
			if (styleName==null || styleName=="") return false;
			
			if (!(object is String) && !isClass && styleClient==null) return false; 
			
			// not sure if this is a valid way to tell if an object has a style
			if (checkFlexObjects) {
				
				if (!(object is String)) {
					throw new Error("Object cannot be of type String and use second method");
				}
				
				if (styleName in styleClient.inheritingStyles) {
					found = true;
				}
				else if (styleName in styleClient.nonInheritingStyles) {
					found = true;
				}
				
				return found;
			}
			
			
			styles = getStyleNames(object);
			
			if (styles.indexOf(styleName)!=-1) {
				return true;
			}
			
			return false;
		}
		
		/**
		 * Returns an array the members for the given object including super class members. 
		 * This includes events, properties, styles and optionally method names.<br/><br/>
		 * 
		 * For example, if you give it a Spark Button class it gets all the
		 * members for it and all the members on the super classes.<br/><br/>
		 * 
		 * Usage:<br/>
 <pre>
 var allMembers:Array = getMemberNames(myButton);
 </pre>
		 * 
		 * @param object The object to inspect. Either string, object or class.
		 * @param sort Sorts the members in order
		 * @param includeMethods includes method names
		 * @param ignoreCache on dynamic objects and styles clients new properties and news styles 
		 * could be added. set to true to check for new properties or styles
		 * 
		 * @see #getPropertyNames()
		 * @see #getStyleNames()
		 * @see #getMethodNames()
		 * @see #getMemberNames()
		 * */
		public static function getMemberNames(object:Object, sort:Boolean = true, includeMethods:Boolean = false, ignoreCache:Boolean = false):Array {
			var members:Array;
			var events:Array;
			var styles:Array;
			var properties:Array;
			var methods:Array;
			var typeName:String;
			
			typeName = object is String ? String(object) : getQualifiedClassName(object);
			
			// check cache first
			if (membersNamesCache[typeName] && !ignoreCache) {
				// create a copy so it's not modified elsewhere
				return (membersNamesCache[typeName] as Array).slice();
			}
			
			events = getEventNames(object, false);
			styles = getStyleNames(object, false);
			properties = getPropertyNames(object, false, ignoreCache);
			
			if (includeMethods) {
				methods = getMethodNames(object, false, true);
				members = events.concat(styles.concat(properties.concat(methods)));
			}
			else {
				members = events.concat(styles.concat(properties));
			}
			
			if (sort) {
				members.sort(Array.CASEINSENSITIVE);
			}
			
			return members;
		}
		
		/**
		 * Get object information. It's similar to describe type but returns an object instead of XML
		 * */
		public static function getObjectInformation(object:Object, includeMethods:Boolean = false, ignoreCache:Boolean = false):ObjectDefinition {
			var members:Array;
			var events:Array;
			var styles:Array;
			var properties:Array;
			var methods:Array;
			var typeName:String;
			var qualifiedName:String;
			var unqualifiedName:String;
			var objectDefinition:ObjectDefinition;
			var sort:Boolean;
			
			if (object==null) return null;
			
			sort = true;
			
			members 		= getMemberNames(object, sort, includeMethods);
			events 			= getEventNames(object);
			styles 			= getStyleNames(object);
			properties 		= getPropertyNames(object);
			methods 		= includeMethods ? getMethodNames(object) : null;
			
			objectDefinition 				= new ObjectDefinition();
			objectDefinition.name	 		= getClassName(object);
			objectDefinition.qualifiedName 	= getQualifiedClassName(object);
			objectDefinition.events 		= events;
			objectDefinition.styles 		= styles;
			objectDefinition.properties 	= properties;
			objectDefinition.methods 		= methods;
			objectDefinition.members 		= members;
			objectDefinition.subclasses		= getInheritedClasses(object);
			
			return objectDefinition;
		}
		
		
		/**
		 * Returns true if the object has the style defined somewhere in the style lookup.<br/><br/>
		 * 
		 * For example:<br/>
 <pre>
 var hasStyle:Boolean = ClassUtils.isStyleDefined(myButton, "color"); // true
 var hasStyle:Boolean = ClassUtils.isStyleDefined(myButton, "spagetti"); // false
 </pre>
		 * 
		 * @param object The object to check style exists on
		 * @param styleName Name of style to check for
		 * 
		 * @see StyleManager.isValidStyleValue()
		 * @see #hasStyle()
		 * */
		public static function isStyleDefined(object:Object, styleName:String):Boolean {
			var styleManager:IStyleManager2;
			var styleClient:IStyleClient = object ? object as IStyleClient : null;
			
			if (styleClient==null || styleClient=="" || styleName==null || styleName=="") return false;
			
			//if (object is IFlexModuleFactory) {
				styleManager = StyleManager.getStyleManager(object as IFlexModuleFactory);
			//}
			
			return styleManager.isValidStyleValue(styleClient.getStyle(styleName));
			
		}
		
		/**
		 * Gets the correct case of an objects property. For example, 
		 * "percentwidth" returns "percentWidth".
		 * 
		 * If the property is not found then it returns null.
		 * */
		public static function getCaseSensitivePropertyName(object:Object, propertyName:String):String {
			var properties:Array = getPropertyNames(object);
			var propertyLowerCased:String = propertyName.toLowerCase();
			
			for each (var property:String in properties) {
				if (property.toLowerCase() == propertyLowerCased) {
					return property;
				}
			}
			
			return null;
		}
		
		/**
		 * Gets the correct case of an object's style. For example, 
		 * "backgroundcolor" returns "backgroundColor".
		 * 
		 * If the style is not found then it returns null.
		 * */
		public static function getCaseSensitiveStyleName(object:Object, styleName:String):String {
			var styles:Array = getStyleNames(object);
			var styleLowerCased:String = styleName.toLowerCase();
			
			for each (var style:String in styles) {
				if (style.toLowerCase() == styleLowerCased) {
					return style;
				}
			}
			
			return null;
		}
		
		/**
		 * Gets the correct case of an objects property. For example, 
		 * "percentwidth" returns "percentWidth".  
		 * */
		public static function getCaseSensitivePropertyName2(target:Object, property:String, options:Object = null):String {
			var classInfo:Object = target ? ObjectUtil.getClassInfo(target, null, options) : property;
			var properties:Array = classInfo ? classInfo.properties : [];
			
			for each (var info:QName in properties) {
				if (info.localName.toLowerCase() == property.toLowerCase()) {
					return info.localName;
				}
			}
			
			return property;
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
		 * 
		 * @see #getStyleNames()
		 * @see #getPropertyNames()
		 * @see #getMetaData()
		 * @see #getStylesMetaData()
		 * @see #getEventsMetaData()
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
			var numberOfItems:int;
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
			numberOfItems = itemsList.length();
			
			
			for (var i:int;i<numberOfItems;i++) {
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
						numberOfItems--;
						i--;
						continue;
					}
				}
			}
			
			if (existingItems==null) {
				existingItems = new XMLList();
			}
			
			// add new items to previous items
			if (numberOfItems>0) {
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
		 * 
		 * @see #getPropertiesMetaData()
		 * @see #getEventsMetaData()
		 * @see #getMetaData()
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
		 * 
		 * @see #getPropertiesMetaData()
		 * @see #getStylesMetaData()
		 * @see #getMetaData()
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
		 * Usage:<br/>
<pre>
var allStyles:XMLList = getMetaData(myButton, "Style");
</pre>
		 * @param object The object to inspect. Either string, object or class.
		 * @param metaType The name of the data in the item name property. Either Style or Event
		 * @param existingItems The list of the data in the item name property
		 * @param stopAt Stops at Object unless you change this value
		 * 
		 * @see #getPropertiesMetaData()
		 * @see #getStylesMetaData()
		 * @see #getEventsMetaData()
		 * */
		public static function getMetaData(object:Object, metaType:String, existingItems:XMLList = null, stopAt:String = "Object"):XMLList {
			var describedTypeRecord:DescribeTypeCacheRecord = mx.utils.DescribeTypeCache.describeType(object);
			var typeDescription:* = describedTypeRecord.typeDescription;
			var hasFactory:Boolean = typeDescription.factory.length()>0;
			var factory:* = typeDescription.factory;
			var extendsClass:XMLList = hasFactory ? typeDescription.factory.extendsClass : typeDescription.extendsClass;
			var numberOfExtendedClasses:int = extendsClass.length();
			// can be on typeDescription.metadata or factory.metadata
			var isRoot:Boolean = object is String ? false : true;
			var className:String = describedTypeRecord.typeName;
			var numberOfItems:int;
			var itemsList:XMLList;
			var numberOfExistingItems:int = existingItems ? existingItems.length() : 0;
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
			numberOfItems = itemsList.length();
			
			
			for (var i:int;i<numberOfItems;i++) {
				var item:XML = XML(itemsList[i]);
				metaName = item.arg[0].@value;
				item.@name = metaName;
				item.@metadataType = metaType;
				item.@declaredBy = className;
				
				for (var j:int=0;j<numberOfExistingItems;j++) {
					var existingItem:XML = existingItems[j];
					
					if (metaName==existingItem.@name) {
						//existingItem.@declaredBy = className;
						existingItem.appendChild(new XML("<overrides type=\""+ className + "\"/>"));
						delete itemsList[i];
						numberOfItems--;
						i--;
						continue;
					}
				}
			}
			
			if (existingItems==null) {
				existingItems = new XMLList();
			}
			
			// add new items to previous items
			if (numberOfItems>0) {
				existingItems = new XMLList(existingItems.toString()+itemsList.toString());
			}

			if (isRoot && numberOfExtendedClasses>0) {
				for (i=0;i<numberOfExtendedClasses;i++) {
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
		 * Get MetaData data for the given member. 
		 * 
		 * Given an instance of a class, checks if that class has
		 * a property, style, event or method of the given name.
		 * 
		 * Some properties are facades for styles. By default we ignore 
		 * properties that are facades. 
		 * 
		 * @returns MetaData of member or null if not found
		 * 
		 * @see #getMetaDataOfStyle();
		 * @see #getMetaDataOfProperty();
		 * @see #getMetaDataOfMethod();
		 * @see #getMetaDataOfEvent();
		 * */
		public static function getMetaDataOfMember(target:Object, member:String, ignoreFacades:Boolean = true):MetaData {
			var isProperty:Boolean;
			var isStyle:Boolean;
			var isEvent:Boolean;
			var isMethod:Boolean;
			var typeName:String;
			var hasMember:Boolean;
			
			
			isProperty = hasProperty(target, member);
			
			if (!isProperty) {
				isStyle = hasStyle(target, member);
				
				if (!isStyle) {
					isEvent = hasEvent(target, member);
					
					if (!isEvent) {
						isMethod = hasMethod(target, member);
					}
				}
			}
			
			if (isProperty) {
				return getMetaDataOfProperty(target, member, ignoreFacades);
			}
			else if (isStyle) {
				return getMetaDataOfStyle(target, member);
			}
			else if (isEvent) {
				return getMetaDataOfEvent(target, member);
			}
			else if (isMethod) {
				return getMetaDataOfMethod(target, member);
			}
			
			return null;
		}
		
		/**
		 * Checks if target or type has a given member. 
		 * 
		 * Given an instance of a class, checks if that class has
		 * a property, style, event or method of the given name.
		 * 
		 * Some properties are facades for styles. By default we ignore 
		 * properties that are facades. 
		 * 
		 * @returns MetaData of member or null if not found
		 * 
		 * @see #getMetaDataOfStyle();
		 * @see #getMetaDataOfProperty();
		 * @see #getMetaDataOfMethod();
		 * @see #getMetaDataOfEvent();
		 * */
		public static function hasMember(target:Object, member:String, ignoreFacades:Boolean = true):Boolean {
			var isProperty:Boolean;
			var isStyle:Boolean;
			var isEvent:Boolean;
			var isMethod:Boolean;
			
			isProperty = hasProperty(target, member);
			
			if (!isProperty) {
				isStyle = hasStyle(target, member);
				
				if (!isStyle) {
					isEvent = hasEvent(target, member);
					
					if (!isEvent) {
						isMethod = hasMethod(target, member);
					}
				}
			}
			
			return isProperty || isStyle || isEvent || isMethod;
		}
		
		/**
		 * Get AccessorMetaData data for the given property. 
		 * 
		 * @see #getMetaDataOfStyle();
		 * @see #getMetaDataOfEvent();
		 * */
		public static function getMetaDataOfProperty(target:Object, property:String, ignoreFacades:Boolean = false):AccessorMetaData {
			var describedTypeRecord:mx.utils.DescribeTypeCacheRecord;
			var accessorMetaData:AccessorMetaData;
			var matches:XMLList;
			var matches2:XMLList;
			var node:XML;
			var cachedMetaData:Object;
			
			
			describedTypeRecord = DescribeTypeCache.describeType(target);
			
			// we should not include facade properties
			// could we move this up a few lines before the XMLList stuff and save some cpu cycles?
			// testing now
			//cachedMetaData = DescribeTypeCacheRecord[property];
			cachedMetaData = describedTypeRecord[property];
			
			if (cachedMetaData is AccessorMetaData) {
				AccessorMetaData(cachedMetaData).updateValues(target);
				return AccessorMetaData(cachedMetaData);
			}
			
			matches = describedTypeRecord.typeDescription..accessor.(@name==property);
			matches2 = describedTypeRecord.typeDescription..variable.(@name==property);
			
			if (matches.length()>0) {
				node = matches[0];
			}
			else if (matches2.length()>0) {
				node = matches2[0];
			}
			
			
			if (node) {
				accessorMetaData = new AccessorMetaData();
				accessorMetaData.unmarshall(node, target);
				
				// we want to cache property meta data
				if (accessorMetaData) {
					DescribeTypeCache.registerCacheHandler(property, function (record:DescribeTypeCacheRecord):Object {
						//if (relevantPropertyFacades.indexOf(style)!=-1) {
						return accessorMetaData;
						//}
					});
				}
				
				return accessorMetaData;
			}
			
			return null;
		}
		
		public static const relevantPropertyFacades:Array = 
			[ "top", "left", "right", "bottom", 
			"verticalCenter", "horizontalCenter", "baseline"];
		
		private static var metadataCache:Object = {};
		
		/**
		 * Set cached metadata 
		 * */
		public static function setCachedMetaData(object:*, name:*, metadata:MetaData):void {
			var className:String;
			var cacheKey:String;
			var metadataDictionary:Dictionary;
			var weakKeys:Boolean;
			
			if (object is String) {
				cacheKey = className = object;
			}
			else {
				cacheKey = className = getQualifiedClassName(object);
			}
			
			//Need separate entries for describeType(Foo) and describeType(myFoo)
			if (object is Class) {
				cacheKey += "$";
			}
			
			// check if class is cached
			if (!(cacheKey in metadataCache)) {
				metadataCache[cacheKey] = null;
			}
			
			// create dictionary if not created
			if (metadataCache[cacheKey]==null) {
				metadataDictionary = new Dictionary(weakKeys);
				metadataCache[cacheKey] = metadataDictionary;
			}
			else {
				metadataDictionary = metadataCache[cacheKey];
			}
				
			// check if member is cached
			if (metadataDictionary[name]==null) {
				metadataDictionary[name] = metadata;
			}
			
		}
		
		/**
		 * Get cached metadata
		 * */
		public static function getCachedMetaData(object:*, name:*):MetaData {
			var className:String;
			var cacheKey:String;
			var metadataDictionary:Dictionary;
			var metaData:MetaData;
			
			if (object is String) {
				cacheKey = className = object;
			}
			else {
				cacheKey = className = getQualifiedClassName(object);
			}
			
			//Need separate entries for describeType(Foo) and describeType(myFoo)
			if (object is Class) {
				cacheKey += "$";
			}
			
			// check if class is cached
			if (cacheKey in metadataCache) {
				metadataDictionary = metadataCache[cacheKey];
				
				if (metadataDictionary[name]!=null) {
					metaData = metadataDictionary[name];
				}
			}
			
			return metaData;
		}
		
		/**
		 * Get MetaData for the given metadata. 
		 * 
		 * Usage:<br/>
<pre>
var metadataMetaData:MetaData = getMetaDataOfMetaData(myButton, "DefaultProperty");
</pre>
		 * @returns an MetaData object
		 * @param target Object that contains the metadata
		 * @param name name of metadata
		 * @param type if metadata is not defined on target class we check super class. used in recursive search. default null 
		 * @param stopAt if we don't want to look all the way up to object we can set the class to stop looking at
		 * 
		 * @see #getMetaDataOfProperty()
		 * */
		public static function getMetaDataOfMetaData(target:Object, metaDataName:String, type:String = null, stopAt:String = null):MetaDataMetaData {
			var describedTypeRecord:DescribeTypeCacheRecord;
			var cachedMetaData:Object;
			var metaDataMetaData:MetaDataMetaData;
			var extendsClassList:XMLList;
			var typeDescription:XML;
			var found:Boolean;
			var hasFactory:Boolean;
			var matches:XMLList;
			var factory:Object;
			var node:XML;
			
			
			cachedMetaData = getCachedMetaData(target, metaDataName);
			
			if (cachedMetaData) {
				//MetaDataMetaData(cachedMetaData).updateValues(target, false);
				return MetaDataMetaData(cachedMetaData);
			}
			
			if (type) {
				describedTypeRecord = DescribeTypeCache.describeType(type);
			}
			else {
				describedTypeRecord = DescribeTypeCache.describeType(target);
			}
			
			typeDescription = describedTypeRecord.typeDescription[0];
			factory = typeDescription.factory;
			hasFactory = factory.length()>0;
			
			if (hasFactory) {
				matches = factory.metadata.(@name==metaDataName);
			}
			else {
				matches = typeDescription.metadata.(@name==metaDataName);
			}
			
			if (matches && matches.length()==0) {
				
				if (hasFactory) {
					extendsClassList = factory.extendsClass;
				}
				else {
					extendsClassList = typeDescription.extendsClass;
				}
				
				var numberOfTypes:int = extendsClassList.length();
				
				for (var i:int;i<numberOfTypes;i++) {
					type = extendsClassList[i].@type;
					if (type==stopAt) return null;
					if (type=="Class") return null;
					
					return getMetaDataOfMetaData(target, metaDataName, type);
				}
			}
			
			if (matches.length()>0) {
				node = matches[0];
				
				if ("typeName" in typeDescription) {
					node.@declaredBy = typeDescription.typeName;
				}
				else if (type) {
					node.@declaredBy = type;
				}
				else if (typeDescription.hasOwnProperty("name")) {
					node.@declaredBy = typeDescription.@name;
				}
				
				metaDataMetaData = new MetaDataMetaData();
				metaDataMetaData.unmarshall(node, target);
				
				// we want to cache meta data meta data
				if (metaDataMetaData) {
					//Main Thread (Suspended: Error: Error #2090: The Proxy class does not implement callProperty. It must be overridden by a subclass.)	
					//	Error$/throwError [no source]	
					//	flash.utils::Proxy/http://www.adobe.com/2006/actionscript/flash/proxy::callProperty [no source]	
					
					setCachedMetaData(target, metaDataName, metaDataMetaData);
					
					/*
					this doesn't seem to work for metadata or might need more work
					DescribeTypeCache.registerCacheHandler(metaDataName, function (record:DescribeTypeCacheRecord):Object {
						//if (relevantPropertyFacades.indexOf(style)!=-1) {
						return metaDataMetaData;
						//}
					});
					*/
				}
				
				return metaDataMetaData;
			}
			
			return null;
		}
		
		/**
		 * Get StyleMetaData data for the given style. 

		 * Usage:<br/>
 <pre>
 var styleMetaData:StyleMetaData = getMetaDataOfStyle(myButton, "color");
 </pre>
		 * @returns an StyleMetaData object
		 * @param target IStyleClient that contains the style
		 * @param style name of style
		 * @param type if style is not defined on target class we check super class. used in recursive search. default null 
		 * @param stopAt if we don't want to look all the way up to object we can set the class to stop looking at
		 * 
		 * @see #getMetaDataOfProperty()
		 * */
		public static function getMetaDataOfStyle(target:Object, style:String, type:String = null, stopAt:String = null):StyleMetaData {
			var describedTypeRecord:DescribeTypeCacheRecord;
			var cachedMetaData:Object;
			var styleMetaData:StyleMetaData;
			var extendsClassList:XMLList;
			var typeDescription:XML;
			var foundStyle:Boolean;
			var hasFactory:Boolean;
			var matches:XMLList;
			var factory:Object;
			var node:XML;
			
			if (type) {
				describedTypeRecord = DescribeTypeCache.describeType(type);
			}
			else {
				describedTypeRecord = DescribeTypeCache.describeType(target);
			}
			
			cachedMetaData = describedTypeRecord[style];
			
			if (cachedMetaData is StyleMetaData) {
				StyleMetaData(cachedMetaData).updateValues(target);
				return StyleMetaData(cachedMetaData);
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
				
				var numberOfTypes:int = extendsClassList.length();
				
				for (var i:int;i<numberOfTypes;i++) {
					type = extendsClassList[i].@type;
					if (type==stopAt) return null;
					if (type=="Class") return null;
					
					return getMetaDataOfStyle(target, style, type);
				}
			}
			
			if (matches.length()>0) {
				node = matches[0].parent();
				if ("typeName" in typeDescription) {
					node.@declaredBy = typeDescription.typeName;
				}
				else if (type) {
					node.@declaredBy = type;
				}
				else if (typeDescription.hasOwnProperty("name")) {
					node.@declaredBy = typeDescription.@name;
				}
				styleMetaData = new StyleMetaData();
				styleMetaData.unmarshall(node, target);
				
				// we want to cache style meta data
				if (styleMetaData) {
					//Main Thread (Suspended: Error: Error #2090: The Proxy class does not implement callProperty. It must be overridden by a subclass.)	
					//	Error$/throwError [no source]	
					//	flash.utils::Proxy/http://www.adobe.com/2006/actionscript/flash/proxy::callProperty [no source]	
						
					DescribeTypeCache.registerCacheHandler(style, function (record:DescribeTypeCacheRecord):Object {
						//if (relevantPropertyFacades.indexOf(style)!=-1) {
						return styleMetaData;
						//}
					});
				}
				
				return styleMetaData;
			}
			
			return null;
		}
		
		/**
		 * Get EventMetaData data for the given event. 

		 * Usage:<br/>
 <pre>
 var eventMetaData:EventMetaData = getMetaDataOfEvent(myButton, "color");
 </pre>
		 * @returns an EventMetaData object
		 * @param target IEventClient that contains the event
		 * @param event name of event
		 * @param type if event is not defined on target class we check super class. default null 
		 * @param stopAt if we don't want to look all the way up to object we can set the class to stop looking at
		 * 
		 * @see #getMetaDataOfProperty()
		 * */
		public static function getMetaDataOfEvent(target:Object, event:String, type:String = null, stopAt:String = null):EventMetaData {
			var describedTypeRecord:DescribeTypeCacheRecord;
			var eventMetaData:EventMetaData;
			var extendsClassList:XMLList;
			var cachedMetaData:Object;
			var typeDescription:XML;
			var foundEvent:Boolean;
			var hasFactory:Boolean;
			var matches:XMLList;
			var factory:Object;
			var node:XML;
			
			if (type) {
				describedTypeRecord = DescribeTypeCache.describeType(type);
			}
			else {
				describedTypeRecord = DescribeTypeCache.describeType(target);
			}
			
			cachedMetaData = describedTypeRecord[event];
			
			if (cachedMetaData is EventMetaData) {
				EventMetaData(cachedMetaData).updateValues(target);
				return EventMetaData(cachedMetaData);
			}
			
			typeDescription = describedTypeRecord.typeDescription[0];
			factory = typeDescription.factory;
			hasFactory = factory.length()>0;
			
			// sometimes factory exists sometimes it doesn't wtf?
			if (hasFactory) {
				//matches = describedTypeRecord.typeDescription.factory.metadata.(@name=="Event").arg.(@value==event);
				matches = factory.metadata.(@name=="Event").arg.(@value==event);
			}
			else {
				matches = typeDescription.metadata.(@name=="Event").arg.(@value==event);
			}
			
			if (matches && matches.length()==0) {
				
				if (hasFactory) {
					extendsClassList = factory.extendsClass;
				}
				else {
					extendsClassList = typeDescription.extendsClass;
				}
				
				var numberOfTypes:int = extendsClassList.length();
				
				for (var i:int;i<numberOfTypes;i++) {
					type = extendsClassList[i].@type;
					if (type==stopAt) return null;
					if (type=="Class") return null;
					
					return getMetaDataOfEvent(target, event, type);
				}
			}
			
			if (matches.length()>0) {
				node = matches[0].parent();
				if ("typeName" in typeDescription) {
					node.@declaredBy = typeDescription.typeName;
				}
				else if (type) {
					node.@declaredBy = type;
				}
				else if (typeDescription.hasOwnProperty("name")) {
					node.@declaredBy = typeDescription.@name;
				}
				eventMetaData = new EventMetaData();
				eventMetaData.unmarshall(node, target);
				
				// we want to cache event meta data
				if (eventMetaData) {
					//Main Thread (Suspended: Error: Error #2090: The Proxy class does not implement callProperty. It must be overridden by a subclass.)	
					//	Error$/throwError [no source]	
					//	flash.utils::Proxy/http://www.adobe.com/2006/actionscript/flash/proxy::callProperty [no source]	
						
					DescribeTypeCache.registerCacheHandler(event, function (record:DescribeTypeCacheRecord):Object {
						//if (relevantPropertyFacades.indexOf(event)!=-1) {
						return eventMetaData;
						//}
					});
				}
				
				return eventMetaData;
			}
			
			return null;
		}
		
		/**
		 * Get MethodMetaData data for the given method. 
		 *
		 * Usage:<br/>
<pre>
	var methodMetaData:MethodMetaData = getMetaDataOfMethod(myButton, "color");
</pre>
		 * @returns an MethodMetaData object
		 * @param target IMethodClient that contains the method
		 * @param method name of method
		 * @param type if method is not defined on target class we check super class. default null 
		 * @param stopAt if we don't want to look all the way up to object we can set the class to stop looking at
		 * 
		 * @see #getMetaDataOfProperty()
		 * */
		public static function getMetaDataOfMethod(target:Object, method:String, type:String = null, stopAt:String = null):MethodMetaData {
			var describedTypeRecord:DescribeTypeCacheRecord;
			var methodMetaData:MethodMetaData;
			var extendsClassList:XMLList;
			var cachedMetaData:Object;
			var typeDescription:XML;
			var foundMethod:Boolean;
			var hasFactory:Boolean;
			var matches:XMLList;
			var factory:Object;
			var node:XML;
			
			if (type) {
				describedTypeRecord = DescribeTypeCache.describeType(type);
			}
			else {
				describedTypeRecord = DescribeTypeCache.describeType(target);
			}
			
			cachedMetaData = describedTypeRecord[method];
			
			if (cachedMetaData is MethodMetaData) {
				MethodMetaData(cachedMetaData).updateValues(target);
				return MethodMetaData(cachedMetaData);
			}
			
			typeDescription = describedTypeRecord.typeDescription[0];
			factory = typeDescription.factory;
			hasFactory = factory.length()>0;
			
			// sometimes factory exists sometimes it doesn't wtf?
			if (hasFactory) {
				//matches = describedTypeRecord.typeDescription.factory.metadata.(@name=="Method").arg.(@value==method);
				matches = factory.metadata.(@name=="Method").arg.(@value==method);
			}
			else {
				matches = typeDescription.metadata.(@name=="Method").arg.(@value==method);
			}
			
			if (matches && matches.length()==0) {
				
				if (hasFactory) {
					extendsClassList = factory.extendsClass;
				}
				else {
					extendsClassList = typeDescription.extendsClass;
				}
				
				var numberOfTypes:int = extendsClassList.length();
				
				for (var i:int;i<numberOfTypes;i++) {
					type = extendsClassList[i].@type;
					if (type==stopAt) return null;
					if (type=="Class") return null;
					
					return getMetaDataOfMethod(target, method, type);
				}
			}
			
			if (matches.length()>0) {
				node = matches[0].parent();
				if ("typeName" in typeDescription) {
					node.@declaredBy = typeDescription.typeName;
				}
				else if (type) {
					node.@declaredBy = type;
				}
				else if (typeDescription.hasOwnProperty("name")) {
					node.@declaredBy = typeDescription.@name;
				}
				methodMetaData = new MethodMetaData();
				methodMetaData.unmarshall(node, target);
				
				// we want to cache method meta data
				if (methodMetaData) {
					//Main Thread (Suspended: Error: Error #2090: The Proxy class does not implement callProperty. It must be overridden by a subclass.)	
					//	Error$/throwError [no source]	
					//	flash.utils::Proxy/http://www.adobe.com/2006/actionscript/flash/proxy::callProperty [no source]	
					
					DescribeTypeCache.registerCacheHandler(method, function (record:DescribeTypeCacheRecord):Object {
						//if (relevantPropertyFacades.indexOf(method)!=-1) {
						return methodMetaData;
						//}
					});
				}
				
				return methodMetaData;
			}
			
			return null;
		}
		
		/**
		 * Gets an array of the styles from an array of names<br/><br/>
		 * 
		 * Usage:<br/>
 <pre>
 // returns ["backgroundAlpha", "fontFamily"]
 var styles:Array = getStylesFromArray(myButton, ["chicken","potatoe","backgroundAlpha","swisscheese","fontFamily"]);
 </pre>
		 * 
		 * @param object The object to use. Either string, object or class.
		 * @param possibleStyles An existing list of styles
		 * 
		 * @returns an array of style names or an empty array
		 * 
		 * @see #getObjectsPropertiesFromArray()
		 * @see #getObjectsEventsFromArray()
		 * */
		public static function getObjectsStylesFromArray(object:Object, possibleStyles:Object):Array {
			var styleNames:Array = getStyleNames(object);
			var result:Array = [];
			var style:String;
			var numberOfStyles:int;
			
			possibleStyles = ArrayUtil.toArray(possibleStyles);
			numberOfStyles = possibleStyles.length;
			
			for (var i:int; i < numberOfStyles; i++) {
				style = possibleStyles[i];
				
				if (styleNames.indexOf(style)!=-1) {
					if (result.indexOf(style)==-1) {
						result.push(style);
					}
				}
			}
			
			
			return result;
		}
		
		/**
		 * Gets an array of the styles from an object with name value pair<br/><br/>
		 * 
		 * Usage:<br/>
<pre>
// returns ["color", "fontFamily"]
var styles:Array = getStylesFromObject(myButton, {"color":10,"fontFamily":30,"marshmallow":20});
</pre>
		 * 
		 * @param object The object to check.
		 * @param object A generic object with properties on it.
		 * 
		 * @see #getPropertiesFromObject()
		 * @see #getEventsFromObject()
		 * */
		public static function getStylesFromObject(object:Object, valueObject:Object):Array {
			// get the properties on the value object
			var propertiesNames:Array = getPropertyNames(valueObject);
			
			return getObjectsStylesFromArray(object, propertiesNames);
		}
		
		/**
		 * Gets an array of the properties from an object with name value pair<br/><br/>
		 * 
		 * Usage:<br/>
<pre>
// returns ["x", "width"]
var properties:Array = getPropertiesFromObject(myButton, {"x":10,"apple":30,"width":20});
</pre>
		 * 
		 * @param object The object to check.
		 * @param object A generic object with properties on it.
		 * 
		 * @see #getStylesFromObject()
		 * @see #getEventsFromObject()
		 * */
		public static function getPropertiesFromObject(object:Object, valueObject:Object, removeConstraints:Boolean = false):Array {
			var propertiesNames:Array = getPropertyNames(valueObject);
			
			return getObjectsPropertiesFromArray(object, propertiesNames, removeConstraints);
		}
		
		/**
		 * Gets an array of the events from an object with name value pair<br/><br/>
		 * 
		 * Usage:<br/>
<pre>
// returns ["click"]
var events:Array = getEventsFromObject(myButton, {"x":10,"apple":30,"click":myClickHandler});
</pre>
		 * 
		 * @param object The object to check.
		 * @param object A generic object with properties on it.
		 * 
		 * @see #getStylesFromObject()
		 * @see #getPropertiesFromObject()
		 * */
		public static function getEventsFromObject(object:Object, valueObject:Object):Array {
			var propertiesNames:Array = getPropertyNames(valueObject);
			
			return getObjectsEventsFromArray(object, propertiesNames);
		}
		
		public static var CONSTRAINTS:Array = ["baseline", "left", "top", "right", "bottom", "horizontalCenter", "verticalCenter"];
		
		/**
		 * Gets an array of valid properties from an array of possible property names<br/><br/>
		 * 
		 * Usage:<br/>
 <pre>
 // returns ["width", "x"]
 var properties:Array = getPropertiesFromArray(myButton, ["chicken","potatoe","width","swisscheese","x","top"], true);
 // returns ["width", "x", "top"]
 var properties:Array = getPropertiesFromArray(myButton, ["chicken","potatoe","width","swisscheese","x","top"], false);
 </pre>
		 * 
		 * @param object The object to use. Either string, object or class.
		 * @param possibleProperties An list of possible properties
		 * 
		 * @returns an array of styles names or empty array
		 * 
		 * @see #getObjectsStylesFromArray()
		 * @see #getObjectsEventsFromArray()
		 * */
		public static function getObjectsPropertiesFromArray(object:Object, possibleProperties:Object, removeConstraints:Boolean = false):Array {
			var propertyNames:Array = getPropertyNames(object);
			var result:Array = [];
			var property:String;
			var numberOfProperties:int;
			
			possibleProperties = ArrayUtil.toArray(possibleProperties);
			numberOfProperties = possibleProperties.length;
			
			for (var i:int; i < numberOfProperties; i++) {
				property = possibleProperties[i];
				
				if (propertyNames.indexOf(property)!=-1) {
					if (result.indexOf(property)==-1) {
						
						if (removeConstraints) {
							
							// remove constraints (they are a facade for the styles)
							if (CONSTRAINTS.indexOf(property)==-1) { 
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
		 * Gets an array of valid events from an array of possible event names<br/><br/>
		 * 
		 * Usage:<br/>
 <pre>
 // returns ["click"]
 var events:Array = getEventsFromArray(myButton, ["chicken","potatoe","width","click","x"]);
 </pre>
		 * 
		 * @param object The object to use. Either string, object or class.
		 * @param possibleEvents An list of possible events
		 * 
		 * @returns an array of event names or an empty array
		 * 
		 * @see #getObjectsStylesFromArray()
		 * @see #getObjectsPropertiesFromArray()
		 * */
		public static function getObjectsEventsFromArray(object:Object, possibleEvents:Object):Array {
			var eventNames:Array = getEventNames(object);
			var result:Array = [];
			var eventName:String;
			var numberOfEvents:int;
			
			possibleEvents = ArrayUtil.toArray(possibleEvents);
			numberOfEvents = possibleEvents.length;
			
			for (var i:int; i < numberOfEvents; i++) {
				eventName = possibleEvents[i];
				
				if (eventNames.indexOf(eventName)!=-1) {
					if (result.indexOf(eventName)==-1) {
						result.push(eventName);
					}
				}
			}
			
			
			return result;
		}
		
		/**
		 * Removes the constraint values from an array since the constraint properties
		 * are a facade for the styles of the same name. 
		 * 
		 * @returns an array with the elements that were removed
		 * */
		public static function removeConstraintsFromArray(items:Array):Array {
			var numberOfItems:int = items ? items.length : 0;
			var constraints:Array = [];
			var property:String;
			
			for (var i:int; i < numberOfItems; i++) {
				property = items[i];
				
				// found constraint then delete it from the object
				if (CONSTRAINTS.indexOf(property)!=-1) { 
					items.slice(i, 1);
					
					if (constraints.indexOf(property)==-1) {
						constraints.push(property);
					}
				}
			}
			
			return constraints;
		}
		
		/**
		 * Removes the constraint values from an object since the constraint properties
		 * are a facade for the styles of the same name. 
		 * Having an attribute defined twice in XML makes the XML invalid. So we must
		 * remove them.
		 * */
		public static function removeConstraintsFromObject(object:Object):Object {
			var propertyNames:Array = getPropertyNames(object);
			var numberOfProperties:int = propertyNames.length;
			var property:String;
			
			for (var i:int; i < numberOfProperties; i++) {
				property = propertyNames[i];
				
				// found constraint then delete it from the object
				if (CONSTRAINTS.indexOf(property)!=-1) { 
					object[property] = null;
					delete object[property];
				}
			}
			
			return object;
		}

		
		/**
		 * Checks if the application has the definition. Returns true if it does. 
		 * */
		public static function hasDefinition(definition:String, domain:ApplicationDomain = null):Boolean {
			var isDefined:Boolean;
			
			if (domain) {
				isDefined = domain.hasDefinition(definition);
				return isDefined;
			}
			
			isDefined = ApplicationDomain.currentDomain.hasDefinition(definition);
			return isDefined;
		}
		
		/**
		 * Gets the definition if defined. If not defined returns null. 
		 * */
		public static function getDefinition(definition:String, domain:ApplicationDomain = null):Object {
			var isDefined:Boolean;
			var definedClass:Object;
			domain = domain ? domain : ApplicationDomain.currentDomain;
			
			isDefined = domain.hasDefinition(definition);
			
			if (isDefined) {
				definedClass = domain.getDefinition(definition);
			}
			
			return definedClass;
		}
		
		/**
		 * Checks if the object is empty, if it has no properties. 
		 * Uses describeType to get the metadata on the object and 
		 * checks the number of properties.
		 * */
		public static function isEmptyObject(object:Object):Boolean {
			var propertiesArray:Array = getPropertyNames(object);
			return propertiesArray==null || propertiesArray.length==0;
		}
		
		/**
		 * Get a styles type 
		 * 
<pre>
var type:String = getTypeOfStyle(myButton, "color");
trace(type); // "String"
var type:Object = getTypeOfStyle(myButton, "color", true);
trace(type); // [Object String]
</pre>
		 * */
		public static function getTypeOfStyle(elementInstance:Object, style:String, returnAsClass:Boolean = false):Object {
			var styleMetaData:StyleMetaData = getMetaDataOfStyle(elementInstance, style);
			var ClassObject:Object;
			
			if (styleMetaData) {
				
				if (returnAsClass) {
					ClassObject = getDefinition(styleMetaData.type);
					return ClassObject;
				}
				else {
					return styleMetaData.type;
				}
			}
			
			return null;
		}
		/**
		 * Get a properties type 
		 * 
<pre>
var type:String = getTypeOfProperty(myButton, "x");
trace(type); // "int"
var type:Object = getTypeOfProperty(myButton, "x", true);
trace(type); // [Object int]
</pre>
		 * */
		public static function getTypeOfProperty(elementInstance:Object, property:String, returnAsClass:Boolean = false):Object {
			var propertyMetaData:MetaData = getMetaDataOfProperty(elementInstance, property);
			var classObject:Object;
			
			if (propertyMetaData) {
				
				if (returnAsClass) {
					classObject = getDefinition(propertyMetaData.type);
					return classObject;
				}
				else {
					return propertyMetaData.type;
				}
			}
			
			return null;
		}
		
		/**
		 * Get object that has name and value pair of styles and makes sure the values are of correct type
Usage: 
<pre>
var elementInstance:UIComponent = new ComboBox();
var node = &lt;s:ComboBox height="23" x="30" y="141" width="166" dataProvider="Item 1,Item 2,Item 3" xmlns:s="library://ns.adobe.com/flex/spark" />
var elementName:String = node.localName();
var attributeName:String;
var attributes:Array;
var childNodeNames:Array;
var propertiesOrStyles:Array;
var properties:Array;
var styles:Array;
var attributesValueObject:Object;
var childNodeValueObject:Object;
var values:Object;
var valuesObject:ValuesObject;
var failedToImportStyles:Object = {};
var failedToImportProperties:Object = {};

attributes 				= XMLUtils.getAttributeNames(node);
childNodeNames 			= XMLUtils.getChildNodeNames(node);
propertiesOrStyles 		= attributes.concat(childNodeNames);
properties 				= ClassUtils.getPropertiesFromArray(elementInstance, propertiesOrStyles);
styles 					= ClassUtils.getStylesFromArray(elementInstance, propertiesOrStyles);

attributesValueObject 	= XMLUtils.getAttributesValueObject(node);
attributesValueObject	= ClassUtils.getTypedStyleValueObject(elementInstance as IStyleClient, attributesValueObject, styles, failedToImportStyles);
attributesValueObject	= ClassUtils.getTypedPropertyValueObject(elementInstance, attributesValueObject, properties, failedToImportProperties);
</pre>
		 * @param target Object to set values on
		 * @param values Object containing name value pair of styles
		 * @param styles Optional Array of specific styles to
		 * @param failedToImportObject Optional Object that contains any styles that failed to import and errors as the value
		 * */
		public static function getTypedStyleValueObject(target:Object, values:Object, styles:Array = null, getTypedObject:Boolean = false, failedToImportStyles:Object = null):Object {
			var numberOfStyles:int = styles && styles.length ? styles.length : 0;
			var styleType:Object;
			var styleMetaData:StyleMetaData;
			var style:String;
			var value:*;
			
			// get specified styles
			if (styles && numberOfStyles) {
				for each (style in styles) {
					styleMetaData = getMetaDataOfStyle(target, style);
					
					if (styleMetaData.format=="Color") {
						styleType = "String";
					}
					else {
						styleType = styleMetaData.type;
					}
					
					if (styleType=="Object") {
						
						// ITextLayoutFormat
						if (style=="trackingLeft" || style=="trackingRight" || style=="lineHeight") {
							value = values[style];
							
							if (value && value.indexOf("%")!=-1) {
								styleType = "String";
							}
							else {
								styleType = "Number";
							}
						}
						//else if (style=="baselineShift" ) {
						//	value = values[style];
						//	styleType = "String";
						//}
					}
					
					try {
						values[style] = getCorrectType(values[style], styleType);
					}
					catch (error:Error) {
						if (failedToImportStyles) {
							failedToImportStyles[style] = error;
						}
					}
				}
			}
			
			// get all styles in values object
			else {
				for (style in values) {
					styleMetaData = getMetaDataOfStyle(target, style);
					
					if (styleMetaData) {
						if (styleMetaData.format=="Color") {
							styleType = "String";
						}
						else {
							styleType = styleMetaData.type;
						}
						
						
						try {
							values[style] = getCorrectType(values[style], styleType);
						}
						catch (error:Error) {
							if (failedToImportStyles) {
								failedToImportStyles[style] = error;
							}
						}
					}
				}
			}
			
			return values;
		}
		
		/**
		 * Get object that has property and value pair and makes sure the values are of correct type
Usage: 
<pre>
var elementInstance:UIComponent = new ComboBox();
var node = &lt;s:ComboBox height="23" x="30" y="141" width="166" dataProvider="Item 1,Item 2,Item 3" xmlns:s="library://ns.adobe.com/flex/spark" />
var elementName:String = node.localName();
var attributeName:String;
var attributes:Array;
var childNodeNames:Array;
var propertiesOrStyles:Array;
var properties:Array;
var styles:Array;
var attributesValueObject:Object;
var childNodeValueObject:Object;
var values:Object;
var valuesObject:ValuesObject;
var failedToImportStyles:Object = {};
var failedToImportProperties:Object = {};

attributes 				= XMLUtils.getAttributeNames(node);
childNodeNames 			= XMLUtils.getChildNodeNames(node);
propertiesOrStyles 		= attributes.concat(childNodeNames);
properties 				= ClassUtils.getPropertiesFromArray(elementInstance, propertiesOrStyles);
styles 					= ClassUtils.getStylesFromArray(elementInstance, propertiesOrStyles);

attributesValueObject 	= XMLUtils.getAttributesValueObject(node);
attributesValueObject	= ClassUtils.getTypedStyleValueObject(elementInstance as IStyleClient, attributesValueObject, styles, failedToImportStyles);
attributesValueObject	= ClassUtils.getTypedPropertyValueObject(elementInstance, attributesValueObject, properties, failedToImportProperties);
</pre>
		 * 
		 * @param target Object to set values on
		 * @param values Object containing name value pair of properties
		 * @param properties Optional Array of specific properties to
		 * @param failedToImportObject Optional Object that contains any properties that failed to import and errors as values
		 * */
		public static function getTypedPropertyValueObject(target:Object, values:Object, properties:Array = null, failedToImportObject:Object = null):Object {
			var numberOfProperties:int = properties && properties.length ? properties.length : 0;
			var propertyType:Object;
			var property:String;
			
			// get specific properties
			if (properties && numberOfProperties) {
				for each (property in properties) {
					try {
						propertyType = getTypeOfProperty(target, property, true);
						values[property] = getCorrectType(values[property], propertyType);
					}
					catch(error:Error) {
						if (failedToImportObject) {
							failedToImportObject[property] = error;
						}
					}
				}
			}
			else {
				
				// get all properties in values object
				for (property in values) {
					try {
						propertyType = getTypeOfProperty(target, property, true);
						values[property] = getCorrectType(values[property], propertyType);
					}
					catch(error:Error) {
						if (failedToImportObject) {
							failedToImportObject[property] = error;
						}
					}
				}
			}
			
			return values;
		}
		
		/**
		 * Casts the value to the correct type
		 * NOTE: May not work for colors
		 * Also supports casting to specific class. use ClassDefinition as type
		 * returns instance of flash.utils.getDefinitionByName(className)
		 * */
		public static function getCorrectType(value:String, Type:*):* {
			var typeString:String;
			var ClassDefinition:Class;
			
			if (Type==undefined || Type==null) {
				return value;
			}
			
			if (Type && !(Type is String)) {
				
				if (Type==Boolean) {
					if (value && value.toLowerCase() == "false") {
						return false;
					}
					else if (value && value.toLowerCase() == "true") {
						return true;
					}
					else if (!value) {
						return false;
					}
				}
				return Type(value);
			}
			else {
				typeString = Type;
				
				if (typeString == "Boolean" && value.toLowerCase() == "false") {
					return false;
				}
				else if (typeString == "Boolean" && value.toLowerCase() == "true") {
					return true;
				}
				else if (typeString == "Boolean" && !value) {
					return false;
				}
				else if (typeString == "Number") {
					if (value == null || value == "") {
						return undefined
					};
					return Number(value);
				}
				else if (typeString == "int") {
					if (value == null || value == "") {
						return undefined
					};
					return int(value);
				}
				else if (typeString == "String") {
					return String(value);
				}
					// TODO: Return color type1
				else if (typeString == "Color") {
					return String(value);
				}
				else if (typeString == "ClassDefinition") {
					if (value) {
						ClassDefinition = getDefinitionByName(value) as Class;
						return ClassDefinition(value);
					}
					return null;
				}
				else {
					return value;
				}
			}
		}
		
	}
}