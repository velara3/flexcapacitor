



package com.flexcapacitor.utils {
	import com.flexcapacitor.events.InspectorEvent;
	import com.flexcapacitor.graphics.LayoutLines;
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
	import mx.core.IVisualElement;
	import mx.core.IVisualElementContainer;
	import mx.core.UIComponent;
	import mx.managers.ISystemManager;
	import mx.utils.NameUtil;
	import mx.utils.ObjectUtil;

	public class InspectorUtils {


		public function InspectorUtils() {


		}
		
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
		 * Clears outline drawn around target display object
		 * */
		public static function clearSelection(target:Object, systemManager:ISystemManager, remove:Boolean = false):void {
			LayoutLines.getInstance().clear(target, systemManager, remove);
		}
		
		/**
		 * Draws outline around target display object
		 * */
		public static function drawSelection(target:Object, systemManager:ISystemManager):void {
			throw new Error("CANNOT USE DRAW SELECTION");
			//Radiate.drawSelection(target);
			/*if (target is DisplayObject) {
				LayoutLines.getInstance().drawLines(target, systemManager);
			}
			else if (target!=null) {
				trace("Is not displayObject", NameUtil.getUnqualifiedClassName(target));
			}*/
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
		 * Gets the ID of the target object
		 * returns null if no ID is specified or target is not a UIComponent
		 * */
		public static function getIdentifier(element:Object):String {
			var id:String;

			if (element is UIComponent && UIComponent(element).id) {
				id = UIComponent(element).id;
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
		 * With the given target it returns a regexp pattern to find the exact instance in MXML
		 * If isScript is true it attempts to returns a pattern to find the exact instance in AS3
		 * The MXML pattern will find the instance with that ID. If the instance doesn't have an ID it no worky.
		 * NOTE: Press CMD+SHIFT+F to and check regular expression in the Find in Files dialog
		 * */
		public static function getRegExpSearchPattern(target:DisplayObject, isScript:Boolean = false):String {
			var id:String = getIdentifier(target);
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
		 * Get ancestors of element 
		 * 
		 * @param target
		 * @param collection
		 * @param ancestors
		 * @return
		 */
		public static function getVisualElementsArray(element:*, items:Array, ancestors:int = 0, topMostDisplayObject:Object = null):Array {
			var vo:VisualElementVO;

			// do the worm up the display list
			while (element!= null && ancestors>-1)
			{
				// store display element information
				vo = VisualElementVO.unmarshall(element);
				
				// save reference to display element VO's for tree
				if (!items) items = new Array();
				items.push(vo);
				
				if ("owner" in element) {
					element = element.owner as IVisualElement;
				}
				
				ancestors--;
				
				if (element==topMostDisplayObject) {
					ancestors = 0; //bail after the next run through
				}
			}
			
			return items;

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
	}
}