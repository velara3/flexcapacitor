




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
		
		public static var indentPattern:RegExp = /([\t ]*)(.+)$/gm;
		public static var singleOutdentPattern:RegExp = /^[\t ]{0,1}/gm;
		public static var doubleOutdentPattern:RegExp = /^[\t ]{0,2}/gm;
		public static var tripleOutdentPattern:RegExp = /^[\t ]{0,3}/gm;
		public static var outdentAllPattern:RegExp = /([\t ]*)(.+)$/gm;
		public static var whiteSpaceStartPattern:RegExp = /(^[\t ]*).*$/;
		public static var tabCountPattern:RegExp = /(^[\t ]*)/gm;
		
		/**
		 * The padLeft method creates a new string by concatenating enough leading 
		 * pad characters to an original string to achieve a specified total length. 
		 * This method enables you to specify your own padding character.
		 * */
		public static function padLeft(value:String="", digits:int = 2, character:String="0", isNumber:Boolean=false):String {
			var padding:String = "";
			var count:int = value.length;
			var position:int;
			
			if (isNumber) {
				position = value.lastIndexOf(".");
				count = position!=-1 ? digits - position : digits - count;
			}
			else {
				count = digits - count;
			}
			
			for (var i:int;i<count;i++) padding += character;
			
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
		public static function padString(value:String, amount:int):String {
			amount = amount - value.length;
			
			for (var i:int;i<amount;i++) {
				value += " ";
			}
			
			if (amount<0) {
				value = value.substr(0, amount);
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
			var count:int;
			
			if (tokenList==null || propertyList==null) { 
				return value;
			}
			
			count = tokenList.length;
			
			// loop through the tokens
			for (var i:int=0;i<count;i++) {
				
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
			var count:int = value.length;
			var char:String;
			
		    for (var i:int;i<count;i++) {
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
		 * Gets the tab count before non whitespace characters
		 * 
<pre>
var count:int = getTabCountBeforeContent("  Hello");
trace(count); // 1
</pre>
		 * */
		public static function getTabCountBeforeContent(input:String, allLines:Boolean = false):int {
			if (input==null || input=="") return 0;
			var result:Array = input.match(tabCountPattern);
			var matches:Array = result && result.length ? String(result[0]).match(/\t/g) : null;
			var count:int = matches ? matches.length : 0;
			return count;
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
			
			if (indentAmount==null || indentAmount=="") indentAmount = "\t";
			
			var indentedText:String = input.replace(indentPattern, indentAmount + "$1$2");
			return indentedText;
		}

		/**
		 * Outdent by one or more tabs
		 * 
<pre>
var outdented:String = outdent("	Hello World");
trace(outdented); // "Hello World"
var indented3Times:String = outdent("			Hello World", 2);
trace(indented3Times); // "	Hello World" - one indent left
</pre>
		 * */
		public static function outdent(input:String, outdentAmount:uint = 1):String {
			if (input==null || input=="") return "";
			
			var outdentedText:String;
			
			if (outdentAmount==1) {
				outdentedText = input.replace(singleOutdentPattern, "");
			}
			else if (outdentAmount==2) {
				outdentedText = input.replace(doubleOutdentPattern, "");
			}
			else if (outdentAmount==3) {
				outdentedText = input.replace(tripleOutdentPattern, "");
			}
			else {
				outdentedText = input.replace(new RegExp("^[\t ]{0," + outdentAmount + "}", "gm"), "");
			}
			
			return outdentedText;
		}
	}
}