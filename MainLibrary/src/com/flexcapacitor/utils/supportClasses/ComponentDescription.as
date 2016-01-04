package com.flexcapacitor.utils.supportClasses {
	import flash.display.Sprite;
	import flash.system.ApplicationDomain;
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;
	
	import mx.collections.ArrayCollection;
	import mx.core.ClassFactory;
	import mx.core.IVisualElementContainer;
	import mx.core.UIComponent;
	import mx.utils.NameUtil;
	
	import spark.core.IGraphicElement;
	
	/**
	 * Contains information about components that are
	 * added or removed from the display list
	 * */
	[Bindable]
	public class ComponentDescription {
		
		public function ComponentDescription(element:Object = null):void {
			if (element) {
				name = NameUtil.getUnqualifiedClassName(element);
				className = getQualifiedClassName(element);
				instance = element;
			}
		}
		
		/**
		 * Layer name
		 * */
		public var name:String;
		
		/**
		 * Folder name if part of a folder
		 * */
		public var folderName:String;
		
		/**
		 * Qualified class name
		 * */
		public var className:String;
		
		/**
		 * Class used to create component instance
		 * */
		public var classType:Object;
		
		/**
		 * Class or path to icon
		 * */
		public var icon:Object;
		
		/**
		 * Info about a layer if imported from a file 
		 * */
		public var layerInfo:Object;
		
		/**
		 * Default properties
		 * */
		public var defaultProperties:Object;
		
		/**
		 * Default styles
		 * */
		public var defaultStyles:Object;
		
		/**
		 * User defined styles
		 * */
		public var userStyles:String;
		
		/**
		 * Creates a snapshot of the selected component and sets it as a background to the element.
		 * Use this to compare the background design spec with the crap you've come up with.
		 * */
		public var createBackgroundSnapshot:Boolean;
		
		
		/**
		 * Creates an image of the selected component and adds it in the exact place and size 
		 * of the original component. Doesn't always work with auto layout scenarios..
		 * */
		public var convertElementToImage:Boolean;
		
		/**
		 * Properties
		 * */
		public var properties:Object;
		
		/**
		 * Styles
		 * */
		public var styles:Object;
		
		/**
		 * Instance of component. Optional. 
		 * Used for display list
		 * */
		public var instance:Object;
		
		/**
		 * Is IVisualElementContainer
		 * */
		public function get isVisualElementContainer():Boolean {
			if (instance) {
				return instance is IVisualElementContainer;
			}
			
			// we may need to find a way to check this from the class type
			// if instance is not set
			return false;
		}
		
		/**
		 * Is IGraphicElement
		 * */
		public function get isGraphicElement():Boolean {
			if (instance) {
				return instance is IGraphicElement;
			}
			
			// we may need to find a way to check this from the class type
			// if instance is not set
			return false;
		}
		
		/**
		 * Get invalidating sprite (display object) used by GraphicElements.
		 * 
		 * If not added to the stage this may be null
		 * 
		 * */
		public function getInvalidatingSprite():Sprite {
			if (isGraphicElement) {
				return Sprite(IGraphicElement(instance).displayObject);
			}
			
			return null;
		}
		
		/**
		 * Children. Optional. 
		 * Used for display in hierarchy view such as Tree.
		 * */
		public var children:ArrayCollection;
		
		/**
		 * If true then during export child components are exported
		 * Default is true.
		 * */
		public var exportChildDescriptors:Boolean = true;
		
		/**
		 * Parent in the component hierarchy. This is different than the 
		 * display list hierarchy.
		 * */ 
		public var parent:ComponentDescription;
		
		/**
		 * Skin class. If it doesn't exist the component 
		 * may not be able to be added to the display list.
		 * */
		public var skin:Class;
		
		/**
		 * Used to store if the instance is visible.
		 * Does not check if an ancestor is visible 
		 * @see parentVisible
		 * */
		public var visible:Boolean = true;
		
		/**
		 * Used to store if an ancestor is not visible.
		 * Manually set
		 * */
		public var parentVisible:Boolean = true;
		
		/**
		 * Indicates if the component is locked from interaction. 
		 * */
		public var locked:Boolean = false;
		
		/**
		 * Inspector class name.
		 * */
		public var inspectorClassName:String;
		
		/**
		 * Inspector class.
		 * */
		public var inspectorClass:Class;
		
		/**
		 * Instance of inspector class. 
		 * */
		public var inspectorInstance:UIComponent;
		
		/**
		 * Cursors
		 * */
		public var cursors:Dictionary;
		
		/**
		 * XML representation of the current instance markup
		 * */
		public var markupData:String;
		
		/**
		 * XML representation of the export markup after preprocessors have run
		 * */
		public var processedMarkupData:String;
		
		/**
		 * XML representation of the current instance styles
		 * */
		public var stylesData:String;
		
		/**
		 * XML representation of the export styles after preprocessors have run
		 * */
		public var processedStylesData:String;
		
		/**
		 * List of preprocessors to run on export
		 * */
		public var preprocessors:Array = [];
		
		/**
		 * Gets an instance of the inspector class or null if the definition is not found.
		 * */
		public function getInspectorInstance():UIComponent {
			var classFactory:ClassFactory;
			var hasDefinition:Boolean;
			var component:Object;
			var classType:Object;
			
			if (!inspectorInstance) {
				hasDefinition = ApplicationDomain.currentDomain.hasDefinition(inspectorClassName);
				
				if (hasDefinition) {
					classType = ApplicationDomain.currentDomain.getDefinition(inspectorClassName);
					
					// Create component to drag
					classFactory = new ClassFactory(classType as Class);
					//classFactory.properties = defaultProperties;
					inspectorInstance = classFactory.newInstance();
				
					
				}
				else {
					return null;
				}
			
			}

			return inspectorInstance;
			
		}
		
		/**
		 * Get a clone of this object
		 * */
		public function clone():ComponentDescription {
			var item:ComponentDescription = new ComponentDescription();
			item.className = className;
			item.classType = classType;
			item.cursors = cursors;
			item.defaultProperties = defaultProperties;
			item.defaultStyles = defaultStyles;
			item.icon = icon;
			item.inspectorClass = inspectorClass;
			item.inspectorClassName = inspectorClassName;
			item.inspectorInstance = inspectorInstance;
			item.name = name;
			item.parent = parent;
			item.parentVisible = parentVisible;
			item.visible = visible;
			item.styles = styles;
			item.skin = skin;
			item.properties = properties;
			item.locked = locked;
			item.preprocessors = preprocessors;
			item.processedMarkupData = processedMarkupData;
			item.processedStylesData = processedStylesData;
			item.stylesData = stylesData;
			//item.propertyNames = propertyNames; read only
			//item.styleNames = styleNames;
			item.markupData = markupData;
			//item.styleData = styleData;
			
			return item;
		}
		
		
		/**
		 * Get an array of properties used by this instance
		 * */
		public function get propertyNames():Array {
			var _propertyNames:Array = [];
			
			for (var name:String in properties)  {
				_propertyNames.push(name);
			}
			
			return _propertyNames;
		}
		
		/**
		 * Get an array of styles used by this instance
		 * */
		public function get styleNames():Array {
			var _styleNames:Array = [];
			
			for (var name:String in styles)  {
				_styleNames.push(name);
			}
			
			return _styleNames;
		}
	}
}