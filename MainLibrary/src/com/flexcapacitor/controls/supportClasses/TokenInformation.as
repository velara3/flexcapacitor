
package com.flexcapacitor.controls.supportClasses {
	
	import com.flexcapacitor.model.MetaData;

	public class TokenInformation {
		
		public function TokenInformation() {
			
		}
		
		public var found:Boolean;
		public var idToken:TokenInformation;
		public var row:int;
		public var column:int;
		public var cursor:Object;
		public var value:String;
		public var innerValue:String;
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