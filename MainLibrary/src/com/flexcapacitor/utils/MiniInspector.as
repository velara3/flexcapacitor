package com.flexcapacitor.utils {
	
	import flash.debugger.enterDebugger;
	import flash.display.BitmapData;
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
	import mx.core.mx_internal;
	import mx.logging.ILogger;
	import mx.logging.Log;
	import mx.logging.LogEventLevel;
	import mx.logging.targets.TraceTarget;
	import mx.managers.ISystemManager;
	import mx.managers.SystemManager;
	import mx.styles.CSSCondition;
	import mx.styles.CSSConditionKind;
	import mx.styles.CSSStyleDeclaration;
	import mx.styles.IAdvancedStyleClient;
	import mx.styles.IStyleClient;
	import mx.styles.IStyleManager2;
	import mx.styles.StyleManager;
	import mx.utils.ArrayUtil;
	import mx.utils.NameUtil;
	import mx.utils.ObjectUtil;
	
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
	 * • Open the Search in Files dialog (CTRL + H)<br/>
	 * • Copy the created pattern from the console and paste it into the search text input<br/>
	 * • select regular expression checkbox <br/>
	 * • select current workspace or project<br/>
	 * • click search.<br/><br/>
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
	 * • Add an image to your component for example, <br/>
	 * &lt;s:BitmapImage id="image" source="mockup.png" /><br/><br/>
	 * • Set the background image property to the image like so, <br/>
	 * &lt;utils:MiniInspector backgroundImage="{image}"/><br/><br/>
	 * • Run the application<br/>
	 * • While holding COMMAND / CTRL scroll the mouse wheel up or down. <br/><br/>
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
		public var minimumStyleNamePadding:int = 35;
		
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
		 * Show device fonts information
		 * @see includeEmbeddedFontDetails
		 * @see showEmbeddedFontInformation
		 * */
		public var showDeviceFontInformation:Boolean;
		
		/**
		 * Checks if a font family is embedded when showing style information
		 * @see showEmbeddedFontInformation
		 * @see showEmbeddedFontInformation
		 * */
		public var includeEmbeddedFontDetails:Boolean = true;
		
		/**
		 * Show all style declarations
		 * @see showStyleInheritanceInformation
		 * */
		public var showAllStyleDeclarations:Boolean;
		
		/**
		 * Shows color under the mouse
		 * */
		public var showColorUnderMouse:Boolean = true;
		
		/**
		 * Space before some output text
		 * */
		public var prespace:String = " ";
		
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
		 * Set this to false to test on touch screen device. 
		 * */
		public var requireCTRLKey:Boolean = true;
		
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
		 * We only check the target if the ctrl key is down
		 * If the shift key is down also then we enter the debugger
		 * Press step into to bring the debugger to the check target method
		 * In that method you can check details in the target property
		 * */
		protected function handleClick(event:MouseEvent):void {
			
			if (enabled) {
				if (!requireCTRLKey || event.ctrlKey) {
					// we are intercepting this event so we can inspect the target
					// stop the event propagation
					
					// we don't stop the propagation on touch devices so you can navigate the application
					if (requireCTRLKey) {
						event.stopImmediatePropagation();
					}
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
			var rootSystemManagerTree:ComponentItem = createComponentTreeFromElement(FlexGlobals.topLevelApplication.systemManager);
			var componentItem:ComponentItem = getFirstParentComponentItemFromComponentTreeByDisplayObject(DisplayObject(event.target), rootComponent);
			componentItem = componentItem ==null ? getFirstParentComponentItemFromComponentTreeByDisplayObject(DisplayObject(event.target), rootSystemManagerTree) : componentItem;
			var target:DisplayObject = event.target as DisplayObject; // original clicked on item as reported by the mouse event
			// first component found to own the event.target that is also on the component tree
			// if the component is in a pop up we are not handling it
			var componentTarget:Object = componentItem ? componentItem.target : target;
			var selectedTarget:Object;
			var message:String = "";
			var clearStyle:Boolean;
			// set to string so debugger allows change of values
			var property:String = "";
			var style:String = "";
			var value:String = "";
			var styles:Array;
			var currentValue:*;
			
			
			// get target
			if (event.shiftKey) {
				selectedTarget = target;
			}
			else {
				selectedTarget = componentTarget;
			}
			
			// show target information
			if (showDisplayObjectInformation) {
				if (event.shiftKey) {
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
				message += getStyleDetails(selectedTarget, includeEmbeddedFontDetails);
			}
			
			// show embedded fonts
			if (showEmbeddedFontInformation) {
				if (message!="") message += "\n";
				message += getFontInformationDetails(selectedTarget);
			}
			
			// show all styles
			if (showAllStyleDeclarations) {
				if (message!="") message += "\n";
				message += getAllStyleDeclarationsDetails(selectedTarget);
			}
			
			// show color under pixel
			if (showColorUnderMouse) {
				if (message!="") message += "\n";
				message += getColorUnderMouse(event);
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
			
			
			// TO GET OR SET VALUES SET THE PROPERTY OR STYLE VARIABLE NOW
			
			// allows you to get or set a property or style value dynamically 
			// through the IDE while debugging
			if (property) {
				
				try {
					currentValue = selectedTarget[property];
					
					selectedTarget[property] = value;
				}
				catch (error:Error) {
					trace("Error setting property:" + error.message);
				}
				
			}
			else if (style) {
				
				try {
					currentValue = selectedTarget.getStyle(style);
					
					// need to call clear style or allow setting undefined
					// to support
					if (value!="undefined") {
						selectedTarget.setStyle(style, value);
					}
					else if (clearStyle) {
						selectedTarget.setStyle(style, undefined);
					}
					
					currentValue = selectedTarget.getStyle(style);
				}
				catch (error:Error) {
					trace("Error setting style:" + error.message);
				}
			}
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
			
			
			// get style declarations
			classDeclarations = styleClient.getClassStyleDeclarations();
			
			var length:int = classDeclarations.length;
			
			
			// add pseudo selectors
			// experimental method to get TextInput / TextArea pseudo conditions
			// TextInput:normalWithPrompt etc
			// the ordering is still under development
			for (var ii:int=0;ii<length;ii++) {
				declaration = classDeclarations[ii];
				var subjects:Object = styleManager.getStyleDeclarations(declaration.subject);
				
				for (var subject:String in subjects) {
					var items:Array = ArrayUtil.toArray(subjects[subject]);
					
					for (var jj:int = 0;jj<items.length;jj++) {
						var item:CSSStyleDeclaration = items[jj];
						
						// the hard part is how to order them in???
						if (classDeclarations.indexOf(item)==-1) {
							trace("Found advanced selector:" + item.mx_internal::selectorString);
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
			length = allSelectors.length;
			
			for (var aa:int;aa<length;aa++) {
				var selector:String = allSelectors[aa];
				declaration = styleManager.getStyleDeclaration(selector);
				styleClientMatches = declaration.matchesStyleClient(styleClient as IAdvancedStyleClient);
				
				if (styleClientMatches) {
					var indexOf:int = classDeclarations.indexOf(declaration);
					
					// the hard part is how to order them in???
					if (indexOf<0) {
						trace("Found rogue selector:" + selector);
						//classDeclarations.unshift(declaration);
					}
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
		 * Gets all styles information
		 * */
		public function getColorUnderMouse(event:MouseEvent):String {
			var output:String = "";
			var temporaryBitmap:BitmapData;
			var scale:Number;
			var stageX:Number;
			var stageY:Number;
			var onApplication:Boolean = true;
			
			if (onApplication) {
				temporaryBitmap = new BitmapData(FlexGlobals.topLevelApplication.stage.width, FlexGlobals.topLevelApplication.stage.height, false);
				temporaryBitmap.draw(DisplayObject(FlexGlobals.topLevelApplication.stage));
		
				scale = FlexGlobals.topLevelApplication.applicationDPI / FlexGlobals.topLevelApplication.runtimeDPI;
				stageX = event.stageX * scale;
				stageY = event.stageY * scale;
			}
			else {// not verified
				temporaryBitmap = new BitmapData(event.target.width, event.target.height, false);
				temporaryBitmap.draw(DisplayObject(event.target));
		
				scale = FlexGlobals.topLevelApplication.applicationDPI / FlexGlobals.topLevelApplication.runtimeDPI;
				stageX = event.localX * scale;
				stageY = event.localY * scale;
			}
			
			var eyeDropperColorValue:uint = temporaryBitmap.getPixel(stageX, stageY);
			var value:String = displayInHex(eyeDropperColorValue);
			
			output = showConsoleDividerMarks ? "\n" + dividerMarks + "\n":"";
			output += "Color at location";
			output += showConsoleDividerMarks ? "\n" + dividerMarks + "\n":"";
			
			output += " #" + value + "\n";
			
			output += showConsoleDividerMarks && showFooterConsoleDividerMarks ? "\n" + dividerMarks + "\n" : "";
			
			return output;
		}
	
		public function extractRed(c:uint):uint {
			return (( c >> 16 ) & 0xFF);
		}
		
		public function extractGreen(c:uint):uint {
			return ( (c >> 8) & 0xFF );
		}
		
		public function extractBlue(c:uint):uint {
			return ( c & 0xFF );
		}
		
		public function combineRGB(r:uint,g:uint,b:uint):uint {
			return ( ( r << 16 ) | ( g << 8 ) | b );
		}
		
		public function displayInHex(c:uint):String {
			var r:String = extractRed(c).toString(16).toUpperCase();
			var g:String = extractGreen(c).toString(16).toUpperCase();
			var b:String = extractBlue(c).toString(16).toUpperCase();
			var hs:String = "";
			var zero:String = "0";
			
			if (r.length==1) {
				r = zero.concat(r);
			}
			
			if (g.length==1) {
				g = zero.concat(g);
			}
			
			if (b.length==1) {
				b = zero.concat(b);
			}
			
			hs = r+g+b;
			
			return hs;
		}
		
		/**
		 * Gets all styles information
		 * */
		public function getAllStyleDeclarationsDetails(target:Object):String {
			var component:UIComponent = target as UIComponent;
			var styleManager:IStyleManager2 = StyleManager.getStyleManager(component ? component.moduleFactory: null);
			var output:String = "";
			var name:String;
			
			
			output = showConsoleDividerMarks ? "\n" + dividerMarks + "\n":"";
			output += "All Style Declarations";
			output += showConsoleDividerMarks ? "\n" + dividerMarks + "\n":"";
			
			if (component==null) {
				output += styleManager==null ? "Warning: Target is not a UIComponent. Using global style manager\n" : "";
			}
			
			var selectors:Array = styleManager.selectors;
			var length:int = selectors.length;
			
			
			for (var i:int;i<length;i++)
			{
				name = selectors[i];
				
				output += " " + name + "\n";
			}
			
			output += showConsoleDividerMarks && showFooterConsoleDividerMarks ? "\n" + dividerMarks + "\n" : "";
			
			
			return output;
		}
		
		/**
		 * Gets details about the embedded fonts
		 * */
		public function getFontInformationDetails(target:Object):String {
			var styleItem:CSSStyleDeclarationItem;
			var component:UIComponent = target as UIComponent;
			var systemManager:ISystemManager = component ? component.systemManager : null;
			var dictionary:Dictionary = new Dictionary(true);
			var fontList:Array = Font.enumerateFonts(showDeviceFontInformation);
			var length:int = fontList.length;
			var output:String = "";
			var fontObject:Object;
			var paddedName:String;
			var name:String;
			var font:Font;
			
			
			output = showConsoleDividerMarks ? "\n" + dividerMarks + "\n":"";
			output += "Fonts";
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
				
				output += prespace + paddedName;
				
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
					if (indicateEmbeddedFonts && name=="fontFamily" && actualValue!==undefined) {
						var fontObject:Object = getFontFamilyEmbedded(value, systemManager);
						
						output += prespace + paddedName + "" + padString(value, Math.max(minimumStyleNamePadding, value.length+1));
						
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
							output += prespace + paddedName + "#" + padLeft(Number(value).toString(16), 6);;
						}
							// array of colors
						else if (actualValue && actualValue is Array && actualValue.length>0 && !isNaN(actualValue[0])) {
							for (var k:int;k<actualValue.length;k++) {
								if (!isNaN(actualValue[k])) {
									actualValue[k] = "#" + padLeft(Number(actualValue[k]).toString(16), 6);
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
						var className:String = value ? getQualifiedClassName(actualValue) : "";
						output += prespace + paddedName + "" + padString(value, minimumStyleNamePadding) + className;
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
				//message += "\nIt's linked document " + getLinkedClassName(componentItem.document);
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
				
				if (componentItem.id && searchPattern) {
					message += "\nSearch in files with regexp " + searchPattern;
				}
				else {
					//message += "\nSearch in files with regexp \"" + searchPattern + "\"";
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
			var output:String = "";
			output += "(" + name.replace("::",".") + ".as:1)";
			//output += "\n(" + name.replace("::",".") + ".mxml)";
			output += "\n(" + name.replace("::",".") + ".mxml:1)";
			/*output += "\nftp://" + name.replace("::",".") + ".mxml";
			output += "\nhttp://" + name.replace("::",".") + ".mxml";
			output += "\n(" + name.replace("::",".") + ".java:12)";
			output += "\n./" + name.replace("::",".") + ".mxml";
			output += "\n../" + name.replace("::",".") + ".mxml";*/
			return output;
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
		
		

        // =========================================================================================
        // Debug mode
        // =========================================================================================

		/**
		 * The state of the debug mode.
		 * */
        protected var _debug:Boolean=false;

		/**
		 * The target for the logger.
		 * */
        protected var logTarget:TraceTarget;

		/**
		 * The class logger.
		 * */
        protected var logger:ILogger = Log.getLogger("WebView");
		
		/**
		 * Displays a JavaScript alert and issues an WebViewEvent.Result event with 
		 * the response from a JavaScript call. 
		 * */
        public var runTestScript:Boolean;
		
		/**
		 * Get the state of the debug mode.
		 * */
        public function get debug():Boolean
        {
            return _debug;
        }

		/**
		 * Set the state of the debug mode.
		 * */
        public function set debug(value:Boolean):void
        {
            if (value == debug) {
                return;
			}

            if (value)
            {
                if (!logTarget)
                {
                    logTarget = new TraceTarget();
                    logTarget.includeLevel = true;
                    logTarget.includeTime = true;
                    logTarget.level = LogEventLevel.ALL;
                    logTarget.filters = ["WebView"];
                }
				
                logTarget.addLogger(logger);
            }
            else
            {
                if (logTarget) {
                    logTarget.removeLogger(logger);
				}
            }

            _debug=value;
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