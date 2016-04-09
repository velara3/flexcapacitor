package com.flexcapacitor.utils.supportClasses {
	import flash.system.ApplicationDomain;
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;
	
	import mx.collections.ArrayCollection;
	import mx.core.ClassFactory;
	import mx.core.UIComponent;
	import mx.utils.NameUtil;
	
	/**
	 * Contains information about components that are
	 * added or removed from the display list
	 * */
	[Bindable]
	public class ComponentDefinition {
		
		public function ComponentDefinition(element:Object = null):void {
			if (element) {
				name = NameUtil.getUnqualifiedClassName(element);
				className = getQualifiedClassName(element);
				instance = element;
			}
		}
		
		/**
		 * Unqualified class name
		 * */
		public var name:String;
		
		/**
		 * Qualified class name
		 * */
		public var className:String;
		
		/**
		 * Class used to create component instance
		 * */
		public var classType:Object;
		
		/**
		 * Qualified class name that will export HTML code
		 * */
		public var htmlClassName:String;
		
		/**
		 * Class used to create HTML element
		 * */
		public var htmlClassType:Object;
		
		/**
		 * Class used to override default HTML class object
		 * */
		public var customHTMLClassType:Object;
		
		/**
		 * Class or path to icon
		 * */
		public var icon:Object;
		
		/**
		 * Default properties
		 * */
		public var defaultProperties:Object;
		
		/**
		 * Default styles
		 * */
		public var defaultStyles:Object;
		
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
		 * Children. Optional. 
		 * Used for display in heiarchy view such as Tree.
		 * */
		public var children:ArrayCollection;
		
		/**
		 * Parent
		 * */ 
		public var parent:ComponentDefinition;
		
		/**
		 * Skin class. If it doesn't exist the component 
		 * may not be able to be added to the display list.
		 * */
		public var skin:Class;
		
		/**
		 * Used to indicate if this component type is shown in the components panel
		 * */
		public var enabled:Boolean = true;
		
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
		 * Inspector class names.
		 * */
		public var inspectors:Array;
		
		/**
		 * Inspector class name
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
		public function clone():ComponentDefinition {
			var item:ComponentDefinition = new ComponentDefinition();
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
				
			return item;
		}
	}
}