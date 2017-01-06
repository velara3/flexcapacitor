package com.flexcapacitor.utils {
	
	import flash.utils.ByteArray;
	
	import mx.utils.ArrayUtil;

	public class ByteArrayUtils {
		
		public function ByteArrayUtils() {
			
		}
		
		public static var debug:Boolean;
		
		
		/**
		 * Gets the position where either a single character or an array of hexidecimal values are found in a byte array
		 * */
		public function getIndexOfValueInByteArray(byteArray:ByteArray, value:*, startPosition:int = 0, endPosition:int = 0, endian:String = null):int {
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
				byte = byteArray.readByte();
				
				if (!compareAsString && byte==firstByte) {
					debug ? trace("Byte:0x" + byte.toString(16) + " " + String.fromCharCode(byte)):void;
					
					for (var j:int = 1; j < searchArrayLength; j++) {
						byte = byteArray.readByte();
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
	}
}