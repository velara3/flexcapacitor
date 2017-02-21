package com.flexcapacitor.model
{
	
	/**
	 * Used to store data about a file to be created
	 * */
	public class FileInfo {
		
		public function FileInfo() {
			
		}
		
		/**
		 * Name of file to show the user
		 * */
		public var label:String = "";
		
		/**
		 * Name of file with extension
		 * */
		public var fileName:String = "";
		
		/**
		 * File extension
		 * */
		public var fileExtension:String;
		
		/**
		 * File contents
		 * */
		public var contents:Object;
		
		/**
		 * Directory 
		 * */
		public var directory:String;
		
		/**
		 * Indicates the file was saved. You do not set this.
		 * */
		public var created:Boolean;
		
		/**
		 * Path to the destination the file was saved to. You do not set this.
		 * */
		public var filePath:String;
		
		/**
		 * URL to the destination the file was saved to. You do not set this.
		 * */
		public var url:String;
		
		/**
		 * Get fully concatenated file name, extension and path
		 * */
		public function getFullFileURI():String {
			var tempDirectory:String;
			if (directory==null) {
				tempDirectory = "";
			}
			return tempDirectory + fileName + "." + fileExtension;
		}
	}
}