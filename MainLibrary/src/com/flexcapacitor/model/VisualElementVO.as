



/**
 * Used for display in the Outline view
 * */
package com.flexcapacitor.model {
	
	import com.flexcapacitor.utils.InspectorUtils;
	
	import flash.display.DisplayObjectContainer;
	
	import mx.collections.ArrayCollection;

	public class VisualElementVO {

		public var id:String;
		public var name:String;
		public var type:String;
		public var superClass:String;
		public var element:Object;
		public var children:ArrayCollection;
		public var parent:DisplayObjectContainer;
		public var label:String;

		public function VisualElementVO() {

		}

		public static function unmarshall(element:*):VisualElementVO {
			var vo:VisualElementVO = new VisualElementVO();
			
			vo.id = 		InspectorUtils.getIdentifier(element);
			vo.name = 		InspectorUtils.getName(element);
			vo.type = 		InspectorUtils.getClassName(element);
			vo.superClass = InspectorUtils.getSuperClassName(element);
			vo.element = 	element;
			vo.label =		vo.type;
			
			// get vo.children manually

			return vo;
		}
	}
}