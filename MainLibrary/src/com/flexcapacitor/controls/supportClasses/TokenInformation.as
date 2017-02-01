
package com.flexcapacitor.controls.supportClasses {
	
	import com.flexcapacitor.model.MetaData;

	public class TokenInformation {
		
		public function TokenInformation() {
			
		}
		
		public var cursor:Object;
		public var token:Object;
		public var tagName:QName;
		public var uriTagName:QName;
		public var entity:String;
		public var classFound:Boolean;
		public var classObject:Object;
		public var attributeName:QName;
		public var qualifiedClassName:String;
		public var type:String;
		public var attributeMetaData:MetaData;
		public var classMetaData:MetaData;
		public var tokenType:String;
	}
}