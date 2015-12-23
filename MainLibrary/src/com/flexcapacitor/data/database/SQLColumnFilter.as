
package com.flexcapacitor.data.database {
	
	
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
		
		/**
		 * Type of join. For example,
		 * AND, OR, INNER JOIN, OUTER JOIN etc 
		 * 
		 * Default is AND
		 * */
		public var join:String = "AND";
		
	}
}