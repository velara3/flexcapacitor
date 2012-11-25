
package com.flexcapacitor.data.database {
	import flash.data.SQLColumnSchema;
	
	/**
	 * SQL Column used for select, update and insert
	 * @copy SQLColumn
	 * */
	public class SQLColumnData extends SQLColumn {
		
		public function SQLColumnData() {
			
		}
		
		/**
		 * Value of the field when used with Insert and Update operations
		 * */
		[Bindable]
		public var value:Object;
		
	}
}