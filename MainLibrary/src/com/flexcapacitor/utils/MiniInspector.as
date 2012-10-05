	package com.flexcapacitor.utils {
	
	import flash.debugger.enterDebugger;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.text.Font;
	import flash.text.TextFormat;
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;
	
	import mx.collections.ArrayList;
	import mx.core.EventPriority;
	import mx.core.FlexGlobals;
	import mx.core.IMXMLObject;
	import mx.core.IVisualElement;
	import mx.core.IVisualElementContainer;
	import mx.core.UIComponent;
	import mx.managers.ISystemManager;
	import mx.managers.SystemManager;
	import mx.styles.CSSCondition;
	import mx.styles.CSSConditionKind;
	import mx.styles.CSSStyleDeclaration;
	import mx.styles.IStyleClient;
	import mx.styles.IStyleManager2;
	import mx.styles.StyleManager;
	import mx.utils.NameUtil;
	
	import spark.components.Application;

	/**
	 * Dispatched when pressing the ALT key. Use to get the target under the mouse or the lastComponentItem. 
	 * */
	[Event(name="click", type="flash.events.MouseEvent")]
	
	/**
	 * At runtime it will display information about the object you click on in the console. 
	 * It also lets you manually fade in and out a bitmap image.<br/><br/>
	 * 
	 * Click anywhere on the application while pressing the CTRL / COMMAND key and 
	 * information about the object under the mouse (that is also in the component tree excluding the skin) will be written to the console.<br/><br/>
	 * 
	 * Click anywhere on the application while pressing CTRL / CMD + SHIFT key and 
	 * information about the object under the mouse (that is in the component tree OR in the skin) will be written to the console.<br/><br/>
	 * 
	 * Adding the ALT key to the above keyboard shortcuts will cause you to enter the debugger 
	 * during a click handler event to inspect the properties and values of the item you clicked.<br/><br/>
	 * 
	 * The information output to the console includes a way to find the object in Eclipse. <br/>
	 * It will create a search pattern using a regular expression that will locate the document the object is defined in. 
	 * This is used with the Eclipse Search in Files dialog.<br/><br/>
	 * 
	 * To use find in files:<br/>
	 * • Open the Search in Files dialog (CTRL + H)<br/>
	 * • Copy the created pattern from the console and paste it into the search text input<br/>
	 * • select regular expression checkbox <br/>
	 * • select current workspace or project<br/>
	 * • click search.<br/><br/>
	 * 
	 * Note: If it has an ID it will find it quickly. If it doesn't it will narrow it down and in most cases still find it. <br/><br/>
	 * 
	 * Mini Inspector Usage<br/>
	 * Add the class to the declarations tag usually in the root application like so,<br/><br/>
	 * 
	 * &lt;utils:MiniInspector /><br/><br/>
	 * 
	 * To use the image fade in fade out:<br/>
	 * 
	 * • Add an image to your component for example, <br/>
	 * &lt;s:BitmapImage id="image" source="mockup.png" /><br/><br/>
	 * • Set the background image property to the image like so, <br/>
	 *  &lt;utils:MiniInspector backgroundImage="{image}"/><br/><br/>
	 * • Run the application<br/>
	 * • While holding COMMAND / CTRL scroll the mouse wheel up or down. <br/><br/>
	 * 
	 * More information at http://code.google.com/p/flexcapacitor/
	 * */
	public class MiniInspector extends EventDispatcher implements IMXMLObject {
		
		
		public static const DEFAULT_FACTORY:String = "Theme Type Declaration";
		public static const FACTORY_FUNCTION:String = "Type Declaration";
		public static const OVERRIDE:String = "Inline";
		
		private var _alpha:Number;
		private var _enabled:Boolean = true;
		private var _backgroundImage:IVisualElement;
		
		/**
		 * Message to output to the console
		 **/
		public var message:String = "";
		
		/**
		 * Flag indicating if the url starts with "http"
		 * */
		public var isOnServer:Boolean;
		
		/**
		 * Shows display object information instead of component information
		 * Does not work at this time
		 * */
		public var showDisplayObjectInformation:Boolean = true;
		
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
		public  var minimumStyleNamePadding:int = 35;
		
		/**
		 * Shows style inheritance information
		 * 
		 * @see #showUniversalStyles
		 * @see #showGlobalStyles
		 * */
		public var showStyleInheritanceInformation:Boolean = true;
		
		/**
		 * Show embedded fonts information
		 * @see includeEmbeddedFontDetails 
		 * */
		public var showEmbeddedFontInformation:Boolean;
		
		/**
		 * Show embedded fonts information for the font famiily when showing style information
		 * */
		public var includeEmbeddedFontDetails:Boolean = true;
		
		/**
		 * Show document information
		 * */
		public var showDocument:Boolean = true;
		
		/**
		 * Show parent document information
		 * */
		public var showParentDocument:Boolean = true;
		
		/**
		 * Show regular expression search pattern in console when checking target. 
		 * This is used to find the target in Eclipse.
		 * Copy the value and paste it into the Find or Search window with RegExp option checked.
		 * */
		public var showSearchPattern:Boolean = true;
		
		/**
		 * Shows the path of the target clicked excluding components in the skin.
		 * This shows the path from the component to the root component.
		 * 
		 * For example, if you click a label in a skin the path will start from
		 * the component that owns the button not the button itself.
		 * 
		 * Example:
		 * Button > Group > Application
		 * 
		 * @see showHeirarchy
		 * */
		public var showHeirarchy:Boolean = true;
		
		/**
		 * Show the path from the target up the display list or component display list
		 * in an ascending order. Default is true.
		 * */
		public var showHeirarchyAscending:Boolean = true;
		
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
		 * Sets the alpha of the background image
		 * @see backgroundImage
		 * */
		public var backgroundImageAlpha:Number;
		
		/**
		 * Amount of alpha to change when scrolling the mouse wheel
		 * 
		 * @see backgroundImage
		 * @see backgroundImageAlpha
		 * */
		public var mouseWheelDelta:int;
		
		/**
		 * When an visual element is set and this option is enabled 
		 * and when the shift key is pressed scrolling up or down on the
		 * mouse wheel will increase or decrease the transparency of the 
		 * background image
		 * 
		 * @see backgroundImage
		 * @see backgroundImageAlpha
		 * */
		public var enableBackgroundCrossFade:Boolean = true;
		
		/**
		 * The amount to add to the mouse wheel delta to fade up or down the 
		 * transparency of the background image. 
		 * For example, if the delta is 4 and the multiplier is 10 then the amount 
		 * to add to the alpha value is .4 since 4/10. 
		 * Default is 20. 
		 * 
		 * @see backgroundImage
		 * @see backgroundImageAlpha
		 * @see mouseWheelDelta
		 * */
		public var multiplier:int = 20;
		
		/**
		 * Reference to the document set automatically when declared in MXML.
		 * If this class isn't declared in MXML then it is not set.
		 * You must set this manually if you want the path of the target to work
		 * when checking the target.
		 * */
		public var document:Object;
		
		/**
		 * ID of the reference to the document set automatically when declared in MXML.
		 * If this isn't declared in MXML then it is not set.
		 * */
		public var documentID:String;
		
		/**
		 * Flags used to set the "dot all" property to on for multiline support in Eclipse.
		 * Default value is "(?s)".
		 * */
		public var regExpSearchFlags:String = "(?s)";
		
		/**
		 * Last item selected in the component 
		 **/
		public var lastComponentItem:ComponentItem;
		
		/**
		 * 
		 **/
		public function MiniInspector() {
			var rootDisplay:DisplayObject = SystemManager.getSWFRoot(this);
			
			isOnServer = rootDisplay.loaderInfo.url.indexOf("http")==0 ? true : false;
			
			SystemManager.getSWFRoot(this).addEventListener(MouseEvent.CLICK, handleClick, true, EventPriority.CURSOR_MANAGEMENT, true);
		}
		
		public function initialized(document:Object, id:String):void {
			this.document = document;
			this.documentID = id;
		}
		
		/**
		 * Set this to an image or visual element on the stage. At runtime hold the COMMAND key and 
		 * scroll the mouse wheel up or down to fade the element in or out.
		 * */
		public function get backgroundImage():IVisualElement {
			return _backgroundImage;
		}

		public function set backgroundImage(value:IVisualElement):void {
			_backgroundImage = value;
			
			// this does something
			if (_backgroundImage) {
				SystemManager.getSWFRoot(this).addEventListener(MouseEvent.MOUSE_WHEEL, mouseWheelHandler, true, 0, true);
			}
			else {
				SystemManager.getSWFRoot(this).removeEventListener(MouseEvent.MOUSE_WHEEL, mouseWheelHandler, true);
			}
			
		}
		
		/**
		 * Enables or disables this class
		 * */
		public function get enabled():Boolean {
			return _enabled;
		}

		public function set enabled(value:Boolean):void {
			_enabled = value;
			
			// enabled
			if (value) {
				SystemManager.getSWFRoot(this).addEventListener(MouseEvent.CLICK, handleClick, true, EventPriority.CURSOR_MANAGEMENT, true);
			}
			else {
				SystemManager.getSWFRoot(this).removeEventListener(MouseEvent.CLICK, handleClick, true);
			}
			
		}

		/**
		 * Click handler added to stage
		 * We only check the target if the alt key is down
		 * If the shift key is down also then we enter the debugger
		 * Press step into to bring the debugger to the check target method
		 * In that method you can check details in the target property
		 * */
		protected function handleClick(event:MouseEvent):void {
			
			if (enabled) {
				if (event.ctrlKey) {
					// we are intercepting this event so we can inspect the target
					// stop the event propagation
					event.stopImmediatePropagation();
					checkTarget(event);
				}
			}
		}
		
		/**
		 * Handler to increase or decrease the transparency of a visual element
		 * on a mouse wheel scroll event
		 * */
		protected function mouseWheelHandler(event:MouseEvent):void {
			
			if (enabled && enableBackgroundCrossFade && backgroundImage) {
				if (event.shiftKey || event.ctrlKey) {
					mouseWheelDelta = event.delta;
					_alpha = backgroundImage.alpha;
					
					_alpha = _alpha + mouseWheelDelta/multiplier;
					_alpha = _alpha>1?1:_alpha<0?0:_alpha;
					
					backgroundImage.alpha = _alpha;
					
					// prevent scrolling higher up the line
					event.stopImmediatePropagation();
				}
			}
		}
		
		/**
		 * Gets the current target and traces it to the console
		 * */
		public function checkTarget(event:MouseEvent):void {
			var rootComponent:ComponentItem = document ? createComponentTreeFromElement(document) : createComponentTreeFromElement(FlexGlobals.topLevelApplication);
			var componentItem:ComponentItem = getFirstParentComponentItemFromComponentTreeByDisplayObject(DisplayObject(event.target), rootComponent);
			var target:DisplayObject = event.target as DisplayObject; // original clicked on item as reported by the mouse event
			var componentTarget:Object = componentItem.target; // first component found to own the event.target that is also on the component tree
			var message:String = "";
			var styles:Array;
			
			if (showDisplayObjectInformation) {
				if (event.altKey) {
					message = getComponentDetails(componentItem.accessPath, true);
				}
				else {
					message = getComponentDetails(componentItem, false);
				}
			}
			else {
				// SHOW OPTION TO GET OBJECT IN DISPLAY LIST
				// -- NOT SUPPORTED YET
				//message = getDisplayObjectDetails(event.target);
			}
			
			// show styles
			if (showStyleInheritanceInformation) {
				if (message!="") message += "\n";
				if (event.shiftKey) {
					message += getStyleDetails(target, includeEmbeddedFontDetails);
				}
				else {
					message += getStyleDetails(componentTarget, includeEmbeddedFontDetails);
				}
			}
			
			// show embedded fonts
			if (showEmbeddedFontInformation) {
				if (message!="") message += "\n";
				message += getEmbeddedFontInformationDetails(componentTarget);
			}
			
			trace(message);
			lastComponentItem = componentItem;
			
			// add an event listener to this class and then get the lastComponentItem
			dispatchEvent(event);
			
			
			// The purpose of this is to check the properties on the target
			if (event.altKey) {
				
				// the debugger doesn't take you here until you press step into or step over
				trace("\n// Click your heels three times and step in...");
				
				// the target object contains the item you clicked on
				enterDebugger();
			}
		}
		
		/**
		 * Get's the style inheritance 
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
			
			// get style declarations
			classDeclarations = styleClient.getClassStyleDeclarations();
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
			
			if (classDeclarations.length>0) {
				
				for (var i:int;i<classDeclarations.length;i++) {
					var overrides:Object;
					var defaultFactoryInstance:Object;
					var factoryInstance:Object;
					var selectorType:String = "";
					var conditions:Array;
					var array:Array = [];
					var outputArray:Array = [];
					declaration = classDeclarations[i];
					array = [];
					
					// we could or should make this a method
					
					// this is from an mxml inline attribute being set or calling setStyle in actionscript
					if (declaration.overrides!=null) {
						styleItem = new CSSStyleDeclarationItem();
						styleItem.name = getStyleDeclarationDisplayName(declaration);
						styleItem.declaration = classDeclarations[i];
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
						styleItem.declaration = classDeclarations[i];
						targetStyleDeclarationsArray.push(styleItem);
						styleItem.type = FACTORY_FUNCTION;
						factoryInstance = new declaration.factory();
						array = getArrayFromObject(factoryInstance);
						array.sortOn(sortType);
						styleItem.styles = array;
					}
					
					// this is from the theme defaults.css - default type declaration
					if (declaration.defaultFactory!=null) {
						styleItem = new CSSStyleDeclarationItem();
						styleItem.name = getStyleDeclarationDisplayName(declaration);
						styleItem.declaration = classDeclarations[i];
						targetStyleDeclarationsArray.push(styleItem);
						styleItem.type = DEFAULT_FACTORY;
						defaultFactoryInstance = new declaration.defaultFactory();
						array = getArrayFromObject(defaultFactoryInstance);
						array.sortOn(sortType);
						styleItem.styles = array;
					}
				}
			}
			/*
			// add global styles 
			if (showGlobalStyles) {
				var globalDeclaration:CSSStyleDeclaration = styleManager.getStyleDeclaration("global");
				
				if (globalDeclaration) {
					styleItem = new CSSStyleDeclarationItem();
					styleItem.name = getStyleDeclarationDisplayName(globalDeclaration);
					styleItem.declaration = globalDeclaration;
					targetStyleDeclarationsArray.push(styleItem);
				}
			}
			
			// add universal styles
			if (showUniversalStyles) {
				var universalDeclaration:CSSStyleDeclaration = styleManager.getStyleDeclaration("*");
				
				if (universalDeclaration) {
					styleItem = new CSSStyleDeclarationItem();
					styleItem.name = getStyleDeclarationDisplayName(universalDeclaration);
					styleItem.declaration = universalDeclaration;
					targetStyleDeclarationsArray.push(styleItem);
				}
			}*/
			
			/*var length:int = targetStyleDeclarationsArray.length;
			
			
			for (var j:int=0;j<length;j++) {
				var overrides:Object;
				var defaultFactoryInstance:Object;
				var factoryInstance:Object;
				var selectorType:String = "";
				var conditions:Array;
				var array:Array = [];
				var outputArray:Array = [];
				var name:String = declaration.toString();
				
				styleItem = CSSStyleDeclarationItem(targetStyleDeclarationsArray[j]);
				declaration = styleItem.declaration;
				
				// get display name ie s|TextInput.MyStyle
				if (declaration.selector) {
					name = declaration.selector.toString();
					
					if (declaration.selector.conditions) {
						conditions = declaration.selector.conditions;
						
						for (var k:int;k<conditions.length;k++) {
							selectorType = CSSCondition(conditions[k]).kind + ":" + CSSCondition(conditions[k]).value;
						}
					}
				}
				
				// we should check for font embedding
				
				// check default factory
				// THEME default declaration
				defaultFactoryInstance = declaration.defaultFactory!=null ? new declaration.defaultFactory():null;
				
				if (styleItem.type==null && defaultFactoryInstance) {
					array = getArrayFromObject(factoryInstance, DEFAULT_FACTORY, selectorType);
					array.sortOn(sortType);
					outputArray = outputArray.concat(array);
				}
				
				// check factory - 
				// Application stylesheet type declaration
				factoryInstance = declaration.factory!=null ? new declaration.factory():null;
				
				if (factoryInstance) {
					array = array.concat(getArrayFromObject(factoryInstance, FACTORY_FUNCTION, selectorType));
					array.sortOn(sortType);
					outputArray = outputArray.concat(array);
				}
				
				// check overrides 
				// if working with a UIComponent and a style attribute is set inline in MXML 
				// or setStyle is called then the overrides are where they are held
				overrides = declaration.overrides;
				
				if (overrides) {
					array = array.concat(getArrayFromObject(overrides, OVERRIDE));
					array.sortOn(sortType);
					outputArray = outputArray.concat(array);
				}
				
				styleItem.styles = outputArray;
			}*/
			
			return targetStyleDeclarationsArray;
		}
		
		private function getStyleDeclarationDisplayName(declaration:CSSStyleDeclaration, showFullPath:Boolean = false):String
		{
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
								selectorType = declaration.selector.subject;
								
								if (lastDotLocation!=-1) {
									className = selectorType.substr(lastDotLocation+1);
									selectorType = className + "." + value;
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
		 * Gets details about the embedded fonts
		 * */
		public function getEmbeddedFontInformationDetails(target:Object):String {
			var styleItem:CSSStyleDeclarationItem;
			var component:UIComponent = target as UIComponent;
			var systemManager:ISystemManager = component ? component.systemManager : null;
			var dictionary:Dictionary = new Dictionary(true);
			var fontList:Array = Font.enumerateFonts();
			var length:int = fontList.length;
			var output:String = "";
			var fontObject:Object;
			var paddedName:String;
			var name:String;
			var font:Font;
			
			
			output = showConsoleDividerMarks ? "\n" + dividerMarks + "\n":"";
			output += "Embedded Fonts";
			output += showConsoleDividerMarks ? "\n" + dividerMarks + "\n":"";
			
			if (systemManager==null && FlexGlobals.topLevelApplication.systemManager) {
				output += systemManager==null ? "Warning: Target system manager is null. Using FlexGlobals top level application system manager\n" : "";  
				systemManager = FlexGlobals.topLevelApplication.systemManager;
			}
			else if (systemManager==null) {
				output += "Could not find system manager";
				return output;
			}
			
			for (var i:int;i<length;i++)
			{
				font = Font(fontList[i]);
				name = font.fontName;
				if (dictionary[name]==1) continue;
				dictionary[name] = 1;
				
				paddedName = padString(name, minimumStyleNamePadding);
				fontObject = getFontFamilyEmbedded(name, systemManager);
				
				output += "   " + paddedName;
				
				if (fontObject.embeddedCFF.length>0) {
					output += "Embedded CFF: " + fontObject.embeddedCFF.join(", ");
				}
				
				if (fontObject.embedded.length>0) {
					if (fontObject.embeddedCFF.length>0) {
						output+= "; ";
					}
					output += "Embedded: " + fontObject.embedded.join(", ");
				}
				
				output += "\n";
			}
			
			output += showConsoleDividerMarks && showFooterConsoleDividerMarks ? "\n" + dividerMarks + "\n" : "";
			
			
			return output;
		}
			
			
		
		/**
		 * Get's style details about the target such as font family, font weight, etc
		 * */
		public function getStyleDetails(target:Object, indicateEmbeddedFonts:Boolean = true):String {
			var styleItem:CSSStyleDeclarationItem;
			var component:UIComponent = target as UIComponent;
			var systemManager:ISystemManager = component ? component.systemManager : null;
			var output:String = "";
			var styles:Array;
			var stylesLength:int;
			
			
			output = showConsoleDividerMarks ? "\n" + dividerMarks + "\n":"";
			output += "Style Inheritance";
			output += showConsoleDividerMarks ? "\n" + dividerMarks + "\n":"";
			
			
			if (!(target as IStyleClient)) {
				output += "Target is not a style client";
				return output;
			}
			
			styles = getStyleInheritance(target as IStyleClient);
			stylesLength = styles.length;
			
			for (var i:int;i<stylesLength;i++) {
				styleItem = styles[i];
				output += styleItem.name + "\n";
				var items:Array = styleItem.styles;
				var itemsLength:int = items.length;
				var name:String;
				var value:String;
				var paddedName:String;
				var actualValue:*;
				
				for (var j:int=0;j<itemsLength;j++) {
					name = items[j].name;
					paddedName = padString(items[j].name, minimumStyleNamePadding);
					value = items[j].value;
					actualValue = items[j].value;
					
					// check for embedded font
					if (indicateEmbeddedFonts && name=="fontFamily") {
						var fontObject:Object = getFontFamilyEmbedded(value, systemManager);
						
						output += "   " + paddedName + "" + padString(value, Math.max(minimumStyleNamePadding, value.length+1));
						
						if (fontObject.embeddedCFF.stylesLength>0) {
							output += "EmbeddedCFF: " + fontObject.embeddedCFF.join(", ");
						}
						
						if (fontObject.embedded.stylesLength>0) {
							if (fontObject.embeddedCFF.stylesLength>0) {
								output+= "; ";
							}
							output += "Embedded: " + fontObject.embedded.join(", ");
						}
						
					}
					// check for color values
					else if (String(name).toLowerCase().indexOf("color")!=-1) {
						
						// single color
						if (!isNaN(actualValue)) {
							output += "   " + paddedName + "#" + padLeft(Number(value).toString(16), 6);;
						}
						// array of colors
						else if (actualValue && actualValue is Array && actualValue.length>0 && !isNaN(actualValue[0])) {
							for (var k:int;k<actualValue.length;k++) {
								if (!isNaN(actualValue[k])) { 
									actualValue[k] = "#" + padLeft(Number(actualValue[k]).toString(16), 6);
								}
							}
							output += "   " + paddedName + "" + actualValue;
						}
						// false alarm
						else {
							output += "   " + paddedName + "" + value;
						}
						
					}
					// check for skin classes
					else if (name && value && actualValue is Class) {
						var className:String = value ? getQualifiedClassName(actualValue) : "";
						output += "   " + paddedName + "" + padString(value, minimumStyleNamePadding) + className;
					}
					else {
						output += "   " + paddedName + "" + value;
					}
					
					output += "\n";
				}
				
			}
			
			output += showConsoleDividerMarks && showFooterConsoleDividerMarks ? "\n" + dividerMarks + "\n" : "";
			
			
			return output;
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
		public function getFontFamilyEmbedded(name:String, systemManager:ISystemManager):Object {
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
		public function isFontFaceEmbeddedCFF(textFormat:TextFormat, systemManager:ISystemManager):Boolean
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
			
			/*if (!fontName ||
				!systemManager.embeddedFontList ||
				!systemManager.embeddedFontList[fontName])
			{
				return false;
			}
			
			var info:Object = systemManager.embeddedFontList[fontName];
			
			return !((bold && !info.bold) ||
				(italic && !info.italic) ||
				(!bold && !italic && !info.regular));*/
			
		}

		
		/**
		 * 
		 **/
		protected function getArrayFromObject(object:Object):Array {
			var array:Array = [];
			
			for (var property:String in object) {
				var css:Object = {};
				css.name = property;
				css.value = object[property];
				array.push(css);
			}
			
			return array;
		}
		
		/**
		 * Adds a minimumn amount of spaces to a String if they don't have them.
		 * */
		private static function padString(value:String, length:int):String {
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
		 * Get item by name
		 * Not used at the moment.
		 **/
		public function getByName(root:*, member:String):* {
			var memlist:Array = member.split('.');
			var temp:* = root;
			
			for(var i:uint = 0; i < memlist.length; i++) {
				temp = temp[memlist[i]];
			}
			return temp;
		}

		/**
		 * Get's details about the target such as id, type, ancestors and search pattern
		 * */
		public function getComponentDetails(componentItem:ComponentItem, includeSkinComponents:Boolean = false):String {
			var searchPattern:String;
			var message:String = "";
			var document:Object;
			var name:String;
			var out:String;
			var item:Array;
			
			
			message = showConsoleDividerMarks ? "\n" + dividerMarks + "\n":"";
			message += "Target Information";
			message += showConsoleDividerMarks ? "\n" + dividerMarks + "":"";
			
			
			// describe component
			if (componentItem.id!=null) {
				message += "\n" + componentItem.id + " is a " + componentItem.name;
			}
			if (componentItem.name!=null) {
				message += "\nThe target is an instance of " + componentItem.name;
			}
			else {
				//message += "\nThe target is an instance of " + componentItem.name;
			}
			
			
			// get document
			if (showDocument) {
				if (componentItem.documentID!=null) {
					message += "\nIt's document " + componentItem.documentID + " is a " + componentItem.documentName;
				}
				else if (componentItem.documentName!=null) {
					message += "\nIt's document is an instance of " + componentItem.documentName;
				}
				else {
					//message += "\nIt's document is an instance of " + componentItem.documentName;
				}
			}
			
			
			// get document
			if (showDocument) {
				message += "\nIt's linked document " + getLinkedClassName(componentItem.document);
			}
			
			
			// get parent document
			if (showParentDocument) {
				
				if (componentItem.parentDocumentID!=null) {
					message += "\nIt's defined in " + componentItem.parentDocumentID + " which is a " + componentItem.parentDocumentName;
				}
				else if (componentItem.parentDocumentName!=null) {
					message += "\nIt's defined in an instance of " + componentItem.parentDocumentName;
				}
				else {
					//message += "\nIt's defined in an instance of " + componentItem.parentDocumentName;
				}
			}
			
			
			
			// show heirachy
			if (showHeirarchy) {
				out = getComponentPath(componentItem, showHeirarchyAscending);
				
				message += "\nIt's path is "+ out;
			}
			
			
			// show regexp to find in Eclipse
			if (showSearchPattern) {
				searchPattern = getRegExpSearchPattern(DisplayObject(componentItem.target), componentItem.parentDocumentName, false);
				
				if (componentItem.id) {
					message += "\nSearch in files with regexp " + searchPattern;
				}
				else {
					message += "\nSearch in files with regexp \"" + searchPattern + "\". Add an ID to it to get a better search pattern";
				}
			}
			
			
			message += showConsoleDividerMarks && showFooterConsoleDividerMarks ? "\n" + dividerMarks + "" : "";
			
			
			return message;
		}
		
		/**
		 * Gets the path up the component display list tree 
		  
		 Usage:
		 var string:String = getComponentPath(componentItem); // componentItem.instance is Button
		 
		 trace(string); // application > group > group > button
		 
		 * */
		public function getComponentPath(componentItem:ComponentItem, ascending:Boolean = false, separator:String = " > "):String {
			var items:Array = [];
			var out:String = "";
			
			while (componentItem) {
				items.push(componentItem.name);
				componentItem = componentItem.parent;
			}
			
			out = ascending ? items.join(separator) : items.reverse().join(separator);
			
			return out;
		}
		
		/**
		 * Get qualified class name of the target object
		 * */
		public function getQualifiedClassName(element:Object):String {
			var name:String = flash.utils.getQualifiedClassName(element);
			return name;
		}
		
		/**
		 * Get qualified class name of the target object
		 * */
		public function getLinkedClassName(element:Object):String {
			var name:String = flash.utils.getQualifiedClassName(element);
			name = "(" + name.replace("::",".") + ".as:0)";
			name += "(" + name.replace("::",".") + ".mxml:0)";
			return name;
		}
		
		/**
		 * Creates a component tree starting at the given element.
		 * Element being visual element like an Application, UIComponent or Rect.  
		 * */
		public function createComponentTreeFromElement(element:Object, parentItem:ComponentItem = null, depth:int = 0):ComponentItem {
			var item:ComponentItem;
			var childElement:IVisualElement;
			
			
			if (!parentItem) {
				parentItem = new ComponentItem(element);
				parentItem.children = new ArrayList();
				return createComponentTreeFromElement(element, parentItem);
			}
			
			
			// check for IVisualElementContainers and add their child elements
			if (element is IVisualElementContainer) {
				var visualElementContainer:IVisualElementContainer = IVisualElementContainer(element);
				var length:int = visualElementContainer.numElements;
				
				for (var i:int;i<length;i++) {
					childElement = visualElementContainer.getElementAt(i);
					item = new ComponentItem(childElement);
					item.parent = parentItem;
					
					parentItem.children.addItem(item);
					
					if (childElement is IVisualElementContainer && IVisualElementContainer(childElement).numElements>0) {
						item.children = new ArrayList();
						createComponentTreeFromElement(childElement, item, depth + 1);
					}
					
					
				}
			}
			
			return parentItem;
		}
		
		/**
		 * Given a component item tree and a target (most likely a UIComponent or display object) 
		 * we walk down through the component tree (parentItem and parentItem.children) 
		 * and find a match where the target matches the stored ComponentItem instance property. 
		 * 
		 * Note: the component tree is created by createComponentTreeFromElement();
		 * parentItem could be the root component tree object such as the Application or child group or container component
		 * 
		 * Call getComponentItemFromComponentTreeByDisplayObject
		 * */
		private function findComponentItemInParentItemByElement(target:Object, parentItem:ComponentItem, depth:int = 0):ComponentItem {
			var length:int = parentItem.children ? parentItem.children.length : 0;
			var possibleItem:ComponentItem;
			var itemFound:Boolean;
			
			if (target==parentItem.target) {
				return parentItem;
			}
			
			for (var i:int; i < length; i++) {
				var item:ComponentItem = parentItem.children.getItemAt(i) as ComponentItem;
				
				if (item && item.target==target) {
					itemFound = true;
					break;
				}
				
				if (item.children) {
					possibleItem = findComponentItemInParentItemByElement(target, item, depth + 1);
					
					if (possibleItem) {
						itemFound = true;
						item = possibleItem;
						break;
					}
				}
				
			}
			
			if (itemFound) return item;
			
			return null;
		}
		
		/**
		 * Find the component that owns the display object 
		 * AND is also on the component tree
		 * This method continues to walk up the display list / component tree until 
		 * it finds a component that owns the original display object then returns that component item
		 * The findComponentItemInParentItemByElement returns null 
		 * if it does not find the item in the given component tree
		 * If it does not find the owner of the display object it will keep a reference to it in the
		 * target property on the access path instance. 
		 * */
		public function getFirstParentComponentItemFromComponentTreeByDisplayObject(displayObject:DisplayObject, componentTree:ComponentItem):ComponentItem {
			var componentItem:ComponentItem;
			var displayPath:Array = [];
			var item:ComponentItem;
			
			
			// find the owner of a visual element that is also on the component tree
			while (displayObject) {
				componentItem = findComponentItemInParentItemByElement(displayObject, componentTree);
				
				if (componentItem) {
					if (displayPath.length>0) {
						componentItem.accessPath = displayPath[0];
						componentItem.subTarget = (displayPath[0] as ComponentItem).target;
					}
					else {
						componentItem.accessPath = componentItem;
					}
					return componentItem;
				}
				else {
					
					// accessPath
					item = new ComponentItem(displayObject);
					
					if (displayPath.length>0) {
						displayPath[displayPath.length-1].parent = item;
					}
					
					displayPath.push(item);
					
					
					// if we are here the display object is probably in a skin
					// if so we could create a tree / path until we get to the component item
					// something like displayObjectItem in the third argument
					// it would be accessPath
					if ("owner" in displayObject && displayObject['owner']!=null) {
						displayObject = Object(displayObject).owner as DisplayObjectContainer;
					}
					else {
						displayObject = displayObject.parent;
					}
					
				}
			}
			
			return componentItem;
		}
		
		/**
		 * With the given target it returns a regexp pattern that can be used to find it in the document, project or workspace
		 * If isScript is true it attempts to returns a pattern to find the exact instance in AS3
		 * The MXML pattern will find the instance with that ID. If the instance doesn't have an ID it will create a regexp that will narrow it down.
		 * 
		 * NOTE: Press CTRL + H to open the Search in Files dialog, paste the value in, check regular expression and press Find. 
		 * */
		public function getRegExpSearchPattern(target:DisplayObject, parentDocumentName:String = "", isScript:Boolean = false):String {
			var id:String = getIdentifier(target);
			var className:String = NameUtil.getUnqualifiedClassName(target);
			var applicationName:String;
			var pattern:String;
			var scriptPattern:String;
			
			if (id == null) {
				if (parentDocumentName) {
					applicationName = NameUtil.getUnqualifiedClassName(FlexGlobals.topLevelApplication);
					
					if (applicationName==parentDocumentName) {
						parentDocumentName = getSuperClassName(FlexGlobals.topLevelApplication);
					}
					
					// this finds the document tag then the tag name so something like Group ... :Button
					// the (?! is a positive look ahead. it matches a group after the main expression 
					pattern = regExpSearchFlags + "(?!:" + parentDocumentName + "(.)*:):" + className + " ";
					
				}
				return pattern;
			}
			else {
				pattern = className + "(.*)id\\s?=\\s?[\"|']" + id + "[\"|']";
				scriptPattern = id + ".addEventListener";
			}
			
			
			if (isScript) {
				return scriptPattern;
			}
			
			return pattern;
		}
		
		/**
		 * Gets the ID of the target object
		 * returns null if no ID is specified
		 * */
		public function getIdentifier(element:Object):String {
			var id:String;
			
			if (element && "id" in element) {
				id = element.id;
			}
			return id;
		}
		
		/**
		 * Get super class name of the target object
		 * */
		public function getSuperClassName(element:Object):String {
			var name:String = flash.utils.getQualifiedSuperclassName(element);
			if (name && name.indexOf("::")) {
				name = name.split("::")[name.split("::").length-1]; // i'm sure theres a better way to do this
			}
			
			return name;
		}
	}
}


import flash.display.DisplayObject;
import flash.utils.getQualifiedClassName;

import mx.collections.ArrayList;
import mx.styles.CSSStyleDeclaration;
import mx.utils.NameUtil;

/**
 * Describes the display object
 * */
class ComponentItem {
	
	
	public function ComponentItem(element:Object = null):void {
		
		if (element) {
			target = element;
			subTarget = element;
			className = getQualifiedClassName(element);
			name = NameUtil.getUnqualifiedClassName(element);
			id = "id" in element && element.id!=null ? element.id : null;

			document = "document" in element ? element.document : null;
			documentClassName = getQualifiedClassName(document);
			documentName = document ? NameUtil.getUnqualifiedClassName(document) : null;
			documentID = document && "id" in document && document.id!=null ? document.id : null;
			
			parentDocument = "parentDocument" in element ? element.parentDocument : null;
			parentDocumentClassName = getQualifiedClassName(parentDocument);
			parentDocumentName = parentDocument ? NameUtil.getUnqualifiedClassName(parentDocument) : null;
			parentDocumentID = parentDocument && "id" in parentDocument && parentDocument.id!=null ? parentDocument.id : null;
		}
	}
	
	/**
	 * ID
	 * */
	public var id:String;
	
	/**
	 * Unqualified class name
	 * */
	public var name:String;
	
	/**
	 * Qualified class name
	 * */
	public var className:String;
	
	/**
	 * Instance of component. 
	 * */
	public var target:Object;
	
	/**
	 * Original target from MouseEvent target event. Sometimes this is a sub component or skin part of an actual component.
	 * */
	public var subTarget:Object;
	
	/**
	 * Component that owns MouseEvent target event
	 * */
	public var componentTarget:Object;
	
	/**
	 * Document instance
	 * */
	public var document:Object;
	
	/**
	 * Document name
	 * */
	public var documentName:String;
	
	/**
	 * Document class name
	 * */
	public var documentClassName:String;
	
	/**
	 * Document ID
	 * */
	public var documentID:String;
	
	/**
	 * Parent document instance
	 * */
	public var parentDocument:Object;
	
	/**
	 * Document name
	 * */
	public var parentDocumentName:String;
	
	/**
	 * Document class name
	 * */
	public var parentDocumentClassName:String;
	
	/**
	 * Document ID
	 * */
	public var parentDocumentID:String;
	
	/**
	 * Children. Optional. 
	 * Used for display in heiarchy view such as Tree.
	 * */
	public var children:ArrayList;
	
	/**
	 * Parent
	 * */
	public var parent:ComponentItem;
	
	/**
	 * Accessed path from display object event to component.
	 * Used when determining the display object that was clicked
	 * */
	public var accessPath:ComponentItem;
	
}


/**
 * Describes the display object
 * */
class CSSStyleDeclarationItem extends CSSStyleDeclaration {
/**
 * 
 **/
public function CSSStyleDeclarationItem(element:Object = null):void {}
/**
 * 
 **/
public var name:String;
/**
 * 
 **/
public var declaration:CSSStyleDeclaration;
/**
 * 
 **/
public var styles:Array;
/**
 * 
 **/
public var type:String;

}
		