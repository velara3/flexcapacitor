



/**
 * Used to contain Visual Element display object information
 * */
package com.flexcapacitor.utils.supportClasses {
	
	import com.flexcapacitor.utils.ClassUtils;
	
	import flash.display.DisplayObjectContainer;
	
	import mx.collections.ArrayCollection;

	public class VisualElement {

		public var id:String;
		public var name:String;
		public var type:String;
		public var superClass:String;
		public var element:Object;
		public var children:ArrayCollection;
		public var parent:DisplayObjectContainer;
		public var label:String;

		public function VisualElement() {

		}

		public static function unmarshall(element:*):VisualElement {
			var visualElement:VisualElement = new VisualElement();
			
			visualElement.id = 			ClassUtils.getIdentifier(element);
			visualElement.name = 		ClassUtils.getName(element);
			visualElement.type = 		ClassUtils.getClassName(element);
			visualElement.superClass = 	ClassUtils.getSuperClassName(element);
			visualElement.element = 	element;
			visualElement.label =		visualElement.type;
			
			// get visualElement.children manually

			return visualElement;
		}
	}
}