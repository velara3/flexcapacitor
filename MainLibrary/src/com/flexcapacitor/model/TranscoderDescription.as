package com.flexcapacitor.model {
	import com.flexcapacitor.utils.DocumentTranscoder;
	
	import flash.system.ApplicationDomain;
	
	/**
	 * Data about a transcoder
	 * */
	public class TranscoderDescription {
		
		public function TranscoderDescription() {
			
		}
		
		/**
		 * Name of transcoder. Possibly transcoder author or manufacturer. 
		 * */
		public var name:String;
		
		/**
		 * Label of transcoder. "HTML Importer / Exporter"
		 * */
		public var label:String;
		
		/**
		 * Default extension. Default is "html".
		 * */
		public var extension:String;
		
		/**
		 * Label of import transcoder. "HTML Importer"
		 * */
		public var importLabel:String;
		
		/**
		 * Label of export transcoder. "HTML Exporter"
		 * */
		public var exportLabel:String;
		
		/**
		 * Language to import or export. For example, "MXML" or "HTML"
		 * */
		public var type:String;
		
		/**
		 * Reference to the class path 
		 * */
		public var classPath:String;
		
		/**
		 * Reference to the class definition 
		 * */
		public var classType:Object;
		
		/**
		 * Reference to the transcoder instance
		 * */
		public var exporter:DocumentTranscoder;
		
		/**
		 * Reference to the transcoder instance
		 * */
		public var importer:DocumentTranscoder;
		
		/**
		 * Importer options
		 * */
		public var importOptions:ImportOptions;
		
		/**
		 * Exporter options
		 * */
		public var exportOptions:ExportOptions;
		
		/**
		 * Import supported
		 * */
		public var isImportSupported:Boolean;
		
		/**
		 * Export supported
		 * */
		public var isExportSupported:Boolean;
		
		/**
		 * Import settings from XML
		 * */
		public function importXML(item:XML):void {
			classPath = String(item.attribute("classPath"));
			type = String(item.attribute("type"));
			label = String(item.attribute("label"));
			importLabel = String(item.attribute("importLabel"));
			exportLabel = String(item.attribute("exportLabel"));
			name = String(item.attribute("name"));
			extension = String(item.attribute("extension"));
			isImportSupported = String(item.attribute("supportsImport")).toLowerCase()=="true";
			isExportSupported = String(item.attribute("supportsExport")).toLowerCase()=="true";
			
			var hasDefinition:Boolean = ApplicationDomain.currentDomain.hasDefinition(classPath);
			
			if (hasDefinition) {
				classType = ApplicationDomain.currentDomain.getDefinition(classPath);
				
				if (classType) {
					
					if (isImportSupported) {
						importer = new classType();
					}
					if (isExportSupported) {
						
						if (importer) {
							exporter = importer;
						}
						else {
							exporter = new classType();
						}
					}
					
					if (exporter) {
						exportOptions = exporter.getExportOptions();
					}
					
					if (importer) {
						importOptions = importer.getImportOptions();
					}
				}
			}
			else {
				//throw new Error("Document transcoder class for " + type + " not found: " + classPath);
			}
		}
		
		/**
		 * Gets the default export options. Transcoder classes should create these
		 * */
		public function getExportOptions():ExportOptions {
			if (exportOptions==null) {
				exportOptions = new ExportOptions();
			}
			
			// apply your own settings here
			
			return exportOptions;
		}
	}
}