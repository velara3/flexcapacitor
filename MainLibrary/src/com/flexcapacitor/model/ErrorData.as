package com.flexcapacitor.model {
	
	/**
	 * Contains information on errors during compilation
	 * */
	public class ErrorData extends IssueData {
		
		public function ErrorData() {
			
		}
		
		public var errorID:String;
		public var message:String;
		public var name:String;
		public var stackTrace:String;
		
		/**
		 * Returns an instance with name and message
		 * */
		public static function getIssue(name:String, description:String, line:int = -1, column:int = -1):ErrorData {
			var data:ErrorData = new ErrorData();
			data.description = description;
			data.label = name;
			data.line = line;
			data.column = column;
			return data;
		}
	}
}