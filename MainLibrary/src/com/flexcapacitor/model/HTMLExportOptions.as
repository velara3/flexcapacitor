package com.flexcapacitor.model
{
	
	/**
	 * Base class for options for DocumentExporter class
	 * */
	public class HTMLExportOptions extends ExportOptions {
		
		public function HTMLExportOptions() {
			
		}
		
		public var addZoom:Boolean;
		
		/**
		 * Takes a snapshop of the document, encodes it in base 64 and adds it to the output as a background 
		 * */
		public var showScreenshotBackground:Boolean;
		
		////////////////////////////////////
		// The following may be removed
		////////////////////////////////////
		
		public var showFullHTMLPageSource:Boolean;
		public var showBorders:Boolean;
		public var useSVGButtonClass:Boolean;
		public var css:String;
		public var stylesheets:String;
		public var target:Boolean;
		public var includePreviewCode:Boolean;
		public var useCustomMarkup:Boolean;
		public var markup:String;
		public var styles:String;
		public var disableTabs:Boolean;
		public var reverseInitialCSS:Boolean;
	}
}