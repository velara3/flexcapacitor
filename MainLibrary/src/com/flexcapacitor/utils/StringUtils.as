




package com.flexcapacitor.utils {
	import mx.formatters.StringFormatter;
	
	/**
	 * String utilities. 
	 * */
	public class StringUtils {
		
		/**
		 * Constructor
		 * */
		public function StringUtils() {
			
		}
		
		/**
		 * The padLeft method creates a new string by concatenating enough leading 
		 * pad characters to an original string to achieve a specified total length. 
		 * This method enables you to specify your own padding character.
		 * */
		public static function padLeft(value:String="", digits:int = 2, character:String="0", isNumber:Boolean=false):String {
			var padding:String = "";
			var length:int = value.length;
			var position:int;
			
			if (isNumber) {
				position = value.lastIndexOf(".");
				length = position!=-1 ? digits - position : digits - length;
			}
			else {
				length = digits - length;
			}
			
			for (var i:int;i<length;i++) padding += character;
			
			return padding + value;
		}
		
		/**
		 * The padRight method creates a new string by concatenating enough trailing 
		 * pad characters to an original string to achieve a specified total length. 
		 * This method enables you to specify your own padding character.
		 * */
		public static function padRight(value:String="", digits:int = 2, character:String="0"):String {
			var padding:String = "";
			var length:int = digits - value.length;
			
			for (var i:int;i<length;i++) padding += character;
			
			return value + padding;
		}
		
		/**
		 * Replace tokens enclosed in brackets with values in object.
		 * 
		 * Example, 
		 * var value:String = StringUtils.replace("The [name] is [description]", {name:"fox",description:"quick"}, ");
		 * 
		 * multiline = "m";
		 * global = "g";
		 * extended = "x";
		 * dotAll = "s";
		 * caseInsensitive = "i";
		 * */
		public static function replaceTokens(value:String, propertyBag:Object, flags:String="gm", excludeNullValues:Boolean = true, alternativeValue:String = null):String {
			var propertyPattern:RegExp = new RegExp("\\[(\\w*)\]", flags); // gets the properties "[name]" -> "name"
			var tokenPattern:RegExp = /(\[\w*])/gm; // gets the tokens like "[name]"
			var propertyList:Array = value.match(propertyPattern);
			var tokenList:Array = value.match(tokenPattern);
			var propertyValue:String;
			var property:String;
			var token:String;
			var length:int;
			
			if (tokenList==null || propertyList==null) { 
				return value;
			}
			
			length = tokenList.length;
			
			// loop through the tokens
			for (var i:int=0;i<length;i++) {
				
				property = String(propertyList[i]).replace(propertyPattern, "$1");
				token = tokenList[i];
				propertyValue = "";
				
				if (propertyBag.hasOwnProperty(property)) {
					propertyValue = String(propertyBag[property]).toString();
					
					if (propertyValue==null && excludeNullValues) continue;
					
					value = value.replace(token, propertyValue);
				}
				else if (propertyBag.hasOwnProperty("getStyle")) {
					propertyValue = String(propertyBag.getStyle(property)).toString();
					
					if (propertyValue!=null && propertyValue!="undefined") {
						value = value.replace(token, propertyValue);
					}
					else if (alternativeValue!=null) {
						value = value.replace(token, alternativeValue);
					}
					
				}
				else if (alternativeValue!=null) {
					value = value.replace(token, alternativeValue);
				}
			}
			
			return value;
		}
		
		
		/**
		 * Gets a word count
		 * */
		public static function getWordCount(value:String=""):int {
			
			return value.match(/\S+/g).length;
		}
	}
}