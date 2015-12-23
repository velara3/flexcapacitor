package com.flexcapacitor.utils {
	import flash.text.Font;
	import flash.text.TextFormat;
	import flash.utils.Dictionary;
	
	import mx.core.FlexGlobals;
	import mx.core.UIComponent;
	import mx.managers.ISystemManager;
	
	/**
	 * Makes working with fonts easier. 
	 * */
	public class FontUtils {
		
		public function FontUtils() {
			
		}
		
		public static var cachedFontList:Object;
		public static var matchFontStyles:RegExp = /\sbold\sitalic|\sbold|\sitalic|\sregular/gi;
		
		/**
		 * Instead of returning "Arial Bold" or "Arial Italic" we return just "Arial". 
		 * */
		public static function getSanitizedFontName(componentInstance:Object):String
		{
			var fontName:String = componentInstance.getStyle("fontFamily");
			fontName = fontName.replace(matchFontStyles, "");
			return fontName;
		}
		
		/**
		 * Given a font name we replace names like "Arial Bold" or "Arial Italic" with just "Arial". 
		 * */
		public static function sanitizeFontName(fontName:String):String {
			fontName = fontName.replace(matchFontStyles, "");
			return fontName;
		}
		
		/**
		 * Gets details about the embedded fonts
		 * */
		public static function getFontInformationDetails(target:Object, showDeviceFontInformation:Boolean = true):Array {
			var component:UIComponent = target as UIComponent;
			var systemManager:ISystemManager = component ? component.systemManager : null;
			var dictionary:Dictionary = new Dictionary(true);
			var fontList:Array = Font.enumerateFonts(showDeviceFontInformation);
			var numberOfFonts:int = fontList.length;
			var output:String = "";
			var filtered:Array = [];
			var fontObject:Object;
			var paddedName:String;
			var name:String;
			var font:Font;
			
			
			if (systemManager==null && FlexGlobals.topLevelApplication.systemManager) {
				output += systemManager==null ? "Warning: Target system manager is null. Using FlexGlobals top level application system manager\n" : "";
				systemManager = FlexGlobals.topLevelApplication.systemManager;
			}
			else if (systemManager==null) {
				output += "Could not find system manager";
				return [];
			}
			
			for (var i:int;i<numberOfFonts;i++) {
				font = Font(fontList[i]);
				name = font.fontName;
				
				if (dictionary[name]==1) {// there are duplicates
					//fontList.pop();
					continue;
				}
				
				dictionary[name] = 1;
				
				filtered.push(font);
				
				paddedName = name; //padString(name, minimumStyleNamePadding);
				fontObject = getFontFamilyEmbedded(name, systemManager);
				
				//output += prespace + paddedName;
				
				if (fontObject.embeddedCFF.length>0) {
					output += "Embedded CFF: " + fontObject.embeddedCFF.join(", ");
				}
				
				if (fontObject.embedded.length>0) {
					if (fontObject.embeddedCFF.length>0) {
						output+= "; ";
						output+= "Embedded    : ";
					}
					else {
						output+= "Embedded: ";
					}
					
					output += fontObject.embedded.join(", ");
				}
				
				output += "\n";
				
			}
			
			return filtered;
		}
		
		/**
		 * Returns an object that contains an array of embedding information for the font with the given name.
		 * Includes embedded and embeddedCFF information. If null then the font and that style of the font
		 * are not embedded.<br/><br/>
		 * Example, <br/>
		 * <pre>
		 * var object:Object = getFontFamilyEmbedded("MyFont", myButton.systemManager);
		 * trace(object); // {embedded:[regular, italic], embeddedCFF:[regular, bold, italic, boldItalic]}
		 * </pre>
		 **/
		public static function getFontFamilyEmbedded(name:String, systemManager:ISystemManager):Object {
			var textFormat:TextFormat = new TextFormat();
			var fontDescription:String = "";
			var embeddedCFF:Array = [];
			var embedded:Array = [];
			var boldItalic:Boolean;
			var regular:Boolean;
			var italic:Boolean;
			var bold:Boolean;
			
			textFormat.font = name;
			
			// check for regular
			regular = systemManager.isFontFaceEmbedded(textFormat);
			if (regular) {
				fontDescription = "regular";
				
				if (isFontFaceEmbeddedCFF(textFormat, systemManager)) {
					embeddedCFF.push(fontDescription);
				}
				if (!isFontFaceEmbeddedCFF(textFormat, systemManager)) {
					embedded.push(fontDescription);
				}
			}
			
			// check for bold
			textFormat.bold = true;
			bold = systemManager.isFontFaceEmbedded(textFormat);
			if (bold) {
				fontDescription = "bold";
				if (isFontFaceEmbeddedCFF(textFormat, systemManager)) {
					embeddedCFF.push(fontDescription);
				}
				if (!isFontFaceEmbeddedCFF(textFormat, systemManager)) {
					embedded.push(fontDescription);
				}
			}
			
			// check for bold and italic
			textFormat.italic = true;
			boldItalic = systemManager.isFontFaceEmbedded(textFormat);
			if (boldItalic) {
				fontDescription = "boldItalic";
				if (isFontFaceEmbeddedCFF(textFormat, systemManager)) {
					embeddedCFF.push(fontDescription);
				}
				if (!isFontFaceEmbeddedCFF(textFormat, systemManager)) {
					embedded.push(fontDescription);
				}
			}
			
			// check for italic
			textFormat.bold = false;
			italic = systemManager.isFontFaceEmbedded(textFormat);
			if (italic) {
				fontDescription = "italic";
				if (isFontFaceEmbeddedCFF(textFormat, systemManager)) {
					embeddedCFF.push(fontDescription);
				}
				if (!isFontFaceEmbeddedCFF(textFormat, systemManager)) {
					embedded.push(fontDescription);
				}
			}
			
			// there's probably alot of optimization that could go into this call
			// but for now we are using this
			
			return {embedded:embedded, embeddedCFF:embeddedCFF};
		}
		
		
		
		/**
		 * Checks if font is embedded and is also embeddedCFF.
		 * Does not run all methods system manager function runs.
		 */
		public static function isFontFaceEmbeddedCFF(textFormat:TextFormat, systemManager:ISystemManager):Boolean
		{
			var fontName:String = textFormat.font;
			var bold:Boolean = textFormat.bold;
			var italic:Boolean = textFormat.italic;
			
			var fontList:Array = Font.enumerateFonts();
			
			var n:int = fontList.length;
			for (var i:int = 0; i < n; i++)
			{
				var font:Font = Font(fontList[i]);
				if (font.fontName == fontName)
				{
					var style:String = "regular";
					if (bold && italic)
						style = "boldItalic";
					else if (bold)
						style = "bold";
					else if (italic)
						style = "italic";
					
					if (font.fontStyle == style ) {
						if (font.fontType=="embeddedCFF") {
							return true;
						}
						else {
							return false;
						}
					}
				}
			}
			
			return false;
		}
	}
}