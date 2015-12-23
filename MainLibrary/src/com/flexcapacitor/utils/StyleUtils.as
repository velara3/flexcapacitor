




package com.flexcapacitor.utils {
	import com.flexcapacitor.utils.supportClasses.CSSStyleDeclarationItem;
	
	import mx.core.FlexGlobals;
	import mx.core.UIComponent;
	import mx.core.mx_internal;
	import mx.managers.ISystemManager;
	import mx.styles.CSSCondition;
	import mx.styles.CSSConditionKind;
	import mx.styles.CSSStyleDeclaration;
	import mx.styles.IAdvancedStyleClient;
	import mx.styles.IStyleClient;
	import mx.styles.IStyleManager2;
	import mx.styles.StyleManager;
	import mx.utils.ArrayUtil;
	import mx.utils.ObjectUtil;
	
	import spark.components.Application;
	
	/**
	 * Style utilities. 
	 * */
	public class StyleUtils {
		
		public function StyleUtils() {
			
		}
		
		public static const DEFAULT_FACTORY:String = "Theme Type Declaration";
		public static const FACTORY_FUNCTION:String = "Type Declaration";
		public static const OVERRIDE:String = "Inline";
		
		/**
		 * Shows styles from the "global" type declaration
		 *
		 * @see #showUniversalStyles
		 * @see #showStyleInheritanceInformation
		 * */
		public var showGlobalStyles:Boolean;
		
		/**
		 * Shows styles from the "*" type declaration
		 *
		 * @see #showGlobalStyles
		 * @see #showStyleInheritanceInformation
		 * */
		public var showUniversalStyles:Boolean;
		
		/**
		 * Minimum and maximumn amount of space to show style name in console in style name lookup
		 * */
		public var minimumStyleNamePadding:int = 35;
		
		/**
		 * Shows style inheritance information
		 *
		 * @see #showUniversalStyles
		 * @see #showGlobalStyles
		 * */
		public var showStyleInheritanceInformation:Boolean;
		
		/**
		 * Show embedded fonts information. 
		 * 
		 * Note: When on mobile remember that StageTextArea and StageTextInput
		 * skins do not allow embedded fonts. Use Spark mobile TextSkins instead.
		 * @see includeEmbeddedFontDetails
		 * */
		public var showEmbeddedFontInformation:Boolean;
		
		/**
		 * Space before some output text
		 * */
		public var prespace:String = "  ";
		
		/**
		 * Shows divider markers in the console when checking the target
		 * */
		public var showConsoleDividerMarks:Boolean = true;
		
		/**
		 * Divider markers in the console when checking the target
		 * */
		public var dividerMarks:String = "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~";
		
		/**
		 * Shows footer divider markers in the console when checking the target
		 * */
		public var showFooterConsoleDividerMarks:Boolean;
		
		/**
		 * Get's style details about the target such as font family, font weight, etc
		 * */
		public function getStyleDetails(target:Object, indicateEmbeddedFonts:Boolean = true, reverseOrder:Boolean = false):String {
			var styleItem:CSSStyleDeclarationItem;
			var component:UIComponent = target as UIComponent;
			var systemManager:ISystemManager = component ? component.systemManager : null;
			var output:String = "";
			var styles:Array;
			var stylesLength:int;
			var name:String;
			var value:String;
			var paddedName:String;
			var actualValue:*;
			var fontObject:Object;
			var fontWeight:String;
			var fontStyle:String;
			var fontLookup:String;
			var renderingMode:String;
			var items:Array;
			var itemsLength:int;
			/*
			
			output = showConsoleDividerMarks ? "\n" + dividerMarks + "\n":"";
			output += "Style Inheritance";
			output += showConsoleDividerMarks ? "\n" + dividerMarks + "\n":"";
			*/
			
			if (!(target as IStyleClient)) {
				output += "Target is not a style client";
				return output;
			}
			
			styles = getStyleInheritance(target as IStyleClient);
			stylesLength = styles.length;
			
			for (var i:int;i<stylesLength;i++) {
				styleItem = styles[i];
				output += styleItem.name + "\n";
				items = styleItem.styles;
				itemsLength = items.length;
				
				for (var j:int=0;j<itemsLength;j++) {
					name = items[j].name;
					paddedName = StringUtils.padString(items[j].name, minimumStyleNamePadding);
					value = items[j].value;
					actualValue = items[j].value;
					
					
					// check for embedded font
					if (indicateEmbeddedFonts && name=="fontFamily" && actualValue!==undefined) {
						fontObject = FontUtils.getFontFamilyEmbedded(value, systemManager);
						
						fontWeight = target.getStyle("fontWeight");
						fontStyle = target.getStyle("fontStyle");
						fontLookup = target.getStyle("fontLookup");
						renderingMode = target.getStyle("renderingMode");
						
						output += prespace + paddedName + "" + StringUtils.padString(value, Math.max(minimumStyleNamePadding, value.length+1));
						
						if (fontObject.embeddedCFF.length>0) {
							output += "EmbeddedCFF: " + fontObject.embeddedCFF.join(", ");
						}
						
						if (fontObject.embedded.length>0) {
							if (fontObject.embeddedCFF.length>0) {
								output+= "; ";
							}
							output += "Embedded: " + fontObject.embedded.join(", ");
						}
						
					}
						// check for color values
					else if (String(name).toLowerCase().indexOf("color")!=-1) {
						
						// single color
						if (!isNaN(actualValue)) {
							output += prespace + paddedName + "#" + StringUtils.padLeft(Number(value).toString(16), 6);;
						}
							// array of colors
						else if (actualValue && actualValue is Array && actualValue.length>0 && !isNaN(actualValue[0])) {
							for (var k:int;k<actualValue.length;k++) {
								if (!isNaN(actualValue[k])) {
									actualValue[k] = "#" + StringUtils.padLeft(Number(actualValue[k]).toString(16), 6);
								}
							}
							output += prespace + paddedName + "" + actualValue;
						}
							// false alarm
						else {
							output += prespace + paddedName + "" + value;
						}
						
					}
						// check for skin classes
					else if (name && value && actualValue is Class) {
						var className:String = value ? ClassUtils.getQualifiedClassName(actualValue) : "";
						//output += prespace + paddedName + "" + StringUtils.padString(value, minimumStyleNamePadding) + className;
						output += prespace + paddedName + "" + className;
					}
					else {
						if (actualValue===undefined) {
							output += prespace + paddedName + "undefined";
						}
						else {
							output += prespace + paddedName + "" + value;
						}
					}
					
					output += "\n";
				}
				
			}
			
			output += showConsoleDividerMarks && showFooterConsoleDividerMarks ? "\n" + dividerMarks + "\n" : "";
			
			
			return output;
		}
		/**
		 * Returns if style is inherited or declared inline or set in actionscript with setStyle();
		 * */
		public static function isStyleDeclaredInline(styleClient:IStyleClient, styleName:String):Boolean {
			if (styleClient && 
				styleClient.styleDeclaration && 
				styleName in styleClient.styleDeclaration.overrides) {
				return true;
			}
			
			return false;
		}
		
		
		/**
		 * Get's the style inheritance
		 *
		 * Getting TextInput / TextArea pseudo conditions is experimental
		 * TextInput:normalWithPrompt etc
		 * the ordering of pseudo style declarations is still under development
		 * Also, doesn't get unqualified / unconditional styles so it will
		 * find "TextInput.myStyle" but not ".myStyle".
		 * */
		public function getStyleInheritance(styleClient:IStyleClient):Array {
			if (styleClient==null) return [];
			
			var className:String = styleClient.className;
			var targetStyleDeclarationsArray:Array = [];
			var classDeclarations:Array;
			var component:UIComponent = styleClient as UIComponent;
			var styleManager:IStyleManager2 = StyleManager.getStyleManager(component.moduleFactory);
			var styleItem:CSSStyleDeclarationItem;
			var applicationStyleManager:IStyleManager2 = Application(FlexGlobals.topLevelApplication).styleManager;
			var sortType:Array = ["name"];
			var declaration:CSSStyleDeclaration;
			var advancedStyleClient:IAdvancedStyleClient = styleClient as IAdvancedStyleClient;
			
			var hasPseudoCondition:Boolean = styleManager.hasPseudoCondition("normalWithPrompt");
			var hasAdvancedSelectors:Object = component.styleManager.hasAdvancedSelectors();
			
			var numberOfDeclarations:int;
			
			// get style declarations
			classDeclarations = styleClient.getClassStyleDeclarations();
			
			numberOfDeclarations = classDeclarations.length;
			
			
			// add pseudo selectors
			// experimental method to get TextInput / TextArea pseudo conditions
			// TextInput:normalWithPrompt etc
			// the ordering is still under development
			for (var ii:int=0;ii<numberOfDeclarations;ii++) {
				declaration = classDeclarations[ii];
				var subjects:Object = styleManager.getStyleDeclarations(declaration.subject);
				
				for (var subject:String in subjects) {
					var items:Array = ArrayUtil.toArray(subjects[subject]);
					
					for (var jj:int = 0;jj<items.length;jj++) {
						var item:CSSStyleDeclaration = items[jj];
						
						// the hard part is how to order them in???
						if (classDeclarations.indexOf(item)==-1) {
							log("Found advanced selector:" + item.mx_internal::selectorString);
							//item.setStyle("PSEUDO", ii);
							//classDeclarations.unshift(item);
							//classDeclarations.splice(ii, 0, item);
						}
					}
				}
			}
			
			classDeclarations.reverse();
			
			
			// add inline styles
			var styleDeclaration:CSSStyleDeclaration = styleClient.styleDeclaration;
			
			if (styleDeclaration) {
				classDeclarations.unshift(styleDeclaration);
			}
			
			// add global styles
			if (showGlobalStyles) {
				var globalDeclaration:CSSStyleDeclaration = styleManager.getStyleDeclaration("global");
				
				if (globalDeclaration) {
					classDeclarations.push(globalDeclaration);
				}
			}
			
			// add universal styles
			if (showUniversalStyles) {
				var universalDeclaration:CSSStyleDeclaration = styleManager.getStyleDeclaration("*");
				
				if (universalDeclaration) {
					classDeclarations.push(universalDeclaration);
				}
			}
			
			
			// feeble attempt to get rogue selectors like .myStyle
			// ie universal class selectors (or ID selectors?)
			var allSelectors:Array = styleManager.selectors;
			var styleClientMatches:Boolean;
			numberOfDeclarations = allSelectors.length;
			
			for (var aa:int;aa<numberOfDeclarations;aa++) {
				var selector:String = allSelectors[aa];
				declaration = styleManager.getStyleDeclaration(selector);
				
				if (declaration) {
					styleClientMatches = declaration.matchesStyleClient(styleClient as IAdvancedStyleClient);
				}
				
				if (styleClientMatches) {
					var indexOf:int = classDeclarations.indexOf(declaration);
					
					// the hard part is how to order them in???
					if (indexOf<0) {
						log("Found rogue selector:" + selector);
						//classDeclarations.unshift(declaration);
					}
				}
			}
			
			if (classDeclarations && classDeclarations.length>0) {
				
				for (var i:int;i<classDeclarations.length;i++) {
					var overrides:Object;
					var defaultFactoryInstance:Object;
					var factoryInstance:Object;
					var selectorType:String = "";
					var conditions:Array;
					var array:Array = [];
					var outputArray:Array = [];
					var skipDuplicate:Boolean = false;
					
					declaration = classDeclarations[i];
					
					
					// this is from an mxml inline attribute being set or calling setStyle in actionscript
					if (declaration.overrides!=null) {
						styleItem = new CSSStyleDeclarationItem();
						styleItem.name = getStyleDeclarationDisplayName(declaration);
						styleItem.declaration = declaration;
						targetStyleDeclarationsArray.push(styleItem);
						styleItem.type = OVERRIDE;
						overrides = declaration.overrides;
						array = getArrayFromObject(overrides);
						array.sortOn(sortType);
						styleItem.styles = array;
					}
					
					
					
					// this is from an applications stylesheet - type declaration (optionally matched by class or id)
					if (declaration.factory!=null) {
						styleItem = new CSSStyleDeclarationItem();
						styleItem.name = getStyleDeclarationDisplayName(declaration);
						styleItem.declaration = declaration;
						targetStyleDeclarationsArray.push(styleItem);
						styleItem.type = FACTORY_FUNCTION;
						factoryInstance = new declaration.factory();
						array = getArrayFromObject(factoryInstance);
						array.sortOn(sortType);
						styleItem.styles = array;
					}
					
					// prevent duplicates where the default factory and
					// and the factory instances create the same object
					// this is a result of the way we're looking up pseudo declarations
					if (factoryInstance && declaration.defaultFactory!=null) {
						defaultFactoryInstance = new declaration.defaultFactory();
						var result:Object = ObjectUtil.compare(factoryInstance, defaultFactoryInstance);
						
						// results are the same
						if (result==0) {
							skipDuplicate = true;
						}
					}
					
					// this is from the theme defaults.css - default type declaration
					if (declaration.defaultFactory!=null && !skipDuplicate) {
						styleItem = new CSSStyleDeclarationItem();
						styleItem.name = getStyleDeclarationDisplayName(declaration);
						styleItem.declaration = declaration;
						targetStyleDeclarationsArray.push(styleItem);
						styleItem.type = DEFAULT_FACTORY;
						defaultFactoryInstance = new declaration.defaultFactory();
						array = getArrayFromObject(defaultFactoryInstance);
						array.sortOn(sortType);
						styleItem.styles = array;
					}
				}
			}
			
			
			return targetStyleDeclarationsArray;
		}
		
		/**
		 * Show name of style declaration
		 * */
		public function getStyleDeclarationDisplayName(declaration:CSSStyleDeclaration, showFullPath:Boolean = false):String {
			var selectorType:String = "";
			var conditions:Array;
			var name:String;
			var packageName:String;
			var className:String;
			var typeSymbol:String;
			
			// get display name ie s|TextInput.MyStyle
			if (declaration.selector) {
				selectorType = declaration.selector.toString();
				
				if (!showFullPath) {
					var lastDotLocation:int = selectorType.lastIndexOf(".");
					
					if (lastDotLocation!=-1) {
						className = selectorType.substr(lastDotLocation+1);
						selectorType = className;
					}
				}
				
				
				if (declaration.selector.conditions) {
					conditions = declaration.selector.conditions;
					
					for (var i:int;i<conditions.length;i++) {
						var kind:String = CSSCondition(conditions[i]).kind;
						var value:String = CSSCondition(conditions[i]).value;
						
						if (kind==CSSConditionKind.CLASS) {
							
							if (!showFullPath) {
								lastDotLocation = declaration.selector.subject.lastIndexOf(".");
								selectorType = declaration.selector.toString();
								//selectorType = declaration.selector.subject;
								
								if (lastDotLocation!=-1) {
									className = selectorType.substr(lastDotLocation+1);
									//selectorType = className + "." + value;
									selectorType = className;
								}
								
							}
						}
						
					}
				}
			}
			else {
				selectorType = "inline";
			}
			
			return selectorType;
		}
		
		/**
		 * Log
		 **/
		public static function log(value:String):void {
			if (true) {
				trace(value);
			}
		}
		
		/**
		 * Get array of name value pair of all properties and values on an object
		 **/
		public static function getArrayFromObject(object:Object):Array {
			var array:Array = [];
			
			for (var property:String in object) {
				var css:Object = {};
				css.name = property;
				css.value = object[property];
				array.push(css);
			}
			
			return array;
		}
	}
}