package com.flexcapacitor.model
{
	import flash.utils.ByteArray;
	
	import mx.utils.Base64Decoder;
	
	/**
	 * Contains information from the browser clipboard or paste event.
	 * Utility methods include getAsByteArray() and getAsString() to 
	 * convert data URI value into a byte array or a string.
	 * 
	 * Not all file types have a mime type registered
	 * That does not mean they are invalid. 
	 * Use a base64 to byte array class to convert the string value
	 * */
	public class HTMLClipboardData {
		
		public function HTMLClipboardData(data:Object = null, createByteArray:Boolean = false) {
			
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
		 * For example, "data:svg/xml;base64,abcdefghij"
		 * */
		public var dataURI:String;
		
		/**
		 * Mime type of the file as returned from the browser. 
		 * Sometimes this is null when the mime type is not registered
		 * */
		public var mimeType:String;
		
		/**
		 * Kind of the content as returned from the browser. 
		 * Not available in all browsers. 
		 * */
		public var kind:String;
		
		/**
		 * This is true if the mime type is not empty. 
		 * Not all file types have a mime type registered
		 * That does not mean they are invalid. 
		 * Use a base64 to byte array class to convert the string value
		 * */
		public var mimeTypeDefined:Boolean;
		
		/**
		 * Name and extension of the content or file if available
		 * Default is null. 
		 * */
		public var name:String;
		
		/**
		 * Original object
		 **/
		public var originalData:Object;
		
		/**
		 * Name of event if available.
		 **/
		public var eventName:String;
		
		/**
		 * Reference to error if error occurred.
		 **/
		public var error:Object;
		
		/**
		 * Size if available
		 **/
		public var size:String;
		
		/**
		 * List of types or formats of data in the clipboard during the paste event 
		 **/
		public var types:Array;
		
		/**
		 * List of items in the clipboard by name only. 
		 * Note: Some browsers do not allow access to clipboard items 
		 * Can only pass string between Flash and the container
		 * so only returning single file in data uri property 
		 * one event at a time at this time. 
		 **/
		public var clipboardItems:Array;
		
		/**
		 * List of files in the clipboard by name only. 
		 * Note: Some browsers do not allow access to clipboard files 
		 * Can only pass string between Flash and the container
		 * so only returning single file in data uri property 
		 * one event at a time at this time. 
		 **/
		public var clipboardFiles:Array;
		
		/**
		 * Number of nodes pasted or contained in an content editable element
		 **/
		public var numberOfNodes:int;
		
		/**
		 * Width of content if available
		 **/
		public var width:String;
		
		/**
		 * Height of content if available
		 **/
		public var height:String;
		
		/**
		 * Origin of data. 
		 **/
		public var origin:String;
		
		/**
		 * Index of item whether clipboard item, clipboard file or pasted element nodes
		 **/
		public var index:int;
		
		/**
		 * Number of files in the clipboard
		 **/
		public var numberOfFiles:int;
		
		/**
		 * Number of items in the clipboard
		 **/
		public var numberOfItems:int;
		
		/**
		 * Text value when pasted item is text/plain or text/html.
		 **/
		public var value:String;
		
		/**
		 * When data pasted is invalid. Check the error property and log for more info. 
		 **/
		public var invalid:Boolean;
		
		private var byteArray:ByteArray;
		
		/**
		 * Set the values from the event data. 
		 * Not all properties are available for each event. 
		 **/
		public function unmarshall(object:Object):void {
			dataURI = object.dataURI;
			name = object.name;
			
			// some file types do not return a mime type
			// so for example, a fxg file header is data:;base64,
			if (object.type!="" && object.type!=null) {
				mimeType = object.type;
				mimeTypeDefined = true;
			}
			
			if (object.kind!="" && object.kind!=null) {
				kind = object.kind;
			}
			
			error = object.error;
			eventName = object.eventType || object.eventName;
			
			types = object.types ? object.types : [];
			
			clipboardItems = object.clipboardItems ? object.clipboardItems : [];
			clipboardFiles = object.clipboardFiles ? object.clipboardFiles : [];
			
			originalData = object;
			
			width = object.width;
			height = object.height;
			
			numberOfFiles = object.numberOfFiles;
			numberOfItems = object.numberOfItems;
			index = object.index;
			
			numberOfNodes = object.numberOfNodes;
			origin = object.origin;
			
			value = object.value;
			invalid = object.invalid;
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
		public function getURIData(includeHeader:Boolean = false):String {
			var startIndex:int;
			var newData:String;
			
			if (dataURI==null) {
				return null;
			}
			
			if (includeHeader) {
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
		
		/**
		 * Get a string value from the data URI
		 **/
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
		
		/**
		 * Get extension of the file if it has one. Searches the name
		 * property for "." and returns the value after it. 
		 **/
		public function getExtension():String {
			var lastIndex:int;
			var extension:String;
			
			lastIndex = name ? name.lastIndexOf(".") : -1;
			extension = name ? name.substring(lastIndex+1) : null;
			
			return extension;
		}
	}
}