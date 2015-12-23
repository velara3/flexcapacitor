




package com.flexcapacitor.utils {
	
	
	/**
	 * String utilities. 
	 * */
	public class StringUtils {
		
		/**
		 * Constructor
		 * */
		public function StringUtils() {
			
		}
		
		public static const TAB:String = "\t";
		public static const NEW_LINE:String = "\n";
		
		public static var indentPattern:RegExp = /([\t ]*)(.*)$/gm;
		public static var whiteSpaceStartPattern:RegExp = /(^[\t ]*).*$/;
		
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
		 * Adds a minimumn amount of spaces to a String if they don't have them.
		 * */
		public static function padString(value:String, length:int):String {
			length = length - value.length;
			
			for (var i:int;i<length;i++) {
				value += " ";
			}
			
			if (length<0) {
				value = value.substr(0, length);
			}
			return value;
		}
		
		/**
		 * Repeats the character the specified number of time.
		 * */
		public static function repeatCharacter(character:String = "", count:int = 0):String {
			var value:String = "";
			
			for (var i:int;i<count;i++) {
				value += character;
			}
			
			return value;
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
		
		/**
		 * Changes camel case to a human readable format. So helloWorld, hello-world and hello_world becomes "Hello World". 
		 * */
		public static function prettifyCamelCase(value:String=""):String {
			var value:String = '';
		    var output:String = "";
			var len:int = value.length;
			var char:String;
			
		    for (var i:int;i<len;i++) {
				char = value.charAt(i);
				
		        if (i==0) {
		            output += char.toUpperCase();
		        }
		        else if (char !== char.toLowerCase() && char === char.toUpperCase()) {
		            output += " " + char;
		        }
		        else if (char == "-" || char == "_") {
		            output += " ";
		        }
		        else {
		            output += char;
		        }
		    }
			
			return output;
		}
		
		/**
		 * Trims white space from before and after a string 
		 * */
		public static function trim(value:String=""):String {
			if (value==null) return "";
		    var output:String = value.replace(/^\s\s*/, "").replace(/\s\s*$/, "");
			
			return output;
		}
		
		
		/**
		 * Gets the tab or whitespace amount before a matching token
		 * 
<pre>
var whiteSpace:String = getWhiteSpaceBeforeContent("  Hello");
trace(whiteSpace); // "  "
</pre>
		 * */
		public static function getWhiteSpaceBeforeContent(input:String):String {
			if (input==null || input=="") return "";
			var whiteSpace:String = input.replace(whiteSpaceStartPattern, "$1");
			return whiteSpace;
		}
		
		
		/**
		 * Indent by one tab or a specific amount of white space
		 * 
<pre>
var indented:String = indent("Hello World");
trace(indented); // "	Hello World"
var indented:String = indent("Hello World", "		");
trace(indented); // "		Hello World"
</pre>
		 * */
		public static function indent(input:String, indentAmount:String = "\t"):String {
			if (input==null || input=="") return indentAmount;
			
			var indentedText:String = input.replace(indentPattern, indentAmount + "$1$2");
			return indentedText;
		}
	}
}