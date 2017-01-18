package com.flexcapacitor.utils.supportClasses {
	
	/**
	 * Used to store data from the browser drag and drop of a file
	 * */
	public class FileData {
		
		public function FileData(value:Object = null) {
			
			if (value) {
				unmarshall(value);
			}
		}
		
		public var name:String;
		public var type:String;
		public var dataURI:String;
		public var data:Object;
		
		public function unmarshall(object:Object):FileData {
			if ("name" in object) {
				name = object.name;
			}
			if ("type" in object) {
				type = object.type;
			}
			if ("dataURI" in object) {
				dataURI = object.dataURI;
			}
			if ("data" in object) {
				data = object.data;
			}
			
			return this;
		}
	}
}