
package com.flexcapacitor.utils {
	import com.flexcapacitor.utils.supportClasses.ComponentDescription;
	import com.flexcapacitor.utils.supportClasses.GroupOptions;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.IBitmapDrawable;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.PixelSnapping;
	import flash.display.Sprite;
	import flash.display.StageQuality;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Matrix3D;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.system.Capabilities;
	import flash.system.LoaderContext;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import flash.utils.Endian;
	import flash.utils.getTimer;
	
	import mx.collections.ArrayCollection;
	import mx.core.BitmapAsset;
	import mx.core.FlexGlobals;
	import mx.core.IFlexModuleFactory;
	import mx.core.IInvalidating;
	import mx.core.IUIComponent;
	import mx.core.IVisualElement;
	import mx.core.IVisualElementContainer;
	import mx.core.UIComponent;
	import mx.core.mx_internal;
	import mx.graphics.BitmapFill;
	import mx.graphics.BitmapFillMode;
	import mx.graphics.codec.JPEGEncoder;
	import mx.graphics.codec.PNGEncoder;
	import mx.managers.ISystemManager;
	import mx.styles.StyleManager;
	import mx.utils.Base64Decoder;
	import mx.utils.Base64Encoder;
	import mx.utils.MatrixUtil;
	
	import spark.components.Image;
	import spark.components.supportClasses.GroupBase;
	import spark.components.supportClasses.InvalidatingSprite;
	import spark.components.supportClasses.Skin;
	import spark.components.supportClasses.SkinnableComponent;
	import spark.core.IGraphicElement;
	import spark.core.SpriteVisualElement;
	import spark.primitives.BitmapImage;
	import spark.primitives.supportClasses.GraphicElement;
	import spark.skins.IHighlightBitmapCaptureClient;
	
	use namespace mx_internal;
	
	/**
	 * Utils used to manipulate the component tree and display list tree.<br/><br/>
	 * 
	 * There are a bunch of capture screen shot methods and a few other utility methods 
	 * in this class. All of them have had issues at one point or another. Sometimes
	 * things were clipped, other times things were not clipped, other times
	 * the top left was off or included off screen objects. I would like to 
	 * go through and test each method on each component type and display object 
	 * and find one that works or just document things more but haven't had the 
	 * time. I've come across numerous methods the Flex and Flash engineers used
	 * to capture screenshots and added and referenced some of them here.
	 * These include, spark.utils.BitmapUtil. <br/><br/>
	 * 
	 * Official display object snapshot methods (Oct 2015):  
<pre>
if (displayTarget is UIComponent) {
	container = DisplayObjectUtils.rasterizeComponent(displayTarget as UIComponent);
}
else {
	container = DisplayObjectUtils.rasterize2(displayTarget as DisplayObject);
}
</pre>
	 * */
	public class DisplayObjectUtils extends EventDispatcher {
		
		public function DisplayObjectUtils() {
			
		}
		
		//1172: Definition flash.display:JPEGEncoderOptions could not be found.
		//import flash.display.JPEGXREncoderOptions; 
		//import flash.display.JPEGEncoderOptions; 
		//import flash.display.PNGEncoderOptions;
		
		public static const HEXIDECIMAL_HASH_COLOR_TYPE:String = "hexidecimalHash";
		public static const HEXIDECIMAL_PREFIX_COLOR_TYPE:String = "hexidecimalPrefix";
		public static const HEXIDECIMAL_COLOR_TYPE:String = "hexidecimal";
		public static const STRING_UINT_COLOR_TYPE:String = "stringUint";
		public static const NUMBER_COLOR_TYPE:String = "number";
		public static const UINT_COLOR_TYPE:String = "uint";
		public static const INT_COLOR_TYPE:String = "int";
		
		public static const PNG_MIME_TYPE:String = "image/png";
		public static const FLASH_MIME_TYPE:String = "application/x-shockwave-flash"
		public static const JPEG_MIME_TYPE:String = "image/jpeg";
		public static const GIF_MIME_TYPE:String = "image/gif";
		
		public static const PNG:String = "png";
		public static const FLASH:String = "swf"
		public static const SWF:String = "swf"
		public static const JPG:String = "jpg";
		public static const JPEG:String = "jpeg";
		public static const GIF:String = "gif";
		
		/**
		 * Blend modes from 
		 * https://www.adobe.com/devnet-apps/photoshop/fileformatashtml/
		
		'pass' = pass through, 
		'norm' = normal, 
		'diss' = dissolve, 
		'dark' = darken, 
		'mul ' = multiply, 
		'idiv' = color burn, 
		'lbrn' = linear burn, 
		'dkCl' = darker color, 
		'lite' = lighten, 
		'scrn' = screen, 
		'div ' = color dodge, 
		'lddg' = linear dodge, 
		'lgCl' = lighter color, 
		'over' = overlay, 
		'sLit' = soft light, 
		'hLit' = hard light, 
		'vLit' = vivid light, 
		'lLit' = linear light, 
		'pLit' = pin light, 
		'hMix' = hard mix, 
		'diff' = difference, 
		'smud' = exclusion, 
		'fsub' = subtract, 
		'fdiv' = divide,
		'hue ' = hue, 
		'sat ' = saturation, 
		'colr' = color, 
		'lum ' = luminosity
		 * */
		public static var BLEND_MODES:Object = {
			norm: "normal",
			dark: "darken",
			lite: "lighten",
			hue:  "hue",
			sat:  "saturation",
			colr: "color",
			lum:  "luminosity",
			mul:  "multiply",
			scrn: "screen",
			diss: "dissolve",
			over: "overlay",
			hLit: "hard light",
			sLit: "soft light",
			diff: "difference",
			smud: "exclusion",
			div:  "color dodge",
			idiv: "color burn",
			lbrn: "linear burn",
			lddg: "linear dodge",
			vLit: "vivid light",
			lLit: "linear light",
			pLit: "pin light",
			hMix: "hard mix",
			pass: "pass through",
			fsub: "subtract", 
			fdiv: "divide"
		}
		
		/**
		 * Used to encode images
		 * */
		public static var base64Encoder:Base64Encoder;
		
		/**
		 * Used to decode images
		 * */
		public static var base64Decoder:Base64Decoder;
		
		/**
		 * Alternative base 64 encoder based on Base64. You must set this to the class for it to be used.
		 * */
		public static var Base64Encoder2:Object;
		
		/**
		 * Alternative base 64 decoder based on Base64. You must set this to the class for it to be used.
		 * */
		public static var Base64Decoder2:Object;
		
		/**
		 * Used to create PNG images
		 * */
		public static var pngEncoder:PNGEncoder;
		
		/**
		 * Used to create JPEG images
		 * */
		public static var jpegEncoder:JPEGEncoder;
		
		/**
		 * PNG Encoder options
		 * */
		public static var pngEncoderOptions:Object; // PNGEncoderOptions;
		
		/**
		 * JPEG Encoder options
		 * */
		public static var jpegEncoderOptions:Object; // JPEGEncoderOptions;
		
		/**
		 * JPEG XR Encoder options
		 * */
		public static var jpegXREncoderOptions:Object; // JPEGXREncoderOptions;
		
		/**
		 * References to previously encoded bitmaps
		 * */
		public static var base64BitmapCache:Dictionary = new Dictionary(true);
		
		/**
		 * Keep a reference to groups that have mouse enabled where transparent 
		 * and mouse handler support added when addGroupMouseSupport is called
		 * Stored so it can be removed with removeGroupMouseSupport
		 * */
		public static var applicationGroups:Dictionary = new Dictionary(true);
		
		/**
		 * Gets top level coordinate space. 
		 * */
		public static function getTopTargetCoordinateSpace():DisplayObject {
			
			// if selection is offset then check if using system manager sandbox root or top level root
			var systemManager:ISystemManager = ISystemManager(FlexGlobals.topLevelApplication.systemManager);
			
			// no types so no dependencies
			var marshallPlanSystemManager:Object = systemManager.getImplementation("mx.managers.IMarshallPlanSystemManager");
			var targetCoordinateSpace:DisplayObject;
			
			if (marshallPlanSystemManager && marshallPlanSystemManager.useSWFBridge()) {
				targetCoordinateSpace = Sprite(systemManager.getSandboxRoot());
			}
			else {
				targetCoordinateSpace = Sprite(FlexGlobals.topLevelApplication);
			}
			
			return targetCoordinateSpace;
		}
		
		
		/**
		 * Creates a heiarchial object of the display list starting at the given element.
		 * This is a duplicate of the getComponentDisplayList = needs to be just display list
		 * */
		public static function getDisplayList(element:Object, parentItem:ComponentDescription = null, depth:int = 0):ComponentDescription {
			var item:ComponentDescription;
			var childElement:IVisualElement;
			
			
			if (!parentItem) {
				parentItem = new ComponentDescription(element);
				parentItem.children = new ArrayCollection();
				return getDisplayList(element, parentItem);
			}
			
			
			if (element is IVisualElementContainer) {
				var visualContainer:IVisualElementContainer = IVisualElementContainer(element);
				var numberOfElements:int = visualContainer.numElements;
				
				for (var i:int;i<numberOfElements;i++) {
					childElement = visualContainer.getElementAt(i);
					item = new ComponentDescription(childElement);
					item.parent = parentItem;
					
					parentItem.children.addItem(item);
					
					// check for IVisualElement
					if (childElement is IVisualElementContainer && IVisualElementContainer(childElement).numElements>0) {
						item.children = new ArrayCollection();
						getDisplayList(childElement, item, depth + 1);
					}
					
					
				}
			}
			
			return parentItem;
		}
		
		/**
		 * Gets the component tree list starting at the given element. 
		 * application as IVisualElement
		 * 
		 Usage:
<pre>
var rootComponent:ComponentDescriptor = getComponentDisplayList(FlexGlobals.topLevelApplication);
		 
trace(ObjectUtil.toString(rootComponent));
</pre>
		 * 		 
		 * */
		public static function getComponentDisplayList2(element:Object, parentItem:ComponentDescription = null, depth:int = 0, dictionary:Dictionary = null):ComponentDescription {
			var item:ComponentDescription;
			var childElement:IVisualElement;
			
			
			if (!parentItem) {
				if (dictionary && dictionary[element]) {
					parentItem = dictionary[element];
				}
				else {
					parentItem = new ComponentDescription(element);
				}
				
				// reset the children bc could be different
				parentItem.children = new ArrayCollection();
				
				return getComponentDisplayList2(element, parentItem, depth++, dictionary);
			}
			
			
			if (element is IVisualElementContainer) {
				var visualContainer:IVisualElementContainer = IVisualElementContainer(element);
				var numberOfElements:int = visualContainer.numElements;
				
				if (parentItem.children) {
					//parentItem.children.removeAll(); // reseting above
				}
				
				for (var i:int;i<numberOfElements;i++) {
					childElement = visualContainer.getElementAt(i);
						
					if (dictionary && dictionary[childElement]) {
						item = dictionary[childElement];
					}
					else {
						item = new ComponentDescription(childElement);
					}
					
					if (item.children) {
						item.children.removeAll(); // removing old references
					}
					
					// parent may be new - set parent here
					item.parent = parentItem;
					
					parentItem.children.addItem(item);
					
					// check for IVisualElement
					if (childElement is IVisualElementContainer && IVisualElementContainer(childElement).numElements>0) {
						!item.children ? item.children = new ArrayCollection() : void;
						getComponentDisplayList2(childElement, item, depth++, dictionary);
					}
					
					
				}
			}
			
			return parentItem;
		}
		
		/**
		 * Finds the target component in the component tree
		 * returns ComponentDescription where instance is the target
		 * 
		 * Note: the component tree is created by getComponentDisplayList();
		 * parentItem could be the root component tree object
		 * */
		public static function getTargetInComponentDisplayList(target:Object, parentItem:ComponentDescription, depth:int = 0):ComponentDescription {
			var numberOfChildren:int = parentItem.children ? parentItem.children.length : 0;
			var possibleItem:ComponentDescription;
			var itemFound:Boolean;
			var itemInstance:Object;
			var invalidatingSprite:Boolean = target as InvalidatingSprite;
			var item:ComponentDescription;
			
			if (target==parentItem.instance) {
				return parentItem;
			}
			
			for (var i:int; i < numberOfChildren; i++) {
				item = parentItem.children.getItemAt(i) as ComponentDescription;
				itemInstance = item ? item.instance : null;
				
				
				if (itemInstance) {
					if (itemInstance==target) {
						itemFound = true;
						break;
					}
					else if (itemInstance is GraphicElement && GraphicElement(itemInstance).displayObject==target) {
						itemFound = true;
						break;
					}
				}
				
				if (item.children) {
					possibleItem = getTargetInComponentDisplayList(target, item, depth + 1);
					
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
		 * Method to walk down into visual element tree and run a function on each element.<br/><br/>
		 * 
		 Usage:<br/>
		 <pre>
		 DisplayObjectUtils.walkDownTree(application as IVisualElement, traceTree);
		 
		 public function traceTree(element:Object):void {
		 	trace("element="+NameUtil.getUnqualifiedClassName(element));
		 }
		 
		 // trace
		 element=Application
		 element=Group
		 element=Button1
		 element=Button2
		 </pre>
		 * 
		 * */
		public static function walkDownTree(element:IVisualElement, proc:Function, includeSkinnable:Boolean = false):void {
			var visualContainer:IVisualElementContainer;
			var skin:Skin;
			
			proc(element);
			
			if (element is IVisualElementContainer) {
				visualContainer = IVisualElementContainer(element);
				
				for (var i:int = 0; i < visualContainer.numElements; i++) {
					walkDownTree(visualContainer.getElementAt(i), proc);
				}
			}
			else if (includeSkinnable && element is SkinnableComponent)	{
				skin = SkinnableComponent(element).skin as Skin;
				walkLayoutTree(skin, proc);
			}
			
		}
		/**
		 * Method to walk down into display list and run a function on each display object.<br/><br/>
		 * 
		 Usage:<br/>
		 <pre>
		 DisplayObjectUtils.walkDownTree(application as IVisualElement, traceTree);
		 
		 public function traceTree(element:Object):void {
		 trace("element="+NameUtil.getUnqualifiedClassName(element));
		 }
		 
		 // trace
		 element=Application
		 element=Group
		 element=Button1
		 element=Button2
		 </pre>
		 * 
		 * */
		public static function walkDownDisplayList(element:DisplayObject, procedure:Function, includeSkinnable:Boolean = false):void {
			var visualElementContainer:IVisualElementContainer;
			var displayObjectContainer:DisplayObjectContainer;
			var skin:Skin;
			
			if (element) {
				procedure(element);
			}
			
			if (element is DisplayObjectContainer) {
				visualElementContainer = element as IVisualElementContainer;
				displayObjectContainer = element as DisplayObjectContainer;
				
				
				if (displayObjectContainer) {
					for (var i:int = 0; i < displayObjectContainer.numChildren; i++) {
						walkDownDisplayList(displayObjectContainer.getChildAt(i), procedure);
					}
				}
				
				
				if (visualElementContainer) {
					for (i = 0; i < visualElementContainer.numElements; i++) {
						walkDownDisplayList(visualElementContainer.getElementAt(i) as DisplayObject, procedure);
					}
				}
			}
			else if (includeSkinnable && element is SkinnableComponent)	{
				skin = SkinnableComponent(element).skin as Skin;
				if (skin) {
					walkDownDisplayList(skin, procedure);
				}
			}
			
		}
		
		/**
		 * Method to walk down into visual element and skinnable container tree and run a function on each element
		 * Doesn't show depth but could.
		
		Usage:
		
		DisplayObjectUtils.walkLayoutTree(application as IVisualElement, traceTree);
		
		public function traceTree(element:Object):void {
		trace("element="+NameUtil.getUnqualifiedClassName(element));
		}
		
		// trace
		element=Application
		element=SkinnableComponent
		element=Button1
		element=Button2
		element=Group
		 * 
		 * */
		public static function walkLayoutTree(element:IVisualElement, proc:Function):void {
			proc(element);
			
			if (element is SkinnableComponent) {
				var skin:Skin = SkinnableComponent(element).skin as Skin;
				walkLayoutTree(skin, proc);
			}
			else if (element is IVisualElementContainer) {
				var visualContainer:IVisualElementContainer = IVisualElementContainer(element);
				
				for (var i:int = 0; i < visualContainer.numElements; i++)
				{
					walkLayoutTree(visualContainer.getElementAt(i), proc);
				}
			}
			// expand this to MX and IRawChildrenContainer?
		}
		
		/**
		 * Method to walk down component tree and run a function. 
		 * Pass in an object, not a primitive to keep a reference to it. 
		
		Usage:
<pre>
var object:Object = {};
object.count = 1;
DisplayObjectUtils.walkDownComponentTree(componentDescription, traceTree, object);

public function traceTree(description:ComponentDescription, object:Object):void {
    object.count = int(object.count) + 1;
	trace("component " + object.count + " = " + component.name);
}
</pre>
		 * 
		// trace
		element 1 = Application
		element 2 = SkinnableComponent
		element 3 = Button1
		element 4 = Button2
		element 5 = Group
		 * 
		 * */
		public static function walkDownComponentTree(componentDescription:ComponentDescription, method:Function, args:Array = null):* {
			var numberOfChildren:int;
			var newArgs:Array;
			var returnValue:*;
			
			if (args) {
				newArgs = [componentDescription].concat(args);
				returnValue = method.apply(method, newArgs);
			}
			else {
				returnValue = method(componentDescription);
			}
			
			numberOfChildren = componentDescription.children ? componentDescription.children.length :0;
			
			
			for (var i:int = 0; i < numberOfChildren; i++) {
				walkDownComponentTree(ComponentDescription(componentDescription.children.getItemAt(i)), method, args);
			}
			
			return returnValue;
		}
		
		/**
		 * Gumbo sdk methods to walk up tree (via owner) from current element and run a function on each element
		 * Does not take into account if owner is part of the component tree
		  
		 Usage:
		 DisplayObjectUtils.walkUpTree(element as IVisualElement, traceTree);
		 
		 public function traceTree(element:Object):void {
		 	trace("element="+NameUtil.getUnqualifiedClassName(element));
		 }
		 
		 * */
		public static function walkUpTree(element:IVisualElement, proc:Function):void {
			while (element!= null) {
				proc(element);
				element = element.owner as IVisualElement;
			}
		}
		
		/**
		 * Walks up the visual element display list (via parent) from current element and run a function on each element
		 * Does not take into account if parent is part of the component tree??
		 
		 Usage:
		 DisplayObjectUtils.walkUpLayoutTree(element as IVisualElement, traceTree);
		 
		 public function traceTree(element:Object):void {
		 	trace("element="+NameUtil.getUnqualifiedClassName(element));
		 }
		 
		 * */
		public static function walkUpLayoutTree(element:IVisualElement, proc:Function):void {
			
			while (element != null) {
				proc(element);
				element = element.parent as IVisualElement;
			}
		}
		
		/**
		 * Find the class type that contains the display object 
		 * */
		public static function getTypeFromDisplayObject(displayObject:DisplayObject, classReference:Class):* {
			
			while (displayObject) {
				
				if (displayObject is classReference) {
					return displayObject;
				}
				else {
					displayObject = displayObject.parent;
				}
			}
			
			return displayObject;
		}
		
		/**
		 * Find the component that contains the display object 
		 * AND is also on the component tree
		 * */
		public static function getComponentFromDisplayObject(displayObject:DisplayObject, componentTree:ComponentDescription):ComponentDescription {
			var componentDescription:ComponentDescription;
			
			// find the owner of a visual element that is also on the component tree
			while (displayObject) {
				componentDescription = getTargetInComponentDisplayList(displayObject, componentTree);
				
				if (componentDescription) {
					return componentDescription;
				}
				else {
					if ("owner" in displayObject) { // is IUIComponent
						// using Object because of RichEditableText is not IUIComponent
						// displayObject = IUIComponent(displayObject).owner as DisplayObjectContainer;
						displayObject = Object(displayObject).owner as DisplayObjectContainer;
					}
					else {
						displayObject = displayObject.parent;
					}
				}
			}
			
			return componentDescription;
		}
		
		/**
		 * Finds the component that contains the given visual element AND is also on the component tree
		 * */
		public static function getComponentFromElement(element:IVisualElement, componentTree:ComponentDescription):ComponentDescription {
			var componentDescription:ComponentDescription;
			
			// find the owner of a visual element that is also on the component tree
			while (element) {
				componentDescription = getTargetInComponentDisplayList(element, componentTree);
				
				if (componentDescription) {
					return componentDescription;
				}
				else {
					if ("owner" in element) {
						element = element.owner as IVisualElement;
					}
					else {
						element = null;
					}
				}
			}
			
			return componentDescription;
		}
		
		/**
		 * Find the group that contains the given visual element and that is also on the component tree
		 * */
		public static function getGroupFromElement(element:IVisualElement, componentTree:ComponentDescription):ComponentDescription {
			var componentDescription:ComponentDescription;
			
			// find the owner of a visual element that is also on the component tree
			while (element) {
				componentDescription = getTargetInComponentDisplayList(element, componentTree);
				
				if (componentDescription && element is GroupBase) {
					return componentDescription;
				}
				else {
					if ("owner" in element) {
						element = element.owner as IVisualElement;
					}
					else {
						element = null;
					}
				}
			}
			
			return componentDescription;
		}
		
		/**
		 * Find the visual element container of the given visual element and that is also on the component tree
		 * */
		public static function getVisualElementContainerFromElement(element:IVisualElement, componentTree:ComponentDescription):ComponentDescription {
			var componentDescription:ComponentDescription;
			
			// find the owner of a visual element that is also on the component tree
			while (element) {
				componentDescription = getTargetInComponentDisplayList(element, componentTree);
				
				if (componentDescription && element is IVisualElementContainer) {
					return componentDescription;
				}
				else {
					if ("owner" in element) {
						element = element.owner as IVisualElement;
					}
					else {
						element = null;
					}
				}
			}
			
			return componentDescription;
		}
		
		/**
		 * Find the path of a visual element that is on the component tree
		 * Usage:
		 * var ancestorVisualElement:ComponentDescription = Tree(owner).dataProvider.getItemAt(0) as ComponentDescription;
		 * getVisualElementPath(myButton, getDisplayList(ancestorVisualElement)); // [button(myButton),group,hgroup,ancestorVisualElement]
		 * */
		public static function getVisualElementPath(element:IVisualElement, componentTree:ComponentDescription, reverseOrder:Boolean = false):String {
			var componentDescription:ComponentDescription;
			var path:Array = [];
			
			// find the owner of a visual element that is also on the component tree
			while (element) {
				componentDescription = getTargetInComponentDisplayList(element, componentTree);
				
				// get name
				if (componentDescription && element is IVisualElementContainer) {
					path.push(componentDescription.className);
				}
				
				// get next ancestor
				if ("owner" in element) {
					element = element.owner as IVisualElement;
				}
				else {
					element = null;
				}
			}
			
			return reverseOrder ? path.reverse().join(".") : path.join(".");
		}
		
		/**
		 * Find the greatest visibility state of a visual element that is on the component tree
		 * 
		 * Usage:
		 * var rootApplicationDescription:ComponentDescription = DisplayObjectUtils.getDisplayList(application);//Tree(owner).dataProvider.getItemAt(0) as ComponentDescription;
		 * var visibility:Boolean = DisplayObjectUtils.getGreatestVisibility(IVisualElement(item.instance), rootApplicationDescription); 
		 * */
		public static function getGreatestVisibility(element:IVisualElement, componentTree:ComponentDescription):Boolean {
			var componentDescription:ComponentDescription;
			var path:Array = [];
			var visible:Boolean;
			
			// find the owner of a visual element that is also on the component tree
			while (element) {
				componentDescription = getTargetInComponentDisplayList(element, componentTree);
				
				// get name
				if (componentDescription) {
					visible = element.visible;
					path.push(visible);
				}
				
				// get next ancestor
				if ("owner" in element) {
					element = element.owner as IVisualElement;
				}
				else {
					element = null;
				}
			}
			
			return path.indexOf(false)!=-1 ? false : true;
		}
		
		/**
		 * Find the greatest visibility state of a visual element. It tells you 
		 * if the display object is visible, at least programmatically. <br><br>
		 * 
		 * Usage:
<pre>
var isVisible:Boolean = DisplayObjectUtils.getGreatestVisibility(IVisualElement(item.instance));
</pre> 
		 * */
		public static function getGreatestVisibilityDisplayList(element:IVisualElement):Boolean {
			var componentDescription:ComponentDescription;
			var path:Array = [];
			var visible:Boolean;
			
			// find the owner of a visual element that is also on the component tree
			while (element) {
				
				if (element) {
					visible = element.visible;
					path.push(visible);
				}
				
				// get next ancestor
				if ("owner" in element) {
					element = element.owner as IVisualElement;
				}
				else {
					element = null;
				}
			}
			
			return path.indexOf(false)!=-1 ? false : true;
		}
		
		/**
		 * Walk down into the component tree target and set the parentVisible flag.<br/>
		 * 
		 * Usage:
		 *  DisplayObjectUtils.setVisibilityFlag(component, false);
		 * 
		 * */
		public static function setVisibilityFlag(component:ComponentDescription, visible:Boolean = false):void {
			var numberOfChildren:int = component.children ? component.children.length : 0;
			var item:ComponentDescription;
			
			for (var i:int; i < numberOfChildren; i++) {
				item = component.children.getItemAt(i) as ComponentDescription;
				
				if (item) {
					item.parentVisible = visible;
				}
				
				if (item.children && item.children.length) {
					setVisibilityFlag(item, visible);
				}
				
			}
			
		}
		
		/**
		 * Adds listeners to groups on the display list so drag operations work
		 * when over transparent areas
		 * */
		public static function enableDragBehaviorOnDisplayList(element:IVisualElement, enableDragBehavior:Boolean = true, applicationGroups:Dictionary = null):Dictionary {
			var groupOptions:GroupOptions;
			var group:GroupBase;
			
			if (!applicationGroups && enableDragBehavior) applicationGroups = new Dictionary();
			
			if (element is GroupBase) {
				group = GroupBase(element);
				
				// add drag supporting behavior
				if (enableDragBehavior) {
					addGroupMouseSupport(group, applicationGroups);
				}
				else {
					// disable drag supporting behavior
					removeGroupMouseSupport(group, applicationGroups);
				}
			}
			
			if (element is IVisualElementContainer) {
				var visualContainer:IVisualElementContainer = IVisualElementContainer(element);
				var numberOfElements:int = visualContainer.numElements;
				
				for (var i:int;i<numberOfElements;i++) {
					enableDragBehaviorOnDisplayList(visualContainer.getElementAt(i), enableDragBehavior, applicationGroups);
				}
			}
			
			return applicationGroups;
		}
		
		
		//----------------------------------
		//
		// DISPLAY SIZING METHODS
		//
		//----------------------------------
		
		//----------------------------------
		//  splashScreenScaleMode
		//----------------------------------
		
		[Inspectable(enumeration="none,letterbox,stretch,zoom", defaultValue="none")]
		
		/**
		 *  The image scale mode:
		 *  
		 *  <ul>
		 *      <li>A value of <code>none</code> implies that the image size is set 
		 *      to match its intrinsic size.</li>
		 *
		 *      <li>A value of <code>stretch</code> sets the width and the height of the image to the
		 *      stage width and height, possibly changing the content aspect ratio.</li>
		 *
		 *      <li>A value of <code>letterbox</code> sets the width and height of the image 
		 *      as close to the stage width and height as possible while maintaining aspect ratio.  
		 *      The image is stretched to a maximum of the stage bounds,
		 *      with spacing added inside the stage to maintain the aspect ratio if necessary.</li>
		 *
		 *      <li>A value of <code>zoom</code> is similar to <code>letterbox</code>, except 
		 *      that <code>zoom</code> stretches the image past the bounds of the stage, 
		 *      to remove the spacing required to maintain aspect ratio.
		 *      This setting has the effect of using the entire bounds of the stage, but also 
		 *      possibly cropping some of the image.</li>
		 *  </ul>
		 * 
		 * */
		public static function getSizeByScaleMode(maxWidth:int, maxHeight:int, 
												  width:int, height:int, 
												  scaleMode:String="letterbox",
												  dpi:Number=NaN):Matrix 
		{
			
			var aspectRatio:String = (maxWidth < maxHeight) ? "portrait" : "landscape";
			var orientation:String = aspectRatio;
			
			// Current stage orientation
			//var orientation:String = stage.orientation;
			
			// DPI scaling factor of the stage
			//var dpiScale:Number = this.root.scaleX;
			
			// Start building a matrix
			var m:Matrix = new Matrix();
			
			// Stretch
			var scaleX:Number = 1;
			var scaleY:Number = 1;
			
			switch(scaleMode) {
				case "zoom":
					scaleX = Math.max( maxWidth / width, maxHeight / height);
					scaleY = scaleX;
					break;
				
				case "letterbox":
					scaleX = Math.min( maxWidth / width, maxHeight / height);
					scaleY = scaleX;
					break;
				
				case "stretch":
					scaleX = maxWidth / width;
					scaleY = maxHeight / height;
					break;
			}
			
			// what does this do
			if (scaleX != 1 || scaleY != 0)
			{
				width *= scaleX;
				height *= scaleY;
				m.scale(scaleX, scaleY);
			}
			
			
			// Move center to (0,0):
			m.translate(-width / 2, -height / 2);
			
			// Align center of image (0,0) to center of stage: 
			m.translate(maxWidth / 2, maxHeight / 2);
			
			// Apply matrix
			// splashImage.transform.matrix = m;
			
			return m;
		}
		
		/**
		 * Set display object to scale
		 * */
		public static function getScale(maxWidth:int, maxHeight:int,
										width:int, height:int,
										scaleMode:String="letterbox",
										dpi:Number=NaN):Matrix 
		{
			
			var aspectRatio:String = (maxWidth < maxHeight) ? "portrait" : "landscape";
			var orientation:String = aspectRatio;
			
			// Current stage orientation
			//var orientation:String = stage.orientation;
			
			// DPI scaling factor of the stage
			//var dpiScale:Number = this.root.scaleX;
			
			// Start building a matrix
			var m:Matrix = new Matrix();
			
			// Stretch
			var scaleX:Number = 1;
			var scaleY:Number = 1;
			
			switch(scaleMode) {
				case "zoom":
					scaleX = Math.max( maxWidth / width, maxHeight / height);
					scaleY = scaleX;
					break;
				
				case "letterbox":
					scaleX = Math.min( maxWidth / width, maxHeight / height);
					scaleY = scaleX;
					break;
				
				case "stretch":
					scaleX = maxWidth / width;
					scaleY = maxHeight / height;
					break;
			}
			
			// what does this do
			if (scaleX != 1 || scaleY != 0)
			{
				width *= scaleX;
				height *= scaleY;
				m.scale(scaleX, scaleY);
			}
			
			
			// Move center to (0,0):
			m.translate(-width / 2, -height / 2);
			
			// Align center of image (0,0) to center of stage: 
			m.translate(maxWidth / 2, maxHeight / 2);
			
			// Apply matrix
			// splashImage.transform.matrix = m;
			
			return m;
		}
		
		
		/**
		 *  Scales the display object to the new width and height.
		 * 
		 *  The image scale mode:
		 *  
		 *  <ul>
		 *      <li>A value of <code>none</code> implies that the image size is set 
		 *      to match its intrinsic size.</li>
		 *
		 *      <li>A value of <code>stretch</code> sets the width and the height of the image to the
		 *      stage width and height, possibly changing the content aspect ratio.</li>
		 *
		 *      <li>A value of <code>letterbox</code> sets the width and height of the image 
		 *      as close to the stage width and height as possible while maintaining aspect ratio.  
		 *      The image is stretched to a maximum of the stage bounds,
		 *      with spacing added inside the stage to maintain the aspect ratio if necessary.</li>
		 *
		 *      <li>A value of <code>zoom</code> is similar to <code>letterbox</code>, except 
		 *      that <code>zoom</code> stretches the image past the bounds of the stage, 
		 *      to remove the spacing required to maintain aspect ratio.
		 *      This setting has the effect of using the entire bounds of the stage, but also 
		 *      possibly cropping some of the image.</li>
		 *  </ul>
		 * 
		 * */
		public static function scaleDisplayObject(displayObject:DisplayObject,
												  newWidth:Number, 
												  newHeight:Number,
												  scaleMode:String="letterbox",
												  position:String="center",
												  dpi:Number=NaN):Boolean 
		{
			
			
			// DPI scaling factor of the stage
			var dpiScale:Number = 1;// = this.root.scaleX;
			
			// Get container dimensions at default orientation
			var maxWidth:Number = dpiScale ? newWidth / dpiScale : newWidth;
			var maxHeight:Number = dpiScale ? newHeight / dpiScale : newHeight;
			
			// The image dimensions
			var width:Number = displayObject.width;
			var height:Number = displayObject.height;
			
			// Start building a matrix
			var matrix:Matrix = new Matrix();
			
			// Stretch
			var scaleX:Number = 1;
			var scaleY:Number = 1;
			
			switch(scaleMode) {
				case "zoom":
					scaleX = Math.max( maxWidth / width, maxHeight / height);
					scaleY = scaleX;
					break;
				
				case "letterbox":
					scaleX = Math.min( maxWidth / width, maxHeight / height);
					scaleY = scaleX;
					break;
				
				case "stretch":
					scaleX = maxWidth / width;
					scaleY = maxHeight / height;
					break;
			}
			
			// what does this do
			// for zoom?
			if (scaleX != 1 || scaleY != 0) {
				width *= scaleX;
				height *= scaleY;
				matrix.scale(scaleX, scaleY);
			}
			
			
			// Move center to (0,0):
			if (position=="center") {
				matrix.translate(-width / 2, -height / 2);
				
				// Align center of image (0,0) to center of stage: 
				matrix.translate(maxWidth / 2, maxHeight / 2);
			}
			
			// Apply matrix
			displayObject.transform.matrix = matrix;
			
			return true;
		}
		
		/**
		 * Add mouse listener and set mouse enabled where transparent to true to so that we
		 * can listen to mouse events for drag over and drag and drop events. 
		 * Group ignores mouse events by default since it has no background or border. 
		 * */
		public static function addGroupMouseSupport(group:GroupBase, groupsDictionary:Dictionary = null):void {
			//trace("adding group mouse support" + ClassUtils.getIdentifierNameOrClass(group));
			if (!groupsDictionary) groupsDictionary = applicationGroups;
			groupsDictionary[group] = new GroupOptions(group.mouseEnabledWhereTransparent);
			// there's got to be a better way to do this
			//if (!group.hasEventListener(MouseEvent.MOUSE_OUT)) {
				group.addEventListener(MouseEvent.MOUSE_OUT, enableGroupMouseHandler, false, 0, true);
			//}
			group.mouseEnabledWhereTransparent = true;
		}
		
		/**
		 * Remove the mouse listener and restore mouseEnabledWhereTransparent value to group. 
		 * */
		public static function removeGroupMouseSupport(group:GroupBase, groupsDictionary:Dictionary = null):void {
			if (!groupsDictionary) groupsDictionary = applicationGroups;
			//TypeError: Error #1010: A term is undefined and has no properties. (applicationGroups)
			if (group in groupsDictionary) {
				group.mouseEnabledWhereTransparent = groupsDictionary[group].mouseEnabledWhereTransparent;
				
				// if mouse is enabled don't we need to keep the mouse handler on it?
				group.removeEventListener(MouseEvent.MOUSE_OUT, enableGroupMouseHandler);
				//trace("mouse handler removed on " + ClassUtils.getIdentifierNameOrClass(group));
				groupsDictionary[group] = null;
				delete groupsDictionary[group];
			}
		}
		
		/**
		 * Handler for mouse events on groups. Group needs mouse event listener to track mouse
		 * events over it. This is the handler we add to the group. It does nothing. 
		 * */
		public static function enableGroupMouseHandler(event:MouseEvent):void
		{
			// this is used to enable mouse events where transparent 
			//trace("display object utils. mouse over group");
		}
		
		
		/**
		 * Get red value from uint
		 * */
		public static function extractRed(color:uint):uint {
			return (( color >> 16 ) & 0xFF);
		}
		
		/**
		 * Get green value from uint
		 * */
		public static function extractGreen(color:uint):uint {
			return ((color >> 8) & 0xFF);
		}
		
		/**
		 * Get blue value from uint
		 * */
		public static function extractBlue(color:uint):uint {
			return (color & 0xFF);
		}
		
		/**
		 * Get combined RGB value
		 * */
		public static function combineRGB(red:uint, green:uint, blue:uint):uint {
			return (( red << 16) | (green << 8) | blue);
		}
		
		/**
		 * Get color value in hex value format
		 * 
<pre>
var color:String = getColorInHex(255, true);
trace(color); // #ff0000
</pre>
		 * 
		 **/
		public static function getColorInHex(color:uint, addHash:Boolean = false, addPrefix:Boolean = false):String {
			var red:String = extractRed(color).toString(16).toUpperCase();
			var green:String = extractGreen(color).toString(16).toUpperCase();
			var blue:String = extractBlue(color).toString(16).toUpperCase();
			var value:String = "";
			var zero:String = "0";
			
			if (red.length==1) {
				red = zero.concat(red);
			}
			
			if (green.length==1) {
				green = zero.concat(green);
			}
			
			if (blue.length==1) {
				blue = zero.concat(blue);
			}
			
			if (addHash) {
				value = "#" + red + green + blue;
			}
			else if (addPrefix) {
				value = "0x" + red + green + blue;
			}
			else {
				value = red + green + blue;
			}
			
			return value;
		}
		
		public static function getColorInHexWithHash(color:uint):String {
			
			return getColorInHex(color, true);
		}
		
		/**
		 * Get color value in RGB.
		 * 
<pre>
var result:String = getColorInRGB(256);
trace(result); // rgb(255, 0, 0);
  
var result:String = getColorInRGB(256, .3);
trace(result); // rgba(255, 0, 0, 0.3);
</pre>
		 **/
		public static function getColorInRGB(color:uint, alpha:Number = NaN):String {
			var red:uint = extractRed(color);
			var green:uint = extractGreen(color);
			var blue:uint = extractBlue(color);
			var value:String = "";
			
			if (isNaN(alpha)) {
				value = "rgb("+red+","+green+","+blue+")";
			}
			else {
				value = "rgba("+red+","+green+","+blue+","+alpha+")";
			}
			
			return value;
		}
		
		/**
		 * Gets the color as type from uint. 
		 * */
		public static function getColorAsType(color:uint, type:String):Object {
			
			// #FF0000
			if (type==HEXIDECIMAL_HASH_COLOR_TYPE) {
				return getColorInHex(color, true);
			} // 0xFF0000
			else if (type==HEXIDECIMAL_PREFIX_COLOR_TYPE) {
				return getColorInHex(color, false, true);
			} // FF0000
			else if (type==HEXIDECIMAL_COLOR_TYPE) {
				return getColorInHex(color, false, false);
			} // "255"
			else if (type==STRING_UINT_COLOR_TYPE) {
				return String(color);
			} // 255
			else if (type==NUMBER_COLOR_TYPE) {
				return Number(color);
			} // 255
			else if (type==UINT_COLOR_TYPE) {
				return uint(color);
			} // 255
			else if (type==INT_COLOR_TYPE) {
				return int(color);
			}
			
			return color;
		}
		
		/**
		 * Gets the color as uint. Converts "#FFFFFF" to "0xFFFFFF" and then casts 
		 * it to a uint.
		 * */
		public static function getColorAsUInt(color:String, moduleFactory:IFlexModuleFactory = null):uint {
			var number:Number;
			
			if (color.charAt(0) == "#") {
				// Map "#77EE11" to 0x77EE11
				number = Number("0x" + color.slice(1));
				return isNaN(number) ? StyleManager.NOT_A_COLOR : uint(number);
			}
			
			if (color.charAt(1) == "x" && color.charAt(0) == "0") {
				number = Number(color);
				return isNaN(number) ? StyleManager.NOT_A_COLOR : uint(number);
			}
			
			number = StyleManager.getStyleManager(moduleFactory).getColorName(color);
			
			return isNaN(number) ? StyleManager.NOT_A_COLOR : uint(number);
			
		}
		
		
		/**
		 * Gets the color under the mouse pointer.
		 *  
		 * Returns the error if taking bitmap screen shot results in a security violation.
		 * For example, if an image is from another domain and we are in Flash Player
		 * security sandbox it will return an error. You should set Security.allowDomain()
		 * I think to get around it or checkSecurityPolicy to false. I don't know. 
		 * */
		public static function getColorUnderMouse(event:MouseEvent):Object {
			var eyeDropperColorValue:uint;
			var screenshot:BitmapData;
			var output:String = "";
			var stageX:Number;
			var stageY:Number;
			var value:String;
			var scale:Number;
			
			screenshot = new BitmapData(FlexGlobals.topLevelApplication.width, FlexGlobals.topLevelApplication.height, false);
			
			try {
				drawBitmapData(screenshot, DisplayObject(FlexGlobals.topLevelApplication));
			}
			catch (error:Error) {
				// could not draw it possibly because of security sandbox 
				// so we return null
				return error;
			}
	
			scale = FlexGlobals.topLevelApplication.applicationDPI / FlexGlobals.topLevelApplication.runtimeDPI;
			stageX = event.stageX * scale;
			stageY = event.stageY * scale;
		
			eyeDropperColorValue = screenshot.getPixel(stageX, stageY);
			
			return eyeDropperColorValue;
			
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
		 * Gets visual elements by their type. 
		 * 
		 * For example, gets all the Buttons or Images when 
		 * that type is passed in. You can pass in an existing array of objects to add to
		 * */
		public static function getElementsByType(container:IVisualElementContainer, type:Class, elements:Array = null):Array {
			if (elements==null) elements = [];
			
			for (var i:int;i<container.numElements;i++) {
				var element:IVisualElement = container.getElementAt(i);
				
				if (element is type) {
					elements.push(element);
				}
				if (element is IVisualElementContainer) {
					getElementsByType(element as IVisualElementContainer, type, elements);
				}
			}
			
			return elements;
		}
		
		
		/**
		 * Get data URI from object. 
		 * 
		 * Returns a string "data:image/png;base64,..." where ... is the image data. 
		 * @see #getBase64ImageData()
		 * */
		public static function getBase64ImageDataString(target:Object, type:String = PNG, encoderOptions:Object = null, ignoreErrors:Boolean = false, color:Number = NaN, alpha:Number = 1, linebreaks:Boolean = false):String {
			var hasJPEGEncoderOptions:Boolean = ClassUtils.hasDefinition("flash.display.JPEGEncoderOptions");
			var hasPNGEncoderOptions:Boolean = ClassUtils.hasDefinition("flash.display.PNGEncoderOptions");
			var output:String;
			var message:String;
			
			if (!encoderOptions && !hasJPEGEncoderOptions && !hasPNGEncoderOptions && ignoreErrors==false) {
				message = "Your project must include a reference to the flash.display.JPEGEncoderOptions or ";
				message += "flash.display.PNGEncoderOptions in your project for this call to work. ";
				message += "You may also need an newer version of Flash Player or AIR or set -swf-version equal to 16 or greater. ";
				throw new Error(message);
			}
			
			if (type==null || type=="") {
				type = PNG;
			}
			else if (type.toLowerCase()==JPG) {
				type = JPEG;
			}
			
			// you have to be careful, if line breaks occur, the image data will not show
			if (hasJPEGEncoderOptions || hasPNGEncoderOptions) {
				output = "data:image/" + type + ";base64," + getBase64ImageData(target, type, encoderOptions, false, 80, color, alpha, linebreaks);
			}
			else {
				output = "data:image/" + type + ";base64," + "";
			}
			
			
			return output;
		}
		
		
		/**
		 * Returns base64 image string. This function may be doing too much. 
		 * 
		 * Encoding to JPG took 2000ms in some cases where PNG took 200ms.
		 * I have not extensively tested this but it seems to be 10x faster
		 * than JPG. 
		 * 
		 * Performance: 
		 * get snapshot. time=14
		 * encode to png. time=336 // encode to jpg. time=2000
		 * encode to base 64. time=35
		 * 
		 * Don't trust these numbers. Test it yourself. First runs are always longer than previous. 
		 * 
		 * @see #getBase64ImageDataString()
		 * */
		public static function getBase64ImageData(target:Object, type:String = PNG, encoderOptions:Object = null, checkCache:Boolean = false, quality:int = 80, color:Number = NaN, alpha:Number = 1, linebreaks:Boolean = false):String {
			var component:IUIComponent = target as IUIComponent;
			var bitmapData:BitmapData;
			var byteArray:ByteArray;
			var useEncoder:Boolean;
			var rectangle:Rectangle;
			var fastCompression:Boolean = true;
			var timeEvents:Boolean = false;
			var altBase64:Boolean = false;
			var base64Data:String;
			var colorTransform:ColorTransform;
			var tintType2:Boolean = true;
			var time:int;
			
			
			if (checkCache && base64BitmapCache[target]) {
				return base64BitmapCache[target];
			}
			
			if (timeEvents) {
				time = getTimer();
			}
			
			if (component) {
				bitmapData = getUIComponentBitmapData(component);
			}
			else if (target is DisplayObject) {
				bitmapData = getBitmapDataSnapshot2(target as DisplayObject);
			}
			else if (target is BitmapData) {
				bitmapData = target as BitmapData;
			}
			else if (target is GraphicElement) {
				//bitmapData = getGraphicElementBitmapData(target as IGraphicElement);
				//bitmapData = rasterize2(GraphicElement(target).displayObject);
				bitmapData = getBitmapDataSnapshot2(GraphicElement(target).displayObject);
			}
			else {
				throw Error("Target is null. Target must be a display object.");
			}
			
			if (!isNaN(color)) {
				rectangle = new Rectangle(0, 0, bitmapData.width, bitmapData.height);
				
				if (tintType2) {
					colorTransform = new ColorTransform(color >> 16 & 0x0000FF / 255, color >> 8 & 0x0000FF / 255, color & 0x0000FF / 255);
				}
				else  {
					colorTransform = new ColorTransform();
					colorTransform.color = color;
				}
				
				colorTransform.alphaMultiplier = alpha;
				bitmapData.colorTransform(rectangle, colorTransform);
			}
			
			if (timeEvents) {
				trace ("get snapshot. time=" + (getTimer()-time));
				time = getTimer();
			}
			
			byteArray = getByteArrayFromBitmapData(bitmapData, null, useEncoder, type, fastCompression, quality, encoderOptions);
			
			if (timeEvents) {
				trace ("encode to " + type + ". time=" + (getTimer()-time));
				time = getTimer();
			}
			
			base64Data = getBase64FromByteArray(byteArray, altBase64, linebreaks);
			//trace(base64.toString());
			
			if (timeEvents) {
				trace ("encode to base 64. time=" + (getTimer()-time));
			}
			
			checkCache ? base64BitmapCache[target] = base64Data : void;
			
			return base64Data;
		}
		
		/**
		 * Returns a byte array from bitmap data
		 * 
		 * @param alternativeEncoder Set the static Base64Encoder2 property to an alternative encoder before calling this.
		 * @see #getBitmapByteArray()
		 * @see #getBase64ImageData()
		 * @see #getBase64ImageDataString()
		 * */
		public static function getBase64FromByteArray(byteArray:ByteArray, alternativeEncoder:Boolean, insertLinebreaks:Boolean = false):String {
			var results:String;
			
			if (!alternativeEncoder) {
				if (!base64Encoder) {
					base64Encoder = new Base64Encoder();
				}
				
				base64Encoder.encodeBytes(byteArray);
				base64Encoder.insertNewLines = insertLinebreaks;
				
				results = base64Encoder.toString();
			}
			else {
				if (Base64Encoder2==null) {
					throw new Error("Set the static alternative base encoder before calling this method");
				}
				
				// Base64.encode(data:ByteArray);
				results = Base64Encoder2.encode(byteArray);
				
				
				// have to remove line breaks for background: url(datauri) to work in some environments
				if (insertLinebreaks) {
					results = results.replace(lineEndingsGlobalPattern, "");
				}
			}
			
			return results;
		}
		
		public static var removeBase64HeaderPattern:RegExp = /.*base64,/si;
		public static var lineEndingsGlobalPattern:RegExp = /\n/g;
		public static var JPEG_ENCODER_OPTIONS_CLASS_PATH:String = "flash.display.JPEGEncoderOptions";
		public static var PNG_ENCODER_OPTIONS_CLASS_PATH:String = "flash.display.PNGEncoderOptions";
		
		/**
		 * Returns a byte array from a base 64 string. Need to remove the header text, ie "data:image/png;base64,"
		 * and possibly line breaks.
		 * 
		 * @param alternativeEncoder Set the static Base64Decoder2 property to an alternative decoder before calling this.
		 * @see #getBitmapDataFromByteArray()
		 * @see #getBase64ImageData()
		 * @see #getBase64ImageDataString()
		 * */
		public static function getByteArrayFromBase64(encoded:String, alternativeDecoder:Boolean = false, removeHeader:Boolean = true, removeLinebreaks:Boolean = true):ByteArray {
			var results:ByteArray;
			
			if (!alternativeDecoder) {
				if (!base64Decoder) {
					base64Decoder = new Base64Decoder();
				}
				
				if (removeHeader) {
					encoded = encoded.replace(removeBase64HeaderPattern, "");
				}
				
				if (removeLinebreaks) {
					encoded = encoded.replace(lineEndingsGlobalPattern, "");
				}
				
				base64Decoder.reset();
				base64Decoder.decode(encoded);
				results = base64Decoder.toByteArray();
				
				// if you get the following error then try removing the header or line breaks
				//    Error: A partial block (3 of 4 bytes) was dropped. Decoded data is probably truncated!
			}
			else {
				if (Base64Decoder2==null) {
					throw new Error("Set the static alternative base decoder before calling this method");
				}
				
				if (removeHeader) {
					encoded = encoded.replace(removeBase64HeaderPattern, "");
				}
				
				if (removeLinebreaks) {
					encoded = encoded.replace(lineEndingsGlobalPattern, "");
				}
				
				Base64Decoder2.reset();
				Base64Decoder2.decode(encoded);
				results = Base64Decoder2.toByteArray();
			}
			
			/*
			Error: A partial block (3 of 4 bytes) was dropped. Decoded data is probably truncated!
			at mx.utils::Base64Decoder/flush()[/Users/justinmclean/Documents/ApacheFlex4.15/frameworks/projects/framework/src/mx/utils/Base64Decoder.as:139]
			at mx.utils::Base64Decoder/toByteArray()[/Users/justinmclean/Documents/ApacheFlex4.15/frameworks/projects/framework/src/mx/utils/Base64Decoder.as:173]
			at com.flexcapacitor.utils::DisplayObjectUtils$/getByteArrayFromBase64()[/Users/monkeypunch/Documents/ProjectsGithub/flexcapacitor/MainLibrary/src/com/flexcapacitor/utils/DisplayObjectUtils.as:1673]
			*/
			
			return results as ByteArray;
		}
		
		/**
		 * Returns a byte array from bitmap data. <br/><br/>
		 * 
		 * This byte array is in PNG or JPG format. You can then save it to the file system. 
		 * The default image type is PNG. The useEncoder is false by default. That means 
		 * it uses BitmapData.encode(). This is usually much faster than the PNG and JPG Encoder classes. 
		 * You can set the options for BitmapData.encode() with the last parameter "encoderOptions". 
		 * By passing in PNG, JPG and JPEGXR encoder options instances you'll create those types
		 * of image data files.<br/><br/>
		 *  
		 * If no type is passed in then we use byteArray = BitmapData.getPixels(clipRectangle);<br/><br/>
		 * 
		 * Create an instance of "flash.display.JPEGEncoderOptions", "flash.display.PNGEncoderOptions"
		 * or "flash.display.JPEGXREncoderOptions" and that is the type of file that will 
		 * get made (the type string is ignored when you pass in the encoderOptions). <br/><br/>
		 * 
		 * @param bitmapData BitmapData from calling getSnapshot or another image source
		 * @param rectangle The rectangle to use to clip the content. If null the bitmapData size is used.
		 * @param useEncoder If true uses PNGEncoder or JPGEncoder. If false uses bitmapData.encode(). 
		 * The bitmapData.encode() method was made available in Flash player 11.3 and AIR 3.3. 
		 * @param type The type of image data to create. It is either "png" or "jpg". The string "jpeg" is also allowed.\
		 * @param fastCompression When using bitmapData.encode() the "png" encoder allows a "fastCompression" option to be 
		 * enabled. See #BitmapData.fastCompression.
		 * @param quality When using the PNG or JPG encoder classes this specifies the quality of the image. Default is 80. 
		 * @param encoderOptions When using bitmap.encode() the method can accept a optional instance of 
		 * "flash.display.JPEGEncoderOptions" or "flash.display.PNGEncoderOptions" 
		 * @returns ByteArray returns a byte array that can be saved to the file system as a PNG or JPG
		 * 
		 * @see flash.display.BitmapData
		 * @see flash.display.BitmapData.encode()
		 * @see http://help.adobe.com/en_US/as3/dev/WS4768145595f94108-17913eb4136eaab51c7-8000.html
		 * */
		public static function getByteArrayFromBitmapData(bitmapData:BitmapData, 
												  clipRectangle:Rectangle = null, 
												  useEncoder:Boolean = false, 
												  type:String = PNG, 
												  fastCompression:Boolean = true, 
												  quality:int = 80, 
												  bitmapDataEncoderOptions:Object = null):ByteArray {
			
			var PNGEncoderOptionsClass:Object;
			var JPEGEncoderOptionsClass:Object;
			var byteArray:ByteArray;
			
			var hasJPEGEncoderOptions:Boolean = ClassUtils.hasDefinition(JPEG_ENCODER_OPTIONS_CLASS_PATH);
			var hasPNGEncoderOptions:Boolean = ClassUtils.hasDefinition(PNG_ENCODER_OPTIONS_CLASS_PATH);
			
			if (clipRectangle==null) {
				clipRectangle = new Rectangle(0, 0, bitmapData.width, bitmapData.height);
			}
			
			if (!useEncoder && !("encode" in bitmapData)) {
				throw new Error("BitmapData.encode is not available. You must be using a Flash Player 11.3 or AIR 3.3 to call this method or " +
					"use the PNG and JPG Encoder classes. Set parameter useEncoder to true to use these encoders.");
			}
			
			// if we have BitmapData.encode options use them right away and return the data
			if (bitmapDataEncoderOptions) {
				byteArray = Object(bitmapData).encode(clipRectangle, bitmapDataEncoderOptions);
				return byteArray;
			}
			
			// PNG
			if (type && type.toLowerCase()==PNG) {
				
				// using PNGEncoder
				if (useEncoder) {
					if (!pngEncoder) {
						pngEncoder = new PNGEncoder();
					}
					
					byteArray = pngEncoder.encode(bitmapData);
				}
				else {
				
				// using BitmapData.encode()
					if (!pngEncoderOptions) {
						// did you get an error here? include this class and set flash player swfversion to 19 or newer
						PNGEncoderOptionsClass = ClassUtils.getDefinition(PNG_ENCODER_OPTIONS_CLASS_PATH);
						// be sure to include this class in your project or library or else use the other encoder
						pngEncoderOptions = new PNGEncoderOptionsClass(fastCompression);
					}
					
					byteArray = Object(bitmapData).encode(clipRectangle, pngEncoderOptions);
				}
			}
			
			// JPG
			else if (type && (type.toLowerCase()==JPG || type.toLowerCase()==JPEG)) {
				
				
				// using JPGEncoder
				if (useEncoder) {
					if (!jpegEncoder) {
						jpegEncoder = new JPEGEncoder();
					}
					
					byteArray = jpegEncoder.encode(bitmapData);
				}
				else {
					
				// using BitmapData.encode()
					if (!jpegEncoderOptions) {
						// to use JPEGXR pass in an instance of JPEGXREncoderOptions class
						JPEGEncoderOptionsClass = ClassUtils.getDefinition(JPEG_ENCODER_OPTIONS_CLASS_PATH);
						jpegEncoderOptions = new JPEGEncoderOptionsClass(quality);
					}
					
					byteArray = Object(bitmapData).encode(clipRectangle, jpegEncoderOptions);
				}
			}
			else {
				// raw bitmap image data
				byteArray = bitmapData.getPixels(clipRectangle);
			}
			
			return byteArray;
		}
		
		public static var loader:Loader;
		
		/**
		 * Get bitmap data from a byte array
		 * */
		public static function getBitmapDataFromByteArray(byteArray:ByteArray, loaderContext:LoaderContext = null, size:Point = null):BitmapData {
			var PNGEncoderOptionsClass:Object;
			var bitmapData:BitmapData;
			var value:Object;
			var async:Boolean = true;
			var rectangle:Rectangle;
			var initialWidth:int = size ? size.x : 100;
			var initialHeight:int = size ? size.y : 100;
			var quality:String;
			var loaderContext:LoaderContext;
			var isPNG:Boolean;
			var isJPG:Boolean;
			
			try {
				byteArray.position = 0;
				bitmapData = new BitmapData(initialWidth,initialHeight,true,0xFFFFFFFF);
				rectangle = new Rectangle(0,0,initialWidth,initialHeight);
				//quality = StageQuality.HIGH_16X16_LINEAR;
				
				// asyncronous
				if (async) {
					/*
					loaderContext = new LoaderContext(); 
					loaderContext.imageDecodingPolicy = ImageDecodingPolicy.ON_DEMAND;
					*/
					
					loader = new Loader();
					loader.loadBytes(byteArray, loaderContext);
					
					//var stage:Object = FlexGlobals.topLevelApplication.stage;
					//	stage.addChild(loader);
					
					if (loader.content) {
						var bitmap:Bitmap;
						bitmap = loader.content as Bitmap;
						return bitmap.bitmapData;
					}
					
					// we don't need an event listener if we have the size before hand
					
					loader.contentLoaderInfo.addEventListener(Event.INIT, function (event:Event):void {
						var newBitmapData:BitmapData;
						var bitmap:Bitmap;
						var rectangle:Rectangle;
						
						if (loader.content) {
							bitmap = LoaderInfo(event.currentTarget).loader.content as Bitmap;
							newBitmapData = bitmap ? bitmap.bitmapData : null;
							
							// the bitmapData does not change size with any of these
							if (newBitmapData) {
								//rectangle = new Rectangle(0, 0, newBitmapData.width, newBitmapData.height);
								//bitmapData.merge(newBitmapData, rectangle, new Point(), 0, 0, 0, 0);
								//bitmapData.drawWithQuality(newBitmapData, null, null, null, rectangle, false, quality);
								bitmapData.drawWithQuality(newBitmapData, null, null, null, null, false, quality);
								//bitmapData.drawWithQuality(LoaderInfo(event.currentTarget).loader, null, null, null, null, false, quality);
								//bitmapData.copyPixels(newBitmapData, newBitmapData.rect, new Point());
								//bitmapData = newBitmapData.clone();
								//bitmapData.merge(newBitmapData, null, new Point(), 0, 0, 0, 0);
							}
						}
					});
					
				}
				else {
					bitmapData.setPixels(rectangle, byteArray);
				}
			}
			catch (error:*) {
				
			}
			
			return bitmapData;
		}
		
		
		/**
		 * Get bitmap data from a base 64
		 * */
		public static function getBitmapDataFromBase64(encodedValue:String, loaderContext:LoaderContext = null, parseBitmapSize:Boolean = true, imageType:String = null):BitmapData {
			var PNGEncoderOptionsClass:Object;
			var bitmapData:BitmapData;
			var loader:Loader;
			var value:Object;
			var byteArray:ByteArray;
			var base64PNGImageData:String;
			var size:Point;
			var jpgSize:Object;
			
			byteArray = getByteArrayFromBase64(encodedValue);
			
			if (parseBitmapSize) {
				if (imageType==null) {
					imageType = getImageTypeFromBase64Data(encodedValue);
				}
				
				size = getImageDimensionsFromByteArray(byteArray, imageType);
			}
			
			if (byteArray) {
				bitmapData = getBitmapDataFromByteArray(byteArray, loaderContext, size);
			}
			
			return bitmapData;
		}
			
		/**
		 * Center the application or native window
		 * */
		public static function centerWindow(application:Object, offsetHeight:Number = 0, offsetWidth:Number = 0):void {
			
			if ("nativeWindow" in application) {
				application.nativeWindow.x = (Capabilities.screenResolutionX - application.width) / 2 - offsetHeight;
				application.nativeWindow.y = (Capabilities.screenResolutionY - application.height) / 2 - offsetHeight;
			}
			else {
				application.x = (Capabilities.screenResolutionX - application.width) / 2 - offsetHeight;
				application.y = (Capabilities.screenResolutionY - application.height) / 2 - offsetHeight;
			}
		}
		
		/**
		 * Create a checkered background fill. Default size is 10x10.<br/><br/>
		 * 
		 * How to use: 
<pre>
var rect:Rect = new Rect();
rect.percentWidth = 100;
rect.percentHeight = 100;
//rect.fill = DisplayObjectUtil.createCheckeredFill(10,10); sets width and height
rect.fill = DisplayObjectUtil.createCheckeredFill();
</pre>
		 * 
		 * */
		public static function createCheckeredFill(width:int=10, height:int=10):BitmapFill {
			
				var fillSprite:Sprite = new Sprite();
				fillSprite.graphics.beginFill(0xCCCCCC, 1);
				fillSprite.graphics.drawRect(0, 0, width, height);
				fillSprite.graphics.beginFill(0xFFFFFF, 1);
				fillSprite.graphics.drawRect(width, 0, width, height);
				fillSprite.graphics.beginFill(0xFFFFFF, 1);
				fillSprite.graphics.drawRect(0, height, width, height);
				fillSprite.graphics.beginFill(0xCCCCCC, 1);
				fillSprite.graphics.drawRect(width, height, width, height);
				
				var bitmapFill:BitmapFill = new BitmapFill();
				bitmapFill.fillMode = BitmapFillMode.REPEAT;
				bitmapFill.source = fillSprite;
				
				
				return bitmapFill;
		}
		
		/**
		 * Given a UIComponent, DisplayObject, BitmapData or GraphicElement
		 * returns bitmap data of that object.  
		 * */
		public static function getAnyTypeBitmapData(anything:Object):BitmapData {
			var component:IUIComponent = anything as IUIComponent;
			var bitmapData:BitmapData;
			
			
			if (component) {
				bitmapData = getUIComponentBitmapData(component);
			}
			else if (anything is DisplayObject) {
				bitmapData = getBitmapDataSnapshot2(anything as DisplayObject);
			}
			else if (anything is BitmapData) {
				bitmapData = anything as BitmapData;
			}
			else if (anything is GraphicElement) {
				//bitmapData = getGraphicElementBitmapData(target as IGraphicElement);
				//bitmapData = rasterize2(GraphicElement(target).displayObject);
				bitmapData = getBitmapDataSnapshot2(GraphicElement(anything).displayObject);
			}
			else {
				throw Error("Target is not of an acceptable type. UIComponent, DisplayObject, BitmapData and GraphicElement are accepted.");
			}
			
			return bitmapData;
		}
		
		/**
		 * Adds diagonal lines to a display object or bitmapdata. Not complete. <br/><br/>
		 * 
		 * How to use: 
<pre>
// not complete
DisplayObjectUtil.addDiagonalLines(displayObject, 10, 10);
</pre>
		 * */
		public static function addDiagonalLines(object:IBitmapDrawable, lineWidth:int=3, lineHeight:int=3, eraseLines:Boolean = true, color:int = 0xFFFFFF):SpriteVisualElement {
			var showClip:Boolean;
			var copyOfTargetBitmapData:BitmapData;
			var lineBitmapData:BitmapData;
			var diagonalLinesSprite:SpriteVisualElement;
			var spriteContainer:SpriteVisualElement;
			var fillSprite:Sprite;
			var visualElementContainer:IVisualElementContainer;
			var displayObjectContainer:DisplayObjectContainer;
			
			// get copy of target
			copyOfTargetBitmapData = getAnyTypeBitmapData(object);
			
			// create container for target 
			spriteContainer = new SpriteVisualElement();
			fillSprite = new Sprite();
			
			// add copy of target to container
			var targetBitmap:Bitmap = new Bitmap(copyOfTargetBitmapData);
			spriteContainer.blendMode = BlendMode.LAYER;
			spriteContainer.addChild(targetBitmap);
			
			/*
			if (object && "parent" in object) {
				displayObjectContainer = Object(object).parent as DisplayObjectContainer;
			}
			
			if (object && "owner" in object) {
				visualElementContainer = Object(object).owner as IVisualElementContainer;
			}*/
			
			
			// draw our diagonal line on a sprite
			fillSprite.graphics.lineStyle(0, color, 1, true);
			fillSprite.graphics.moveTo(0, lineWidth);
			fillSprite.graphics.lineTo(lineHeight, 0);
			
			// NOTE THIS way is crap. the lines are not connecting.
			// draw all the line pixels into a bitmap data object 
			// the third and forth properties make the non pixel areas transparent instead of filled
			lineBitmapData = new BitmapData(lineWidth+1, lineHeight+1, true, 0x0000000000000000000000000000);
			lineBitmapData.draw(fillSprite);
			
			if (showClip) {
				spriteContainer.addChild(fillSprite);
				
				if (visualElementContainer) {
					visualElementContainer.addElement(spriteContainer);
				}
				else if (displayObjectContainer) {
					displayObjectContainer.addChild(spriteContainer);
				}
				return null;
			}
			
			// create a new sprite and with the graphics object 
			// draw a rectangle and fill it with a repeating bitmap data
			diagonalLinesSprite = new SpriteVisualElement();
			diagonalLinesSprite.graphics.beginBitmapFill(lineBitmapData, null, true);
			diagonalLinesSprite.graphics.drawRect(0, 0, targetBitmap.width, targetBitmap.height);
			diagonalLinesSprite.graphics.endFill();
			
			// to erase the lines set the blend mode to erase
			if (eraseLines) {
				diagonalLinesSprite.blendMode = BlendMode.ERASE;
				spriteContainer.addChild(diagonalLinesSprite);
			}
			else {
				//diagonalLinesSprite.blendMode = BlendMode.ERASE;
				spriteContainer.addChild(diagonalLinesSprite);
			}
			
			return spriteContainer;
		}
		
		/**
		 * Gets the size of the same aspect ratio after providing one of the sizes
		 * 
		 * How to use: 
<pre>
var myButton:Button = new Button();
myButton.width = 100;
myButton.height = 50;
var size:Object = getConstrainedSize(myButton, "width", 200);
trace(size); // {width = 200, height = 100}
</pre>
		 * */
		public static function getConstrainedSize(target:Object, property:String, value:*):Object {
			const WIDTH:String = "width";
			const HEIGHT:String = "height";
			
			var widthValue:Number;
			var heightValue:Number;
			var roundingConstraints:int = 1;
			var supportDecimals:Boolean;
			// check width / height is not 0
			if (property==WIDTH) {
				widthValue = supportDecimals ? Number(value) : Math.round(value);
				
				if ("sourceHeight" in target && !isNaN(target.sourceHeight)) {
					heightValue = (target.sourceHeight/target.sourceWidth) * widthValue;
				}
				else {
					heightValue = (target.height/target.width) * widthValue;
				}
				
				heightValue = Math.round(heightValue);
			}
			else if (property==HEIGHT) {
				heightValue = supportDecimals ? Number(value) : Math.round(value);
				
				if ("sourceHeight" in target && !isNaN(target.sourceHeight)) {
					widthValue = (target.sourceWidth/target.sourceHeight) * heightValue;
				} else {
					widthValue = (target.width/target.height) * heightValue;
				}
				
				widthValue = Math.round(widthValue);
			}
			
			return {width:widthValue, height:heightValue};
			
		}
		
		/**
		 *  Returns a rectangle that describes the visible region of the target, 
		 *  including any filters. The padding argument specifies how much space
		 *  to pad the temporary BitmapData with, to capture any extra visible pixels
		 *  from things like filters. See also getRectangleBounds() which is useful 
		 *  for UIComponents.<br/><br/>
		 * 
		 *  Note that this actually captures the full bounds of an object as seen
		 *  by the player, including any transparent areas. For example, the player 
		 *  pads significantly around text objects and slightly around filtered areas.
		 *  To deal with this, we render our object with an opaque background into
		 *  our temporary bitmap and examine the result for pixels that were written to.
		 *  When the player exposes an API for getting the real, internal bounds (which
		 *  getBounds() does not do), then we can remove this code and use that 
		 *  API instead.<br/><br/>
		 * 
		 *  Copied from spark.utils.BitmapUtil<br/><br/>
		 * 
		 *  @param target The target object whose bounds are requested<br/>
		 * 
		 *  @param matrix The transform matrix for the target object. This should be the
		 *  object's concatenatedMatrix, since we want the real bounds of the object
		 *  on the stage, which should include any transformations on the object.<br/>
		 * 
		 *  @param padding The amount of padding to use to catch any pixels
		 *  outside the core object area (such as filtered or text objects have).
		 * 
		 * @see #getRectangleBounds()
		 */
		public static function getRealBounds(target:DisplayObject, matrix:Matrix = null, padding:int = 0):Rectangle {
			var bitmap:BitmapData;
			bitmap = new BitmapData(target.width + 2 * padding, target.height + 2 * padding, true, 0x00000000);
			
			if (!matrix) {
				matrix = new Matrix();
			}
			
			var translateX:Number = matrix.tx;
			var translateY:Number = matrix.ty;
			
			matrix.translate(-translateX + padding, -translateY + padding);
			
			var tempOpaqueBackground:Object = target.opaqueBackground;
			target.opaqueBackground = 0xFFFFFFFF;
			bitmap.draw(target, matrix);
			
			// restore the matrix translation
			matrix.translate(translateX - padding, translateY - padding);
			target.opaqueBackground = tempOpaqueBackground;
			
			// getColorBoundsRect() will find the inner rect of opaque pixels,
			// consistent with the player's view of the object bounds
			var actualBounds:Rectangle = bitmap.getColorBoundsRect(0xFF000000, 0x0, false);
			
			if ((actualBounds.width == 0 || actualBounds.height == 0) ||
				(actualBounds.x > 0 && actualBounds.y > 0 &&
					actualBounds.right < bitmap.width &&
					actualBounds.bottom < bitmap.height)) {
				actualBounds.x = actualBounds.x + translateX - padding;
				actualBounds.y = actualBounds.y + translateY - padding;
				bitmap.dispose();
				return actualBounds;
			}
			else {
				// If we ran right up to the borders of our bitmap,
				// then we may not have created a large enough bitmap - do it
				// again with twice the padding.
				
				// padding shouldn't be zero, but just in case...
				var newPadding:int = (padding == 0) ? 10 : 2 * padding;
				
				bitmap.dispose();
				return getRealBounds(target, matrix, newPadding);
			}
		}
		
		/*********************************************************************
		 * 
		 * The great list of collected snapshot functions 
		 * 
		 * Some of these work some of them don't. 
		 * Many failed over the years in some ways until recently because as I found out
		 * (in 2015) from comments on spark.util.BitmapUtil.getRealBounds()
		 * "DisplayObject.getBounds() is not sufficient; the player 
		 * pads significantly around text objects and slightly around filtered 
		 * areas. we need the same bounds as those used internally by the player"
		 * 
		 * 
		 * Recommended methods are: 
		 * 
		 * 
		 * DisplayObjects: 
		 *  - rasterize2                     - highest reliability
		 * 
		 * UIComponents: 
		 *  - getUIComponent                 - highest reliability
		 *  - getUIComponentWithQuality      - same as above but sets quality to highest
		 *  - getSnapshot                    - from spark.util.BitmapUtil (new 2015)
		 *  - getSnapshotWithPadding         - from spark.util.BitmapUtil (new 2015)
		 * 
		 * BitmapImage
		 *  - rasterizeBitmapImage           - seems to work ok
		 * 
		 * BitmapData: 
		 *  - rasterizeBitmapData            - seems to work ok
		 * 
		 * VisualElements
		 *  - rasterize2
		 * 
		 * IGraphicElement
		 *  - getGraphicElementBitmapData      - testing
		 *  - rasterize2                     - use IGraphicElement(target).displayObject
		 * *******************************************************************/
		
		
		/**
		 * Creates a snapshot of the display object passed to it
		 **/
		public static function rasterize(target:DisplayObject, transparentFill:Boolean = true, scaleX:Number = 1, scaleY:Number = 1, horizontalPadding:int = 0, verticalPadding:int = 0, fillColor:Number = 0x00000000):Sprite {
			//var bounds:Rectangle = target.getBounds(target);
			var bounds:Rectangle = target.getRect(target);
			var targetWidth:Number = target.width==0 ? 1 : target.width;
			var targetHeight:Number = target.height==0 ? 1 : target.height;
			/*
			var bounds:Rectangle = target.getBounds(target);
			var targetWidth:Number = target.width==0 ? 1 : bounds.size.x;
			var targetHeight:Number = target.height==0 ? 1 : bounds.size.y;*/
			var bitmapData:BitmapData = new BitmapData(targetWidth * scaleX, targetHeight * scaleY, transparentFill, fillColor);
			var matrix:Matrix = new Matrix();
			var container:Sprite = new Sprite();
			var bitmap:Bitmap;
			
			matrix.translate(-bounds.left, -bounds.top);
			matrix.scale(scaleX, scaleY);
			
			try {
				drawBitmapData(bitmapData, target, matrix);
			}
			catch (e:Error) {
				//log(LogEventLevel.ERROR, "Can't get display object outline. " + e.message);
				var fillRect:Rectangle
				var skin:DisplayObject = "skin" in target ? Object(target).skin : null;
				
				if (skin)
					fillRect = new Rectangle(skin.x, skin.y, skin.width, skin.height);
				else
					fillRect = new Rectangle(target.x, target.y, target.width, target.height);
				
				bitmapData.fillRect(fillRect, 0);
			}
			
			bitmap = new Bitmap(bitmapData, PixelSnapping.AUTO, true);
			bitmap.x = bounds.left;
			bitmap.y = bounds.top;
			
			container.cacheAsBitmap = true;
			container.transform.matrix = target.transform.matrix;
			container.addChild(bitmap);
			
			// added to fix some clipping issues
			targetWidth = container.getBounds(container).size.x;
			targetHeight = container.getBounds(container).size.y;
			
			targetWidth = Math.max(container.getBounds(container).size.x, targetWidth);
			targetHeight = Math.max(container.getBounds(container).size.y, targetHeight);
			
			var bitmapData2:BitmapData = new BitmapData(targetWidth, targetHeight, transparentFill, fillColor);
			
			drawBitmapData(bitmapData2, container, matrix);
			
			return container;
		}
		
		/**
		 * Creates a snapshot of the display object passed to it
		 **/
		public static function rasterize2(target:DisplayObject, 
										  transparentFill:Boolean = true, 
										  scaleX:Number = 1, 
										  scaleY:Number = 1, 
										  horizontalPadding:int = 0, 
										  verticalPadding:int = 0, 
										  fillColor:Number = 0x00000000):SpriteVisualElement {
			
			var bounds:Rectangle = target.getBounds(target);
			var targetWidth:Number = target.width==0 ? 1 : bounds.size.x;
			var targetHeight:Number = target.height==0 ? 1 : bounds.size.y;
			var bitmapData:BitmapData = new BitmapData((targetWidth + horizontalPadding) * scaleX, (targetHeight + verticalPadding) * scaleY, transparentFill, fillColor);
			var matrix:Matrix = new Matrix();
			var spriteVisualElement:SpriteVisualElement = new SpriteVisualElement();
			var bitmap:Bitmap;
			
			matrix.translate(-bounds.left+horizontalPadding/2, -bounds.top+verticalPadding/2);
			matrix.scale(scaleX, scaleY);
			
			try {
				drawBitmapData(bitmapData, target, matrix);
			}
			catch (e:Error) {
				//trace( "Can't get display object preview. " + e.message);
				// show something here
				// If capture fails, substitute with a Rect
				var fillRect:Rectangle
				var skin:DisplayObject = "skin" in target ? Object(target).skin : null;
				
				if (skin)
					fillRect = new Rectangle(skin.x, skin.y, skin.width, skin.height);
				else
					fillRect = new Rectangle(target.x, target.y, target.width, target.height);
				
				bitmapData.fillRect(fillRect, 0);
			}
			
			bitmap = new Bitmap(bitmapData, PixelSnapping.AUTO, true);
			bitmap.x = bounds.left;
			bitmap.y = bounds.top;
			
			spriteVisualElement.cacheAsBitmap = true;
			spriteVisualElement.transform.matrix = target.transform.matrix;
			spriteVisualElement.addChild(bitmap);
			
			targetWidth = spriteVisualElement.getBounds(spriteVisualElement).size.x;
			targetHeight = spriteVisualElement.getBounds(spriteVisualElement).size.y;
			
			targetWidth = Math.max(spriteVisualElement.getBounds(spriteVisualElement).size.x, targetWidth);
			targetHeight = Math.max(spriteVisualElement.getBounds(spriteVisualElement).size.y, targetHeight);
			
			var bitmapData2:BitmapData = new BitmapData(targetWidth, targetHeight, transparentFill, fillColor);
			
			drawBitmapData(bitmapData2, spriteVisualElement, matrix);
			
			//var bitmapAsset:BitmapAsset = new BitmapAsset(bitmapData2, PixelSnapping.ALWAYS);
			
			//return bitmapAsset;
			return spriteVisualElement;
		}
		
		/**
		 * Creates a snapshot Sprite of the bitmap data passed to it
		 **/
		public static function rasterizeBitmapData(bitmapData:BitmapData, 
												   transparentFill:Boolean = true, 
												   scaleX:Number = 1, 
												   scaleY:Number = 1, 
												   horizontalPadding:int = 0, 
												   verticalPadding:int = 0, 
												   fillColor:Number = 0x00000000):SpriteVisualElement {
			//var bounds:Rectangle = target.getBounds(target);
			//var targetWidth:Number = target.width==0 ? 1 : bounds.size.x;
			//var targetHeight:Number = target.height==0 ? 1 : bounds.size.y;
			//var bitmapData:BitmapData = new BitmapData((targetWidth + horizontalPadding) * scaleX, (targetHeight + verticalPadding) * scaleY, transparentFill, fillColor);
			var matrix:Matrix = new Matrix();
			var spriteVisualElement:SpriteVisualElement = new SpriteVisualElement();
			var bitmap:Bitmap;
			/*
			matrix.translate(-bounds.left+horizontalPadding/2, -bounds.top+verticalPadding/2);
			matrix.scale(scaleX, scaleY);
			
			try {
				drawBitmapData(bitmapData, target, matrix);
			}
			catch (e:Error) {
				//trace( "Can't get display object preview. " + e.message);
				// show something here
				// If capture fails, substitute with a Rect
				var fillRect:Rectangle
				var skin:DisplayObject = "skin" in target ? Object(target).skin : null;
				
				if (skin)
					fillRect = new Rectangle(skin.x, skin.y, skin.width, skin.height);
				else
					fillRect = new Rectangle(target.x, target.y, target.width, target.height);
				
				bitmapData.fillRect(fillRect, 0);
			}*/
			
			bitmap = new Bitmap(bitmapData, PixelSnapping.AUTO, true);
			//bitmap.x = bounds.left;
			//bitmap.y = bounds.top;
			
			spriteVisualElement.cacheAsBitmap = true;
			//container.transform.matrix = target.transform.matrix;
			spriteVisualElement.addChild(bitmap);
			
			var targetWidth:Number = spriteVisualElement.getBounds(spriteVisualElement).size.x;
			var targetHeight:Number = spriteVisualElement.getBounds(spriteVisualElement).size.y;
			
			targetWidth = Math.max(spriteVisualElement.getBounds(spriteVisualElement).size.x, targetWidth);
			targetHeight = Math.max(spriteVisualElement.getBounds(spriteVisualElement).size.y, targetHeight);
			
			var bitmapData2:BitmapData = new BitmapData(targetWidth, targetHeight, transparentFill, fillColor);
			
			drawBitmapData(bitmapData2, spriteVisualElement, matrix);
			
			//var bitmapAsset:BitmapAsset = new BitmapAsset(bitmapData2, PixelSnapping.ALWAYS);
			
			//return bitmapAsset;
			return spriteVisualElement;
		}
		
		/**
		 * Creates a snapshot Sprite of a BitmapImage passed to it
		 **/
		public static function rasterizeBitmapImage(bitmapImage:BitmapImage):SpriteVisualElement {
			var bitmapData:BitmapData = bitmapImage.captureBitmapData();
			var spriteVisualElement:SpriteVisualElement = new SpriteVisualElement();
			var bitmap:Bitmap;
			
			bitmap = new Bitmap(bitmapData, PixelSnapping.AUTO, true);
			
			spriteVisualElement.cacheAsBitmap = true;
			//spriteVisualElement.transform.matrix = target.transform.matrix;
			spriteVisualElement.addChild(bitmap);
			
			var targetWidth:Number = spriteVisualElement.getBounds(spriteVisualElement).size.x;
			var targetHeight:Number = spriteVisualElement.getBounds(spriteVisualElement).size.y;
			
			targetWidth = Math.max(spriteVisualElement.getBounds(spriteVisualElement).size.x, targetWidth);
			targetHeight = Math.max(spriteVisualElement.getBounds(spriteVisualElement).size.y, targetHeight);
			
			var bitmapData2:BitmapData = new BitmapData(targetWidth, targetHeight, true);
			//spriteVisualElement.width = targetWidth;
			//spriteVisualElement.height = targetHeight;
			
			// when using sprites the sprite is sized to the content automatically
			// when using sprite visual element it's not sized at all
			if (spriteVisualElement.width==0 && targetWidth>0) {
				spriteVisualElement.width = targetWidth;
			}
			if (spriteVisualElement.height==0 && targetHeight>0) {
				spriteVisualElement.height = targetHeight;
			}
			
			drawBitmapData(bitmapData2, spriteVisualElement);
			
			//drawBitmapDataWithQuality(bitmapData, spriteVisualElement);
			
			return spriteVisualElement;
		}
		
		
		
		/**
		 * Creates a snapshot of the display object passed to it with quality setting
		 * 
		 * @see #getUIComponentSnapshot()
		 **/
		public static function getUIComponentWithQuality(target:IUIComponent, quality:String = "16x16linear", smoothing:Boolean = false, bitmapDataOnly:Boolean = true, transparentFill:Boolean = true, scaleX:Number = 1, scaleY:Number = 1):Object {
			
			return getUIComponentSnapshot(target, transparentFill, scaleX, scaleY, 0, 0, 0x00000000, smoothing, quality, bitmapDataOnly);
		}
		
		/**
		* Creates a snapshot of the display object passed to it with quality setting
		* 
		* @see #getUIComponentSnapshot()
		**/
		public static function getUIComponentBitmapData(target:IUIComponent, quality:String = "16x16linear", smoothing:Boolean = false, transparentFill:Boolean = true, scaleX:Number = 1, scaleY:Number = 1):BitmapData {
			
			return getUIComponentSnapshot(target, transparentFill, scaleX, scaleY, 0, 0, 0x00000000, smoothing, quality, true) as BitmapData;
		}
		
		
		/**
		 * Creates a snapshot of the display object passed to it. 
		 * Returns BitmapData or a SpriteVisualElement.
		 * 
		 * @param target UIComponent to rasterize
		 * @param transparentFill if true background is transparent if false then opaque. default is true
		 * @param scaleX scale of image horizontally. default is 1
		 * @param scaleY scale of image vertically. default is 1
		 * @param horizontalPadding padding to add horizontally. default is 0
		 * @param verticalPadding padding to add vertically. default is 0
		 * @param fillColor color to fill when background is not transparent. default is 0x00000000
		 * @param smoothing if true smoothing is applied. default is false
		 * @param quality quality to apply. see StageQuality class. default is null (uses stage.quality)
		 * @param bitmapDataOnly returns the bitmap data instead of the sprite. default is false
		 * @param propagateColorTransform propogates color transforms. default is false
		 * @param substituteRectangle returns a gray box if content is not accessible in another domain. 
		 * if not enabled then the SecurityError is returned instead of a bitmapData or sprite object 
		 **/
		public static function getUIComponentSnapshot(target:IUIComponent, 
												  transparentFill:Boolean = true, 
												  scaleX:Number = 1, 
												  scaleY:Number = 1, 
												  horizontalPadding:int = 0, 
												  verticalPadding:int = 0, 
												  fillColor:Number = 0x00000000, 
												  smoothing:Boolean = false, 
												  quality:String = null, 
												  bitmapDataOnly:Boolean = false,
												  propagateColorTransform:Boolean = false, 
												  substituteRectangle:Boolean = true):Object {
			
			var targetWidth:Number = target.width==0 || isNaN(target.width) ? 1 : target.width;
			var targetHeight:Number = target.height==0 || isNaN(target.height) ? 1 : target.height;
			var expectedBounds:Rectangle = getRectangleBounds(target as UIComponent);
			var bitmapData:BitmapData = new BitmapData(targetWidth * scaleX, targetHeight * scaleY, transparentFill, fillColor);
			var matrix:Matrix = new Matrix();
			var spriteVisualElement:SpriteVisualElement = new SpriteVisualElement();
			var bitmap:Bitmap;
			var fillRect:Rectangle;
			var skin:DisplayObject;
			var propagatedTransform:ColorTransform = propagateColorTransform ? target.transform.colorTransform : null;
			
			if (expectedBounds==null) {
				if ("stage" in target && target.stage==null) { 
					// target was removed from the stage
					expectedBounds = new Rectangle(0,0,1,1);
				}
				else {
					expectedBounds = new Rectangle(0,0,1,1);
				}
			}
			
			targetWidth = expectedBounds.width;
			targetHeight = expectedBounds.height;
			
			
			try {
				
				if (quality) {
					//bitmapData.drawWithQuality(IBitmapDrawable(target), matrix, propagateColorTransform ? target.transform.colorTransform : null, null, null, smoothing, quality);
					drawBitmapDataWithQuality(bitmapData, IBitmapDrawable(target), matrix, propagatedTransform, null, null, smoothing, quality);
				}
				else {
					//bitmapData.draw(IBitmapDrawable(target), matrix, );
					drawBitmapData(bitmapData, IBitmapDrawable(target), matrix, propagatedTransform, null, null, smoothing);
				}
			}
			catch (error:*) {
				
				if (!substituteRectangle) {
					return error;
				}
				
				//log(LogEventLevel.ERROR, "Can't get display object outline. " + e.message);
				
				skin = "skin" in target ? Object(target).skin : null;
				
				if (skin) {
					fillRect = new Rectangle(skin.x, skin.y, skin.width, skin.height);
				}
				else {
					fillRect = new Rectangle(expectedBounds.x, expectedBounds.y, targetWidth, targetHeight);
				}
				
				bitmapData.fillRect(fillRect, 0);
			}
			
			bitmap = new Bitmap(bitmapData, PixelSnapping.AUTO, true);
			//bitmap.x = expectedBounds.left;
			//bitmap.y = expectedBounds.top;
			
			spriteVisualElement.cacheAsBitmap = true;
			spriteVisualElement.transform.matrix = target.transform.matrix;
			spriteVisualElement.addChild(bitmap);
			
			// added to fix some clipping issues
			targetWidth = spriteVisualElement.getBounds(spriteVisualElement).size.x;
			targetHeight = spriteVisualElement.getBounds(spriteVisualElement).size.y;
			
			targetWidth = Math.max(spriteVisualElement.getBounds(spriteVisualElement).size.x, targetWidth);
			targetHeight = Math.max(spriteVisualElement.getBounds(spriteVisualElement).size.y, targetHeight);
			
			var bitmapData2:BitmapData = new BitmapData(targetWidth, targetHeight, transparentFill, fillColor);
			
			if (quality) {
				drawBitmapDataWithQuality(bitmapData2, spriteVisualElement, matrix);
			}
			else {
				drawBitmapData(bitmapData2, spriteVisualElement, matrix);
			}
			
			// when using sprites the sprite is sized to the content automatically
			// when using sprite visual element it's not sized at all
			if (spriteVisualElement.width==0 && targetWidth>0) {
				spriteVisualElement.width = targetWidth;
			}
			if (spriteVisualElement.height==0 && targetHeight>0) {
				spriteVisualElement.height = targetHeight;
			}
			
			if (bitmapDataOnly) {
				return bitmapData2;
			}
			
			return spriteVisualElement;
		}
		
		/**
		 * Get graphic element bitmap data
		 * */
		public static function getGraphicElementBitmapData(graphicElement:IGraphicElement, transparent:Boolean = true, fillColor:uint = 0xFFFFFF, useLocalSpace:Boolean = true, clipRectangle:Rectangle = null):BitmapData {
			var bitmapData:BitmapData;
			
			if (graphicElement) {
				bitmapData = GraphicElement(graphicElement).captureBitmapData(transparent, fillColor, useLocalSpace, clipRectangle);
				return bitmapData;
			}
			
			return null;
		}
		
		/**
		 * Create a duplicate and place it in the same location 
		 * */
		public static function duplicateIntoImage(graphicElement:IGraphicElement, transparent:Boolean = true, fillColor:uint = 0xFFFFFF, useLocalSpace:Boolean = true, clipRectangle:Rectangle = null):Image {
			var bitmapData:BitmapData = getGraphicElementBitmapData(graphicElement as IGraphicElement, transparent, fillColor, useLocalSpace, clipRectangle);
			var container:Object = graphicElement.owner ? graphicElement.owner : graphicElement.parent;
			var image:Image = new Image();
			var x:Number;
			var y:Number;
			image.source = bitmapData;
			image.includeInLayout = false;
			x = graphicElement.getLayoutBoundsX();
			y = graphicElement.getLayoutBoundsY();
			
			image.x = x;
			image.y = y;
			image.width = bitmapData.width;
			image.height = bitmapData.height;
			
			if (container is IVisualElementContainer) {
				container.addElement(image);
			}
			else if (container is DisplayObjectContainer) {
				container.addChild(image);
			}
			
			if (container is IInvalidating) {
				IInvalidating(container).validateNow();
			}
			
			return image;
		}
		
		/**
		 * Get graphic element bitmap data. Not done.
		 * */
		public static function getVisualElementBitmapData(visualElement:IVisualElement, transparent:Boolean = true, fillColor:uint = 0xFFFFFF, useLocalSpace:Boolean = true, clipRectangle:Rectangle = null):BitmapData {
			var bitmapData:BitmapData;
			
			if (visualElement) {
				//bitmapData = rasterize(visualElement as DisplayObject);
				return bitmapData;
			}
			
			return null;
		}
		
		/**
		 * Takes a target DisplayObject, rasterizes it into a Bitmap, and returns it in a container Sprite 
		 * transformed to be identical to the target.
		 * @author Nick Bilyk (nbflexlib)
		 * @modified possibly
		 * 
		 * see the documentation at the top of this class
		 */
		public static function getSpriteSnapshot(target:DisplayObject, useAlpha:Boolean = true, scaleX:Number = 1, scaleY:Number = 1):Sprite {
			var bounds:Rectangle = target.getBounds(target);
			var bitmapData:BitmapData = new BitmapData(target.width * scaleX, target.height * scaleY, useAlpha, 0x00000000);
			var matrix:Matrix = new Matrix();
			var container:SpriteVisualElement = new SpriteVisualElement();
			var bitmap:Bitmap;
			
			matrix.translate(-bounds.left, -bounds.top);
			matrix.scale(scaleX, scaleY);
			
			bitmapData.draw(target, matrix);
			
			bitmap = new Bitmap(bitmapData, PixelSnapping.ALWAYS, true);
			bitmap.x = bounds.left;
			bitmap.y = bounds.top;
			
			container.cacheAsBitmap = true;
			container.transform.matrix = target.transform.matrix;
			container.addChild(bitmap);
			
			return container;
		}
		
		/**
		 * Takes a target DisplayObject, rasterizes it into a Bitmap, and returns the bitmap data
		 * transformed to be identical to the target.
		 * @author Nick Bilyk (nbflexlib)
		 * @modified possibly
		 * 
		 * 
		 * PROBLEMS
		 * The images and edges are clipped on some objects. 
		 * 
		 * see the documentation at the top of this class
		 * @see rasterizeComponent()
		 */
		public static function getBitmapDataSnapshot(target:DisplayObject, useAlpha:Boolean = true, scaleX:Number = 1, scaleY:Number = 1):BitmapData {
			var bounds:Rectangle = target.getBounds(target);
			var targetWidth:Number = target.width==0 ? 1 : bounds.size.x;
			var targetHeight:Number = target.height==0 ? 1 : bounds.size.y;
			var bitmapData:BitmapData = new BitmapData(target.width * scaleX, target.height * scaleY, useAlpha, 0x00000000);
			var matrix:Matrix = new Matrix();
			
			matrix.translate(-bounds.left, -bounds.top);
			matrix.scale(scaleX, scaleY);
			
			bitmapData.draw(target, matrix);
			
			// new
			var container:SpriteVisualElement = new SpriteVisualElement();
			var bitmap:Bitmap;
			bitmap = new Bitmap(bitmapData, PixelSnapping.ALWAYS, true);
			bitmap.x = bounds.left;
			bitmap.y = bounds.top;
			
			container.cacheAsBitmap = true;
			container.transform.matrix = target.transform.matrix;
			container.addChild(bitmap);
			
			bitmapData.draw(container);
			
			// added april 2013
			/*targetWidth = container.getBounds(container).size.x;
			targetHeight = container.getBounds(container).size.y;
			
			targetWidth = Math.max(container.getBounds(container).size.x, targetWidth);
			targetHeight = Math.max(container.getBounds(container).size.y, targetHeight);
			
			var bitmapData2:BitmapData = new BitmapData(targetWidth, targetHeight, useAlpha, fillColor);
			
			drawBitmapData(bitmapData2, container, matrix);*/
			
			return bitmapData;
		}
		
		
		/**
		 * Creates a snapshot of the display object passed to it
		 * April 2013
		 * see the documentation at the top of this class
		 **/
		public static function getBitmapAssetSnapshot2(target:DisplayObject, transparentFill:Boolean = true, scaleX:Number = 1, scaleY:Number = 1, horizontalPadding:int = 0, verticalPadding:int = 0, fillColor:Number = 0x00000000):BitmapAsset {
			//var bounds:Rectangle = target.getBounds(target);
			var bounds:Rectangle = target.getBounds(target);
			var targetWidth:Number = target.width==0 ? 1 : Math.max(bounds.size.x, target.width, 1);
			var targetHeight:Number = target.height==0 ? 1 : Math.max(bounds.size.y, target.height, 1);
			var adjustedWidth:Number = Math.max((targetWidth + horizontalPadding) * scaleX, 1);
			var adjustedHeight:Number = Math.max((targetHeight + verticalPadding) * scaleY, 1);
			var bitmapData:BitmapData = new BitmapData(adjustedWidth, adjustedHeight, transparentFill, fillColor);
			var matrix:Matrix = new Matrix();
			var container:Sprite = new Sprite();
			var bitmap:Bitmap;
			
			matrix.translate(-bounds.left+horizontalPadding/2, -bounds.top+verticalPadding/2);
			matrix.scale(scaleX, scaleY);
			
			try {
				drawBitmapData(bitmapData, target, matrix);
			}
			catch (e:Error) {
				//trace( "Can't get display object preview. " + e.message);
				// show something here
			}
			
			bitmap = new Bitmap(bitmapData, PixelSnapping.AUTO, true);
			bitmap.x = bounds.left;
			bitmap.y = bounds.top;
			
			container.cacheAsBitmap = true;
			container.transform.matrix = target.transform.matrix;
			container.addChild(bitmap);
			
			targetWidth = container.getBounds(container).size.x;
			targetHeight = container.getBounds(container).size.y;
			
			targetWidth = Math.max(container.getBounds(container).size.x, targetWidth);
			targetHeight = Math.max(container.getBounds(container).size.y, targetHeight);
			
			var bitmapData2:BitmapData = new BitmapData(targetWidth, targetHeight, transparentFill, fillColor);
			
			drawBitmapData(bitmapData2, container, matrix);
			
			var bitmapAsset:BitmapAsset = new BitmapAsset(bitmapData2, PixelSnapping.ALWAYS);
			
			return bitmapAsset;
		}
		
		
		/**
		 *  Creates a BitmapData representation of the target object.
		 *
		 *  @param target The object to capture in the resulting BitmapData
		 * 
		 *  @param padding Padding, in pixels, around to target to be included in the bitmap.
		 *
		 *  @param propagateColorTransform If true, the target's color transform will
		 *  be applied to the bitmap capture operation. 
		 *   
		 *  @param bounds If non-null, this Rectangle will be populated with
		 *  the visible bounds of the object, relative to the object itself.
		 * 
		 *  @param smoothing If true, then smoothing is applied.
		 *   
		 *  @param quality If non-null, this Rectangle will be drawn with the stage quality you supply.
		 *  http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/display/StageQuality.html
		 * 
		 * The StageQuality class specifies the following values:<br/><br/>
		 * 
		 * • BEST = "best"
		 *  	Specifies very high rendering quality.
		 * • HIGH = "high"
		 *  	Specifies high rendering quality.
		 * • HIGH_16X16 = "16x16"
		 *  	Specifies very high rendering quality.
		 * • HIGH_16X16_LINEAR = "16x16linear"
		 *  	Specifies very high rendering quality.
		 * • HIGH_8X8 = "8x8"
		 *  	Specifies very high rendering quality.
		 * • HIGH_8X8_LINEAR = "8x8linear"
		 *  	Specifies very high rendering quality.
		 * • LOW = "low"
		 *  	Specifies low rendering quality.
		 * • MEDIUM = "medium"
		 *   	Specifies medium rendering quality.
		 * 
		 *  @return A BitmapData object containing the image or the error if one occurs
		 *  If the <code>target</code> object and  all of its child
		 *  objects do not come from the same domain as the caller,
		 *  or are not in a content that is accessible to the caller by having called the
		 *  <code>Security.allowDomain()</code> method a SecurityError is returned.
		 *
		 *  Copied from spark.utils.BitmapUtil
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 * 
		 */
		public static function getSnapshotWithPadding(target:Object, 
													  padding:int = 0, 
													  propagateColorTransform:Boolean = false,
													  bounds:Rectangle = null,
													  smoothing:Boolean = false,
													  quality:String = null):Object {
			var width:Number = target.width;
			var height:Number = target.height;
			var matrix:Matrix = MatrixUtil.getConcatenatedComputedMatrix(target as DisplayObject, null);
			
			var position:Point = new Point(-padding, -padding);
			var size:Point = MatrixUtil.transformBounds(width + padding * 2, 
				height + padding * 2, 
				matrix, 
				position);
			
			// Translate so that when we draw, the bitmap aligns with the top-left
			// corner of the bmpData
			position.x = Math.floor(position.x);
			position.y = Math.floor(position.y);
			matrix.translate(-position.x, -position.y);
			
			// Update the visible bounds:
			if (!bounds) {
				bounds = new Rectangle();
			}
			
			bounds.x = position.x;
			bounds.y = position.y;
			bounds.width = Math.ceil(size.x);
			bounds.height = Math.ceil(size.y);
			
			var bitmapData:BitmapData = new BitmapData(bounds.width, bounds.height, true /*transparent*/, 0);
			
			try {
				if (quality && "drawWithQuality" in bitmapData) {
					bitmapData["drawWithQuality"](IBitmapDrawable(target), matrix, propagateColorTransform ? target.transform.colorTransform : null, null, null, smoothing, quality);
				}
				else {
					bitmapData.draw(IBitmapDrawable(target), matrix, propagateColorTransform ? target.transform.colorTransform : null, null, null, smoothing);
				}
			}
			catch(error:*) {
				return error;
			}
			
			return bitmapData;
		}
		
		/**
		 * Same as getSnapshot but with quality set to highest, "16x16linear". <br/>
		 * 
		 * @copy DisplayObjectUtils.getSnapshot()
		 * */
		public static function getSnapshotWithQuality(target:IUIComponent,
													  quality:String = null, 
													  smoothing:Boolean = false,
													  propagateColorTransform:Boolean = false,
													  visibleBounds:Rectangle = null):Object {
			if (quality==null && "HIGH_16X16_LINEAR" in StageQuality) {
				quality = StageQuality["HIGH_16X16_LINEAR"];
			}
			
			return getSnapshot(target, visibleBounds, propagateColorTransform, smoothing, quality);
		}
		
		/**
		 *  Creates a BitmapData representation of the target object. 
		 *  Note: This seems to add a lot of padding in some tests.<br/><br/>
		 *
		 *  Copied from spark.utils.BitmapUtil<br/><br/>
		 *
		 *  @param target The object to capture in the resulting BitmapData<br/><br/>
		 * 
		 *  @param visibleBounds If non-null, this Rectangle will be populated with
		 *  the visible bounds of the object, relative to the object itself.<br/><br/>
		 * 
		 *  @param propagateColorTransform If true, the target's color transform will
		 *  be applied to the bitmap capture operation. <br/><br/>
		 *
		 *  @param smoothing If true, then smoothing is applied.<br/><br/>
		 *   
		 *  @param quality If non-null, this Rectangle will be drawn with the stage quality you supply.<br/>
		 *  http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/display/StageQuality.html<br/><br/>
		 * 
		 * The StageQuality class specifies the following values:<br/><br/>
		 * 
		 * • BEST = "best"
		 *  	Specifies very high rendering quality.<br/>
		 * • HIGH = "high"
		 *  	Specifies high rendering quality.<br/>
		 * • HIGH_16X16 = "16x16"
		 *  	Specifies very high rendering quality.<br/>
		 * • HIGH_16X16_LINEAR = "16x16linear"
		 *  	Specifies very high rendering quality.<br/>
		 * • HIGH_8X8 = "8x8"
		 *  	Specifies very high rendering quality.<br/>
		 * • HIGH_8X8_LINEAR = "8x8linear"
		 *  	Specifies very high rendering quality.<br/>
		 * • LOW = "low"
		 *  	Specifies low rendering quality.<br/>
		 * • MEDIUM = "medium"
		 *   	Specifies medium rendering quality.<br/><br/>
		 * 
		 *  @return A BitmapData object containing the image or the error if one occurs.
		 *  If the <code>target</code> object and all of its child
		 *  objects do not come from the same domain as the caller,
		 *  or are not in a content that is accessible to the caller by having called the
		 *  <code>Security.allowDomain()</code> method returns a SecurityError.
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		public static function getSnapshot(target:IUIComponent, 
										   visibleBounds:Rectangle = null, 
										   propagateColorTransform:Boolean = false,
										   smoothing:Boolean = false,
										   quality:String = null):Object {
			
			// DisplayObject.getBounds() is not sufficient; we need the same
			// bounds as those used internally by the player
			var matrix:Matrix = MatrixUtil.getConcatenatedComputedMatrix(target as DisplayObject, null);
			var bounds:Rectangle = getRealBounds(DisplayObject(target), matrix);
			
			if (visibleBounds != null) {
				visibleBounds.x = bounds.x - target.x;
				visibleBounds.y = bounds.y - target.y;
				visibleBounds.width = bounds.width;
				visibleBounds.height = bounds.height;
			}
			
			if (bounds.width == 0 || bounds.height == 0) {
				return null;
			}
			
			if (matrix) {
				matrix.translate(-(Math.floor(bounds.x)), -(Math.floor(bounds.y)));
			}
			
			var bitmapData:BitmapData = new BitmapData(bounds.width, bounds.height, true, 0);
			var propagatedTransform:ColorTransform = propagateColorTransform ? target.transform.colorTransform : null;
			
			try {
				if (quality) {
					//bitmapData.drawWithQuality(IBitmapDrawable(target), matrix, propagateColorTransform ? target.transform.colorTransform : null, null, null, smoothing, quality);
					drawBitmapDataWithQuality(bitmapData, IBitmapDrawable(target), matrix, propagatedTransform, null, null, smoothing, quality);
				}
				else {
					//bitmapData.draw(IBitmapDrawable(target), matrix, );
					drawBitmapData(bitmapData, IBitmapDrawable(target), matrix, propagatedTransform, null, null, smoothing);
				}
			}
			catch(error:*) {
				return error;
			}
			
			return bitmapData;
		}
		/**
		 * Get bitmap data of the display object passed to it
		 * padding doesn't seem to work
		 * April 2013
		 * see the documentation at the top of this class
		 **/
		public static function getBitmapDataSnapshot2(target:DisplayObject, transparentFill:Boolean = true, scaleX:Number = 1, scaleY:Number = 1, horizontalPadding:int = 0, verticalPadding:int = 0, fillColor:Number = 0x00000000, smoothing:Boolean = false):BitmapData {
			var targetX:Number = target.x;
			var targetY:Number = target.y;
			var reportedWidth:Number = target.width;
			var reportedHeight:Number = target.height;
			
			var rect1:Rectangle = target.getRect(getTopTargetCoordinateSpace());
			var rect:Rectangle = target.getRect(target);
			var bounds:Rectangle = target.getBounds(target);
			var bounds2:Rectangle = target.getBounds(target.parent);
			
			var targetWidth:Number = target.width==0 ? 1 : bounds.size.x;
			var targetHeight:Number = target.height==0 ? 1 : bounds.size.y;
			var topLevel:Sprite = Sprite(FlexGlobals.topLevelApplication.systemManager.getSandboxRoot());
			//var topLevel:Sprite = Sprite(Object(target.parent).systemManager.getSandboxRoot());
			var bounds3:Rectangle = target.getBounds(topLevel);
			var bitmapData:BitmapData = new BitmapData((targetWidth + horizontalPadding) * scaleX, (targetHeight + verticalPadding) * scaleY, transparentFill, fillColor);
			var matrix:Matrix = new Matrix();
			var container:Sprite = new Sprite();
			var bitmap:Bitmap;
			var translateX:Number = -bounds.left+horizontalPadding/2;
			var translateY:Number = -bounds.top+verticalPadding/2;
			
			matrix.translate(translateX, translateY);
			//matrix.translate(0, 0);
			matrix.scale(scaleX, scaleY);
			
			try {
				drawBitmapData(bitmapData, target, matrix);
			}
			catch (e:Error) {
				//trace( "Can't get display object preview. " + e.message);
				// show something here
			}
			
			bitmap = new Bitmap(bitmapData, PixelSnapping.AUTO, smoothing);
			bitmap.x = bounds.left;
			bitmap.y = bounds.top;
			
			container.cacheAsBitmap = true;
			container.transform.matrix = target.transform.matrix;
			container.addChild(bitmap);
			return bitmapData;
		}
		
		
		/**
		 *  ALSO Graphic element has a getSnapshot method. 
		 * */
		
		/**
		 *  Returns a bitmap snapshot of the GraphicElement.
		 *  The bitmap contains all transformations and is reduced
		 *  to fit the visual bounds of the object.
		 *  
		 *  @param transparent Whether or not the bitmap image supports per-pixel transparency. 
		 *  The default value is true (transparent). To create a fully transparent bitmap, set the value of the 
		 *  transparent parameter to true and the value of the fillColor parameter to 0x00000000 (or to 0). 
		 *  Setting the transparent property to false can result in minor improvements in rendering performance. 
		 *  
		 *  @param fillColor A 32-bit ARGB color value that you use to fill the bitmap image area. 
		 *  The default value is 0xFFFFFFFF (solid white).
		 *  
		 *  @param useLocalSpace Whether or not the bitmap shows the GraphicElement in the local or global 
		 *  coordinate space. If true, then the snapshot is in the local space. The default value is true. 
		 * 
		 *  @param clipRect A Rectangle object that defines the area of the source object to draw. 
		 *  If you do not supply this value, no clipping occurs and the entire source object is drawn.
		 *  The clipRect should be defined in the coordinate space specified by useLocalSpace
		 * 
		 *  @return A bitmap snapshot of the GraphicElement or null if the input element has no visible bounds.
		 *  
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		public function captureBitmapData(transparent:Boolean = true, fillColor:uint = 0xFFFFFFFF, useLocalSpace:Boolean = true, clipRect:Rectangle = null):BitmapData
		{
			throw new Error("not adapted to work independently yet. copied from GraphicElement.");
			/*
			removed code until implemented. see original method
			*/
		}
		
		/**
		 *  @private 
		 *  Returns a bitmap snapshot of a 3D transformed displayObject. Since BitmapData.draw ignores
		 *  the transform matrix of its target when it draws, we need to parent the target in a temporary
		 *  sprite and call BitmapData.draw on that temp sprite. We can't take a bitmap snapshot of the 
		 *  real parent because it might have other children. 
		 */
		private function get3DSnapshot(transparent:Boolean = true, fillColor:uint = 0xFFFFFFFF, useLocalSpace:Boolean = true):BitmapData
		{
			/*
			removed code until implemented. see original method
			*/
			return null;
		}
		
		/**
		 * Copied this from HighlightBitmapCapture used by the focus skin to create
		 * a bitmap of the component. 
		 * 
		 * Accepts "bitmap", "bitmapData" as type parameter. Returns that type. 
		 * */
		public static function getHighlightBitmapCapture(target:Object, type:String="bitmap", borderWeight:int=0):Object {
			var capturingBitmap:Boolean = false;
			var colorTransform:ColorTransform = new ColorTransform(1.01, 1.01, 1.01, 2);
			var rect:Rectangle = new Rectangle();
			
			// if we weren't handed a targetObject then exit early
			if (!target) {
				return null;
			}
			
			var bitmapData:BitmapData = new BitmapData(
				target.width + (borderWeight * 2), 
				target.height + (borderWeight * 2), true, 0);
			
			var m:Matrix = new Matrix();
			
			//capturingBitmap = true;
			
			// Ensure no 3D transforms apply, as this skews our snapshot bitmap.
			var transform3D:Matrix3D = null;
			if (target.$transform.matrix3D) {
				transform3D = target.$transform.matrix3D;  
				target.$transform.matrix3D = null;
			}
			
			// If the target object already has a focus skin, make sure it is hidden.
			if (target.focusObj) {
				target.focusObj.visible = false;
			}
			
			var needUpdate:Boolean;
			var bitmapCaptureClient:IHighlightBitmapCaptureClient = target.skin as IHighlightBitmapCaptureClient;
			
			if (bitmapCaptureClient) {
				needUpdate = bitmapCaptureClient.beginHighlightBitmapCapture();
				
				if (needUpdate) {
					bitmapCaptureClient.validateNow();
				}
			}
			
			m.tx = borderWeight;
			m.ty = borderWeight;
			
			try
			{
				bitmapData.draw(target as IBitmapDrawable, m);
			}
			catch (e:SecurityError)
			{
				// If capture fails, substitute with a Rect
				var fillRect:Rectangle
				var skin:DisplayObject = target.skin;
				
				if (skin)
					fillRect = new Rectangle(skin.x, skin.y, skin.width, skin.height);
				else
					fillRect = new Rectangle(target.x, target.y, target.width, target.height);
				
				bitmapData.fillRect(fillRect, 0);
			}
			
			if (bitmapCaptureClient)
			{
				needUpdate = bitmapCaptureClient.endHighlightBitmapCapture();
				if (needUpdate) {
					bitmapCaptureClient.validateNow();
				}
			}
			
			
			// Show the focus skin, if needed.
			if (target.focusObj) {
				target.focusObj.visible = true;
			}
			
			// Transform the color to remove the transparency. The GlowFilter has the "knockout" property
			// set to true, which removes this image from the final display, leaving only the outer glow.
			rect.x = rect.y = borderWeight;
			rect.width = target.width;
			rect.height = target.height;
			bitmapData.colorTransform(rect, colorTransform);
			
			var bitmap:Bitmap;
			if (!bitmap)
			{
				bitmap = new Bitmap();
				//addChild(bitmap);
			}
			
			bitmap.x = bitmap.y = -borderWeight;
			bitmap.bitmapData = bitmapData;
			
			//processBitmap();
			
			// Restore original 3D matrix if applicable.
			if (transform3D) {
				target.$transform.matrix3D = transform3D;
			}
			
			capturingBitmap = false;
			
			return bitmap;
		}
		
		/**
		 * Draws a substitute rectangle from the target. Usually used when 
		 * trying to create a snapshot but content is from another
		 * domain. 
		 * */
		public static function drawSubstituteRectangleBitmapData(target:Object, 
																 bitmapData:BitmapData = null, 
																 fillColor:uint = 0):BitmapData {
			// If capture fails, substitute with a Rect
			var fillRect:Rectangle;
			var skin:DisplayObject = target && "skin" in target ? target.skin : null;
			
			if (skin) {
				fillRect = new Rectangle(skin.x, skin.y, skin.width, skin.height);
			}
			else {
				fillRect = new Rectangle(target.x, target.y, target.width, target.height);
			}
			
			if (bitmapData==null) {
				bitmapData = new BitmapData(fillRect.width, fillRect.height, true, fillColor);
			}
			
			bitmapData.fillRect(fillRect, fillColor);
			
			return bitmapData;
		}
		
		/**
		 * Draws a substitute rectangle from the target. Usually used when 
		 * trying to create a snapshot but content is from another
		 * domain. 
		 * 
		 * @returns SpriteVisualElement 
		 * */
		public static function drawSubstituteRectangle(target:Object, 
													   bitmapData:BitmapData = null, 
													   fillColor:uint = 0):SpriteVisualElement {
			var bitmapData:BitmapData;
			var spriteVisualElement:SpriteVisualElement;
			var bitmap:Bitmap;

			bitmapData = drawSubstituteRectangleBitmapData(target, bitmapData, fillColor);
			bitmap = new Bitmap(bitmapData, PixelSnapping.ALWAYS, true);
			spriteVisualElement = new SpriteVisualElement();
			
			spriteVisualElement.cacheAsBitmap = true;
			spriteVisualElement.transform.matrix = target.transform.matrix;
			spriteVisualElement.addChild(bitmap);
			
			return spriteVisualElement;
		}
		
		/**
		 * Same as BitmapData.draw() but wrapped in a method to allow error handling. <br/>
		 * 
		 * @copy BitmapData.draw()
		 **/
		public static function drawBitmapData(bitmapData:BitmapData, 
											  displayObject:IBitmapDrawable, 
											  matrix:Matrix = null, 
											  colorTransform:ColorTransform = null, 
											  blendMode:String = null, 
											  clipRect:Rectangle = null, 
											  smoothing:Boolean = false):void {
			
			bitmapData.draw(displayObject, matrix, colorTransform, blendMode, clipRect, smoothing);
		}
		
		/**
		 * Same as BitmapData.drawWithQuality() but wrapped in a method to allow error handling. 
		 * Default quality is "16x16linear". If not specified the current stage quality is used.<br/>
		 * 
		 *  @param quality If non-null, will be drawn with the stage quality you supply.<br/>
		 *  
		 * The StageQuality class specifies the following values:<br/><br/>
		 * 
		 * • BEST = "best"
		 *  	Specifies very high rendering quality.<br/>
		 * • HIGH = "high"
		 *  	Specifies high rendering quality.<br/>
		 * • HIGH_16X16 = "16x16"
		 *  	Specifies very high rendering quality.<br/>
		 * • HIGH_16X16_LINEAR = "16x16linear"
		 *  	Specifies very high rendering quality.<br/>
		 * • HIGH_8X8 = "8x8"
		 *  	Specifies very high rendering quality.<br/>
		 * • HIGH_8X8_LINEAR = "8x8linear"
		 *  	Specifies very high rendering quality.<br/>
		 * • LOW = "low"
		 *  	Specifies low rendering quality.<br/>
		 * • MEDIUM = "medium"
		 *   	Specifies medium rendering quality.<br/><br/>
		 * 
		 * @copy BitmapData.drawWithQuality();
		 * @see #getSnapshot()
		 * @see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/display/StageQuality.html
		 * @see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/display/BitmapData.html#drawWithQuality%28%29
		 **/
		public static function drawBitmapDataWithQuality(bitmapData:BitmapData, 
											  displayObject:IBitmapDrawable, 
											  matrix:Matrix = null, 
											  colorTransform:ColorTransform = null, 
											  blendMode:String = null, 
											  clipRect:Rectangle = null, 
											  smoothing:Boolean = false, 
											  quality:String = "16x16linear"):void {
			
			bitmapData["drawWithQuality"](displayObject, matrix, colorTransform, blendMode, clipRect, smoothing, quality);
		}
		
		/**
		 * Takes a target DisplayObject, rasterizes it into a Bitmap, and returns the bitmap asset
		 * transformed to be identical to the target.
		 * @author Nick Bilyk (nbflexlib)
		 * @modified possibly
		 */
		public static function getBitmapAssetSnapshot(target:DisplayObject, useAlpha:Boolean = true, scaleX:Number = 1, scaleY:Number = 1):BitmapAsset {
			var bitmapData:BitmapData = getBitmapDataSnapshot(target, useAlpha, scaleX, scaleY);
			var bitmapAsset:BitmapAsset = new BitmapAsset(bitmapData, PixelSnapping.ALWAYS);
			
			return bitmapAsset;
		}
		
		/**
		 * Get blend mode from blend mode key. 
		 * 		
		UIComponent supported blend modes:
		add,alpha,darken,difference,erase,hardlight,invert,layer,lighten,multiply,normal,subtract,screen,
		overlay,colordodge,colorburn,exclusion,softlight,hue,saturation,color,luminosity
		
		Group: 
		auto,add,alpha,darken,difference,erase,hardlight,invert,layer,lighten,multiply,normal,subtract,screen,
		overlay,colordodge,colorburn,exclusion,softlight,hue,saturation,color,luminosity
		
		From Group.as: 
		
		*  A value from the BlendMode class that specifies which blend mode to use. 
		*  A bitmap can be drawn internally in two ways. 
		*  If you have a blend mode enabled or an external clipping mask, the bitmap is drawn 
		*  by adding a bitmap-filled square shape to the vector render. 
		*  If you attempt to set this property to an invalid value",
			" 
		*  Flash Player or Adobe AIR sets the value to <code>BlendMode.NORMAL</code>. 
		*
		*  <p>A value of "auto" (the default) is specific to Group's use of 
		*  blendMode and indicates that the underlying blendMode should be 
		*  <code>BlendMode.NORMAL</code> except when <code>alpha</code> is not
		*  equal to either 0 or 1, when it is set to <code>BlendMode.LAYER</code>. 
		*  This behavior ensures that groups have correct
		*  compositing of their graphic objects when the group is translucent.</p>
		* 
		 * */
		public static function getBlendModeByKey(key:String, supportedInFlash:Boolean = true, groupModes:Boolean = false):String {
			var blendMode:String = BLEND_MODES[key];
			
			if (supportedInFlash) {
				
				// if supported by Group
				if (groupModes) {
					if (flexGroupBlendModes.indexOf(blendMode)!=-1) {
						return blendMode;
					}
					else {
						return null;
					}
				}
				else {
					// if supported in UIComponent
					if (flexBlendModes.indexOf(blendMode)!=-1) {
						return blendMode;
					}
					else {
						return null;
					}
				}
			}
			return blendMode;
		}
		
		public static var flexBlendModes:Array = 
		   ["add",
			"alpha",
			"darken",
			"difference",
			"erase",
			"hardlight",
			"invert",
			"layer",
			"lighten",
			"multiply",
			"normal",
			"subtract",
			"screen",
			"overlay",
			"colordodge",
			"colorburn",
			"exclusion",
			"softlight",
			"hue",
			"saturation",
			"color",
			"luminosity"];
		
		public static var flexGroupBlendModes:Array = ["auto"].concat(flexBlendModes);
		
		
		/**
		 * Get distance of one display object to another.
		 * If a button is nested 3 levels deep in a few groups and is visually is
		 * 50 pixels from the edge of the container then this method
		 * returns that value
		 * */
		public static function getDistanceBetweenDisplayObjects(source:Object, target:Object):Point {
			var sourceRelativePoint:Point;
			var sourceLocalToGlobalPoint:Point;
			var containerLocalToGlobalPoint:Point;
			var x:Number;
			var y:Number;
			
			var zeroPoint:Point = new Point(0, 0);
			sourceLocalToGlobalPoint = source.localToGlobal(zeroPoint);
			containerLocalToGlobalPoint = target.localToGlobal(zeroPoint);
			
			var sourceDifference:Point = sourceLocalToGlobalPoint.subtract(containerLocalToGlobalPoint);
			
			return sourceDifference;
		}
		
		
		protected static const JPEG_SOF0:Array = [0xFF, 0xC0, 0x00, 0x11, 0x08];
		
		/**
		 * Get the dimensions of a JPEG image from byte array or base64 string. 
		 * */
		public static function getJPGImageDimensions(imageData:Object, removeLinebreaks:Boolean = true, parseHeadersCount:int = 52):Point {
			var baseArray:Array;
			var byteArray:ByteArray;
			var base64Decoder:Base64Decoder;
			var header:String;
			var imageWidth:int;
			var imageHeight:int;
			var point:Point;
			
			point = new Point();
			
			if (imageData is String) {
				
				if (imageData==null || imageData=="") {
					return point;
				}
				
				baseArray = imageData.split(","); // could use indexof -  could be faster
				
				if (baseArray.length>0) {
					header = String(baseArray[1]);
				}
				else {
					header = imageData as String;
				}
				
				//var header:String = base64.slice(0, 52); // 50 gave error later on
				// we could try to get less of a string and that may be faster???
				if (parseHeadersCount>0) {
					header = header.slice(0, parseHeadersCount);
				}
				
				// linebreaks cause problems for some renderers
				if (removeLinebreaks) {
					header = header.replace(/\n/g, "");
				}
				
				base64Decoder = new Base64Decoder();
				base64Decoder.reset();
				base64Decoder.decode(header);
				
				// base64Decoder.toByteArray();
				//    Error: A partial block (2 of 4 bytes) was dropped. Decoded data is probably truncated!
				// added the whole length (52 works as well) - base64Decoder.decode(header);
				byteArray = base64Decoder.toByteArray();
				byteArray.position = 0;
			}
			else {
				byteArray = imageData as ByteArray;
				
				if (imageData==null) {
					return point;
				}
				
				byteArray.position = 0;
			}
			
			var bytesAvailable:int;
			var byte:int; // should this be uint?
			var hexValue:String;
			var apps:Array;
			var appCount:int = 16;
			var startOfSearchIndex:uint; 
			var position:int;
			var match:Boolean;
			var segmentLength:int;
			var sizeFound:Boolean;
			var frameLength:int;
			
			bytesAvailable = byteArray.length;
			byteArray.endian = Endian.BIG_ENDIAN;
			frameLength = JPEG_SOF0.length + 4;
			
			// get list of possible apps
			if (apps==null) {
				apps = [];
				
				for (var j:int; j < appCount; j++) {
					apps[j] = [0xFF, 0xE0 + j];
				}
			}
			
			// find the start of jpeg frame that contains size information
			while (bytesAvailable >= frameLength) {
				match = false;
				
				byte = byteArray.readUnsignedByte();
				position++;
				
				// skip apps data until we get to final start of frame
				for each (var appArray:Array in apps) {
					
					if (byte == appArray[startOfSearchIndex]) {
						match = true;
						
						if (startOfSearchIndex+1 >= appArray.length) {
							
							if (debug) {
								trace("APP" + Number(byte - 0xE0).toString(16).toUpperCase() + " found at 0x" + position.toString(16).toUpperCase());
							}
							
							// APP table found, skip it as it may contain thumbnails in JPG (we don’t want their SOF’s)
							// this short contains the length of the app segment (thumbnail data) skip it 
							// https://en.wikipedia.org/wiki/JPEG_File_Interchange_Format
							segmentLength = byteArray.readUnsignedShort()-2;// -2 for the short we just read
							
							if (byteArray.bytesAvailable >= segmentLength ) {
								
								for ( var i:uint = 0; i < segmentLength; i++ ) {
									byte = byteArray.readByte();
									position++;
								}
								
								if (debug) {
									trace( "Position after segment: 0x" + Number(position).toString(16).toUpperCase());
								}
							}
							else {
								sizeFound = false;
								break;
							}
								
							segmentLength = 0;
						}
					}
				}
				
				// Check for start of frame
				if (byte == JPEG_SOF0[startOfSearchIndex]) {
					match = true;
					
					if (startOfSearchIndex+1 >= JPEG_SOF0.length) {
						
						imageHeight = byteArray.readUnsignedShort();
						imageWidth = byteArray.readUnsignedShort();
						
						sizeFound = true;
						
						break;
					}
				}
				
				if (match) {
					startOfSearchIndex++;
				} else {
					startOfSearchIndex = 0;
				}
				
				bytesAvailable = byteArray.bytesAvailable;
			}
			
			if (sizeFound) {
				point.x = imageWidth;
				point.y = imageHeight;
			}
			else {
				point = null;
			}
			
			return point;
		}
		
		/**
		 * Get the size of a PNG from byte array or base64 string data. 
		 * 
		 * @param base64 the base 64 string to parse
		 * @param removeLinebreaks some renderers and parsers have problems with linebreaks. encoders use them to make the value more readable
		 * @param parseHeadersCount gets the least amount of string to parse. should be faster. set to 0 to get the full byte array.
		 * */
		public static function getPNGImageDimensions(imageData:Object, removeLinebreaks:Boolean = false, parseHeadersCount:int = 52):Point {
			var baseArray:Array;
			var byteArray:ByteArray;
			var base64Decoder:Base64Decoder;
			var header:String;
			var imageWidth:int;
			var imageHeight:int;
			var point:Point;
			var trimLength:int;
			
			point = new Point();
			
			if (imageData is String) {
				
				if (imageData==null || imageData=="") {
					return point;
				}
				
				baseArray = imageData.split(","); // could use indexof -  could be faster
				
				if (baseArray.length>0) {
					header = String(baseArray[1]);
				}
				else {
					header = imageData as String;
				}
				
				//var header:String = base64.slice(0, 52); // 50 gave error later on
				// we could try to get less of a string and that may be faster???
				if (parseHeadersCount>0) {
					header = header.slice(0, parseHeadersCount);
				}
				
				// linebreaks cause problems for some renderers
				if (removeLinebreaks) {
					header = header.replace(/\n/g, "");
				}
				
				base64Decoder = new Base64Decoder();
				base64Decoder.reset();
				base64Decoder.decode(header);
				
				// base64Decoder.toByteArray();
				//    Error: A partial block (2 of 4 bytes) was dropped. Decoded data is probably truncated!
				// added the whole length (52 works as well) - base64Decoder.decode(header);
				byteArray = base64Decoder.toByteArray();
				byteArray.position = 0;
			}
			else {
				byteArray = imageData as ByteArray;
				
				if (imageData==null) {
					return point;
				}
				
				byteArray.position = 0;
			}
			
			byteArray.position = 16;
			imageWidth = byteArray.readUnsignedInt();
			imageHeight = byteArray.readUnsignedInt();
			
			point.x = imageWidth;
			point.y = imageHeight;
			
			return point;
		}
		
		/**
		 * Get size of image from base64 data string. Not implemented yet.
		 * */
		public static function getGIFImageDimensions(imageData:Object, removeLinebreaks:Boolean = false, parseHeadersCount:int = 22):Point {
			var baseArray:Array;
			var byteArray:ByteArray;
			var base64Decoder:Base64Decoder;
			var header:String;
			var imageWidth:int;
			var imageHeight:int;
			var point:Point;
			var trimLength:int;
			
			point = new Point();
			
			if (imageData is String) {
				
				if (imageData==null || imageData=="") {
					return point;
				}
				
				baseArray = imageData.split(","); // could use indexof -  could be faster
				
				if (baseArray.length>0) {
					header = String(baseArray[1]);
				}
				else {
					header = imageData as String;
				}
				
				//var header:String = base64.slice(0, 52); // 50 gave error later on
				// we could try to get less of a string and that may be faster???
				if (parseHeadersCount>0) {
					header = header.slice(0, parseHeadersCount);
				}
				
				// linebreaks cause problems for some renderers
				if (removeLinebreaks) {
					header = header.replace(/\n/g, "");
				}
				
				base64Decoder = new Base64Decoder();
				base64Decoder.reset();
				base64Decoder.decode(header);
				
				// base64Decoder.toByteArray();
				//    Error: A partial block (2 of 4 bytes) was dropped. Decoded data is probably truncated!
				// added the whole length (52 works as well) - base64Decoder.decode(header);
				byteArray = base64Decoder.toByteArray();
				byteArray.position = 0;
			}
			else {
				byteArray = imageData as ByteArray;
				
				if (imageData==null) {
					return point;
				}
				
				byteArray.position = 0;
			}
			
			byteArray.position = 6;
			
			imageWidth = byteArray.readUnsignedByte();
			imageWidth += byteArray.readUnsignedByte() << 8;
			imageHeight = byteArray.readUnsignedByte();
			imageHeight += byteArray.readUnsignedByte() << 8;
			
			point.x = imageWidth;
			point.y = imageHeight;
			
			return point;
		}
		
		/**
		 * Get size of image from base64 data string. Not implemented yet.
		 * */
		public static function getSWFImageDimensions(imageData:Object):Point {
			throw new Error("getSWFImageDimensions is not implemented yet");
			imageData = imageData.split(',')[1];
			return null;
		}
		
		/**
		 * Get size of image from base64 data string. 
		 * Expects header like "data:image/png;base64,1234567890"
		 * Then it parses the image type and returns a point with the 
		 * size. If the data is corrupt and the size cannot be found
		 * then null is returned.
		 * 
		 * @param base64 string of bitmap data in base64 format
		 * @see #getPNGImageDimensions()
		 * @see #getJPGImageDimensions()
		 * @see #getGIFImageDimensions()
		 * @see #getSWFImageDimensions()
		 * */
		public static function getImageDimensionsFromBase64(base64:String):Point {
			var baseArray:Array = base64 ? base64.split(",") : [];
			var baseInfo:String;
			var point:Point;
			
			if (baseArray.length>1) {
				baseInfo = String(baseArray[0]).toLowerCase();
				
				if (baseInfo.indexOf(PNG)!=-1) {
					point = getPNGImageDimensions(base64);
				}
				else if (baseInfo.indexOf(JPEG)!=-1 || 
					baseInfo.indexOf(JPG)!=-1) {
					point = getJPGImageDimensions(base64);
				}
				else if (baseInfo.indexOf(GIF)!=-1) {
					point = getGIFImageDimensions(base64);
				}
				else if (baseInfo.indexOf(SWF)!=-1) {
					point = getSWFImageDimensions(base64);
				}
			}
			
			return point;
		}
		
		/**
		 * Get size of image from byte array data string. 
		 * Expects header like "data:image/png;base64,1234567890"
		 * Then it parses the image type and returns a point with the 
		 * size. If the data is corrupt and the size cannot be found
		 * then null is returned.
		 * 
		 * @param byteArray bitmap data in byte array format
		 * @see #getPNGImageDimensions()
		 * @see #getJPGImageDimensions()
		 * @see #getGIFImageDimensions()
		 * @see #getSWFImageDimensions()
		 * */
		public static function getImageDimensionsFromByteArray(byteArray:ByteArray, imageType:String = null):Point {
			var baseArray:Array;
			var point:Point;
			
			if (imageType!=null) {
				imageType = imageType.toLowerCase();
			}
			else {
				imageType = getImageTypeFromByteArray(byteArray);
			}
			
			point = new Point();
			
			if (imageType!=null && imageType.indexOf("/")!=-1) {
				imageType = imageType.split("/")[1];
			}
			
			if (imageType==PNG) {
				point = getPNGImageDimensions(byteArray);
			}
			else if (imageType==JPEG || imageType==JPG) {
				point = getJPGImageDimensions(byteArray);
			}
			else if (imageType==GIF) {
				point = getGIFImageDimensions(byteArray);
			}
			else if (imageType==SWF) {
				point = getSWFImageDimensions(byteArray);
			}
		
			
			return point;
		}
		
		/**
		 * Get image type from a byte array. Checks for PNG, JPG, GIF or SWF or null if not found
		 * */
		public static function getImageTypeFromBase64Data(value:String):String {
			var index:int = value!=null ? value.indexOf(",") : 0;
			var baseInfo:String = index!=-1 ? value.substr(0, index) : "";
			
			baseInfo = baseInfo.toLowerCase();
			
			if (baseInfo.indexOf(PNG)!=-1) {
				return PNG;
			}
			
			if (baseInfo.indexOf(JPEG)!=-1 || baseInfo.indexOf(JPG)!=-1) {
				return JPEG;
			}
			
			if (baseInfo.indexOf(GIF)!=-1) {
				return GIF;
			}
			
			if (baseInfo.indexOf(SWF)!=-1) {
				return SWF;
			}
			
			return null;
		}
		
		/**
		 * Get image type from a byte array. Checks for PNG, JPG, GIF or SWF or null if not found
		 * */
		public static function getImageTypeFromByteArray(byteArray:ByteArray):String {
			//var png:Array = [0x89,0x50,0x4E,0x47];
			var png:Array = [0xFFFFFF89,0x50,0x4E,0x47];
			var jpg:Array = [0xFFFFFFFF,0xFFFFFFD8,0xFFFFFFFF];
			var jpg1:Array = [0xFF,0xD8,0xFF]; 
			var jpg2:Array = [0x4A,0x46,0x49,0x46]; // JFIF
			var found:Boolean;
			var headerIndex:int;
			
			if (byteArray) {
				byteArray.position = 0;
			}
			
			headerIndex = ByteArrayUtils.getIndexOfValueInByteArray(byteArray, png, 0, png.length);
			
			if (headerIndex!=-1) {
				return PNG;
			}
			
			headerIndex = ByteArrayUtils.getIndexOfValueInByteArray(byteArray, jpg2, 0, Math.min(52, byteArray.length));
			
			if (headerIndex!=-1) {
				return JPEG;
			}
			
			//headerIndex = ByteArrayUtils.getIndexOfValueInByteArray(byteArray, "JFIF", 0, Math.min(52, byteArray.length));
			
			if (headerIndex!=-1) {
				//return GIF;
			}
			
			return null;
		}
		
		public static var debug:Boolean;
	}
}