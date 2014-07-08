
package com.flexcapacitor.data.database {
	
	
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
		
		/**
		 * If set to true the value is accessed from the data object provided. 
		 * Default is false on insert and true on update.
		 * */
		public var getValueFromData:Boolean;
	}
}