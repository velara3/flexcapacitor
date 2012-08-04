package com.flexcapacitor.utils.supportClasses {
	import flash.utils.getQualifiedClassName;
	
	import mx.collections.ArrayCollection;
	import mx.utils.NameUtil;
	
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
		 * 
		 * */
		public var locked:Boolean = false;
	}
}