package com.flexcapacitor.model {
	
	/**
	 * Base class that contains infomation on any issues during compilation
	 * */
	public class IssueData {
		
		public function IssueData() {
			
		}
		
		/**
		 * Label
		 * */
		public var label:String;
		
		/**
		 * Description
		 * */
		public var description:String;
		
		/**
		 * Class name. Class that message originated from
		 * */
		public var className:String;
		
		/**
		 * Location
		 * */
		public var location:String;
		
		/**
		 * Line
		 * */
		public var line:int = -1;
		
		/**
		 * Column
		 * */
		public var column:int = -1;
		
		/**
		 * Path
		 * */
		public var path:String;
		
		/**
		 * Type
		 * */
		public var type:String;
		
		/**
		 * Log Level. Used for tracking console messages and debugging.
		 * LogEventLevel.DEBUG, LogEventLevel.INFO, etc.
		 * */
		public var level:int;
		
		/**
		 * Return formated error message
		 * */
		public function toString():String {
			var out:String = "";
			
			if (label) {
				out += label;
			}
			if (description) {
				out += ": " + description;
			}
			if (line!=-1) {
				out += " Line " + line;
			}
			if (column!=-1) {
				out += " Column " + column;
			}
			
			return out;
		}
		
		/**
		 * Returns an instance with name and message
		 * */
		public static function getIssue(name:String, description:String, line:int = -1, column:int = -1):IssueData {
			var data:IssueData = new IssueData();
			data.description = description;
			data.label = name;
			data.line = line;
			data.column = column;
			return data;
		}
	}
}