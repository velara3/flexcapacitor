
package com.flexcapacitor.utils {
	import com.flexcapacitor.managers.CodeManager;
	import com.flexcapacitor.model.ExportOptions;
	import com.flexcapacitor.model.HistoryEventData;
	import com.flexcapacitor.model.HistoryEventItem;
	import com.flexcapacitor.model.IDocument;
	import com.flexcapacitor.model.ImportOptions;
	import com.flexcapacitor.model.IssueData;
	import com.flexcapacitor.model.SourceData;
	import com.flexcapacitor.model.TranscoderOptions;
	import com.flexcapacitor.utils.supportClasses.ComponentDefinition;
	import com.flexcapacitor.utils.supportClasses.ComponentDescription;
	
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	
	import mx.collections.ArrayCollection;
	import mx.collections.ListCollectionView;
	
	import spark.components.Application;
	import spark.core.ContentCache;
	
	/**
	 * Invalid elements in the markup
	 * */
	[Event(name="invalidElement", type="flash.events.Event")]
	
	/**
	 * Invalid or malformed XML
	 * */
	[Event(name="invalid", type="flash.events.Event")]
	
	/**
	 * Class or element not found
	 * */
	[Event(name="elementNotFound", type="flash.events.Event")]
	
	/**
	 * Exports or imports document 
	 * */
	public class DocumentTranscoder extends EventDispatcher {
		
		/**
		 * Constructor
		 * */
		public function DocumentTranscoder() {
			
		}
		
		private static var _instance:DocumentTranscoder;
		public static function get instance():DocumentTranscoder
		{
			if (!_instance) {
				//_instance = new DocumentTranscoder(new SINGLEDOUBLE());
				_instance = new DocumentTranscoder();
			}
			return _instance;
		}
		
		public static function getInstance():DocumentTranscoder {
			return instance;
		}
		
		public var debug:Boolean;
		
		public static const INVALID:String = "invalid";
		public static const INVALID_ELEMENT:String = "invalidElement";
		public static const ELEMENT_NOT_FOUND:String = "elementNotFound";
		
		/**
		 * An array of component definitions that can be used to get more information about
		 * a class or object. You must manually set this.  
		 * */
		public var definitions:Array = [];

		/**
		 * Set this in the constructor in sub classes
		 * */
		public var language:String = "";
		
		/**
		 * Instructs the transcoder to create file info data so you can save to file system
		 * */
		public var createFiles:Boolean;
		
		public var supportsImport:Boolean;
		public var supportsExport:Boolean;
		
		/**
		 * Options for transcoder
		 * */
		public var options:TranscoderOptions;
		public var importOptions:ImportOptions;
		public var exportOptions:ExportOptions;
		
		public var previousPresets:ExportOptions;
		
		public var target:Object;
		
		[Bindable]
		public var importingDocument:Boolean;
		
		/**
		 * If set to true, removes all elements when import is called
		 * */
		public var removeAllOnImport:Boolean;
		
		/**
		 * If set to true, does not remove common user interactions.
		 * If set to false then removes user interactions disruptive to a design view.
		 * Default is false.
		 * */
		public var makeInteractive:Boolean;
		
		/**
		 * Export child descriptors. Somewhat temporary global property you would set to false
		 * for a single selected component.  
		 * */
		public var exportChildDescriptors:Boolean = true;
		
		/**
		 * Components created during import
		 * */
		public static var newComponents:Array;
		
		/**
		 * List of component identifiers
		 * */
		public var identifiers:Array;
		
		/**
		 * List of duplicate identifiers
		 * */
		public var duplicateIdentifiers:Array;
		
		/**
		 * Export from history
		 * */
		public var exportFromHistory:Boolean;
		
		
		private var _version:String = "1.0.0";

		/**
		 * Version
		 * */
		public function get version():String
		{
			return _version;
		}

		/**
		 * @private
		 */
		public function set version(value:String):void
		{
			_version = value;
		}

		
		public var contentTabStart:RegExp = /([\t| ]*)(<!--body_content-->)/i;
		public var contentTabStart2:RegExp = /([\t| ]*)(<!--body_start-->)/i;
		public var contentTabStart3:RegExp = /([\t| ]*)(<body.*>)/i;
		
		/**
		 * Regex to find begin and end tags of token in the template that is replaced by the content
		 * */
		public var contentTokenMultiline:RegExp = /([\t| ]*)(<!--body_start-->)(.*)(^\s*)(<!--body_end-->)/ism;
		
		/**
		 * Name of token in the template that is replaced by the styles
		 * */
		public var stylesTokenMultiline:RegExp = /([\t| ]*)(<!--styles_start-->)(.*)(^\s+)(<!--styles_end-->)/ism;
		public var stylesTokenSingleline:RegExp = /([\t| ]*)(<!--styles_content-->)/i;
		public var stylesTokenReplace:String = "$1$2$3[styles]\n$4$5";
		public var stylesTokenStart:String = "<!--styles_start-->";
		public var stylesTokenEnd:String = "<!--styles_end-->";
		
		/**
		 * Name of token in the template that is replaced by the content
		 * */
		public var contentTokenSingleline:RegExp = /([\t| ]*)(<!--body_content-->)/i;
		public var contentTokenReplace:String = "$1$2$3[content]\n$4$5";
		public var contentTokenStart:String = "<!--template_content_start-->";
		public var contentTokenEnd:String = "<!--template_content_end-->";
		
		/**
		 * Name of token in the template that is replaced by links to stylesheets
		 * */
		public var stylesheetTokenMultiline:RegExp = /([\t| ]*)(<!--stylesheets_start-->)(.*)(^\s+)(<!--stylesheets_end-->)/ism;
		public var stylesheetTokenSingleline:RegExp = /([\t| ]*)(<!--stylesheets-->)/i;
		public var stylesheetTokenReplace:String = "$1$2$3$1[stylesheets]\n$4$5";
		public var stylesheetTokenStart:String = "<!--stylesheets_start-->";
		public var stylesheetTokenEnd:String = "<!--stylesheets_end-->";
		
		public var generatorToken:String = "<!--generator-->";
		public var pageTitleToken:String = "<!--page_title-->";
		public var scriptsToken:String = "<!--scripts-->";
		
		public var osNeutralLinebreaks:RegExp = /(\t|\r?\n)+/gm;
		
		private var _isValid:Boolean;

		/**
		 * Indicates if the XML is valid
		 * */
		public function get isValid():Boolean {
			return _isValid;
		}

		/**
		 * @private
		 */
		public function set isValid(value:Boolean):void {
			_isValid = value;
		}

		
		private var _error:Error;

		/**
		 * Validation error
		 * */
		public function get error():Error {
			return _error;
		}

		/**
		 * @private
		 */
		public function set error(value:Error):void {
			_error = value;
		}

		
		private var _errorMessage:String;

		/**
		 * Validation error message
		 * */
		public function get errorMessage():String {
			return _errorMessage;
		}

		/**
		 * @private
		 */
		public function set errorMessage(value:String):void {
			_errorMessage = value;
		}

		
		private var _errors:Array = [];
		
		/**
		 * Error messages
		 * */
		public function get errors():Array {
			return _errors;
		}

		/**
		 * @private
		 */
		public function set errors(value:Array):void {
			_errors = value;
		}

		private var _warnings:Array = [];

		/**
		 * Warning messages
		 * */
		public function get warnings():Array {
			return _warnings;
		}

		/**
		 * @private
		 */
		public function set warnings(value:Array):void {
			_warnings = value;
		}
		
		/**
		 * Apply presets
		 * */
		public function applyPresets(options:ExportOptions, enforceAllValues:Boolean = false):void {
			var properties:Array = ClassUtils.getPropertyNames(options);
			var value:*;
			
			for each (var property:String in properties) {
				
				if (property in this) {
					value = options[property];
					
					if ((value!=null && value!=undefined) || enforceAllValues) {
						this[property] = value;
					}
				}
			}
			
		}
		
		/**
		 * Save current presets. Sub classes should override this or set the options to their
		 * own class options type
		 * */
		public function savePresets():void {
			if (previousPresets==null) {
				previousPresets = new ExportOptions();
			}
			
			var properties:Array = ClassUtils.getPropertyNames(previousPresets);
			
			for each (var property:String in properties) {
				if (property in this) {
					previousPresets[property] = this[property];
				}
			}
		}
		
		/**
		 * 
		 * Restore previous presets.
		 * 
		 * Returns false if no previous presets were found
		 * */
		public function restorePreviousPresets():Boolean {
			if (previousPresets==null) {
				return false;
			}
			
			applyPresets(previousPresets);
			
			return true;
		}
		
		/**
		 * Replaces the page title token with the page title 
		 * */
		public function replacePageTitleToken(value:String, name:String):String {
			var pageOutput:String = value!=null ? value.replace(pageTitleToken, name) : "";
			return pageOutput;
		}
		
		/**
		 * Replaces the generator token with the generator information
		 * */
		public function replaceGeneratorToken(value:String, name:String):String {
			var pageOutput:String = value!=null ? value.replace(generatorToken, name) : "";
			return pageOutput;
		}
		
		/**
		 * Replaces the scripts token with scripts
		 * */
		public function replaceScriptsToken(value:String, replacement:String):String {
			var pageOutput:String = value!=null ? value.replace(scriptsToken, replacement) : "";
			return pageOutput;
		}
		
		
		/**
		 * Replace stylesheet token
		 * */
		public function replaceStylesheetsToken(page:String, stylesheetLinks:String, addToMarkup:Boolean = true):String {
			var stylesheetReplacement:String;
			var warningData:IssueData;
			var whiteSpace:String;
			var match:Object;
			
			match = page.match(stylesheetTokenSingleline);
			
			if (match!=null) {
				whiteSpace = match[1]!=null ? match[1] : "";
				stylesheetLinks = StringUtils.indent(stylesheetLinks, whiteSpace);
				page = page.replace(stylesheetTokenSingleline, stylesheetLinks);
			}
			else {
				
				match = page.match(stylesheetTokenMultiline);
				
				if (match!=null) {
					whiteSpace = match[1]!=null ? match[1] : "";
					stylesheetLinks = StringUtils.indent(stylesheetLinks, whiteSpace + StringUtils.TAB);
					
					stylesheetReplacement = stylesheetTokenReplace.replace("[stylesheets]", stylesheetLinks);
					page = page.replace(stylesheetTokenMultiline, stylesheetReplacement);
				}
				else {
					warningData = IssueData.getIssue("Missing Token", "No stylesheet token(s) found in the template.");
					warnings.push(warningData);
					
					if (addToMarkup) {
						page = stylesheetLinks + "\n" + page;
					}
				}
			}
			
			return page;
		}
		
		/**
		 * Replaces a token in the value that is passed with the content that is passed in
		 * @see #contentTokenSingleline
		 * @see #contentTokenMultiline
		 * @see #contentTokenReplace
		 * */
		public function replaceContentToken(page:String, content:String):String {
			var contentReplacement:String;
			var pageMergedOutput:String = "";
			var warningData:IssueData;
			var whiteSpace:String;
			var match:Object;
			
			// replace content
			match = page.match(contentTokenSingleline);
			
			if (match!=null) {
				whiteSpace = match[1]!=null ? match[1] : "";
				content = StringUtils.indent(content, whiteSpace);
				
				pageMergedOutput = page.replace(contentTokenSingleline, content);
			}
			else {
				match = page.match(contentTokenMultiline);
				
				if (match!=null) {
					whiteSpace = match[1]!=null ? match[1] : "";
					content = StringUtils.indent(content, whiteSpace);
					
					contentReplacement = contentTokenReplace.replace("[content]", content);
					pageMergedOutput = page.replace(contentTokenMultiline, contentReplacement);
				}
				else {
					warningData = IssueData.getIssue("Missing Token", "No content token(s) found in the template.");
					warnings.push(warningData);
					pageMergedOutput = page;
				}
			}
			
			return pageMergedOutput;
		}
		
		/**
		 * Replaces a styles token
		 * @see #stylesTokenSingleline
		 * @see #stylesTokenMultiline
		 * @see #stylesTokenReplace
		 * */
		public function replaceStylesToken(page:String, styles:String):String {
			var contentReplacement:String;
			var pageMergedOutput:String = "";
			var warningData:IssueData;
			var whiteSpace:String;
			var match:Object;
			
			// replace styles
			match = page.match(stylesTokenSingleline);
			
			if (match!=null) {
				whiteSpace = match[1]!=null ? match[1] : "";
				styles = StringUtils.indent(styles, whiteSpace);
				
				pageMergedOutput = page.replace(stylesTokenSingleline, styles);
			}
			else {
				match = page.match(stylesTokenMultiline);
				
				if (match!=null) {
					whiteSpace = match[1]!=null ? match[1] : "";
					styles = StringUtils.indent(styles, whiteSpace);
					
					contentReplacement = stylesTokenReplace.replace("[styles]", styles);
					pageMergedOutput = page.replace(stylesTokenMultiline, contentReplacement);
				}
				else {
					warningData = IssueData.getIssue("Missing Token", "No styles token(s) found in the template.");
					warnings.push(warningData);
					pageMergedOutput = page;
				}
			}
			
			return pageMergedOutput;
		}
		
		/**
		 * Gets the tab or whitespace amount before the content token
		 * */
		public function getContentTabDepth(value:String):String {
			if (value==null || value=="") return "";
			
			var tabResults:Object = contentTabStart.exec(value);
			var tabDepth:String = "";
			
			if (tabResults) {
				tabDepth = tabResults[1]!=null ? tabResults[1] : "";
			}
			else {
				tabResults = contentTabStart2.exec(value);
				
				if (tabResults) {
					tabDepth = tabResults[1]!=null ? tabResults[1] + "	" : "";
				}
				else {
					tabResults = contentTabStart3.exec(value);
					
					if (tabResults!=null) {
						tabDepth = tabResults[1]!=null ? tabResults[1] + "	" : "";
					}
				}
			}
			
			return tabDepth;
		}
		
		/**
		 * Imports the source code for the target component. 
		 * You override this in your class. 
		 * */
		public function importare(source:*, document:IDocument, componentDescription:ComponentDescription = null, parentPosition:int = -1, options:ImportOptions = null, dispatchEvents:Boolean = false):SourceData {
			// override this in your class
			return null;
		}
		
		/**
		 * Exports the source code for the target component. 
		 * You override this in your class. 
		 * */
		public function export(document:IDocument, componentDescription:ComponentDescription = null, options:ExportOptions = null, dispatchEvents:Boolean = false):SourceData {
			// override this in your class
			return null;
		}
		
		/**
		 * @inheritDoc
		 * */
		public function exportReference(document:IDocument, componentDescription:ComponentDescription = null):String {
			var xml:XML;
			var output:String;
			
			xml = <document />;/*
			xml.@host = document.host;
			xml.@id = document.id;
			xml.@name = document.name;
			xml.@uid = document.uid;
			xml.@uri = document.uri;*/
			output = xml.toXMLString();
			
			return output;
		}
		
		/**
		 * Returns options object for export. 
		 * Classes should override this method and return their own export options
		 * */
		public function getExportOptions(getCurrentValues:Boolean = true):ExportOptions {
			var properties:Array;
			
			if (exportOptions==null) {
				exportOptions = new ExportOptions();
			}
			
			if (getCurrentValues) {
				properties = ClassUtils.getPropertyNames(this);
				
				for each (var property:String in properties) {
					if (property in exportOptions) {
						exportOptions[property] = this[property];
					}
				}
			}
			
			return exportOptions;
		}
		
		/**
		 * Returns options object for import. 
		 * Classes should override this method and return their own import options
		 * */
		public function getImportOptions():ImportOptions {
			if (importOptions==null) {
				importOptions = new ImportOptions();
			}
			return importOptions;
		}
		
		/**
		 * Default generator tag.

		 * */
		public var generatorTag:String = "<!-- Generator: [name] [version], [language] Exporter, http://www.velara3.com -->";
		
		/**
		 * Get a generator tag. Any tokens are replaced by property values.
		 * For example,
<pre>
<!-- Generator: VeraType 3.3.0, SVG Export Plug-In, http://www.velara3.com -->
</pre>
Default generator string is: 
<pre>
<!-- Generator: [name] [version], [language] Exporter, http://www.velara3.com -->
</pre>
		 * @see #generatorTag 
		 * */
		public function get generator():String {
			var value:String = generatorTag.replace("[name]", "Radiate");
			value = value.replace("[version]", version);
			value = value.replace("[language]",  language);
			return value;
		}
		
		public function set generator(value:String):void {
			generatorTag = value;
		}
		
		/**
		 * Returns an XML instance that contains the default MXML Application tag and namespaces
		 * */
		public function getDefaultMXMLDocumentXML():XML {
			var mxmlDocument:XML = new XML(MXMLDocumentConstants.xmlDeclaration + "<Application/>");
			var sparkNamespace:QName;
			var namespaceObject:Namespace;
			var namespaces:Dictionary;
			
			namespaces = MXMLDocumentConstants.getNamespaces();
			
			for (var prefix:String in namespaces) {
				//qname = new QName(namespaces[name], name);
				namespaceObject = new Namespace(prefix, namespaces[prefix]);
				mxmlDocument.addNamespace(namespaceObject);
			}
			
			sparkNamespace = new QName(namespaces[MXMLDocumentConstants.sparkNamespacePrefix], "Application");
			mxmlDocument.setName(sparkNamespace);
			
			return mxmlDocument;
		}
		/**
		 * Collection of visual elements that can be added or removed to 
		 * */
		[Bindable]
		public static var componentDefinitions:ArrayCollection = new ArrayCollection();
		
		/**
		 * Get the component by class name
		 * */
		public static function getDynamicComponentType(componentName:Object, fullyQualified:Boolean = false):ComponentDefinition {
			var definition:ComponentDefinition;
			var numberOfDefinitions:uint = componentDefinitions.length;
			var item:ComponentDefinition;
			var className:String;
			
			if (componentName is QName) {
				className = QName(componentName).localName;
			}
			else if (componentName is String) {
				className = componentName as String;
			}
			else if (componentName is Object) {
				className = ClassUtils.getQualifiedClassName(componentName);
				
				if (className=="application" || componentName is Application) {
					className = ClassUtils.getSuperClassName(componentName, true);
				}
			}
			
			fullyQualified = className.indexOf("::")!=-1 ? true : fullyQualified;
			if (fullyQualified) {
				className = className.replace("::", ".");
			}
			
			for (var i:uint;i<numberOfDefinitions;i++) {
				item = ComponentDefinition(componentDefinitions.getItemAt(i));
				
				if (fullyQualified) {
					if (item && item.className==className) {
						return item;
					}
				}
				else {
					if (item && item.name==className) {
						return item;
					}
				}
			}
			
			
			var hasDefinition:Boolean = ClassUtils.hasDefinition(className);
			var classType:Object;
			var name:String;
			
			
			if (hasDefinition) {
				if (className.indexOf("::")!=-1) {
					name = className.split("::")[1];
				}
				else {
					name = className;
				}
				classType = ClassUtils.getDefinition(className);
				addComponentDefinition(name, className, classType, null, null);
				item = getComponentType(className, fullyQualified);
				return item;
			}
			
			return null;
		}
		
		/**
		 * Cache for component icons
		 * */
		[Bindable]
		public static var contentCache:ContentCache = new ContentCache();
		
		/**
		 * Add the named component class to the list of available components
		 * */
		public static function addComponentDefinition(name:String, 
													  className:String, 
													  classType:Object, 
													  inspectors:Array = null, 
													  icon:Object = null, 
													  defaultProperty:String = null,
													  defaultProperties:Object=null, 
													  defaultStyles:Object=null, 
													  enabled:Boolean = true, 
													  childNodes:Array = null, 
													  dispatchEvents:Boolean = true):Boolean {
			var componentDefinition:ComponentDefinition;
			var numberOfDefinitions:uint = componentDefinitions.length;
			var item:ComponentDefinition;
			
			
			for (var i:uint;i<numberOfDefinitions;i++) {
				item = ComponentDefinition(componentDefinitions.getItemAt(i));
				
				// check if it exists already
				if (item && item.classType==classType) {
					return false;
				}
			}
			
			
			componentDefinition = new ComponentDefinition();
			
			componentDefinition.name = name;
			componentDefinition.icon = icon;
			componentDefinition.className = className;
			componentDefinition.classType = classType;
			componentDefinition.defaultStyles = defaultStyles;
			componentDefinition.defaultProperties = defaultProperties;
			componentDefinition.inspectors = inspectors;
			componentDefinition.enabled = enabled;
			componentDefinition.childNodes = childNodes;
			
			componentDefinitions.addItem(componentDefinition);
			
			if (dispatchEvents) {
				instance.dispatchComponentDefinitionAddedEvent(componentDefinition);
			}
			
			CodeManager.setComponentDefinitions(componentDefinitions.source);
			
			return true;
		}
		
		/**
		 * Remove the named component class
		 * */
		public static function removeComponentType(className:String):Boolean {
			var definition:ComponentDefinition;
			var numberOfDefinitions:uint = componentDefinitions.length;
			var item:ComponentDefinition;
			
			for (var i:uint;i<numberOfDefinitions;i++) {
				item = ComponentDefinition(componentDefinitions.getItemAt(i));
				
				if (item && item.classType==className) {
					componentDefinitions.removeItemAt(i);
				}
			}
			
			return true;
		}
		
		/**
		 * Get the component by class name
		 * */
		public static function getComponentType(className:String, fullyQualified:Boolean = false):ComponentDefinition {
			var definition:ComponentDefinition;
			var numberOfDefinitions:uint = componentDefinitions.length;
			var item:ComponentDefinition;
			
			for (var i:uint;i<numberOfDefinitions;i++) {
				item = ComponentDefinition(componentDefinitions.getItemAt(i));
				
				if (fullyQualified) {
					if (item && item.className==className) {
						return item;
					}
				}
				else {
					if (item && item.name==className) {
						return item;
					}
				}
			}
			
			return null;
		}
		
		
		/**
		 * Dispatch component definition added 
		 * */
		public function dispatchComponentDefinitionAddedEvent(data:ComponentDefinition):void {
			/*var assetAddedEvent:RadiateEvent;
			
			if (hasEventListener(RadiateEvent.COMPONENT_DEFINITION_ADDED)) {
				assetAddedEvent = new RadiateEvent(RadiateEvent.COMPONENT_DEFINITION_ADDED);
				assetAddedEvent.data = data;
				dispatchEvent(assetAddedEvent);
			}
			*/
		}
		
		/**
		* Get an object that contains the properties that have been set on the component.
		* This does this by going through the history events and checking the changes.
		* */
		public function getAppliedPropertiesFromHistory(document:IDocument, component:ComponentDescription, addToProperties:Boolean = true, removeConstraints:Boolean = true):Object {
			var historyIndex:int = document.historyIndex+1;
			var historyEvent:HistoryEventItem;
			var historyItem:HistoryEventData;
			var history:ListCollectionView;
			var historyEvents:Array;
			var eventsLength:int;
			var propertiesObject:Object;
			var stylesObject:Object;
			var eventsObject:Object;
			var properties:Array;
			var styles:Array;
			
			history = document.history;
			propertiesObject = component.properties ? component.properties : {};
			stylesObject = component.styles ? component.styles : {};
			eventsObject = component.events ? component.events : {};
			
			if (history.length==0) return propertiesObject;
			
			// go back through the history of changes and 
			// add the properties that have been set to an object
			for (var i:int=historyIndex;i--;) {
				historyItem = history.getItemAt(i) as HistoryEventData;
				historyEvents = historyItem.historyEventItems;
				eventsLength = historyEvents.length;
				
				for (var j:int=0;j<eventsLength;j++) {
					historyEvent = historyEvents[j] as HistoryEventItem;
					properties = historyEvent.properties;
					styles = historyEvent.styles;
					
					if (historyEvent.targets.indexOf(component.instance)!=-1) {
						for each (var property:String in properties) {
							
							if (property in propertiesObject) {
								continue;
							}
							else {
								propertiesObject[property] = historyEvent.propertyChanges.end[property];
							}
						}
						
						for each (var style:String in styles) {
							
							if (style in stylesObject) {
								continue;
							}
							else {
								stylesObject[style] = historyEvent.propertyChanges.end[style];
							}
						}
					}
					
				}
			}
			
			if (removeConstraints) {
				propertiesObject = ClassUtils.removeConstraintsFromObject(propertiesObject);
			}
			
			component.properties = propertiesObject;
			component.styles = stylesObject;
			
			return propertiesObject;
		}

	}
}

class SINGLEDOUBLE{}