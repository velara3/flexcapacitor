package com.flexcapacitor.managers {
	
	import com.flexcapacitor.model.ExportOptions;
	import com.flexcapacitor.model.IDocument;
	import com.flexcapacitor.model.ImportOptions;
	import com.flexcapacitor.model.SourceData;
	import com.flexcapacitor.model.TranscoderDescription;
	import com.flexcapacitor.utils.ArrayUtils;
	import com.flexcapacitor.utils.DisplayObjectUtils;
	import com.flexcapacitor.utils.DocumentTranscoder;
	import com.flexcapacitor.utils.supportClasses.ComponentDescription;
	
	import flash.display.DisplayObject;
	import flash.events.EventDispatcher;
	
	import mx.collections.ArrayCollection;
	import mx.core.IVisualElementContainer;

	
	/**
	 * Export and import code
	 * */
	public class CodeManager extends EventDispatcher {
		
		
		public function CodeManager():void {
			
		}
		
		public static const MXML:String = "MXML";
		public static const HTML:String = "HTML";
		public static const XAML:String = "XAML";
		public static const ANDROID:String = "Android";
		
		public static const IMPORT:String = "import";
		public static const EXPORT:String = "export";
		
		public static const TYPE:String = "type";
		public static const CLASS_PATH:String = "classPath";
		
		public static const IS_IMPORT_SUPPORTED:String = "isImportSupported";
		public static const IS_EXPORT_SUPPORTED:String = "isExportSupported";
		
		public static var transcoders:ArrayCollection = new ArrayCollection();
		
		/**
		 * Array of component definitions used on import and export
		 * */
		public static var definitions:Array = [];
		
		/**
		 * Indicates if multiple transcoders are allowed
		 * */
		public static var allowMultipleTranscoders:Boolean = true;
		
		private var codeManager:CodeManager;
		
		/**
		 * Registers an exporter class for a specific language. 
		 * Throws an error if it's already registered.
		 * */
		public static function registerTranscoder(transcoder:TranscoderDescription, exportOptions:ExportOptions = null, importOptions:ImportOptions = null):void {
			var existingTranscoder:TranscoderDescription = getTranscoder(transcoder.type);
			
			if (existingTranscoder && !allowMultipleTranscoders) {
				throw new Error("Transcoder for " + existingTranscoder.type + " is already registered and only one type can be registered");
			}
			
			transcoders.addItem(transcoder);
		}
		
		/**
		 * Gets a transcoder for a specific language
		 * @param - type name of language
		 * @param - direction is either import or export or if not set then the first one that matches
		 * */
		public static function getTranscoder(type:String, direction:String = null):TranscoderDescription {
			var transcoder:TranscoderDescription;
			
			if (direction==null) {
				transcoder = ArrayUtils.getItem(transcoders, type, TYPE, false) as TranscoderDescription;
				return transcoder;
			}
			
			if (direction==IMPORT) {
				return getImporter(type);
			}
			else if (direction==EXPORT) {
				return getExporter(type);
			}
			
			return null;
		}
		
		/**
		 * Returns all the transcoders for a specific language
		 * */
		public static function getTranscoders(type:String):Array {
			var transcodersArray:Array = ArrayUtils.getItem(transcoders, type, TYPE, false, true) as Array;
			
			return transcodersArray;
		}
		
		/**
		 * Returns all the importers for a specific language
		 * */
		public static function getImporters(type:String):Array {
			var transcodersArray:Array = getTranscoders(type);
			var importers:Array = ArrayUtils.getItem(transcodersArray, true, IS_IMPORT_SUPPORTED, false, true) as Array;
			
			return importers;
		}
		
		/**
		 * Returns all the languages for import
		 * */
		public static function getImporterLanguages():Array {
			var importers:Array = ArrayUtils.getItem(transcoders, true, IS_IMPORT_SUPPORTED, false, true) as Array;
			var transcoder:TranscoderDescription;
			var languages:Array = [];
			
			for (var i:int = 0; i < importers.length; i++) {
				transcoder = importers[i];
				languages.push(transcoder.type);
			}
			
			return languages;
		}
		
		/**
		 * Returns all the exporters for a specific language
		 * */
		public static function getExporters(type:String):Array {
			var transcodersArray:Array = getTranscoders(type);
			var exporters:Array = ArrayUtils.getItem(transcodersArray, true, IS_EXPORT_SUPPORTED, false, true) as Array;
			
			return exporters;
		}
		
		/**
		 * Returns all the exporters
		 * */
		public static function getAllExporters():Array {
			var exporters:Array = ArrayUtils.getItem(transcoders, true, IS_EXPORT_SUPPORTED, false, true) as Array;
			
			return exporters;
		}
		
		/**
		 * Returns true if an transcoder for a specific language is registered
		 * */
		public static function hasTranscoder(type:String):Boolean {
			var transcoder:TranscoderDescription = getTranscoder(type);
			
			return transcoder!=null;
		}
		
		/**
		 * Returns true if an import for a specific language is registered
		 * */
		public static function hasImporter(type:String):Boolean {
			var transcoder:TranscoderDescription = getImporter(type);
			
			return transcoder!=null;
		}
		
		/**
		 * Returns true if an transcoder for a specific language is registered
		 * */
		public static function hasExporter(type:String):Boolean {
			var transcoder:TranscoderDescription = getExporter(type);
			
			return transcoder!=null;
		}
		
		/**
		 * Returns an importer for a specific language
		 * */
		public static function getImporter(type:String, classPath:String = null):TranscoderDescription {
			var transcodersArray:Array = getImporters(type);
			var transcoder:TranscoderDescription;
			
			if (transcodersArray.length) {
				
				if (classPath) {
					transcoder = ArrayUtils.getItem(transcodersArray, classPath, CLASS_PATH, false) as TranscoderDescription;
					return transcoder;
				}
				else {
					return transcodersArray[0];
				}
			}
			
			return null;
		}
		
		/**
		 * Returns an exporter for a specific language
		 * */
		public static function getExporter(type:String, classPath:String = null):TranscoderDescription {
			var transcodersArray:Array = getExporters(type);
			var transcoder:TranscoderDescription;
			
			if (transcodersArray.length) {
				
				if (classPath) {
					transcoder = ArrayUtils.getItem(transcodersArray, classPath, CLASS_PATH, false) as TranscoderDescription;
					return transcoder;
				}
				else {
					return transcodersArray[0];
				}
			}
			
			return null;
		}
		
		/**
		 * Removes the exporter if it exists. Returns true if an exporter was found and removed. 
		 * */
		public static function removeTranscoder(type:String):Boolean {
			var transcoder:TranscoderDescription = getTranscoder(type);
			
			if (transcoder) {
				ArrayUtils.removeItem(transcoders, transcoder);
				return true;
			}
			
			return false;
		}
		
		/**
		 * Get export options for langauge
		 * */
		public static function getExportOptions(language:String = null):ExportOptions {
			var transcoder:TranscoderDescription = getExporter(language);
			var options:ExportOptions = transcoder ? transcoder.getExportOptions() : null;
			
			return options;
		}
		
		/**
		 * Generate the code for the provided target component. 
		 * If language is null then we check the document for language setting
		 * */
		public static function getSourceData(target:Object, document:IDocument, language:* = null, options:ExportOptions = null):SourceData {
			var targetDescription:ComponentDescription;
			var transcoderDescription:TranscoderDescription;
			var exporter:DocumentTranscoder;
			var sourceData:SourceData;
			
			// if target is not set then use document
			if (target==null && document) {
				target = document.instance;
			}
			
			// if language is null then use the document language
			if (language is String || language==null) {
				language = language==null ? document.language : language;
			}
			else if (language is TranscoderDescription) {
				transcoderDescription = TranscoderDescription(language);
			}
			
			if (target is ComponentDescription) {
				targetDescription = target as ComponentDescription;
			}
			
			// find target in display list and get it's code
			if (targetDescription==null) {
				targetDescription = DisplayObjectUtils.getTargetInComponentDisplayList(target, document.componentDescription);
			}
			
			if (targetDescription) {
				
				// get exporter
				// pass options
				// return source code
				
				if (!transcoderDescription) {
					transcoderDescription = getExporter(language);
				}
				
				exporter = transcoderDescription ? transcoderDescription.exporter : null;
				
				if (!transcoderDescription) {
					throw new Error("There is no exporter for " + language + ".");
				}
				
				sourceData = exporter.export(document, targetDescription, options);
				
				return sourceData;
			}
			
			// pasting from other documents: 
			///Radiate.warn("Target not found in get source code. The item may have been deleted.");
			return null;
			//throw new Error("Target not found in get source code. The item may have been deleted. Also, you cannot paste from another document at this time.");
		}
		
		/**
		 * Generate the code for the provided project. Not implemented
		 * */
		///public static function getProjectData(project:IProject, language:* = null, options:ExportOptions = null):Array {
		public static function getProjectData(project:Object, language:* = null, options:ExportOptions = null):Array {
			var targetDescription:ComponentDescription;
			var transcoderDescription:TranscoderDescription;
			var exporter:DocumentTranscoder;
			var sourceData:SourceData;
			var documents:Array;
			var sources:Array = [];
			var numberOfDocuments:int;
			var document:IDocument;
			
			if (language is String || language==null) {
				language = language==null ? MXML : language;
			}
			else if (language is TranscoderDescription) {
				transcoderDescription = TranscoderDescription(language);
			}
			
			// get exporter
			// pass options
			// return source code
			
			if (!transcoderDescription) {
				transcoderDescription = getExporter(language);
			}
			
			exporter = transcoderDescription ? transcoderDescription.exporter : null;
			
			if (!transcoderDescription) {
				throw new Error("There is no exporter for " + language + ".");
			}
			
			documents = project.documents ? project.documents : [];
			numberOfDocuments = documents ? documents.length : 0;
			
			for (var i:int; i < numberOfDocuments; i++) {
				document = documents[i];
				sourceData = exporter.export(document, null, options);
				sources.push(sourceData);
			}
			
			return sources;
			
			// pasting from other documents: 
			///Radiate.warn("Target not found in get source code. The item may have been deleted. Also, you cannot paste from another document at this time.", project);
			return null;
			//throw new Error("Target not found in get source code. The item may have been deleted. Also, you cannot paste from another document at this time.");
		}
		
		/**
		 * Imports the source code to the provided target container. If target is null then import to document.
		 * If language is null then we check the document for language setting
		 * */
		public static function setSourceData(source:String, target:Object, document:IDocument, language:* = null, containerPosition:int = -1, importOptions:ImportOptions = null, dispatchEvents:Boolean = false):SourceData {
			var targetDescription:ComponentDescription;
			var transcoderDescription:TranscoderDescription;
			var importer:DocumentTranscoder;
			var sourceData:SourceData;
			
			// get importer
			// pass options
			// return source code
			
			// get transcoder
			if (language is String || language==null) {
				language = language==null ? document.language : language;
			}
			else if (language is TranscoderDescription) {
				transcoderDescription = TranscoderDescription(language);
			}
			
			if (!transcoderDescription) {
				transcoderDescription = getImporter(language);
			}
			
			importer = transcoderDescription ? transcoderDescription.importer : null;
			
			if (!transcoderDescription) {
				throw new Error("There is no importer for " + language + ".");
			}
			
			// get target
			if (target==null && document) {
				target = document.instance;
			}
			
			// if target is null then set source on document
			if (target==null) {
				targetDescription = document.componentDescription;
			}
			
			if (target is DisplayObject) {
				targetDescription = DisplayObjectUtils.getComponentFromDisplayObject(DisplayObject(target), document.componentDescription);
			}
			else if (target is ComponentDescription) {
				targetDescription = target as ComponentDescription;
			}
			
			// target is descriptor but not a container so we add to document
			if (targetDescription && !(ComponentDescription(targetDescription).instance is IVisualElementContainer)) {
				targetDescription = ComponentDescription(targetDescription).parent;
			}
			// target is display object but not a container so we add to document
			else if (target is DisplayObject && !(target is IVisualElementContainer)) {
				targetDescription = document.componentDescription;
			}
			
			if (!targetDescription) {
				throw new Error("Could not find target in document. It may have been removed");
			}
			
			sourceData = importer.importare(source, document, targetDescription, containerPosition, importOptions, dispatchEvents);
			
			return sourceData;
			
		}
		
		/**
		 * Sets the version number on all transcoders. 
		 * This is a temporary way to make sure we are including the application
		 * version number in the exported code.
		 * */
		public static function setTranscodersVersion(version:String):void {
			var transcoderDescription:TranscoderDescription;
			var numberOfTranscoders:int = transcoders.length;
			var documentTranscoder:DocumentTranscoder;
			
			for (var i:int = 0; i < numberOfTranscoders; i++) {
				transcoderDescription = transcoders.getItemAt(i) as TranscoderDescription;
				documentTranscoder = transcoderDescription.importer;
				
				if (documentTranscoder) {
					documentTranscoder.version = version;
				}
				
				documentTranscoder = transcoderDescription.exporter;
				
				if (documentTranscoder) {
					documentTranscoder.version = version;
				}
			}
			
		}
		
		/**
		 * Adds the component definitions used during export or import of MXML 
		 * */
		public static function setComponentDefinitions(value:Array):void {
			var transcoderDescription:TranscoderDescription;
			var numberOfTranscoders:int = transcoders.length;
			var documentTranscoder:DocumentTranscoder;
			
			for (var i:int = 0; i < numberOfTranscoders; i++) {
				transcoderDescription = transcoders.getItemAt(i) as TranscoderDescription;
				documentTranscoder = transcoderDescription.importer;
				
				if (documentTranscoder) {
					documentTranscoder.definitions = value.slice();
				}
				
				documentTranscoder = transcoderDescription.exporter;
				
				if (documentTranscoder) {
					documentTranscoder.definitions = value.slice();
				}
			}
		}
	}
}
