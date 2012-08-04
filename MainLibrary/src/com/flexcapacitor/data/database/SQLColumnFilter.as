
package com.flexcapacitor.data.database {
	import flash.data.SQLColumnSchema;
	
	/**
	 * SQL Column used for filtering a select statement
	 * @copy SQLColumn
	 * */
	public class SQLColumnFilter extends SQLColumnData {
		
		public function SQLColumnFilter() {
			
		}
		
		/**
		 * Operation such as "=", ">" etc
		 * Default value is "="
		 * */
		public var operation:String = "=";
		
	}
}