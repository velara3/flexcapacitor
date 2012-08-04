

// Cleans up HTML from some locations like wordpress
// this is by no means a real HTML to FTML convert but a transient until TLF comes out
// 
// Usage 
// <!-- Declare a formatter and specify formatting properties. --> 
// <components:HTMLFormatter id="htmlFormatter"/> 
// <mx:Text width="100%" htmlText="Your wordpress content is {htmlFormatter.format(wordpressDescription)}"/> 


package com.flexcapacitor.formatters {
	
	import mx.core.FlexVersion;
	import mx.formatters.Formatter;
	import mx.utils.ObjectUtil;
	import mx.utils.StringUtil;
	import mx.utils.URLUtil;
	
	public class HTMLFormatterTLF extends Formatter {
		
		// add more here
		public var findLineBreaksPattern:RegExp = /\r?\n+?/g;
		public var strongStartPattern:RegExp = /<strong>/gi;
		public var strongEndPattern:RegExp = /<\/strong>/gi;
		public var emphasizedStartPattern:RegExp = /<em>/gi;
		public var emphasizedEndPattern:RegExp = /<\/em>/gi;
		public var underlineStartPattern:RegExp = /<u>/gi;
		public var underlineEndPattern:RegExp = /<\/u>/gi;
		
		// <span style="text-decoration: underline;">underline</span>
		public var spanUnderlinePattern:RegExp = /(<span[^>]+style="[^"]*)text-decoration:\s*underline;?([^"]*"[^>]*>)(.*?)(<\/span>)/gi;
		public var spanUnderlinePatternReplace:String = '$1$2<u>$3</u>$4';
		
		// remove span from underline 
		// <span style=";"><u>underline</u></span>
		// to <u>underline</u>
		public var spanUnderlinePatternEmpty:RegExp = /<span\s*style=";?"><u>(.*)<\/u><\/span>/gi;
		public var spanUnderlinePatternEmptyReplace:String = "<u>$1</u>";
		
		// <p style="text-align:left">
		// to <p align="left">
		public var styleAlignPattern:RegExp = /<p(.*)style="(.*)text-align:(.*)"(.*)>/gi;
		public var styleAlignPatternReplace:String = '<p$1style="$2$4" align="$3"$5>';
		
		// span styles
		// <span style="text-align:left;font-weight:bold;">
		// to <span class="class1" />
		public var stylesPattern:RegExp = /<(span|p)[^>]+style="([^"]*)"[^>]*>(.*?)(<\/span>)/i;
		
		// anchor
		// <a href="http://google.com">link</a>
		// to <a href="event:http://google.com">link</a>
		public var anchorPattern:RegExp = /<a([^>]+)href="([^"]*)"([^>]*)>(.*?)(<\/a>)/i;
		public var anchorPatternReplace:String = "<a$1href=\"event:$2\"$3>$4$5";
		
		public var imageTag:RegExp = /<img[^>]*>/gi;
		public var imageTagSource:RegExp = /<img[^>]*src="(?P<src>[^"]*)"[^>]*>/gim;
		public var imageTagSourceFind:RegExp = /<img ([^>]+)src="([^"]*)"([^>]*)>/gim;
		public var imageTagSourceReplace:String = "<img $1src=\"$2\" source=\"$2\"$3>";
		
		// remove and add id attribute
		public var imagesWithoutIdsPattern:RegExp = /<(img)\s+?(?!id=")([^>]*)>/i;
		public var imagesWithoutIdsPatternReplace:String = "<img $1>";
		public var removeImagesIdsPattern:RegExp = /<img([^>]+)id="[^"]*"([^>]*)>/gi;
		public var removeImagesIdsPatternReplace:String = "<img$1$2>";
		
		public var mediaHandlerLocation:String = "ImageMedia.swf";
		public var mediaHandlerParameter:String = "?url=";
		public var addMediaPattern:RegExp = /<(img)([^>]+)(src)="(?!ImageMedia.swf)([^"]*(jpg|png|gif))"([^>]*)>/gi;
		public var addMediaPatternReplace:String = "<$1$2$3=\"" + mediaHandlerLocation + "$4\"$6>";
		
		[Inspectable(category="General", defaultValue="true")]
		public var replaceUnderlineSpanWithUnderlineTag:Boolean = true;
		
		[Inspectable(category="General", defaultValue="true")]
		public var replaceStrongTags:Boolean = true;
		
		[Inspectable(category="General", defaultValue="true")]
		public var replaceEmphasizedTags:Boolean = true;
		
		[Inspectable(category="General", defaultValue="true")]
		public var replaceUnderlineTags:Boolean = true;
		
		[Inspectable(category="General", defaultValue="true")]
		public var replaceUnderlineSpan:Boolean = true;
		
		[Inspectable(category="General", defaultValue="true")]
		public var replaceLinebreaks:Boolean = true;
		
		[Inspectable(category="General", defaultValue="true")]
		public var replaceStyleAlignTags:Boolean = true;
		
		[Inspectable(category="General", defaultValue="true")]
		public var replaceListItems:Boolean = true;
		
		[Inspectable(category="General", defaultValue="true")]
		public var replaceStyles:Boolean = true;
		
		[Inspectable(category="General", defaultValue="true")]
		public var dispatchEventForAnchors:Boolean = true;
		
		[Inspectable(category="General", defaultValue="true")]
		public var changeSrcToSource:Boolean = true;
		
		// the TextAutoSize components have a cleanWordpressHTML property
		// when this is enabled we use get this instance as a sort of singleton
		// so there is only one instance created for the Text components when they need to use the format command
		// it is accessed like this HTMLFormatter.staticInstance.format(value);
		public static var staticInstance:HTMLFormatterTLF = new HTMLFormatterTLF();
		
		// array of classes
		// we convert styles to a class and then check if a class exists with the same styles
		public var classes:Array = [];
		
		// if we are using a TLF text area set this to true
		// defaults to true in Flex 4 and greater
		public var isTLF:Boolean = false;
		
		public var isFlex3:Boolean = FlexVersion.compatibilityVersionString=="3.0.0";
		
		
		public function HTMLFormatterTLF() {
			//TODO: implement function
			super();
			
			if (!isFlex3) {
				isTLF = true;
			}
			
		}
		
		// Override format()
		// default is to format HTML to Flash compatible HTML or TEXTFLOW (flash text markup language)
		// useful for fixing wordpress html
		// set formatString equal to "wordpress" or leave blank for default behavior
		override public function format(string:Object):String { 
			if (string==null) return "";
			var pattern:RegExp;
			var match:Array;
			var stylesObject:Object;
			var spanContent:String = "";
			var tagName:String = "";
			var value:String = "";
			var attributes:String = "";
			var tags:Array = [];
			var originalContent:String = "";
			var newString:String = "";
			var stylesString:String = "";
			
			if (string is XMLList) {
				string = string.toString();
			}
			
			// FOR TLF we need to replace a couple things
			// EMPHASIZED, BOLD, ITALIC, STRONG and UNDERLINE all need to be replaced or removed
			// to really convert this you need to convert things to an XML object then check 
			// through the tree and follow the rules (spans can only contain spans) 
			// read more news at 
			// http://corlan.org/2009/01/19/how-to-use-text-layout-framework-in-flex-32-or-air-15/
			
			// make sure first element is a DIV, P or TextFlow
			if (string.indexOf("<p")==-1 && string.indexOf("<div")==-1 && string.indexOf("<TextFlow")==-1) {
				
				// UPDATE: We may not have to do this
				//string = "<p>" + string + "</p>";
			}
			
			// replace linebreaks with <br> tags
			if (replaceLinebreaks) {
				string = string.replace(findLineBreaksPattern,"<br/>");
			}
			
			// replace Strong tags with bold tags
			if (replaceStrongTags) {
				string = string.replace(strongStartPattern,"<b>");
				string = string.replace(strongEndPattern,"</b>");
			}
			
			// replace Emphasized tags with italic tags
			if (replaceEmphasizedTags) {
				string = string.replace(emphasizedStartPattern,"<i>");
				string = string.replace(emphasizedEndPattern,"</i>");
			}
			
			// dispatch event for Anchor tags
			// adds "event:" to href
			// <a href="http://google.com">link</a>
			// to <a href="event:http://google.com">link</a>
			if (dispatchEventForAnchors) {
				string = string.replace(anchorPattern, anchorPatternReplace);
			}
			
			// change src to source on images 
			if (changeSrcToSource) {
				string = string.replace(imageTagSourceFind, imageTagSourceReplace);
			}
			
			// replace stuff
			// if paragraph replace styles with attributes
			match = string.match(stylesPattern);
			
			while (match!=null) {
				match = string.match(stylesPattern);
				if (match==null) continue;
				
				tags.length = 0;
				
				originalContent = (match.length>0) ? match[0] : "";
				tagName = (match.length>1) ? match[1] : "";
				stylesString = (match.length>2) ? match[2].replace(/:/g,"=") : "";
				stylesObject = (match.length>2) ? URLUtil.stringToObject(stylesString) : "";
				spanContent = (match.length>3) ? match[3] : "";
				
				// remove nulls and lowercase style names
				for (var style:String in stylesObject) {
					value = StringUtil.trim(stylesObject[style]);
					
					// check for and remove parameters with value of "=null;"
					if (style!="" && style!=null) {
						// create a lowercase property name
						delete(stylesObject[style]);
						stylesObject[style.toLowerCase()] = value;
					}
					else {
						delete(stylesObject[style]);
					}
					
				}
				
				// maybe should break these out into methods
				// if paragraph set attributes
				if (tagName.toLowerCase()=="p") {
					
					if (stylesObject.hasOwnProperty("color")) {
						// whatever don't care about paragraphs right now
					}
					newString = originalContent;
				}
					
				// if span set attributes and replace span with font
				else if (tagName.toLowerCase()=="span") {
					attributes = "";
					
					if (stylesObject.hasOwnProperty("color")) {
						attributes += " color=\""+value+"\"";
					}
					
					if (stylesObject.hasOwnProperty("font-family")) {
						attributes += " face=\""+value+"\"";
						
					}
					
					if (stylesObject.hasOwnProperty("font-size")) {
						attributes += " size=\""+value+"\"";
						
					}
					
					if (stylesObject.hasOwnProperty("text-align")) {
						attributes += " align=\""+value+"\"";
						
					}
					
					if (stylesObject.hasOwnProperty("text-decoration") ) {
						attributes += " textDecoration=\""+value+"\"";
					}
					
					if (stylesObject.hasOwnProperty("font-weight") ) {
						attributes += " fontWeight=\""+value+"\"";
					}
					
					// add custom tags
					for (var i:int = 0;i<tags.length;i++) {
						spanContent = "<"+tags[i]+">"+spanContent+"</"+tags[i]+">";
					}
					
					tagName = "span";
					
					newString = "<"+tagName+attributes+">"+spanContent+"</"+tagName+">";
				}
				
				string = string.replace(stylesPattern, newString);
				
			}
			
			// replace Text Align style with align attribute 
			// <p style="text-align:left"> to
			// <p align="left">
			if (replaceStyleAlignTags) {
				string = string.replace(styleAlignPattern, styleAlignPatternReplace);
			}
			
			// replace Underline span with Underline tags
			/*if (replaceUnderlineSpanWithUnderlineTag) {
				string = string.replace(spanUnderlinePattern, spanUnderlinePatternReplace);
				string = string.replace(spanUnderlinePatternEmpty, spanUnderlinePatternEmptyReplace);
			}*/
			
			// replace list items
			// TODO: do this
			if (replaceListItems) {
				pattern= /<\/li><li>/g;
				string = string.replace(pattern, "</LI><LI>");
				pattern= /<\/li><\/ul>/g;
				string = string.replace(pattern, "</LI>");
				pattern= /<ul><li>/g;
				string = string.replace(pattern, "<LI>");
			}
			
			// wrap in text flow tags
			//string = "<TextFlow xmlns=\"http://ns.adobe.com/textLayout/2008\">" + string + "</TextFlow>";
			
			if (string=="" || string==null) {
				return "<p></p>";
			}
			
			return String(string);
		}
		
		// not used
		// was going to be used to parse out styles and apply a class
		// this function would check if an exact same class (same styles) existed
		// if it did then return that class if not then create a new one
		// then pass that class back and assign it to the span or class
		public function addStylesToClass(styles:String):String {
			var o:Object = URLUtil.stringToObject(styles, null, false);
			var classFound:Boolean = false;
			var className:String = "";
			var stylesClass:Object;
			
			for (className in classes) {
				stylesClass = classes[className];
				
				if (ObjectUtil.compare(stylesClass, o)) {
					classFound = true;
					break;
				}
			}
			
			if (classFound) {
				return className;
			}
			else {
				className = "class" + classes.length;
				classes[className] = o;
			}
			return className;
		}
		
		
		public function getImageSource(string:String):String {
			if (string==null) { return ""; }
			
			var matches:Array = new Array();
			
			// get image src
			matches = imageTagSource.exec(string);
			string = (matches!=null && matches.hasOwnProperty("src")) ? matches.src : "";
			return string;
		}
		
		public function getImageHTML(string:String):String {
			if (string==null) { return ""; }
			
			var matches:Array;
			
			// get image html markup
			matches = string.match(imageTagSource);
			string = (matches.length > 0) ? matches[0] : "";
			
			return string;
		}
		
		// adds id's to image tags
		public function addImageIds(string:String, prefix:String = "loader", startingIndex:int = 0):String {
			if (string==null) return "";
			var originalContent:String = "";
			var beggining:String = "";
			var attributes:String = "";
			var name:String = "";
			var tag:String = "";
			var index:int = startingIndex;
			var match:Array;
			
			string = string.replace(removeImagesIdsPattern, removeImagesIdsPatternReplace);
			match = string.match(imagesWithoutIdsPattern);
			
			while (match!=null) {
				match = string.match(imagesWithoutIdsPattern);
				if (match==null) continue;
				
				originalContent = (match.length>0) ? match[0] : "";
				tag = (match.length>1) ? match[1] : "";
				attributes = (match.length>2) ? match[2] : "";
				name = prefix + index;
				string = string.replace(originalContent, "<" + tag + " id=\"" + name + "\" " + attributes + ">");
				index++;
			}
			
			return string;
		}
		
		// adds media handler to the src of image tags
		// for example, <img src="myImage.jpg"/> becomes:
		// <img src="ImageMedia.swf?url=myImage.jpg"/>
		public function addImageMediaHandler(string:String, mediaHandler:String = null, includeId:Boolean = true):String {
			if (string==null) return "";
			
			// add parameters to swf url
			if (mediaHandler!=null) {
				addMediaPatternReplace = addMediaPatternReplace.replace(mediaHandlerLocation, mediaHandler + mediaHandlerParameter);
			}
			else {
				addMediaPatternReplace = addMediaPatternReplace.replace(mediaHandlerLocation, mediaHandlerLocation + mediaHandlerParameter);
			}
			
			// replace src with swf reference
			string = string.replace(addMediaPattern, addMediaPatternReplace);
			
			return string;
		}
		
		// get the count of images
		public function getImageCount(string:String):int {
			
			var match:Array = string.match(imageTag);
			
			return match.length;
		}
		
		// get matches of images
		// get images only with id's doesn't work yet
		public function getImageMatches(string:String, withID:Boolean = false):Array {
			var matches:Array;
			
			// get images only with id's - doesn't work yet
			if (withID) {
				matches = string.match(imageTag);
			}
			else {
				matches = string.match(imageTag);
			}
			
			return matches;
		}
	}
}