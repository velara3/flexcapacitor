package com.flexcapacitor.model {
	import com.flexcapacitor.utils.supportClasses.ComponentDescription;
	
	/**
	 * Contains data from a code export
	 * */
	public class SourceData {
		
		public function SourceData() {
			
		}
		
		/**
		 * Markup from target
		 * */
		public var markup:String;
		
		/**
		 * Styles from target
		 * */
		public var styles:String;
		
		/**
		 * User styles from target
		 * */
		public var userStyles:String = "";
		
		/**
		 * Template for document
		 * */
		public var template:String;
		
		/**
		 * Source code from target
		 * */
		public var source:String;
		
		/**
		 * An array of data used to create files from the export
		 * */
		public var files:Array;
		
		/**
		 * Array of warnings
		 * */
		public var warnings:Array;
		
		/**
		 * Array of errors
		 * */
		public var errors:Array;
		
		/**
		 * Array of new objects created during an import
		 * */
		public var targets:Array;
		
		/**
		 * When importing the first component that is created.
		 * Used for selecting after import
		 * */
		public var componentDescription:ComponentDescription;
		
		/**
		 * Time in milliseconds to perform action.
		 * Document Transcoder classes use this to store length of time. 
		 * */
		public var duration:int;
		
	}
}