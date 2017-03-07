package com.flexcapacitor.model
{
	
	/**
	 * Drag data
	 * */
	public class HTMLDragData {
		
		public function HTMLDragData(data:Object = null) {
			
			if (data) {
				unmarshall(data);
			}
		}
		
		public var dataURI:String;
		public var mimeType:String;
		public var name:String;
		
		public function unmarshall(object:Object):void {
			
			dataURI = object.dataURI;
			mimeType = object.type;
			name = object.name;
		}
	}
}