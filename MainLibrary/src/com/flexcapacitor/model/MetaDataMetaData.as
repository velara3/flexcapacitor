
package com.flexcapacitor.model {
	import com.flexcapacitor.utils.StyleUtils;
	
	import mx.styles.IStyleClient;
	
	/**
	 * Contains information on style metadata. 
	 * For property metadata see AccessorMetaData
	 * */
	public class MetaDataMetaData extends MetaData {
		
		/**
		 * Constructor
		 * */
		public function MetaDataMetaData(item:XML = null, target:* = null) {
			if (item) unmarshall(item, target);
		}
		
		/**
		 * Import metadata XML Style node into this instance
		 * */
		override public function unmarshall(item:XML, target:* = null, getValue:Boolean = true):void {
			super.unmarshall(item, target, getValue);
			
			
			var args:XMLList = item.arg;
			var keyName:String;
			var keyValue:String;
			
			
			for each (var arg:XML in args) {
				keyName = arg.@key;
				keyValue = String(arg.@value);
				
				if (keyName=="" && name=="DefaultProperty") {
					if (keyName=="") {
						value = keyValue;
						textValue = keyValue;
						break;
					}
				}
			}
			
			//updateValues(target, getValue);
			
		}
		
		/**
		 * @inherit
		 * */
		override public function updateValues(target:Object, getValue:Boolean = true):void {
			super.updateValues(target, false);
		}
	}
}