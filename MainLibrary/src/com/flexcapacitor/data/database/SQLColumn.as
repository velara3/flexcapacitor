
package com.flexcapacitor.data.database {
	
	
	/**
	 * Used to hold information on a SQL Column
	 * */
	public class SQLColumn {
		
		public function SQLColumn() {
			
		}
		
		/**
		 * Alias name used with Insert and Update operations
		 * */
		public var alias:String;
		
		/**
		 * 
		 * @copy flash.data.SQLColumnSchema#allowNull
		 * */
		public var allowNull:Boolean;
		
		/**
		 * 
		 * @copy flash.data.SQLColumnSchema#autoIncrement
		 * */
		public var autoIncrement:Boolean;
		
		/**
		 * Data type of the column. For example, "INTEGER", "TEXT", "REAL", "NULL" and "BLOB"
		 * are all accepted. See http://www.sqlite.org/data type3.html.<br/><br/>
		 * @copy flash.data.SQLColumnSchema#dataType
		 * */
		public var dataType:String;
		
		/**
		 * 
		 * @copy flash.data.SQLColumnSchema#defaultCollationType
		 * */
		public var defaultCollationType:String;
		
		/**
		 * 
		 * @copy flash.data.SQLColumnSchema#name
		 * */
		public var name:String;
		
		/**
		 * 
		 * @copy flash.data.SQLColumnSchema#primaryKey
		 * */
		public var primaryKey:Boolean;
		
		/**
		 * Get the column information in the form of a string. 
		 * Example, "id INTEGER PRIMARY KEY AUTOINCREMENT"
		 * Example, "firstName TEXT"
		 * No space before or after.
		 * */
		public function marshall():String {
			var request:String = name;
			
			if (dataType) {
				request += " " + dataType.toUpperCase();
			}
			if (primaryKey) {
				request += " PRIMARY KEY";
			}
			if (autoIncrement) {
				request += " AUTOINCREMENT";
			}
			if (allowNull) {
				request += " ALLOW NULL";
			}
			if (defaultCollationType) {
				request += " " + defaultCollationType;
			}
			
			return request;
		}
	}
}