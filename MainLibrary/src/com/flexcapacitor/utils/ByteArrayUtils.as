package com.flexcapacitor.utils {
	
	import flash.utils.ByteArray;
	
	import mx.utils.ArrayUtil;
	import mx.utils.Base64Decoder;
	import mx.utils.Base64Encoder;

	public class ByteArrayUtils {
		
		public function ByteArrayUtils() {
			
		}
		
		public static var debug:Boolean;
		
		
		/**
		 * Gets the position where either a single character or an array of hexidecimal values are found in a byte array
		 * */
		public static function getIndexOfValueInByteArray(byteArray:ByteArray, value:*, startPosition:int = 0, endPosition:int = 0, endian:String = null):int {
			var byte:uint;
			var byteString:String;
			var position:int;
			var matchIndex:int;
			var searchArray:Array;
			var searchByte:int;
			var searchByteString:String;
			var found:Boolean;
			var endOfFile:Boolean;
			var endIndex:uint;
			var debug:Boolean;
			var firstByte:uint;
			var firstByteString:String;
			var startIndex:uint;
			var searchArrayLength:int;
			var compareAsString:Boolean;
			
			if (value is String) {
				searchArray = String(value).split("");
				compareAsString = true;
			}
			else {
				searchArray = ArrayUtil.toArray(value);
			}
			
			if (endian) {
				byteArray.endian = endian;
			}
			
			if (startPosition>-1) {
				byteArray.position = startPosition;
			}
			
			if (searchArray && searchArray.length) {
				firstByte = searchArray[0];
				firstByteString = compareAsString ? searchArray[0] : String.fromCharCode(firstByte);
				searchArrayLength = searchArray.length;
			}
			else {
				return -1;
			}
			
			while (byteArray.bytesAvailable) {
				byte = byteArray.readUnsignedByte();
				
				if (!compareAsString && byte==firstByte) {
					debug ? trace("Byte:0x" + byte.toString(16) + " " + String.fromCharCode(byte)):void;
					
					for (var j:int = 1; j < searchArrayLength; j++) {
						byte = byteArray.readUnsignedByte();
						searchByte = searchArray[j];
						
						debug ? trace("Byte:0x" + byte.toString(16) + " " + String.fromCharCode(byte)):void;
						
						if (byte==searchByte) {
							if (j==searchArrayLength-1) {
								found = true;
								matchIndex = byteArray.position;
								startIndex = matchIndex - searchArrayLength;
								endIndex = matchIndex;
								
								debug ? trace("Match found at " + startIndex):void;
								
								break;
							}
						}
						
						if (byteArray.bytesAvailable==0) {
							endOfFile = true;
							break;
						}
					}
				}
					
				else if (compareAsString && String.fromCharCode(byte)==firstByteString) {
					debug ? trace("Byte:0x" + byte.toString(16) + " " + String.fromCharCode(byte)):void;
					
					for (j = 1; j < searchArrayLength; j++) {
						byteString = String.fromCharCode(byteArray.readByte());
						searchByteString = searchArray[j];
						
						debug ? trace("Byte:0x" + byte.toString(16) + " " + searchByteString):void;
						
						if (byteString==searchByteString) {
							if (j==searchArrayLength-1) {
								found = true;
								matchIndex = byteArray.position;
								startIndex = matchIndex - searchArrayLength;
								endIndex = matchIndex;
								
								debug ? trace("Match found at " + startIndex):void;
								
								break;
							}
						}
						
						if (byteArray.bytesAvailable==0) {
							endOfFile = true;
							break;
						}
					}
				}
				else {
					debug ? trace("Byte:0x" + byte.toString(16) + " " + String.fromCharCode(byte)):void;
				}
				
				if (found || endOfFile || (endPosition!=0 && byteArray.position>endPosition)) {
					break;
				}
			}
			
			if (found) {
				debug?trace("Found at position " + startIndex + ". It ends at " + endIndex):0;
			}
			else {
				debug?trace("Could not find what the value you're looking for in this here byte array"):0;
				matchIndex = -1;
			}
			
			return matchIndex;
		}
		
		
		/**
		 * Used to encode data
		 * */
		public static var base64Encoder:Base64Encoder;
		
		/**
		 * Used to decode data
		 * */
		public static var base64Decoder:Base64Decoder;
		
		/**
		 * Alternative base 64 encoder based on Base64. You must set this to the class for it to be used.
		 * */
		public static var Base64Encoder2:Object;
		
		/**
		 * Alternative base 64 decoder based on Base64. You must set this to the class for it to be used.
		 * */
		public static var Base64Decoder2:Object;
		
		public static var removeBase64HeaderPattern:RegExp = /.*base64,/si;
		public static var lineEndingsGlobalPattern:RegExp = /\n/g;
		
		/**
		 * Returns a byte array from a base 64 string. Need to remove the header text, ie "data:image/png;base64,"
		 * and possibly line breaks.
		 * 
		 * @param alternativeEncoder Set the static Base64Decoder2 property to an alternative decoder before calling this.
		 * @see #getBitmapDataFromByteArray()
		 * @see #getBase64ImageData()
		 * @see #getBase64ImageDataString()
		 * */
		public static function getByteArrayFromBase64(encoded:String, alternativeDecoder:Boolean = false, removeHeader:Boolean = true, removeLinebreaks:Boolean = true):ByteArray {
			var results:ByteArray;
			
			if (!alternativeDecoder) {
				if (!base64Decoder) {
					base64Decoder = new Base64Decoder();
				}
				
				if (removeHeader) {
					encoded = encoded.replace(removeBase64HeaderPattern, "");
				}
				
				if (removeLinebreaks) {
					encoded = encoded.replace(lineEndingsGlobalPattern, "");
				}
				
				base64Decoder.reset();
				base64Decoder.decode(encoded);
				results = base64Decoder.toByteArray();
				
				// if you get the following error then try removing the header or line breaks
				//    Error: A partial block (3 of 4 bytes) was dropped. Decoded data is probably truncated!
			}
			else {
				if (Base64Decoder2==null) {
					throw new Error("Set the static alternative base decoder before calling this method");
				}
				
				if (removeHeader) {
					encoded = encoded.replace(removeBase64HeaderPattern, "");
				}
				
				if (removeLinebreaks) {
					encoded = encoded.replace(lineEndingsGlobalPattern, "");
				}
				
				Base64Decoder2.reset();
				Base64Decoder2.decode(encoded);
				results = Base64Decoder2.toByteArray();
			}
			
			/*
			Error: A partial block (3 of 4 bytes) was dropped. Decoded data is probably truncated!
			at mx.utils::Base64Decoder/flush()[/Users/justinmclean/Documents/ApacheFlex4.15/frameworks/projects/framework/src/mx/utils/Base64Decoder.as:139]
			at mx.utils::Base64Decoder/toByteArray()[/Users/justinmclean/Documents/ApacheFlex4.15/frameworks/projects/framework/src/mx/utils/Base64Decoder.as:173]
			at com.flexcapacitor.utils::DisplayObjectUtils$/getByteArrayFromBase64()[/Users/monkeypunch/Documents/ProjectsGithub/flexcapacitor/MainLibrary/src/com/flexcapacitor/utils/DisplayObjectUtils.as:1673]
			*/
			
			return results as ByteArray;
		}
		
	}
}