package com.flexcapacitor.model
{
	import flash.utils.ByteArray;
	
	import mx.utils.Base64Decoder;
	
	/**
	 * Contains information from the browser container about the data dragged into it.
	 * 
	 * Not all file types have a mime type registered
	 * That does not mean they are invalid. 
	 * Use a base64 to byte array class to convert the string value
	 * Check the mimeType for value "invalid" for unsupported types. 
	 * */
	public class HTMLDragData {
		
		public function HTMLDragData(data:Object = null) {
			
			if (data) {
				unmarshall(data);
			}
		}
		
		/**
		 * Static reference to the base 64 decoder instance
		 * */
		public static var decoder:Base64Decoder;
		
		/**
		 * The data URI string of base64 encoded data. 
		 * It looks like "data:svg/xml;base64,abcdefghij"
		 * */
		public var dataURI:String;
		
		/**
		 * Mime type of the file as returned from the browser. 
		 * Sometimes this is null when the mime type is not registered
		 * or is "invalid". Check this property value for "invalid" when 
		 * you get drop event.  
		 * */
		public var mimeType:String;
		
		/**
		 * This is true if the mime type is not empty. 
		 * Not all file types have a mime type registered
		 * That does not mean they are invalid. 
		 * Use a base64 to byte array class to convert the string value
		 * */
		public var mimeTypeDefined:Boolean;
		
		/**
		 * Name and extension of the file
		 * */
		public var name:String;
		
		private var byteArray:ByteArray;
		
		public function unmarshall(object:Object):void {
			dataURI = object.dataURI;
			name = object.name;
			
			// some file types do not return a mime type
			// so for example, a fxg file header is data:;base64,
			if (object.type!="" && object.type!=null) {
				mimeType = object.type;
				mimeTypeDefined = true;
			}
		}
		
		/**
		 * Convenience function to check for various mime types
		 * */
		public function hasMimeType(value:String):Boolean {
			if (mimeTypeDefined && mimeType.indexOf(value)!=-1) {
				return true;
			}
			
			return false;
		}
		
		/**
		 * Convenience function to get the data uri without the header. 
		 * Header is the value before the first comma, "data:image/svg+xml;base64,"
		 * */
		public function getURIData(header:Boolean = false):String {
			var startIndex:int;
			var newData:String;
			
			if (dataURI==null) {
				return null;
			}
			
			if (header) {
				return dataURI;
			}
			
			startIndex = dataURI.indexOf(",");
			newData = dataURI.substring(startIndex+1);
			
			return newData;
		}
		
		/**
		 * Gets the value as a byte array
		 * */
		public function getByteArray():ByteArray {
			var data:String;
			
			if (decoder==null) {
				decoder = new Base64Decoder();
			}
			
			if (byteArray==null) {
				data = getURIData();
				decoder.decode(data);
				byteArray = decoder.toByteArray();
			}
			
			return byteArray;
		}
		
		public function getString():String {
			if (byteArray==null) {
				getByteArray();
			}
			else {
				byteArray.position = 0;
			}
			
			var stringValue:String = byteArray ? byteArray.readUTFBytes(byteArray.length) : "";
			return stringValue;
		}
		
		public function getExtension():String {
			var lastIndex:int;
			var extension:String;
			
			lastIndex = name ? name.lastIndexOf(".") : -1;
			extension = name ? name.substring(lastIndex+1) : null;
			
			return extension;
		}
	}
}