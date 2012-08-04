

package com.flexcapacitor.utils {
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.utils.getQualifiedClassName;
	
	import mx.core.FlexGlobals;
	
	/**
	 * Traverses the display list and finds text matching a specified string
	 * Example found online - modified
	 * */
	public class FindText {

		public var currentLocation:int = 0;
		public var xml:XML;
		public static var staticInstance:FindText = new FindText();
		
		public function FindText() {
			
		}

	    public function findText(container:DisplayObjectContainer, xmlNode:* = "", depth:int = 0):String {
	        var currentNode:XML = new XML();
	        
	        if (xmlNode is XML) {
	        	currentNode = xmlNode;
	        }
	        else {
	        	xml = new XML("<"+application.name+"/>");
	        	currentNode = xml;
	        }
			
			var node:XML = new XML("<node/>");
	        var i:int = container.numChildren;

	        while (i--) {
	            var child:DisplayObject = container.getChildAt(i);
	            var className:String = getQualifiedClassName(child);
	            var packageName:String = className.split("::")[0];
	            className = className.split("::")[1];
	            if (className!="UITextField" || className!="TextField") continue;
	
				// highlight text
				// store locations 
				// select current instance
				
	            if (child is DisplayObjectContainer) {
	            	findText(DisplayObjectContainer(child), node, depth + 1);
	            }
	            
	        }
	        
	        if (depth==0) {
	        	trace(xml.toXMLString());
	        	return xml.toXMLString();
	        }
	        return "";
	    }
		
		public function get application():Object {
			return FlexGlobals.topLevelApplication;
		}
	}
}